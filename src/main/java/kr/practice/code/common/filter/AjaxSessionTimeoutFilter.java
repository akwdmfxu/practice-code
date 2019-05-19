package kr.practice.code.common.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;

public class AjaxSessionTimeoutFilter implements Filter {

	private final Logger logger = LoggerFactory.getLogger(getClass());

	/**
	 * Default AJAX request Header
	 */
	private String ajaxHeader = "AJAX";
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		
		if (isAjaxRequest(request)) {
			try {
				chain.doFilter(request, response);
			} catch (AccessDeniedException e) {
				response.sendError(HttpServletResponse.SC_FORBIDDEN);
			} catch (AuthenticationException e) {
				response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
			}
		} else {
			chain.doFilter(request, response);
		}
	}

	private boolean isAjaxRequest(HttpServletRequest req) {
        return req.getHeader(ajaxHeader) != null && req.getHeader(ajaxHeader).equals(Boolean.TRUE.toString());
	}
	
	@Override
	public void init(FilterConfig filterConfig) throws ServletException {}

	@Override
	public void destroy() {}
	
	/**
	 * Set AJAX Request Header (Default is AJAX)
	 * @param ajaxHeader
	 */
	public void setAjaxHaeder(String ajaxHeader) {
		this.ajaxHeader = ajaxHeader;
	}
}
