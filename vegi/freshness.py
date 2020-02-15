import os
from flask import Flask, request, jsonify, abort
from werkzeug.utils import secure_filename
import numpy as np
from PIL import Image
import torch
import torch.nn as nn
from torchvision import models
"""
from keras.models import load_model
from keras.utils import CustomObjectScope
from keras.initializers import glorot_uniform
import tensorflow as tf
"""
import base64
from io import BytesIO


app = Flask(__name__)
#英語の昇順
vegis = ["きゃべつ", "にんじん", "ねぎ"]
freshness_ = [0,50,100] # bad, good, verygood
"""
graph = tf.get_default_graph()
"""
#鮮度モデルとの結合部分
"""
modelpath = {"きゃべつ" : "weights/cabbage_model.h5" , "にんじん" : "weights/carrot_model.h5" , "ねぎ" : "weights/green_onion_model.h5"}
with CustomObjectScope({'GlorotUniform': glorot_uniform()}):
    fresh_models = {vegi : load_model(modelpath[vegi]) for vegi in vegis}
"""

# load Pytorch model
vegi_judge = models.resnet18(pretrained=True)
num_ftrs = vegi_judge.fc.in_features
vegi_judge.fc = nn.Sequential(nn.Linear(num_ftrs, 64),
                              nn.ReLU(),
                              nn.Dropout(),
                              nn.Linear(256,32),
                              nn.ReLU(),
                              nn.Dropout(),
                              nn.Linear(64,3))
vegi_judge.load_state_dict(torch.load("weights/vegi03.pth", map_location=torch.device('cpu')), False)


def base64string2pillowimage(base64_str): 
    img = base64.b64decode(base64_str)
    img = BytesIO(img) 
    img = Image.open(img) 
    return img


def pillowimage2torch(img):
    img = img.resize((128,128))
    img = np.array(img)
    img = np.transpose(img, (2,0,1))
    img = np.expand_dims(img, axis=0)
    img = torch.Tensor(img)
    return img


def pillowimage2keras(img):
    img = img.resize((224,224))
    img = np.array(img)
    img = np.expand_dims(img, axis=0)
    img = img[:, :, ::-1]
    return img


@app.route('/test', methods=['GET'])
def index():
    return jsonify({
            "status": "OK",             
            })


@app.route("/freshness", methods=["GET", "POST"])
def freshness():
    if request.method == 'GET':
        return jsonify({
            "status": "OK",             
            })

    if request.method == 'POST':
        if 'image' not in request.get_json(): #あやしい
            return jsonify({
                "status": "No file",             
             })
        
        #app.logger.info(request.get_json())
        file = request.get_json().get("image") #あやしい
        
        #file = request.files["file"]
        if file.filename == '':  #あやしい
            return jsonify({
                "status": "No file",             
            })

        base64_str = file["content"].read()      #あやしい
        pillow_img = base64string2pillowimage(base64_str)

        # vegi phese
        img_torch = pillowimage2torch(pillow_img)
        output = vegi_judge(img_torch)
        _, predict = torch.max(output, 1)
        vegi = vegis[predict]

        """
        # freshness phese
        with graph.as_default():
            img_keras = pillowimage2keras(pillow_img)
            fn_judge = fresh_models[vegi]
            predicted = np.argmax(fn_judge.predict(img_keras)[0])
            freshness = freshness_[predicted]
            """     
        freshness = 100

        return jsonify({
            "status": "OK",
            "vegi_info":{
                "name": vegi,
                "freshness": freshness,
            }
        })


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8080))
    app.run(host="0.0.0.0", port=port)
