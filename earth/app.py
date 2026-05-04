import os
import subprocess
from flask import Flask, render_template, request, redirect, url_for, jsonify

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

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
    return {"status": ion_status}

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return jsonify({"status": "error", "message": "No file part"}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({"status": "error", "message": "No selected file"}), 400
    
    if file:
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        file.save(filepath)
        
        try:
            # bpsendfile source_eid dest_eid filename
            cmd = f"bpsendfile ipn:1.1 ipn:2.1 {filepath}"
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            
            if result.returncode == 0:
                return jsonify({"status": "success", "message": f"Successfully sent {file.filename} to Mars!"})
            else:
                return jsonify({"status": "error", "message": result.stderr}), 500
        except Exception as e:
            return jsonify({"status": "error", "message": str(e)}), 500

@app.route('/logs')
def get_logs():
    # Read the last 20 lines of ion.log
    try:
        if os.path.exists('ion.log'):
            with open('ion.log', 'r') as f:
                lines = f.readlines()
                return "".join(lines[-20:])
        return "Waiting for logs..."
    except Exception as e:
        return f"Error reading logs: {str(e)}"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
