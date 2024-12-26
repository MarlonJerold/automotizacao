# Automotização de monitoramento do Nginx Ubuntu utilizando WSL

Surge uma necessidade de vizualizar se um serviço como ngnix está no ar. basicamente verificar se está no ar ou não.

Nessa documentação, falarei como você pode monitorar seu serviço Nginx utiizando um arquivo shell.

## Configuração básica
1. Utilizaremos WSL com Ubuntu
2. Intalação do Nginx no Ubuntu
3. Criação de Script e comando para automatização
4. criação de arquivos para armazenamento de logs

# Ok, o que vai acontecer no final das contas?

Basicamente rodaremos nosso serviço dentro de um sistema ubuntu que utilizamos wsl para que isso seja possível, então, embora estejamos em uma máquina Windows como máquina principal de nosso ambiente, é possível rodar coisas em uma camada a mais de nosso sistema, o que seria nosso wsl e por esse motivo, iremos abrir nosso terminal no Windows e instalar nosso WSL.

utilize o seguinte comando para isso

![image](https://github.com/user-attachments/assets/f025b424-fe2b-4501-8803-264a62f081cb)


Ok, clicaremos na setinha e irá abrir nosso terminal ubuntu, é lá que a "mágica" vai acontecer.

Dentro do terminal Ubuntu digite o seguinte comando para instalar o Nginx

```bash
sudo apt install nginx -y
```

Ao finalizar a instação, podemos dizer ao nosso sistema que nosso nginx irá iniciar assim que iniciamos nosso sistema, mas não será o que iremos fazer agora. O próximo passo é verificar o Status dele.

```bash
sudo systemctl status nginx
```

Ao rodar esse comando, será retornado a seguinte informação

![image](https://github.com/user-attachments/assets/631aaf10-138e-4116-b878-3ed5032d5eeb)


Aqui, nosso Nginx não está rodando, o que podemos fazer é utilizar o seguinte comando para colocar o serviço ativo.

```bash
sudo systemctl start nginx
```

Ao rodar o comando, veremos que nosso sistema está ativo

![image](https://github.com/user-attachments/assets/1ca9bd26-d984-4f02-ad00-e2acb2598d7e)


E para nível de verificação, podemos pesquisar localhost em um navegador e verificar nosso serviço no Ar

![image](https://github.com/user-attachments/assets/abc74e81-e369-42ed-be73-e64b18e35e39)


Perfeito, nosso sistema está rodando, porém vamos ao nosso objetivo, criar nossa automatização para verficicar se ele está no ar ou não, com comando bash.

## Preparando a casa para visualização

Para nosso "monitoramento", será necessário criar uma pasta para guardar dois arquivos logs, um arquivo irá mostrar se nosso serviço está no ar, e outro se está online

![image](https://github.com/user-attachments/assets/95cef2d0-fefd-4eb5-8407-d592eb0de76f)


Perfeito, ao fazer isso, iremos para a criação do nosso script

```bash
#!/bin/bash

# Defina o diretório onde os logs serão salvos
DIR="/home/marlon/nginx_logs"
mkdir -p "$DIR"

# Defina o nome do serviço e a data/hora atual
SERVICE="nginx"
DATETIME=$(date "+%Y-%m-%d %H:%M:%S")

# Verifique o status do serviço Nginx
if systemctl is-active --quiet $SERVICE; then
    STATUS="ONLINE"
    MESSAGE="O serviço $SERVICE está ONLINE."
    FILE="$DIR/status_online.log"
else
    STATUS="OFFLINE"
    MESSAGE="O serviço $SERVICE está OFFLINE."
    FILE="$DIR/status_offline.log"
fi

# Escreva o resultado no arquivo
echo "$DATETIME - $SERVICE - $STATUS - $MESSAGE" >> $FILE
```

## Arquivo não executa sozinho!

Sim, precisamos tornar nosso arquivo executável, esse mesmo que acabamos de criar

```bash
chmod +x seu caminho para o script/nginx_status.sh
```

Depois de tornar ele executável, você pode rodar ele manualmente

```bash
seu caminho para o script/monitor_nginx.sh
```

Depois de executar, iremos verificar os logs

![image](https://github.com/user-attachments/assets/f101b00a-fd2b-4c5a-9f6a-cd5f0b32f518)


Ok, verificamos que ele está no ar por nosso arquivo log que está sendo armazendo pela executação do nosso script para verificar se está ativo, e como está online, e gerado esse log, mostrando a hora nosso serviço está rodando.

## Vamos automatizar o processo!

Precisamos que nosso serviço seja monitorado a cada 5 minutos e que nesse processo seja gerado os nossos logs, a cada 5 minutos e não apenas quando executamos novamente, queremos quandar esses dados para análise.

O primeiro passo é editar o arquivo crontab para agendar o script de monitoramento. Execute o comando

```bash
crontab -e
```

Dentro do arquivo crontab, adicione a seguinte linha para executar o script

```bash
*/5 * * * * /home/marlon/nginx_logs/monitor_nginx.sh
```

Depois disso, veremos que nosso serviço está sendo automatizado!

![image](https://github.com/user-attachments/assets/4b9c22f3-900d-43ca-8fd4-62ab6070011c)


A cada 5 minutos está verificando se nosso serviço está rodando!
