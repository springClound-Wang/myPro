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

package com.navercorp.pinpoint.web.interceptor;

import com.navercorp.pinpoint.web.service.AdminUserServiceImpl;
import com.navercorp.pinpoint.web.vo.user.AdminUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.Writer;

/**
 * FIXME temporary interceptor for admin operations.
 * 
 * @author wzz
 */
public class LoginInterceptor extends HandlerInterceptorAdapter {
    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    public LoginInterceptor() {
        super();
    }

    /**
     * This implementation always returns {@code true}.
     *
     * @param request
     * @param response
     * @param handler
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

                String path=request.getServletPath();
                logger.info("请求的路径是{}",path);
                //获取session
                HttpSession session = request.getSession();
                AdminUser user = (AdminUser) session.getAttribute(AdminUserServiceImpl.LOGIN_USER);
                logger.info("===session中的用户信息{}",user);
            //判断session中是否有用户数据，如果有，则返回true，继续向下执行
               if (user != null) {
                     return true;
               }
              Writer w= response.getWriter();
               w.write("<script>top.location.href='/login.pinpoint';");
               w.write("</script>");
               w.close();
                 return false;

    }

    /**
     * This implementation is empty.
     *
     * @param request
     * @param response
     * @param handler
     * @param modelAndView
     */
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
        super.postHandle(request, response, handler, modelAndView);
    }


    
}
