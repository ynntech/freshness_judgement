import numpy as np
from PIL import Image
from flask import Flask, request, jsonify, abort

import torch
import torch.nn as nn
from torchvision import models, transforms

from keras.models import load_model
from keras.utils import CustomObjectScope
from keras.initializers import glorot_uniform
import tensorflow as tf

import base64
from io import BytesIO
import json
import datetime
import boto3
from botocore.exceptions import ClientError


app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.config["JSON_SORT_KEYS"] = False
#s3 = boto3.resource('s3').Bucket("recipeplus-s3") # 画像保存用S3


#英語の昇順
veges = ["キャベツ", "にんじん", "ねぎ"]
freshness_int = [0,50,100] # bad, good, verygood
freshness_str = ["bad","good","verygood"]


graph = tf.compat.v1.get_default_graph()
#鮮度モデルの定義
modelpath = {"キャベツ" : "weights/cabbage_model.h5" , "にんじん" : "weights/carrot_model.h5" , "ねぎ" : "weights/green_onion_model.h5"}
with CustomObjectScope({'GlorotUniform': glorot_uniform()}):
    fresh_models = {vege : load_model(modelpath[vege]) for vege in veges}


# 野菜分類モデルの定義
vegi_judge = models.resnet18(pretrained=True)
num_ftrs = vegi_judge.fc.in_features
vegi_judge.fc = nn.Sequential(nn.Linear(num_ftrs, 256),
                              nn.ReLU(),
                              nn.Dropout(),
                              nn.Linear(256,64),
                              nn.ReLU(),
                              nn.Dropout(),
                              nn.Linear(64,3),
                              nn.Softmax(1))
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


def pillowimage2keras(img, vege):
    if vege == "にんじん":
        input_shape = 256
    else:
        input_shape = 224
    img = img.resize((input_shape,input_shape))
    img = np.array(img)/255
    img = np.expand_dims(img, axis=0)
    return img


def pillowImage2s3(pillow_image, vege, freshness):
    pillow_image.save("tmp.jpg")
    now = datetime.datetime.now()
    try:
        s3.upload_file("tmp.jpg", vege+"/"+freshness+"/"+str(now)[:19]+".jpg")
    except ClientError as e:
        logging.error(e)


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
        print("accept!")
        
        #base64_str = request.files["file"].read()
        json_data = request.get_json() 
        base64_str = json_data["file"]# base64strを取得
     
        pillow_img = base64string2pillowimage(base64_str) # base64strをPilloImageに変換
     
        # vege phese　野菜分類
        dataloader = pillowImage2torchDataLoader(pillow_img)
        for inputs, labels in dataloader:
            output = vegi_judge(inputs)
            _, predict = torch.max(output, 1)

            output_detached = output.detach().numpy()[0] # 推論結果の数値部分をnumpy arrayで取り出す
            predict_num = predict.numpy()[0]
            if output_detached[predict_num] >= 0.6: # 出力の最高値が0.6以上のときに正しく分類できたとみなし、鮮度判定にうつる
                vege = veges[predict]

                # freshness phese 鮮度判定
                with graph.as_default():
                    img_keras = pillowimage2keras(pillow_img, vege) 
                    fn_judge = fresh_models[vege]
                    result = fn_judge.predict(img_keras)[0]
                    predict = np.argmax(result)
                    freshness = result[1]*50 + result[2]*100
                
            else: #　出力の最高値が0.6未満のときは未知の野菜とみなして鮮度判定をしない
                vege = "others"
                predict = 2
                freshness = 100        

        print("vege : {}, pred_rate : {} || freshness : {}, pred_rate : {}".format(vege, output_detached, freshness, result))

       # pillowImage2s3(pillow_img, vege, freshness_str[predict], item_class) # AWS S3に画像を野菜別鮮度別（3段階）で保存
        
        return jsonify({
            "status": "OK",
            "vegi_info":{
                "item_class": "vegetable",
                "name": vege,
                "freshness": freshness,
                "amount": "1"
            }
        })


if __name__ == "__main__":
    app.debug = True
    #app.run(host="0.0.0.0", port="8888")
    app.run(host="0.0.0.0",port="3000")
