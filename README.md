# Controll_Temperature

#### Com a preocupação crescente com a qualidade e o bem-estar das aves, apresentamos uma abordagem prática e eficiente para monitorar e controlar a temperatura em tempo real. Com o Controll Temperature você pode verificar as condições de temperatura do seu galpão a qualquer momento. A temperatura é exibida em tempo real através de uma interface simples e amigável.

# Projeto Arduino

![arduino_temperature](https://github.com/Abimaelcorado/Controll_Temperature/assets/125766299/7a5c6f43-84dc-41cb-b51b-e17836cebe6b)

# Código

```
const int sensorPin = A0;   
const int motorPin = A1;   

void setup() {
  pinMode(motorPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int sensorValue = analogRead(sensorPin);  
  float voltage = sensorValue * 5.0 / 1023.0;  
  float temperature = (voltage - 0.5) * 100; 

  Serial.print("Temperatura enviada com sucesso!");

  if (temperature > 25) {
    digitalWrite(motorPin, HIGH); 
  } else if (temperature < 30) {
    digitalWrite(motorPin, LOW);  
  }

  delay(30000);  
}
```

# Execução

#### Execute o arquivo execute.py com o comando a seguir. Se funcionar, dois arquivos serão abertos: um que executará a API na URL padrão 127.0.0.1:5000, e outro que receberá os dados fornecidos pelo Arduino, exibindo uma mensagem caso a temperatura seja enviada para a API.

#### OBS 1. Certifique-se que você esteja na pasta do projeto para executar o arquivo.
#### OBS 2. Certifique-se que o arduino esteja conectado na porta COM5 do seu computador, caso contrário essa informaçõa deve ser alterada no arquivo serial_reader.py. OBS: se o arduino não estiver conectado o código apresentará erro.
```
.\execute.py
```

#### 3. Por fim execute o app flutter com o comando abaixo.
```
flutter run
```
