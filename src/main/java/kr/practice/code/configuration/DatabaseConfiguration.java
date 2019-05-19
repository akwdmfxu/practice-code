package kr.practice.code.configuration;
import javax.sql.DataSource;

import org.apache.commons.dbcp.BasicDataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
public class DatabaseConfiguration {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(DatabaseConfiguration.class);
	
	static {
		LOGGER.info("Configure Database - Mysql");
	}
	
	private String CLASSNAME = "";
	private String USERNAME = "";
	private String PASSWORD = "";
	private String URL = "";
	
	@Bean
   	public DataSource dataSource() {
   		BasicDataSource dataSource = new BasicDataSource();
   		dataSource.setDriverClassName(CLASSNAME);
   		dataSource.setUsername(USERNAME);
   		dataSource.setPassword(PASSWORD);
   		dataSource.setUrl(URL);
   		dataSource.setValidationQuery("select 1");
   		dataSource.setValidationQueryTimeout(86400);
   		
   		return dataSource;
   	}

	@Bean
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager(dataSource());
        transactionManager.setGlobalRollbackOnParticipationFailure(false);
        return transactionManager;
    }
	
	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception {
   		SqlSessionFactoryBean sessionFactoryBean = new SqlSessionFactoryBean();
   		sessionFactoryBean.setDataSource(dataSource());
   		sessionFactoryBean.getObject().getConfiguration().setMapUnderscoreToCamelCase(true);
   		return sessionFactoryBean.getObject();
   	}
	
	/**************************************************
	 * <pre>
	 *  기존 domain 설정은
	 *  sessionFactoryBean.setTypeAliases(
		new Class<?>[] {
			AdminDto.class , EventDto.class 
		});
	 *  아래와 같이 설정해서 사용.
	 *  <typeAlias alias="adminDto" type="kr.lifesemantics.service.dashboard.model.AdminDto" />
	 *  
	 *  mapper.xml내에 AdminDto로 사용을 -> adminDto와 같이 사용
	 *  
	 *  설정 : config/mybatis.xml 내에 설정해서 alias를 사용.
	 *  
	 *  </pre>
	 *  
	 * @MethodName : sqlSessionFactory
	 * @Description: Mybatis 설정 (xml 사용시)
	 * @return SqlSessionFactory
	 * @throws Exception
	 * @Author     : DK. Kang
	 * @Version    : 2019. 4. 28.
	**************************************************/
//	@Bean
//	public SqlSessionFactory sqlSessionFactory() throws Exception {
//		SqlSessionFactoryBean sessionFactoryBean = new SqlSessionFactoryBean();
//		sessionFactoryBean.setDataSource(dataSource());
//		sessionFactoryBean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources("mapper/**/*.xml"));
//   		sessionFactoryBean.setConfigLocation(new PathMatchingResourcePatternResolver().getResource("config/mybatis.xml"));
//   		
//		sessionFactoryBean.getObject().getConfiguration().setMapUnderscoreToCamelCase(true);
//		return sessionFactoryBean.getObject();
//	}
	
}