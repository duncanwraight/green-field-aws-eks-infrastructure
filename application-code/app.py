from flask import Flask
import base64

app = Flask(__name__)

@app.route('/')
def hello():
    return base64.b64decode('''TGVlIHNtZWxscwo=''')
