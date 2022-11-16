import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from datetime import datetime

def Email365(username,password,mail_from,mail_to,mail_subject,mail_body,EmailServer,EmailPort,MsgBodyProcess):
    
    
    try:
        # Hora envio do email
        data_e_hora_atuais = datetime.now()
        hora_body = data_e_hora_atuais.strftime('%d/%m/%Y %H:%M')


        HTMLBody = f"""

                <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
                <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
                    <title>Email status do processo</title>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
                </head>
                <table align="center" border="1" cellpadding="0" cellspacing="0" width="600">
                <td align="center" bgcolor="#ffffff" style="padding: 40px 0 30px 0;">
                    <img src="https://practiaglobal.com.br/wp-content/uploads/2020/12/prax.png" alt="Bor Practia" width="300" height="230" style="display: block;" />                    <br>
                    <p>Prezado;
                    <p/>
                </td>
                <tr>
                    <td bgcolor="#ffffff" style="padding: 20px 0px 0px 30px;">
                        <table  cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                            <p>Processo finalizado as {hora_body} </p>
                            </tr>
                            <tr>
                            <p style="padding: 20px 0 30px 0;">
                                {MsgBodyProcess}
                            </p>
                            </tr>
                            <tr>
                            <p style="padding: 20px 0 30px 0;">
                                {mail_body}
                            </p>
                            </tr>
                        </table>
                    </td>
                </tr>
                <br>
                <tr>
                    <td bgcolor="#ee4c50" style="padding: 10px 10px 10px 10px;">
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                            <tr>
                            <td align="right">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="100%">
                                        &reg; Email automatico, sem a necessidade de responder<br/>
                                        </td>
                                        <td>
                                        <a href="https://practiaglobal.com.br/">
                                        <img src="https://practiaglobal.com.br/wp-content/uploads/2020/07/Logo-Negativo.png" alt="Url Practia" width="38" height="38" style="display: block;" border="0" />
                                        </a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            </tr>
                        </table>
                </html>

            """

        mimemsg = MIMEMultipart()
        mimemsg['From']=mail_from
        mimemsg['To']=mail_to
        mimemsg['Subject']=mail_subject
        mimemsg.attach(MIMEText(HTMLBody, 'html'))
        connection = smtplib.SMTP(host=EmailServer, port=EmailPort)
        connection.starttls()
        connection.login(username,password)
        connection.send_message(mimemsg)
        connection.quit()
        return  "Enviado com sucesso"

    except Exception as error:
        return  "Erro no envio do email"