package com.navercorp.pinpoint.web.controller;

import com.github.pagehelper.PageInfo;
import com.navercorp.pinpoint.web.service.AdminUserService;
import com.navercorp.pinpoint.web.util.MD5Util;
import com.navercorp.pinpoint.web.vo.user.AdminUser;
import com.wupao.tools.utils.ValidateUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * @author 汪正章
 * @ClassName AdminUserController
 * @create 2019-01-16 19:30
 * @desc
 * @Version 1.0V
 **/

@RestController
@RequestMapping("/adminUser")
public class AdminUserController {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    AdminUserService adminUserService;
    @RequestMapping("/selectAdminUserInfo")
    public Map<String, Object>  selectAdminUserInfo(@RequestParam("page") Integer page){
        if(page==null){
            page=0;
        }
        Map<String, Object> result = new HashMap<>();
        PageInfo<AdminUser> pageInfo=adminUserService.selectAdminUserInfo(page);
           result.put("code",200);
           result.put("data",pageInfo);
           return result;
    }
    @RequestMapping("/regUser")
    @ResponseBody
    public String regUser(@RequestParam("userIphone") String userIphone,@RequestParam("userPassword") String userPassword,@RequestParam("password2") String password2){
        if(!ValidateUtil.isMobile(userIphone)){
            return "手机号格式有误";
        }
        //判断手机号是否存在
        AdminUser adminUser= adminUserService.selectIPhoneExist(userIphone);
        if(adminUser!=null){
            return "手机号已注册";
        }
        String pwd1= MD5Util.inputPassToDbPass(userPassword, MD5Util.salt);
        String pwd2= MD5Util.inputPassToDbPass(password2, MD5Util.salt);
        logger.info("====第一个加密的密码是:{}第二个加密密码是{}",pwd1,pwd2);
        if(!pwd1.equals(pwd2)){
            return "两次密码不一致";
        }
        return adminUserService.addAmdinUser(userIphone,userPassword);
    }
    @RequestMapping("/deleteUser")
    @ResponseBody
    public String deleteUser(@RequestParam("userIphone") String userIphone,@RequestParam("userPassword") String userPassword,@RequestParam("password2") String password2){
        if(!ValidateUtil.isMobile(userIphone)){
            return "手机号格式有误";
        }
        //判断手机号是否存在
        AdminUser adminUser= adminUserService.selectIPhoneExist(userIphone);
        if(adminUser!=null){
            return "手机号已注册";
        }
        String pwd1= MD5Util.inputPassToDbPass(userPassword, MD5Util.salt);
        String pwd2= MD5Util.inputPassToDbPass(password2, MD5Util.salt);
        logger.info("====第一个加密的密码是:{}第二个加密密码是{}",pwd1,pwd2);
        if(!pwd1.equals(pwd2)){
            return "两次密码不一致";
        }
        return adminUserService.addAmdinUser(userIphone,userPassword);
    }
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public Map<String, String> handleException(Exception e) {
        logger.error(" Exception occurred while trying to CRUD user information", e);

        Map<String, String> result = new HashMap<>();
        result.put("errorCode", "500");
        result.put("errorMessage", "尝试CRUD用户组信息时发生异常");
        return result;
    }

}
