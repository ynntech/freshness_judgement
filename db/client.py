#-*- coding: utf-8 -*-

#basic Item class
class Item:
    # 各アイテムの鮮度updateメソッドは、クライアントアプリ側で実装
    def __init__(self, name, amount, freshness, _class="vegetable"):
        self.name = name
        self.amount = amount
        self.freshness = freshness
        self.item_class = _class

# client class
class Client:
    def __init__(self, data):
        self.data = data
        self.people = data["people"]
        self.show = data["show"]
        self.load()

    def load(self):
        vegis = []
        for ingredient in self.data["ingredients"]:
            item_class = ingredient["class"]
            if item_class != "vegetable":
                continue
            else:
                item_name = ingredient["name"]
                item_amount = ingredient["amount"]
                item_freshness = ingredient["freshness"]
                vegis.append(Item(name=item_name, amount=item_amount,
                                freshness=item_freshness, _class=item_class))
        self.state = vegis
        self._unfresh_idx = self.sort_fresh()

    def sort_fresh(self):
        self.state = sorted(self.state, key=lambda x:(x.freshness, x.amount))
        worst_freshness = self.state[0].freshness
        idx = 1
        for item in self.state[1:]:
            if worst_freshness < item.freshness:
                break
            else:
                idx += 1
        return idx

    @property
    def unfresh(self):
        return self.state[:self._unfresh_idx]