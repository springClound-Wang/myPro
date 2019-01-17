/*
 * Copyright 2014 NAVER Corp.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.navercorp.pinpoint.web.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.navercorp.pinpoint.web.dao.mapper.AdminUserDao;
import com.navercorp.pinpoint.web.util.MD5Util;
import com.navercorp.pinpoint.web.vo.user.AdminUser;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @author wzz
 */
@Service
public class AdminUserServiceImpl implements AdminUserService {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    public static final String LOGIN_USER="login_user";
    @Autowired
    AdminUserDao adminUserDao;

    @Override
    public String deleteAmdinUser(String mobile) {
       int count= adminUserDao.deleteAdminUserByPhone(mobile);
        if(count>0)  return "success"; return "删除失败";
    }

    @Override
    public String addAmdinUser(String mobile, String password) {
        int count=adminUserDao.addAmdinUser(mobile,password);
        if(count>0)  return "success"; return "添加失败";

    }

    @Override
    public String selectIPhoneExist(String phone, String pwd, HttpSession session) {
        AdminUser user= adminUserDao.selectIPhoneExist(phone);
        if(user!=null){
            String password=MD5Util.inputPassToDbPass(pwd, MD5Util.salt);
            logger.info("加密之后的密码{},数据库的密码是{}",password,user.getPassword());
            if(password.equals(user.getPassword())){
                session.setAttribute(LOGIN_USER,user);
                return "success";
            }
        }
        return "用户名或密码错误";
    }

    @Override
    public AdminUser selectIPhoneExist(String phone) {
        return adminUserDao.selectIPhoneExist(phone);
    }

    @Override
    public PageInfo<AdminUser> selectAdminUserInfo(Integer page) {
        PageHelper.startPage(page, 5);
        List<AdminUser> usersList= adminUserDao.selectAdminUserList();
        for (AdminUser user:usersList) {
           if(!StringUtils.isEmpty(user.getGiteeOpenid())){
               user.setGiteeOpenid("是");
           }else{
               user.setGiteeOpenid("否");
           }
            if(!StringUtils.isEmpty(user.getGithubOpenid())){
                user.setGithubOpenid("是");
            }else{
                user.setGithubOpenid("否");
            }
            if(!StringUtils.isEmpty(user.getQqOpenid())){
                user.setQqOpenid("是");
            }else{
                user.setQqOpenid("否");
            }

        }
        PageInfo<AdminUser> pageInfo = new PageInfo<AdminUser>(usersList);
        return pageInfo;
    }


}
