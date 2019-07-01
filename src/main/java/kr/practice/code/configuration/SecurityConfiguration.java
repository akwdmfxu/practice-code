package kr.practice.code.configuration;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.authentication.dao.ReflectionSaltSource;
import org.springframework.security.authentication.encoding.ShaPasswordEncoder;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.provider.approval.JdbcApprovalStore;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.oauth2.provider.token.store.JdbcTokenStore;
import org.springframework.security.web.access.ExceptionTranslationFilter;
import org.springframework.security.web.header.writers.frameoptions.XFrameOptionsHeaderWriter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.filter.CharacterEncodingFilter;

import kr.practice.code.common.filter.AjaxSessionTimeoutFilter;
import kr.practice.code.common.security.AuthenticationFailureImpl;
import kr.practice.code.common.security.AuthenticationLogoutSuccessImpl;
import kr.practice.code.common.security.AuthenticationSuccessImpl;
import kr.practice.code.common.security.UserManager;
import kr.practice.code.util.security.SHA256;
import kr.practice.code.util.security.SHA512;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled=true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityConfiguration.class);
	
	static {
		LOGGER.info("Configure Security Server");
	}
	
	@Autowired DataSource dataSource;
	
	@Bean
	public TokenStore tokenStore() {
		return new JdbcTokenStore(dataSource);
	}
	
	@Bean
	public org.springframework.security.oauth2.provider.approval.ApprovalStore ApprovalStore() {
		return new JdbcApprovalStore(dataSource);
	}
	
	@Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		
		ReflectionSaltSource rss = new ReflectionSaltSource();
		rss.setUserPropertyToUse("salt");
		ShaPasswordEncoder shaPasswordEncoder = new ShaPasswordEncoder();
		
		UserManager manager = new UserManager();
		
		manager.setDataSource(dataSource);
		manager.setUsersByUsernameQuery(getUserQuery());
		manager.setAuthoritiesByUsernameQuery(getAuthoritiesQuery());
		manager.setEnableAuthorities(true);
		manager.setEnableGroups(false);
		
		DaoAuthenticationProvider provider = new DaoAuthenticationProvider();
		provider.setSaltSource(rss);
		provider.setPasswordEncoder(shaPasswordEncoder);
		provider.setUserDetailsService(manager);
		 
		auth.authenticationProvider(provider);
    }
	
	
    @Override
    public void configure(WebSecurity web) throws Exception {
        web.ignoring().antMatchers("/webjars/**", "/oauth/uncache_approvals", "/oauth/cache_approvals", "/images/**", "/error/*", "/font/**", "/js/**", "/css/**", "/img/**");
    }

    @Override 
    @Bean
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        
    	CharacterEncodingFilter filter = new CharacterEncodingFilter();
        filter.setEncoding("UTF-8");
        filter.setForceEncoding(true);
        
        http
		.authorizeRequests()
		.anyRequest().permitAll()
		.and()
		.exceptionHandling()
		.accessDeniedPage("/")
		.and()
		.csrf()
		.requireCsrfProtectionMatcher(new AntPathRequestMatcher("/oauth/authorize"))
		.disable()
		.logout()
		.logoutUrl("/logout")
		.logoutSuccessUrl("/sginin")
		.and()
		.formLogin()
		.usernameParameter("j_username")
		.passwordParameter("j_password")
		.loginProcessingUrl("/j_spring_security_check")
		.failureUrl("/signin?msg=failure")
		.loginPage("/signin");
    }
    
    private String getUserQuery() {
    	return "SELECT TT.userkey, TT.useremail, TT.userphone, TT.password, TS.salt, TT.status FROM ACCOUNTS TT, SALT TS WHERE TT.username = ? AND TT.userkey = TS.userkey;";
    }

    private String getAuthoritiesQuery() {
    	return "SELECT TT.userkey, TS.authority FROM ACCOUNTS TT, AUTHORITIES TS WHERE TT.username = ? AND TT.userkey = TS.userkey;";
    }

}
