package kr.practice.code.configuration;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.servlet.MultipartConfigElement;
import javax.servlet.http.HttpServletRequest;
import javax.xml.transform.Source;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.autoconfigure.web.ServerProperties;
import org.springframework.boot.autoconfigure.web.servlet.error.BasicErrorController;
import org.springframework.boot.web.servlet.MultipartConfigFactory;
import org.springframework.boot.web.servlet.error.ErrorAttributes;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.MediaType;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.ResourceHttpMessageConverter;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.http.converter.support.AllEncompassingFormHttpMessageConverter;
import org.springframework.http.converter.xml.SourceHttpMessageConverter;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.web.multipart.MultipartResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.multipart.support.StandardServletMultipartResolver;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.ContentNegotiationConfigurer;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.view.JstlView;
import org.springframework.web.servlet.view.UrlBasedViewResolver;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;
import org.springframework.web.servlet.view.tiles3.TilesConfigurer;
import org.springframework.web.servlet.view.tiles3.TilesView;
import org.springframework.web.servlet.view.tiles3.TilesViewResolver;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

@Configuration
@EnableAsync
public class WebConfiguration implements WebMvcConfigurer {
	
	private static final Logger logger = LoggerFactory.getLogger(WebConfiguration.class);
	
	static{
		logger.info("Configure Webapp");
	}
	
//	tiles
//	@Override
//	public void addResourceHandlers(ResourceHandlerRegistry registry){
//		registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
//	}
//
//	@Override
//	public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer){
//		configurer.enable();
//	}
//	
//	@Bean
//	public UrlBasedViewResolver urlBasedViewResolver(){
//		UrlBasedViewResolver viewResolver = new UrlBasedViewResolver();
//		viewResolver.setViewClass(TilesView.class);
//		viewResolver.setPrefix("/views/pages/");
//		viewResolver.setSuffix(".jsp");
//		return viewResolver;
//	}
//
//	@Bean
//	public TilesConfigurer tilesConfigurer(){
//	    TilesConfigurer tilesConfigurer = new TilesConfigurer();
//	    tilesConfigurer.setDefinitions(new String[] {"/views/tiles/tiles.xml"});
//	    tilesConfigurer.setCheckRefresh(true);
//	    return tilesConfigurer;
//	}
//	
//	@Override
//	public void configureViewResolvers(ViewResolverRegistry registry) {
//		TilesViewResolver viewResolver = new TilesViewResolver();
//		registry.viewResolver(viewResolver);
//		
//		// .json
//		MappingJackson2JsonView jsonView = new MappingJackson2JsonView();
//        jsonView.setPrettyPrint(true);
//
//        registry.enableContentNegotiation(jsonView);
//        registry.viewResolver(viewResolver);
////      확인 필요
////      super.configureViewResdolvers(registry);
//	}
//
//    @Override
//    public void configureContentNegotiation(ContentNegotiationConfigurer configurer) {
//    	configurer.defaultContentType(MediaType.APPLICATION_JSON);
//    }
//	
//    @Override
//	public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
//
//		StringHttpMessageConverter stringConverter = new StringHttpMessageConverter();
//		stringConverter.setWriteAcceptCharset(false);
//		converters.add(stringConverter);
//
//		converters.add(new ByteArrayHttpMessageConverter());
//		converters.add(new ResourceHttpMessageConverter());
//		converters.add(new SourceHttpMessageConverter<Source>());
//		converters.add(new AllEncompassingFormHttpMessageConverter());
//
//		converters.add(jackson2Converter());
//	}
//
//	@Bean
//	public MappingJackson2HttpMessageConverter jackson2Converter() {
//		MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
//		converter.setObjectMapper(objectMapper());
//		return converter;
//	}
//
//	@Bean
//	public ObjectMapper objectMapper() {
//		ObjectMapper objectMapper = new ObjectMapper();
//		objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
//		return objectMapper;
//	}
//	
//	/**
//	 * Interceptor 설정
//	 */
////    @Override
////    public void addInterceptors(InterceptorRegistry registry) {
////    	// /*의 설정은 1Depth만... /**의 설정으로 1Depth 이상...
////        registry.addInterceptor(new BaseInterceptor()).addPathPatterns("/**");
////    }
//    
//    /**
//     * Error page
//     * <pre>
//	 * application.properties 설정
//	 *  - server.error.path=/error					예외가 발생시 리다이렉트할 URI를 지정한다.
//	 *  - server.error.include-stacktrace=always	예외가 발생했을 때 스택 트레이스를 볼 것인가를 지정한다.
//														never: 보지 않음. (기본값)
//														always: 항상 본다.
//														on_trace_param: URI에 파라미터로 trace=true로 주었을 때만 본다.
//	 *  - server.error.whitelabel.enabled=false		스프링 부트에서 기본적으로 제공하는 윗 그림과 같은 에러페이지를 볼 것인지를 지정한다. false로 설정할 겨우 기본 서블릿 컨테이너 에러 화면을 보게 된다.
//	 * 
//     * </pre>
//     */
//    @Bean
//    public BasicErrorController errorController(ErrorAttributes errorAttributes, ServerProperties serverProperties) {
//        return new BasicErrorController(errorAttributes, serverProperties.getError()) {
//            protected Map<String, Object> getErrorAttributes(HttpServletRequest request, boolean includeStackTrace) {
//            	
//                Map<String, Object> errorAttr = super.getErrorAttributes(request, includeStackTrace);
////                System.out.println("errorAttr : " + errorAttr);
//                
//                request.setAttribute("errorCode", errorAttr.get("status"));
//                request.setAttribute("errorMsg", errorAttr.get("error"));
//
//                return errorAttr;
//            }
//        };
//    }
//    
//    @Bean
//	public LocaleResolver localeResolver(){
//		CookieLocaleResolver resolver = new CookieLocaleResolver();
//		resolver.setCookieName("selectLocale");
//		resolver.setDefaultLocale(new Locale("ko"));
//		
//		return resolver;
//	}
//    
//    @Override
//	public void addInterceptors(InterceptorRegistry registry){
//		LocaleChangeInterceptor localeChangeInterceptor = new LocaleChangeInterceptor();
//		localeChangeInterceptor.setParamName("lang");
//		registry.addInterceptor(localeChangeInterceptor);
//		
//		registry.addInterceptor(new BaseInterceptor()).addPathPatterns("/**");
//	}
//    
//    @Bean
//	public MessageSource messageSource(){
//		ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
//		messageSource.setBasenames("resources/messages/message", "resources/messages/common");
//		messageSource.setDefaultEncoding("UTF-8");
//		return messageSource;
//	}
//    
//    @Bean
//    public MessageSourceAccessor messageSourceAccessor(){
//    	return new MessageSourceAccessor(messageSource());
//    }
	
	
//	tiles 빼고
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry){
		registry.addResourceHandler("/resources/**").addResourceLocations("/resources/");
	}
	
	@Override
    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
        configurer.enable();
    }
	
	@Bean
	public UrlBasedViewResolver urlBasedViewResolver() {
		UrlBasedViewResolver viewResolver = new UrlBasedViewResolver();
		viewResolver.setViewClass(JstlView.class);
		viewResolver.setPrefix("/views/");
		viewResolver.setSuffix(".jsp");

		return viewResolver;
	}

	@Override
	public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {

		StringHttpMessageConverter stringConverter = new StringHttpMessageConverter();
		stringConverter.setWriteAcceptCharset(false);
		converters.add(stringConverter);

		converters.add(new ByteArrayHttpMessageConverter());
		converters.add(new ResourceHttpMessageConverter());
		converters.add(new SourceHttpMessageConverter<Source>());
		converters.add(new AllEncompassingFormHttpMessageConverter());

		converters.add(jackson2Converter());
	}

	@Bean
	public MappingJackson2HttpMessageConverter jackson2Converter() {
		MappingJackson2HttpMessageConverter converter = new MappingJackson2HttpMessageConverter();
		converter.setObjectMapper(objectMapper());
		return converter;
	}

	@Bean
	public ObjectMapper objectMapper() {
		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.enable(SerializationFeature.INDENT_OUTPUT);
		return objectMapper;
	}
	
	private final int MAX_SIZE = 10 * 1024 * 1024;
	
//	옛날 버전 filesize 설정하기
//	@Bean
//	public MultipartConfigElement multipartConfigElement() {
//		MultipartConfigFactory factory = new MultipartConfigFactory();
//		factory.setMaxFileSize("10MB");
//		factory.setMaxRequestSize("10MB");
//		return factory.createMultipartConfig();
//	}
	
//	filesize 설정하기
	@Bean
	public MultipartResolver multipartResolver() {
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
		multipartResolver.setMaxUploadSize(MAX_SIZE); // 10MB
		multipartResolver.setMaxUploadSizePerFile(MAX_SIZE); // 10MB
		multipartResolver.setMaxInMemorySize(0);
		return multipartResolver;
	}
	
}

