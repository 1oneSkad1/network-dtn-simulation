import os
import subprocess
from flask import Flask, render_template, jsonify

app = Flask(__name__)
app.config['RECV_FOLDER'] = 'received'
os.makedirs(app.config['RECV_FOLDER'], exist_ok=True)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/status')
def get_status():
    ion_status = "Running"
    try:
        result = subprocess.run("ionwatch", shell=True, capture_output=True, text=True, timeout=2)
        if result.returncode != 0:
            ion_status = "Stopped or Error"
    except:
        ion_status = "Unknown"
    return jsonify({"status": ion_status})

@app.route('/files')
def get_files():
    files = os.listdir(app.config['RECV_FOLDER'])
    return jsonify({"files": files})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
