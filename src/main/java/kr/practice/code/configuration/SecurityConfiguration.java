package kr.practice.code.configuration;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.access.ExceptionTranslationFilter;
import org.springframework.security.web.header.writers.frameoptions.XFrameOptionsHeaderWriter;

import kr.practice.code.common.filter.AjaxSessionTimeoutFilter;
import kr.practice.code.common.security.AuthenticationFailureImpl;
import kr.practice.code.common.security.AuthenticationLogoutSuccessImpl;
import kr.practice.code.common.security.AuthenticationSuccessImpl;
import kr.practice.code.common.security.UserManager;
import kr.practice.code.util.security.SHA512;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled=true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityConfiguration.class);
	
	static{
		LOGGER.info("Configure Security");
	}
	
	@Autowired DataSource dataSource;
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception{
		//auth.authenticationProvider(customAuthenticationProvider());
		
		UserManager manager = new UserManager();
		manager.setDataSource(dataSource);
		manager.setUsersByUsernameQuery(getUserQuery());
		manager.setEnableAuthorities(true);
		manager.setEnableGroups(false);
		
		PasswordEncoder sha512PasswordEncoder = new PasswordEncoder() {
	        @Override
	        public String encode(CharSequence rawPassword) {
	        	return SHA512.encode(rawPassword.toString());
	        }

	        @Override
	        public boolean matches(CharSequence rawPassword, String encodedPassword) {
	            return encodedPassword.equals(SHA512.encode(rawPassword.toString()));
	        }
	    };
	    
		DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
		provider.setPasswordEncoder(sha512PasswordEncoder);
		provider.setUserDetailsService(manager);
		auth.authenticationProvider(provider);
		
	}
	
	@Override
	public void configure(WebSecurity web) throws Exception {
		web.ignoring().antMatchers("/webjars/**", "/images/**", "/font/**", "/js/**", "/css/**", "/img/**", "/resources/**", "/error/**", "/views/tiles/layout/**");
	}
	
	@Override
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
	
	@Bean
	public AuthenticationFailureImpl authenticationFailureHandler() {
		AuthenticationFailureImpl authenticationFailureImpl = new AuthenticationFailureImpl();
		return authenticationFailureImpl;
	}

	@Bean
	public AuthenticationSuccessImpl authenticationSuccessHandler() {
		AuthenticationSuccessImpl authenticationSuccessHandler = new AuthenticationSuccessImpl();
		return authenticationSuccessHandler;
	}

	@Bean
	public AuthenticationLogoutSuccessImpl authenticationLogoutSuccessImpl() {
		AuthenticationLogoutSuccessImpl authenticationLogoutSuccessImpl = new AuthenticationLogoutSuccessImpl();
		return authenticationLogoutSuccessImpl;
	}
	    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
    	//ajax session time check filter
    	http.addFilterAfter(new AjaxSessionTimeoutFilter(), ExceptionTranslationFilter.class);
    	http.headers().addHeaderWriter(new XFrameOptionsHeaderWriter(XFrameOptionsHeaderWriter.XFrameOptionsMode.SAMEORIGIN)).and()
//    	.authorizeRequests().anyRequest().permitAll()
    	.authorizeRequests()
    	.antMatchers("/test").permitAll()
    	.antMatchers("/login*").permitAll()
    	.antMatchers("/empty/login*").permitAll()
    	.antMatchers("/sample/**").permitAll()
    	.antMatchers("/common/**").permitAll()
        .antMatchers("/**").authenticated()
    	.and()
			.exceptionHandling()
			.accessDeniedPage("/error")
		.and()
			.csrf().disable()
			.logout()
			.deleteCookies("JSESSIONID")
			.logoutSuccessHandler(authenticationLogoutSuccessImpl())	//로그아웃 성공
			.logoutUrl("/logout")
			.logoutSuccessUrl("/login")
		.and()
			.formLogin()
			.usernameParameter("userId")
			.passwordParameter("pwd")
			.loginProcessingUrl("/login/check")
			.failureHandler(authenticationFailureHandler())				//로그인 실패
			.successHandler(authenticationSuccessHandler())				//로그인 성공
			.loginPage("/login");
    }
    
    private String getUserQuery() {
    	return "SELECT user_id AS userId, password, name as userName, department, position, grade FROM admin_mst WHERE user_id = ?";
    }

}

