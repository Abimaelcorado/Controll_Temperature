import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  final String galpaoName;
  final ValueChanged<String> onNameChanged;

  const SettingsPage({
    Key? key,
    required this.galpaoName,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.galpaoName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurações"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Nome do Galpão:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(45, 45))
              ),
              onPressed: () {
                String newName = _nameController.text.trim();
                widget.onNameChanged(newName);
                Navigator.pop(context);
              },
              child: Text("Salvar", style: TextStyle(
                fontSize: 15
              ),),
            ),
            SizedBox(height: 16),
            Text(
              "Sobre:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 16,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 238, 238),
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Nome do aplicativo:", style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700 
                            ),),
                            SizedBox(height: 8,),
                            Text("Control temperature", style: TextStyle(
                              fontSize: 15,
                            ),),
                            SizedBox(height: 8,),
                            Text("Versão do aplicativo:", style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700 
                            ),),
                            SizedBox(height: 8,),
                            Text("1.0.0", style: TextStyle(
                              fontSize: 15,
                            ),),
                            SizedBox(height: 8,),
                            Text("Descrição:", style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700 
                            ),),
                            SizedBox(height: 8,),
                            Text("O aplicativo control temperature usa a temperatura fornecida por um sensor LM35. Com o aplicativo, é possível acompanhar a temperatura em tempo real e fornecer gráficos semanais da temperatura.", style: TextStyle(
                              fontSize: 15,
                            ),),
                            SizedBox(height: 8,),
                            Text("Funcionalidades:", style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700 
                            ),),
                            SizedBox(height: 8,),
                            Text("O aplicatovo funciona de forma independente e automática, permitindo o controle da temperatura de galpões na criação de aves. Emitindo alertas para temperaturas altas e baixas, e permitindo o download do arquivo csv das temperatura para análise dos dados.", style: TextStyle(
                              fontSize: 15,
                            ),),
                            SizedBox(height: 8,),
                            Text("Desenvolvedor:", style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700 
                            ),),
                            SizedBox(height: 8,),
                            Row(
                              children: [
                                Text("Abimael da Cunha Corado:", style: TextStyle(
                                  fontSize: 15,
                                ),),
                                TextButton(onPressed: abrirUrl, child: Text("Github", style: TextStyle(
                                  color: Colors.blue
                                ),))  
                              ],
                            )
                        ],
                        ),
                      ]
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void abrirUrl() async {
    const url = 'https://github.com/Abimaelcorado';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}