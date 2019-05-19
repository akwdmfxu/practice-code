package kr.practice.code.common.filter;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import com.nhncorp.lucy.security.xss.XssFilter;

public class RequestBodyXSSWrapper extends HttpServletRequestWrapper {

	private byte[] b;

	public RequestBodyXSSWrapper(HttpServletRequest request) throws IOException {
		super(request);
		
		//에러페이지로 포워딩시 에러가 발생한다....
		if(getUrlCheck(request.getRequestURI())){
			String contentType = request.getContentType();
	        if ((contentType != null) && contentType.startsWith("multipart/form-data")) return;
	        
	        XssFilter filter = XssFilter.getInstance("lucy-xss-sax.xml", true);
	     	b = new String(filter.doFilter(getBody(request))).getBytes();
		}
	}
	
	private boolean getUrlCheck(String url){
		boolean sw = true;
		
		//에러페이지, 에러페이지 데코레이터(emptyLayout.jsp)의 호출에서도 에러 발생...
		String[] urlarr = {"/error", "/views/tiles/layout/"};
		for(String check : urlarr){
			if(url.contains(check)){
				sw = false;
				break;
			}
		}
		
		return sw;
	}

	public ServletInputStream getInputStream() throws IOException {
 		final ByteArrayInputStream bis = new ByteArrayInputStream(b);
 		return new ServletInputStreamImpl(bis);
 	}
 	
 	class ServletInputStreamImpl extends ServletInputStream {

 		private InputStream is;
 		
 		public ServletInputStreamImpl(InputStream bis){
 			is = bis;
 		}
 		
 		public int read() throws IOException {
 			return is.read();
 		}

 		public int read(byte[] b) throws IOException {
 			return is.read(b);
 		}

		@Override
		public boolean isFinished() {
			return false;
		}

		@Override
		public boolean isReady() {
			return false;
		}

		@Override
		public void setReadListener(ReadListener arg0) {
			
		}
 	}
 	
 	public static String getBody(HttpServletRequest request) throws IOException {

 	    String body = null;
 	    StringBuilder stringBuilder = new StringBuilder();
 	    BufferedReader bufferedReader = null;

 	    try {
 	        InputStream inputStream = request.getInputStream();

 	        if (inputStream != null) {

 	            bufferedReader = new BufferedReader(new InputStreamReader(inputStream));
 	            char[] charBuffer = new char[128];
 	            int bytesRead = -1;

 	            while ((bytesRead = bufferedReader.read(charBuffer)) > 0) {
 	                stringBuilder.append(charBuffer, 0, bytesRead);
 	            }
 	        }
 	        else {
 	            stringBuilder.append("");
 	        }
 	    }
 	    catch (IOException ex) {
 	        throw ex;
 	    }
 	    finally {
 	        if (bufferedReader != null) {
 	            try {
 	                bufferedReader.close();
 	            }
 	            catch (IOException ex) {
 	                throw ex;
 	            }
 	        }
 	    }

 	    body = stringBuilder.toString();

 	    return body;
 	}
}
