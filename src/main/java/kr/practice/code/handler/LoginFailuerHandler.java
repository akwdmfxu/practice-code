package kr.practice.code.handler;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

@Component
public class LoginFailuerHandler implements AuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {
		
	    String username = request.getParameter("j_username");
	    String ip = request.getRemoteHost();
	    
		HttpSession session = request.getSession();
		
		Integer countUsername = (Integer) session.getAttribute(username);
		if(countUsername == null) {
			countUsername = 0;
		}
		
		Integer countIp = (Integer) session.getAttribute(ip);
		if(countIp == null) {
			countIp = 0;
		}

		/*
		if(countUsername > 5) {
			
		}
		
		if(countIp > 5) {
			
		}
		*/
		
		if(exception instanceof AuthenticationException) {
			session.setAttribute("errorStatus", 1);
		}
		
		if(exception instanceof BadCredentialsException) {
			session.setAttribute("errorStatus", 2);
			countUsername++;
					
		}
		
		if(exception instanceof LockedException) {
			session.setAttribute("errorStatus", 3);
		}
		
		session.setAttribute(ip, countIp);
		session.setAttribute(username, countUsername);
		
		String contextPath = request.getContextPath();
		response.sendRedirect(contextPath);
	}
	
}
