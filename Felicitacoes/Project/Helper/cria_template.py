# função que retorna o template em HTML
def template(nome, cargo, data, imagem, mes, caminho_pasta_salvar, caminho_imagens):

    data_convert = f'{data.day} de {mes}' 
    template_pronto = f"<!DOCTYPE html>\
                <html lang='pt-br'>\
                    <head>\
                        <meta charset='UTF-8'>\
                        <meta http-equiv='X-UA-Compatible' content='IE=edge'>\
                        <meta name='viewport' content='width=device-width, initial-scale=1.0'>\
                        <title>template</title>\
                        <link rel='stylesheet' href='style.css'>\
                    </head>\
\
                    <body>\
                        \
                        <div class='container_template' id='templatefull'>\
                            <img src='modelo_template.jpg' class='modelo_template' alt='modelo do template aniversariante'>\
                                <img src='{caminho_imagens+imagem}' class='img_usuario'>\
                            <div class='informacoes'>\
                                <div class='flexnome'>\
                                    <p class='nome' >{nome}</p>\
                                </div>\
                                <p class='data' >{data_convert}</p>\
                                    <div class='flex'>\
                                        <p class='cargo' >{cargo}</p>\
                                   </div>\
                            </div>\
                        </div>\
                    </body>\
\
                </html>"
 
    return  template_pronto


# filtra o mês 
def filtra_mes(data):
    mes = ''
    if data.month == 1:
        mes = "Janeiro"
    elif data.month == 2:
        mes = "Fevereiro"
    elif data.month == 3:
        mes = "Março"
    elif data.month == 4:
        mes = "Abril"
    elif data.month == 5:
        mes = "Maio"
    elif data.month == 6:
        mes = "Junho"
    elif data.month == 7:
        mes = "Julho"
    elif data.month == 8:
        mes = "Agosto"
    elif data.month == 9:
        mes = "Setembro"
    elif data.month == 10:
        mes = "Outubro"
    elif data.month == 11:
        mes = "Novembro"
    elif data.month == 12:
        mes = "Dezembro"
    else: 
        mes = "data invalida"
        
    return  mes
    
import re 

# função onde gera o caminho para a robocorb
def substitui_string(caminho):

    result = re.sub(r' ','{VK_SPACE}',caminho) 
    print(result)
    return result


    
