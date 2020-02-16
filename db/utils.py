#-*- coding: utf-8 -*-
from flask import abort

def check_request(data):
    if not "ingredients" in data:
        abort(400, "\"ingredients\" key is required in request.")
    else:
        if type(data["ingredients"]) is not list:
            abort(400, "\"ingredients\" should be list object.")
        else:
            for ingredient in data["ingredients"]:
                if not "item_class" in ingredient:
                    abort(400, "\"item_class\" key is required \
                                in each ingredient.")
                else:
                    if  (ingredient["item_class"] not in
                            ["vegetable", "seasoning", "meet", "other"]):
                        abort(400, "Bad request (\"item_class\"). \
                                    Choose from vegetable/seasoning/meet/other.")

                if not "name" in ingredient:
                    abort(400, "\"name\" key is required \
                                in each ingredient.")
                else:
                    if  ingredient["name"] is None:
                        abort(400, "Bad request (\"name\"). \
                                    Str object is required.")

                if not "amount" in ingredient:
                    abort(400, "\"amount\" key is required \
                                in each ingredient.")

                if not "freshness" in ingredient:
                    abort(400, "\"freshness\" key is required \
                                in each ingredient.")
                else:
                    if  ingredient["freshness"] is None:
                        abort(400, "Bad request (\"freshness\"). \
                                    Int object (0 ~ 100) is required.")

    if not "people" in data:
        abort(400, "\"people\" key is required in request.")

    if not "show" in data:
        abort(400, "\"show\" key is required in request.")
