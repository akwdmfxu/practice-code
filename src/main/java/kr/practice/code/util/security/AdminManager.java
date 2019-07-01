package kr.practice.code.util.security;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.provisioning.JdbcUserDetailsManager;

public class AdminManager extends JdbcUserDetailsManager {

	public UserDetails loadUserByUsername(String userid)
	{
		final List<GrantedAuthority> authorities = super.loadUserAuthorities(userid);
		
		UserDetails userDetails = getJdbcTemplate().queryForObject(super.getUsersByUsernameQuery(), new String[]{userid}, new RowMapper<UserDetails>() {
			
			public UserDetails mapRow(ResultSet rs, int rowNum) throws SQLException {
				
				String username = rs.getString(1);
				String password = rs.getString(2);
				String salt = rs.getString(3);
				return new SaltedUser(username, password, true, true, true, true, authorities, salt);
			}
		 
		});
		return userDetails;
	}
}
