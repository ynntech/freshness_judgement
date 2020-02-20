#-*- coding: utf-8 -*-

#basic Item class
class Item:
    # 各アイテムの鮮度updateメソッドは、クライアントアプリ側で実装
    def __init__(self, name, amount, freshness, item_class="vegetable"):
        self.name = name
        self.amount = amount
        self.freshness = freshness
        self.item_class = item_class

# client class
class Client:
    def __init__(self, data):
        self.data = data
        self.people = data["people"] if data["people"] is not None else 1
        self.show = data["show"] if data["show"] is not None else 3
        self.load()

    def load(self):
        vegis = []
        for ingredient in self.data["ingredients"]:
            item_class = ingredient["item_class"]
            if item_class != "vegetable":
                continue
            else:
                item_name = ingredient["name"]
                item_amount = float(ingredient["amount"])
                item_freshness = float(ingredient["freshness"])
                vegis.append(Item(name=item_name, amount=item_amount,
                                freshness=item_freshness, item_class=item_class))
        self.state = vegis
        if len(self.state) != 0:
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
        if len(self.state) != 0:
            return self.state[:self._unfresh_idx]
        else:
            return []

    @property
    def fresh(self):
        if len(self.state) != 0:
            return self.state[self._unfresh_idx:]
        else:
            return []
