package kr.practice.code.common.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

public class AuthenticationLogoutSuccessImpl implements LogoutSuccessHandler {
	
	private Logger logger = LoggerFactory.getLogger(AuthenticationLogoutSuccessImpl.class);
	
	@Override
	public void onLogoutSuccess(HttpServletRequest request,
			HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		
		logger.info("Login out");
		//String name = authentication.getName();
		
		String contextPath = request.getContextPath();
		response.sendRedirect(contextPath + "/login");
	}

}
