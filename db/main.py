# -*- coding: utf-8 -*-
import os
import sys
import datetime
from flask import Flask, request, jsonify, abort
from database import DataBase
from client import Client
import functools
import jwt


app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config["JSON_SORT_KEYS"] = False

db = DataBase()

# Authorization setting
key = "secret"
alg = "HS256"

# access token認証関数


def authorize(method):
    @functools.wraps(method)
    def wrapper(*args, **kwargs):
        header = request.headers.get("Authorization")
        if header is not None:
            token = header.split()[-1]
            try:
                decoded = jwt.decode(token, key, algorithms=alg)
                user = decoded["usr"]  # ここが気になる byなかや
            except jwt.DecodeError:
                abort(400, "Token is not valid.")
            return method(user, *args, **kwargs)
        else:
            abort(400, "Access token is required.")
    return wrapper

# 鮮度で最適化されたレシピのリクエストAPI
@app.route("/request", methods=["POST"])
@authorize
def recipe_request(user):
    if user in ["general", "admin"]:
        data = request.get_json()
        client = Client(data=data)
        return jsonify({
            "status": "OK",
            "response": db.suggest(client=client)
        })
    else:
        abort(400, "You are not authorized to perform this operation.")∑

# 全レシピデータの取得API
@app.route("/request/recipes", methods=["GET"])
@authorize
def get_recipes(user):
    if user in ["general", "admin"]:
        return jsonify({
            "status": "OK",
            "response": db.get_recipes()
        })
    else:
        abort(400, "You are not authorized to perform this operation.")

# ingredientsテーブルの全情報取得API
@app.route("/request/ingredients", methods=["GET"])
@authorize
def get_ingredients(user):
    if user in ["general", "admin"]:
        return jsonify({
            "status": "OK",
            "response": db.get_ingredients()
        })
    else:
        abort(400, "You are not authorized to perform this operation.")

# 新規レシピ登録API
@app.route("/register", methods=["POST"])
@authorize
def recipe_register(user):
    if user is "admin":
        recipes = request.get_json()
        db.register(recipes=recipes["recipes"])
        return jsonify({
            "status": "OK"
        })
    else:
        abort(400, "You are not authorized to perform this operation.")

# 権限ある人用のSQL操作API
@app.route("/operate/sql", methods=["POST"])
@authorize
def db_exec(user):
    if user is "admin":
        sql = request.get_json()
        try:
            db.cursor.execute(sql["sql"])
            res = db.cursor.fetchall()
            return jsonify({
                "status": "OK",
                "response": res
            })
        except:
            return jsonify({
                "status": "Error",
                "response": "Unexpected error was occorred. \
                                        Please check your mysql syntax"
            })
    else:
        abort(400, "You are not authorized to perform this operation.")

# test
@app.route("/test")
def test():
    return "test"


@app.route("/test/post", methods=["POST"])
def test_post():
    data = request.get_json()
    return jsonify({
        "status": "ok",
        "response": data
    })


@app.route("/test/get", methods=["GET"])
def test_get():
    return jsonify({
        "status": "ok"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port="8888")
    db.exit()
    sys.exit()
