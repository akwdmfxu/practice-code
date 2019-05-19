package kr.practice.code.system;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

@Component
public class BaseInterceptor implements HandlerInterceptor {
	
	private static final Logger logger = LoggerFactory.getLogger(BaseInterceptor.class);
	
//	@Autowired
//	private IndexService indexService;

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object obj) throws Exception {
		String base = request.getContextPath();
		String uri = request.getRequestURI();
		int lastIdx = uri.lastIndexOf("/");
		String menu = lastIdx > 0 ? uri.substring(1, lastIdx) : "";
		String page = uri.substring(lastIdx + 1);
		
		request.setAttribute("base", base);
		request.setAttribute("menu", menu);
		request.setAttribute("page", page);
		
		//Loading EhCache -> EhcacheUtil.getCache(cache name)
//		indexService.getCache();
//		indexService.getCacheDtm();
		
		logger.info("base is {}, menu is {}, page is {}", base, menu, page);
		
		return true;
	}
	
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object obj, Exception ex) throws Exception {
		
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object obj, ModelAndView mv) throws Exception {

	}
}
