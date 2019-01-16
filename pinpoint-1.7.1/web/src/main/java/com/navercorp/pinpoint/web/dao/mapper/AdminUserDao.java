package com.navercorp.pinpoint.web.dao.mapper;

import com.navercorp.pinpoint.web.vo.user.AdminUser;

public interface AdminUserDao {

    AdminUser selectIPhoneExist(String phone);

}
