import serial
import requests

porta_serial = serial.Serial('COM5', 9600)
porta_serial.timeout = 2
porta_serial.readline()

while True:
    temperatura = porta_serial.readline().decode().strip()

    if temperatura:
        data = {'temperature': float(temperatura)}
        response = requests.post('http://127.0.0.1:5000/temperature', json=data)
        if response.status_code == 200:
            print('Temperatura enviada com sucesso')
            print(temperatura)
