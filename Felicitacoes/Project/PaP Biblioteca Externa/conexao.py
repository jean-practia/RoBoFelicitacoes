import mysql.connector
from mysql.connector import errorcode


def atualizar_banco_de_dados(transaction_number,transaction_item,transaction_status, data_execucao, tempo_execucao):

    try:
        id_processo = 7
        print("executando")
        
        # gereando a coneção
        conexao = mysql.connector.connect(
            host ='localhost',
            user = 'root',
            password = 'Iw7twjsPtk',
            database ='practiapap'
        )

        cursor = conexao.cursor()
        print("Conexao com sucesso")
        print(transaction_status)

        # executando comando

        # pegando id 
        
        comando = f'SELECT id FROM processo_logsdoprocesso WHERE data_execucao <= "{data_execucao}" AND processo_nome_id = {id_processo} AND transaction_status = "em execucao";'
        cursor.execute(comando)
        resultado = cursor.fetchall()
        res = list(resultado)
        print(res)
        id_log = res[0][0]
        # pegando id

        # atualizando
        comando_update =  "UPDATE processo_logsdoprocesso SET transaction_number = {}, transaction_item = {}, transaction_status = '{}', tempo_execucao= {}  WHERE id = {};".format(transaction_number,transaction_item,transaction_status, tempo_execucao, id_log)
        # comando_insert = "INSERT INTO processo_logsdoprocesso (transaction_number, transaction_item, transaction_status, processo_nome_id, data_execucao, tempo_execucao) VALUES ({}, {}, '{}', {}, '{}','{}')".format(transaction_number,transaction_item,transaction_status, 7, data_execucao, tempo_execucao)
        cursor.execute(comando_update)
        conexao.commit()
        # atualizando
        print("Comando com sucesso")

    except Exception as e:
        print('erro')
        print(e)
    finally:
        cursor.close()
        conexao.close()
        print("Conexao fechada com sucesso")


# atualizar_banco_de_dados(0,1,'concluido', '2022-09-19', '70.0')

def rodando_bot(transaction_number,transaction_item,transaction_status, data_execucao, tempo_execucao):

    try:

        print("executando")

        # gereando a coneção
        conexao = mysql.connector.connect(
            host ='localhost',
            user = 'root',
            password = 'Iw7twjsPtk',
            database ='practiapap'
        )

        cursor = conexao.cursor()
        print("Conexao com sucesso")
        

        # executando comando
        comando_insert = "INSERT INTO processo_logsdoprocesso (transaction_number, transaction_item, transaction_status, processo_nome_id, data_execucao, tempo_execucao) VALUES ('{}', '{}', '{}', {}, '{}','{}')".format(transaction_number,transaction_item,transaction_status, 7, data_execucao, tempo_execucao)
        cursor.execute(comando_insert)
        conexao.commit()
        print("Comando com sucesso")

    except Exception as e:
        print('erro')
        print(e)
    finally:
        cursor.close()
        conexao.close()
        print("Conexao fechada com sucesso")
    