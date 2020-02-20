"""
コメントアウトを外すとそのままkerasの鮮度判定モデルが動くはず
requirements.txtに以下を追記
Keras==2.2.5
tensorflow==1.15.2
"""
import os
from flask import Flask, request, jsonify, abort
from werkzeug.utils import secure_filename
import numpy as np
from PIL import Image
import torch
import torch.nn as nn
from torchvision import models, transforms
"""
from keras.models import load_model
from keras.utils import CustomObjectScope
from keras.initializers import glorot_uniform
import tensorflow as tf
"""
import base64
from io import BytesIO
import json


app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config["JSON_SORT_KEYS"] = False

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
vegi_judge.fc = nn.Sequential(nn.Linear(num_ftrs, 256),
                              nn.ReLU(),
                              nn.Dropout(),
                              nn.Linear(256,64),
                              nn.ReLU(),
                              nn.Dropout(),
                              nn.Linear(64,3))
vegi_judge.load_state_dict(torch.load("weights/vegi08.pth", map_location=torch.device('cpu')))
vegi_judge.eval()

class MyDataset(torch.utils.data.Dataset):

    def __init__(self, data, label, transform=None):
        self.transform = transform
        self.data = data
        self.data_num = len(data)
        self.label = label

    def __len__(self):
        return self.data_num

    def __getitem__(self, idx):
        out_data = self.data[idx]
        out_label = self.label[idx]
        if self.transform:
          out_data = self.transform(out_data)

        return out_data, out_label


def base64string2pillowimage(base64_str): 
    img = base64.b64decode(base64_str)
    img = BytesIO(img) 
    img = Image.open(img) 
    return img


def pillowImage2torchDataLoader(img):
    transform = transforms.Compose([
        transforms.Resize((128,128)),
        transforms.ToTensor(),
        transforms.Normalize([0.485, 0.456, 0.406],[0.229, 0.224, 0.225])
    ])

    dataset = MyDataset([img], [0], transform=transform)
    dataloader = torch.utils.data.DataLoader(dataset, batch_size=1)
 
    return dataloader


def pillowimage2keras(img):
    img = img.resize((224,224))
    img = np.array(img)
    img = np.expand_dims(img, axis=0)
    #img = img[:, :, ::-1]
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
        print(request.is_json)
        print(request.headers)

        if "file" not in request.get_json(): 
            return jsonify({
                "status" : "OK"
                })

        json_data = request.get_json() 
        base64_str = json_data["file"]# base64strを取得
     
        pillow_img = base64string2pillowimage(base64_str) # base64strをPilloImageに変換
     
        # vegi phese　野菜分類
        dataloader = pillowImage2torchDataLoader(pillow_img)
        for inputs, labels in dataloader:
            output = vegi_judge(inputs)
            print(output)
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
        
        # 鮮度判定モデルは割愛してるので定数。
        freshness = 100
        item_class = "vegetable" if vegi in vegis else "other"

        return jsonify({
            "status": "OK",
            "vegi_info":{
                "item_class": item_class,
                "name": vegi,
                "freshness": freshness,
                "amount": "1"
            }
        })


if __name__ == "__main__":
    port = int(os.environ.get('PORT', 8080)) # herokuでPORT番号固定するのに一手間かかるため、サーバから指定される開いてるポートを使ってる
    app.run(host="0.0.0.0", port=port)
