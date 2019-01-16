package com.navercorp.pinpoint.web.vo.user;

public class RolePermissionKey {
    private Integer permitId;

    private Integer roleId;

    public Integer getPermitId() {
        return permitId;
    }

    public void setPermitId(Integer permitId) {
        this.permitId = permitId;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    @Override public String toString() {
        return "RolePermissionKey{" + "permitId=" + permitId + ", roleId="
                + roleId + '}';
    }
}