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

public class RequestBodyXSSFilter implements Filter {
    private final Logger logger = LoggerFactory.getLogger(getClass());

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain) throws IOException, ServletException {

		HttpServletRequest request = (HttpServletRequest)req;
 		HttpServletResponse response = (HttpServletResponse)res;
 		RequestBodyXSSWrapper requestBodyXSSWrapper = null;
 		
 		try {
 			requestBodyXSSWrapper = new RequestBodyXSSWrapper(request);
 		}
 		catch(Exception e) {
 			logger.error("doFilter : ", e);
 		}

 		chain.doFilter(requestBodyXSSWrapper, response);
	}

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {}

	@Override
	public void destroy() {}

}
