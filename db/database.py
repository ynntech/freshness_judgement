#-*- coding: utf-8 -*-
import MySQLdb
import json
import datetime
import random

# ・use most unfresh vegi(s)
# ・as possible, use only the vegis client have
class DataBase:
    HOST = "*****"
    USER = "*****"
    PASSWD = "*****"
    DB = "*****"

    def __init__(self):
        self.connect()

    def connect(self):
        self.connection = MySQLdb.connect(host=self.HOST, db=self.DB,
                                        user=self.USER, passwd=self.PASSWD,
                                        charset="utf8")
        self.cursor = self.connection.cursor()

    def save(self):
        self.connection.commit()

    def exit(self):
        self.connection.close()

    def suggest(self, client):
        # get the whole data of client's vegis
        vegis_list = client.state
        # pickup unfresh vegis
        unfresh_list = client.unfresh
        # narrow the search range
        recipes = []
        tmp_cash = {}# store the index of each recipe temporary
        for vegi in unfresh_list:
            # DataBase.search(query) will return recipe name Series
            results = self.search(vegi, people=client.people)
            for result in results:
                if result not in tmp_cash:
                    tmp_cash[result] = len(recipes)
                    recipes.append([result, 1])
                else:
                    recipes[tmp_cash[result]][1] += 1
        # sort with count
        recipes = sorted(recipes, key=lambda x:x[1])
        tmp_len = len(recipes)

        # if we do not have enough recipes
        if len(recipes) < client.show:
            for vegi in client.fresh:
                # DataBase.search(query) will return recipe name Series
                results = self.search(vegi, people=client.people)
                for result in results:
                    if result not in tmp_cash:
                        tmp_cash[result] = len(recipes)
                        recipes.append([result, 1])
                    else:
                        recipes[tmp_cash[result]][1] += 1
            # sort with count
            recipes[tmp_len:] = sorted(recipes[tmp_len:], key=lambda x:x[1])

        final_results = []
        for recipe in recipes:
            final_results.append(self.get(recipe[0]))

        shortage = client.show - len(final_results)
        if shortage > 0:
            excepts = list(tmp_cash.keys())
            final_results.extend(self.get_random(num=shortage, excepts=excepts))
        else:
            final_results = final_results[:client.show]

        return {"recipes":final_results}

    def search(self, query, people=1):
        # 'query' should be an Item class object
        # confirm the existance of specified vegetable
        db = self.cursor
        name = query.name
        term = f"show columns from ingredients like '{name}_freshness'"
        if db.execute(term):
            db.fetchall()
            amount = query.amount
            table = "from ingredients"
            fresh_query = f"where {name}_freshness={query.freshness}"
            term = f"select id, people, {name}_amount {table} {fresh_query}"
            db.execute(term)
            fetched = db.fetchall()
            if amount is not None:
                results = []
                for res in fetched:
                    # res[0]: recipe id
                    # res[1]: people(estimated number of savings)
                    # res[2]: consumption of the vegi in the recipe
                    if res[1] is not None:
                        if float(res[2]) / float(res[1]) <= amount / people:
                            results.append(str(res[0]))
                    else:
                        results.append(str(res[0]))
            else:
                results = [str(res[0]) for res in fetched]
            # this method will return just a list of recipe id
            return results
        else:
            return []

    def get(self, id):
        term = f"select content from recipes where id={id}"
        self.cursor.execute(term)
        res = self.cursor.fetchone()
        return json.loads(res[0])

    def get_random(self, num=1, excepts=[]):
        # excepts: id list for exception
        term = f"select id, content from recipes"
        self.cursor.execute(term)
        res = self.cursor.fetchall()

        results = []
        for r in res:
            if r[0] not in excepts:
                results.append(json.loads(r[1]))
        return random.sample(results, num)

    def get_recipes(self):
        term = f"select id, content from recipes"
        self.cursor.execute(term)
        res = self.cursor.fetchall()
        return {
                "recipes":[{
                            "id":r[0],
                            "content":json.loads(r[1])
                            } for r in res]
                }

    def get_ingredients(self):
        term = f"select * from ingredients"
        self.cursor.execute(term)
        res = self.cursor.fetchall()
        return {
                "recipes":[{
                            "id":r[0],
                            "content":r[1:]
                            } for r in res]
                }

    def register(self, recipes):
        db = self.cursor
        table2 = "into ingredients"
        db.execute("select count(id) from recipes")
        length = int(db.fetchone()[0])
        db.execute("show columns from ingredients")
        fields = [i[0] for i in db.fetchall()]

        for recipe in recipes:
            variables = []
            values = []
            people = recipe["people"]
            if people is not None:
                variables.append("people")
                values.append(people)

            for ingredient in recipe["ingredients"]:
                ingredient["amount"] = str(ingredient["amount"])
                if ingredient["item_class"] == "vegetable":
                    name = ingredient["name"]
                    amount = f"{name}_amount"
                    freshness = f"{name}_freshness"
                    if amount not in fields:
                        db.execute(f"alter table ingredients add {amount} \
                                    float default null")
                        fields.append(amount)
                    variables.append(amount)
                    values.append(float(ingredient["amount"]))
                    if freshness not in fields:
                        db.execute(f"alter table ingredients add {freshness} \
                                    float default null")
                        fields.append(freshness)
                    variables.append(freshness)
                    values.append(float(ingredient["freshness"]))

            term = f"insert into ingredients (id,{','.join(variables)}) \
                    values ({str(length)},{','.join(map(str,values))})"
            db.execute(term)

            time = datetime.datetime.now(datetime.timezone(
                                            datetime.timedelta(hours=9)))
            value = f"values ({str(length)},\
                                \'{json.dumps(recipe, ensure_ascii=False)}\',\
                                \'{time.strftime('%Y-%m-%d %H:%M:%S')}\')"
            term = f"insert into recipes (id,content,created) {value}"
            db.execute(term)

            length += 1

        self.save()

    def reset(self):
        db = self.cursor
        term = "delete from recipes"
        db.execute(term)
        term = "delete from ingredients"
        db.execute(term)
        self.save()
