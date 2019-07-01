package kr.practice.code.controller;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.practice.code.configuration.Constants;

@Controller
public class HomeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(HomeController.class);
	
	@GetMapping(value="")
	public String index(HttpServletRequest request) {
	
		LOGGER.info("index");
		 
		return "index";
	}
	
	@GetMapping(value="test")
	public String test(HttpServletRequest request) {
	
		LOGGER.info("test");
		
		return "test";
	}
	
	@GetMapping(value="/mode")
	public @ResponseBody String mode() {
		
		LOGGER.info("mode");
		
		return Constants.DEPLOY_MODE + ": ready";
		
	}
	
}