from flask import Flask, jsonify, request, render_template
from flask_sqlalchemy import SQLAlchemy
import datetime
import pytz

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///temperatures.db'
db = SQLAlchemy(app)

class Temperature(db.Model):    
    id = db.Column(db.Integer, primary_key=True)
    timestamp = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    value = db.Column(db.Float)

@app.route("/")
def index():
    return render_template('index.html')

@app.route('/temperature', methods=['POST'])
def add_temperature():
    data = request.get_json()
    temperature = Temperature(value=data['temperature'])
    db.session.add(temperature)
    db.session.commit()
    return jsonify({'message': 'Temperature added successfully'})

@app.route('/api', methods=['GET'])
def get_temperatures():
    temperatures = Temperature.query.all()
    result = []
    for temp in temperatures:
        timestamp_local = temp.timestamp.replace(tzinfo=pytz.utc).astimezone(pytz.timezone('America/Sao_Paulo'))
        formatted_timestamp = timestamp_local.strftime("%Y-%m-%d %H:%M:%S")
        result.append({'id': temp.id, 'timestamp': formatted_timestamp, 'value': temp.value})
    return jsonify(result)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()

    app.run()