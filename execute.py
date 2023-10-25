import os
import subprocess
import threading

def run_api():
    novo_diretorio = "lib/models/api/app"
    os.chdir(novo_diretorio)
    subprocess.run(["python", "api.py"])

def run_serial_reader():
    # Use o comando 'start cmd /k' para abrir uma nova janela do cmd e executar o script
    cmd_command = "start cmd /k python serial_reader.py"

    subprocess.run(cmd_command, shell=True)

if __name__ == "__main__":
    # Inicie a execução do api.py em uma thread
    api_thread = threading.Thread(target=run_api)
    api_thread.start()

    # Execute o serial_reader.py em uma nova janela do cmd
    run_serial_reader()
    
    # Aguarde até que a thread api.py termine
    api_thread.join()

# O programa continuará a partir deste ponto após api.py e serial_reader.py terem terminado
