package kr.practice.code.common.security;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;

public class User extends org.springframework.security.core.userdetails.User {

	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String userName;
	private String department;
	private String position;
	private String grade;
	
    public User(String username, 
    			String password, 
    			boolean enabled, 
    			boolean accountNonExpired, 
    			boolean credentialsNonExpired, 
    			boolean accountNonLocked, 
    			Collection<? extends GrantedAuthority> authorities,
    			String userId,
    			String userName,
    			String department,
    			String position,
    			String grade) {
        super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
        this.userId = userId;
        this.userName = userName;
        this.department = department;
        this.position = position;
        this.grade = grade;
    }

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}
}
