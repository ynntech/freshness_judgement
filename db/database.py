#-*- coding: utf-8 -*-
import MySQLdb
import json
import datetime

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
        # sort & slice with 'show' num
        recipes = sorted(recipes, key=lambda x:x[1])
        if len(recipes) > client.show:
            recipes = recipes[:client.show]

        final_results = []
        for recipe in recipes:
            final_results.append(self.get(recipe[0]))
        return {"recipes":final_results}

    def search(self, query, people=1):
        # 'query' should be an Item class object
        db = self.cursor
        amount = query.amount
        table = "from ingredients"
        fresh_query = f"where {query.name}_freshness={query.freshness}"
        term = f"select id, people, {query.name}_amount {table} {fresh_query}"
        db.execute(term)
        fetched = db.fetchall()
        results = []
        for res in fetched:
            # res[0]: recipe id
            # res[1]: people(estimated number of savings)
            # res[2]: consumption of the vegi in the recipe
            if res[1] is None:
                if float(res[2]) <= amount:
                    results.append(str(res[0]))
            else:
                if float(res[2]) / float(res[1]) <= amount / people:
                    results.append(str(res[0]))
        # this method will return just a list of recipe id
        return results

    def get(self, id):
        term = f"select id, content from recipes where id={id}"
        self.cursor.execute(term)
        res = self.cursor.fetchone()
        return {
                "id":res[0],
                "content":json.loads(res[1])
                }

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
                if ingredient["class"] == "vegetable":
                    name = ingredient["name"]
                    amount = f"{name}_amount"
                    freshness = f"{name}_freshness"
                    if amount not in fields:
                        db.execute(f"alter table ingredients add {amount} \
                                    float default null")
                        fields.append(amount)
                    variables.append(amount)
                    values.append(ingredient["amount"])
                    if freshness not in fields:
                        db.execute(f"alter table ingredients add {freshness} \
                                    float default null")
                        fields.append(freshness)
                    variables.append(freshness)
                    values.append(ingredient["freshness"])

            term = f"insert into ingredients (id,{','.join(variables)}) \
                    values ({str(length)},{','.join(map(str,values))})"
            db.execute(term)

            time = datetime.datetime.now(datetime.timezone(
                                            datetime.timedelta(hours=9)))
            value = f"values ({str(length)},\
                                \'{json.dumps(recipe, ensure_ascii=False)}\',\
                                {time.strftime('%Y%m%d-%H%M%S')})"
            term = f"insert into recipes (id,content,created) {value}"
            db.execute(term)

            length += 1

        self.save()
