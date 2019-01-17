package com.navercorp.pinpoint.web.vo.user;

import java.io.Serializable;

public class AdminUser implements Serializable {
	private static final long serialVersionUID = -3096736268081409238L;

	private String mobile;
	private String password;
	private String insertTime;
	private String updateTime;
	private Boolean isDel;
	private String lastTime;
	private String qqOpenid;
	private String giteeOpenid;
	private String githubOpenid;
	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getInsertTime() {
		return insertTime;
	}

	public void setInsertTime(String insertTime) {
		this.insertTime = insertTime;
	}

	public String getUpdateTime() {
		return updateTime;
	}

	public void setUpdateTime(String updateTime) {
		this.updateTime = updateTime;
	}

	public Boolean getDel() {
		return isDel;
	}

	public void setDel(Boolean del) {
		isDel = del;
	}

	public String getLastTime() {
		return lastTime;
	}

	public void setLastTime(String lastTime) {
		this.lastTime = lastTime;
	}

	public String getQqOpenid() {
		return qqOpenid;
	}

	public void setQqOpenid(String qqOpenid) {
		this.qqOpenid = qqOpenid;
	}

	public String getGiteeOpenid() {
		return giteeOpenid;
	}

	public void setGiteeOpenid(String giteeOpenid) {
		this.giteeOpenid = giteeOpenid;
	}

	public String getGithubOpenid() {
		return githubOpenid;
	}

	public void setGithubOpenid(String githubOpenid) {
		this.githubOpenid = githubOpenid;
	}

	@Override
	public String toString() {
		return "AdminUser{" +
				"mobile='" + mobile + '\'' +
				", password='" + password + '\'' +
				", insertTime='" + insertTime + '\'' +
				", updateTime='" + updateTime + '\'' +
				", isDel=" + isDel +
				", lastTime='" + lastTime + '\'' +
				", qqOpenid='" + qqOpenid + '\'' +
				", giteeOpenid='" + giteeOpenid + '\'' +
				", githubOpenid='" + githubOpenid + '\'' +
				'}';
	}
}