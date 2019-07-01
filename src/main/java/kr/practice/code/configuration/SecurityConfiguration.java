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
import org.springframework.security.oauth2.provider.approval.JdbcApprovalStore;
import org.springframework.security.oauth2.provider.token.TokenStore;
import org.springframework.security.oauth2.provider.token.store.JdbcTokenStore;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.web.filter.CharacterEncodingFilter;

import kr.practice.code.handler.LoginFailuerHandler;
import kr.practice.code.handler.LoginSuccessHandler;
import kr.practice.code.handler.PageAccessDeniedHandler;
import kr.practice.code.util.security.AdminManager;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled=true)
public class SecurityConfiguration extends WebSecurityConfigurerAdapter {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(SecurityConfiguration.class);
	
	static {
		LOGGER.info("Configure Security Server");
	}
	
	private static final String FIND_USERNAME_QUERY = "SELECT TT.username, TT.password, TS.saltkey FROM Common.admin TT, Common.admin_salt TS WHERE TT.username = ? AND TT.idx = TS.admin_id;";
	private static final String FIND_AUTHORITIES_QUERY = "SELECT TT.username, TS.role FROM Common.admin TT, Common.admin_authority TS WHERE TT.username = ? AND TT.idx = TS.admin_id;";
	
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
		
		AdminManager manager = new AdminManager();
		
		manager.setDataSource(dataSource);
		manager.setUsersByUsernameQuery(FIND_USERNAME_QUERY);
		manager.setAuthoritiesByUsernameQuery(FIND_AUTHORITIES_QUERY);
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
			.antMatchers("/", "/deny", "/check", "/operation/admin/detail").permitAll()
//			.antMatchers("/enrollment/**", "/inventory/**",  "/admin/**", "/images/**").hasAnyRole("SUPER", "MINI")
			.anyRequest().authenticated()
			.and()
		.formLogin()
			.loginPage("/")
			.usernameParameter("j_username")
			.passwordParameter("j_password")
			.loginProcessingUrl("/login")
//			.successHandler(new LoginSuccessHandler("/enrollment/list"))
			.successHandler(authenticationSuccessHandler())
			.failureHandler(authenticationFailureHandler())
			.and()
		.logout()
			.logoutUrl("/logout")
			.logoutSuccessUrl("/")
			.and()
		.exceptionHandling()
			.accessDeniedPage("/")
			.accessDeniedHandler(new PageAccessDeniedHandler())
			.and()
		.csrf().disable()
		;
    }

    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
    	return new LoginSuccessHandler("/main");
    }
    
    @Bean
    public AuthenticationFailureHandler authenticationFailureHandler() {
    	return new LoginFailuerHandler();
    }

}

