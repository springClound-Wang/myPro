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

import com.navercorp.pinpoint.web.dao.mapper.AdminUserDao;
import com.navercorp.pinpoint.web.util.MD5Util;
import com.navercorp.pinpoint.web.vo.user.AdminUser;
import org.slf4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.slf4j.LoggerFactory;
import javax.servlet.http.HttpSession;

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




}
