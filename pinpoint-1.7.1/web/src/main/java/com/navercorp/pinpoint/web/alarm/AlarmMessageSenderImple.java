package com.navercorp.pinpoint.web.alarm;

import com.navercorp.pinpoint.web.alarm.checker.AlarmChecker;
import com.navercorp.pinpoint.web.service.UserGroupService;
import com.wupao.sms.bean.WupaoSendMsgServer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.List;
import java.util.Properties;


/**
 * Created by 汪正章
 */
public class AlarmMessageSenderImple implements AlarmMessageSender{
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private UserGroupService userGroupService;

    @Override
    public void sendSms(AlarmChecker checker, int sequenceCount) {

        List<String> receivers = userGroupService.selectPhoneNumberOfMember(checker.getuserGroupId());
        logger.info("=======获取短信人的数量{}",receivers.size());
        if (receivers.size() == 0) {
            return;
        }

        List<String> sms = checker.getSmsMessage();
        for (String phone : receivers) {
            logger.info("====发送的手机号：{}",phone);
            WupaoSendMsgServer.SendMsg(sms.get(0),phone);

           // LydSendMsg.sendTemplateMsg(phone, "lydLoan", sms.get(0));

        }
        logger.info("====send SMS :消息{}", sms.get(0));

    }

    @Override
    public void sendEmail(AlarmChecker checker, int sequenceCount) {

        List<String> receivers = userGroupService.selectEmailOfMember(checker.getuserGroupId());
        if (receivers.size() == 0) {
            return;
        }

        for (String emailId : receivers) {
            logger.info("=AlarmMessageSenderImple.sendEmail=>"+emailId);
            // 1.创建一个程序与邮件服务器会话对象 Session
            Properties props = new Properties();
            props.setProperty("mail.transport.protocol", "SMTP");
            props.setProperty("mail.smtp.host", "smtp.exmail.qq.com");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.port", "465");
            props.put("mail.smtp.socketFactory.port", "465");
            try {
                // 验证账号及密码，密码对应邮箱授权码（163密码可行，qq必须授权码）
                Authenticator auth = new Authenticator() {
                    public PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication("server@5pao.com", "1qaz2wSX3");
                    }
                };
                Session session = Session.getInstance(props, auth);

                // 2.创建一个Message，它相当于是邮件内容
                Message message = new MimeMessage(session);
                // 设置发送者
                message.setFrom(new InternetAddress("server@5pao.com"));
                // 设置发送方式与接收者
                message.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(emailId));
                // 设置主题
                message.setSubject("Pinpoint报警");
                // 设置内容
                message.setContent(checker.getEmailMessage(), "text/html;charset=utf-8");

                // 3.创建 Transport用于将邮件发送
                Transport.send(message);
                logger.info("=AlarmMessageSenderImple.sendEmail=>"+emailId+"发送成功！邮件内容："+checker.getEmailMessage());
            }catch (Exception e){
                e.printStackTrace();
                logger.error("=AlarmMessageSenderImple.sendEmail=>错误原因是:" + e.getMessage(),e);
            }


        }

    }

    public static void main(String[] args) throws MessagingException {

    }

}

