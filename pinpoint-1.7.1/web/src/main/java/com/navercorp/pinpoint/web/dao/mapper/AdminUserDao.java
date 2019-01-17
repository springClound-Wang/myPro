package com.navercorp.pinpoint.web.dao.mapper;

import com.navercorp.pinpoint.web.vo.user.AdminUser;

import java.util.List;

public interface AdminUserDao {

    AdminUser selectIPhoneExist(String phone);
    List<AdminUser> selectAdminUserList();
    int udpateInfoByPhone(String phone);
    int addAmdinUser(String mobile,String password);
    int deleteAdminUserByPhone(String phone);
}
