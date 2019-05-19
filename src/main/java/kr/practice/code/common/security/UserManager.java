package kr.practice.code.common.security;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedList;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.provisioning.JdbcUserDetailsManager;

public class UserManager extends JdbcUserDetailsManager {
	
	public User loadUserByUsername(String userid) {
		
		final List<GrantedAuthority> authorities = new LinkedList<GrantedAuthority>();
		
		User userDetails = getJdbcTemplate().queryForObject(super.getUsersByUsernameQuery(), new String[]{userid}, new RowMapper<User>() {			
			public User mapRow(ResultSet rs, int rowNum) throws SQLException {
				String userId = rs.getString(1);
				String pwd = rs.getString(2);
				String userName = rs.getString(3);
				String department = rs.getString(4);
				String position = rs.getString(5);
				String grade = rs.getString(6);
				
				return new User(userId, pwd, true, true, true, true, authorities, userId, userName, department, position, grade);
			}
		});
		
		return userDetails;
	}
	
}
