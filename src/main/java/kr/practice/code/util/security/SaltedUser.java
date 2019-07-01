package kr.practice.code.util.security;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

public class SaltedUser extends User {

	private static final long serialVersionUID = -1836419345127861307L;

	private String salt;
	private int passwordAlert;
	
	public SaltedUser(String username, String password, boolean enabled,
			boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities, String salt) {
		
		super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
		this.salt = salt;
		this.passwordAlert = 0;
	}
	
	public SaltedUser(String username, String password, boolean enabled,
			boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked,
			Collection<? extends GrantedAuthority> authorities, String salt, int passwordAlert) {
		
		super(username, password, enabled, accountNonExpired, credentialsNonExpired, accountNonLocked, authorities);
		this.salt = salt;
		this.passwordAlert = passwordAlert;
	}
	
	public String getSalt() {
		return salt;
	}

	public void setSalt(String salt) {
		this.salt = salt;
	}

	public int getPasswordAlert() {
		return passwordAlert;
	}

	public void setPasswordAlert(int passwordAlert) {
		this.passwordAlert = passwordAlert;
	}

}
