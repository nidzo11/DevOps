from flask import Flask, request, jsonify
from flask_pymongo import PyMongo
from flask_cors import CORS
import os
import socket
import traceback  # Add this for detailed error logging

app = Flask(__name__)

# Update the URI with your MongoDB connection details
app.config["MONGO_URI"] = "mongodb://mongo-service:27017/mydatabase"
print(f"Connecting to MongoDB at {app.config['MONGO_URI']}")

# Initialize PyMongo with the app directly
mongo = PyMongo(app)
CORS(app)

@app.route('/')
def hello():
    return "Backend is running!"

@app.route('/data', methods=['GET', 'POST'])
def handle_data():
    try:
        if mongo.db is None:
            return jsonify({'error': 'Failed to connect to MongoDB'}), 500

        data_collection = mongo.db.data

        if request.method == 'GET':
            output = []
            for s in data_collection.find():
                name = s.get('name', None)
                message = s.get('message', None)
                if name and message:
                    output.append({'name': name, 'message': message})
            return jsonify(output)

        elif request.method == 'POST':
            data = request.json
            if not data:
                return jsonify({'error': 'Request body is empty or not valid JSON'}), 400
            if 'name' not in data or 'message' not in data:
                return jsonify({'error': 'Name or Message field is missing'}), 400

            data_collection.insert_one({
                "name": data['name'],
                "message": data['message']
            })
            return jsonify({'message': 'Data saved successfully'}), 200

    except Exception as e:
        print(traceback.format_exc())
        return jsonify({'error': 'An error occurred', 'details': str(e)}), 500


@app.route('/test_mongo_connection')
def test_mongo_connection():
    try:
        # Debug: Log the hostname resolution
        hostname = "mongo-service"
        resolved_ip = socket.gethostbyname(hostname)
        print(f"Resolved {hostname} to IP: {resolved_ip}")

        mongo.db.data.insert_one({"test": "connection"})
        return jsonify({'status': 'Connected and write operation successful'})
    except Exception as e:
        # Print detailed error for better debugging
        print(traceback.format_exc())
        return jsonify({'status': 'Failed to connect or write to MongoDB', 'error': str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
