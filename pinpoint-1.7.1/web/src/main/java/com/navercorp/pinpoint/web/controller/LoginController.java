package com.navercorp.pinpoint.web.controller;

import com.navercorp.pinpoint.web.service.AdminUserService;
import com.navercorp.pinpoint.web.service.AdminUserServiceImpl;
import com.wupao.tools.utils.ValidateUtil;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/login")
public class LoginController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    AdminUserService adminUserService;
    @RequestMapping("/doLogin")
    @ResponseBody
    public String doLogin(@RequestParam("userPhone") String userPhone, @RequestParam("userPassword") String userPassword, HttpSession session){
        if(!ValidateUtil.isMobile(userPhone)){
            return "手机号格式不正确";
        }
        if(StringUtils.isEmpty(userPassword)){
            return "密码不能为空";
        }
        //根据手机号查询用户是否存在
       return adminUserService.selectIPhoneExist(userPhone,userPassword,session);

    }
    @RequestMapping(method = RequestMethod.GET)
    public String toLogin(){
        return "login";
    }
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public String handleException(Exception e) {
        logger.error("尝试CRUD用户组信息时发生异常", e);
        return "尝试CRUD用户组信息时发生异常";
    }

    @RequestMapping(value="/loginOut",method = RequestMethod.GET)
    public String loginOut(HttpSession session){
        session.removeAttribute(AdminUserServiceImpl.LOGIN_USER);
        session.invalidate();
        return "redirect:login.pinpoint";
    }
}
