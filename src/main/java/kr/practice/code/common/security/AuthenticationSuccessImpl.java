package kr.practice.code.common.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

public class AuthenticationSuccessImpl implements AuthenticationSuccessHandler {
	
	private Logger logger = LoggerFactory.getLogger(AuthenticationSuccessImpl.class);
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, 
			HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException {
		
		logger.info("Login - Success : {}", request.getParameter("userId"));
		
		HttpSession session = request.getSession();
		session.setMaxInactiveInterval(86400);
		
		String contextPath = request.getContextPath();

		response.sendRedirect(contextPath + "/index");
	}
}
