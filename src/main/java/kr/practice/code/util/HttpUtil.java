package kr.practice.code.util;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.NetworkInterface;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.Model;

public class HttpUtil {

	private static final Logger logger = LoggerFactory.getLogger(HttpUtil.class);
	
	/************************************************** 
     * @MethodName : createCookie
     * @Description: Cookies created
     * @param setName
     * @param setValue
     * @param maxage
     * @param path
     * @param response void
     * @Author     : Won-Joon. Lee
     * @Version    : 2016. 01. 14.
    **************************************************/
    public static void createCookie(String setName, String setValue, int maxage, String path, HttpServletResponse response) {
        Cookie cookie = new Cookie(setName, setValue);
        cookie.setMaxAge(maxage);
        cookie.setPath(path);

        response.addCookie(cookie);
    }

    /************************************************** 
     * @MethodName : deleteCookie
     * @Description: cookie delete
     * @param getName
     * @param cookies
     * @param path
     * @param response void
     * @Author     : Won-Joon. Lee
     * @Version    : 2016. 01. 14.
    **************************************************/
    public static void deleteCookie(String getName, Cookie[] cookies, String path, HttpServletResponse response) {

        if (cookies != null) {
            for (int i = 0; i < cookies.length; i++) {
                if (cookies[i].getName().equals(getName)) {
                    cookies[i].setMaxAge(0);
                    cookies[i].setPath(path);
                    response.addCookie(cookies[i]);
                }
            }
        }
    }

    /************************************************** 
	 * @MethodName : getValueFromCookie
	 * @Description: Load cookies settings
	 * @param getName
	 * @param request
	 * @return String
	 * @Author     : Won-Joon. Lee
	 * @Version    : 2016. 01. 14.
	**************************************************/
    public static String getValueFromCookie(String getName, HttpServletRequest request) {

        String getValue = "";
        Cookie[] cookies = request.getCookies();

        if (cookies != null) {
            for (int i = 0; i < cookies.length; i++) {
                if (cookies[i].getName().equals(getName)) {
                    getValue = cookies[i].getValue();
                    break;
                }
            }
        }
        return getValue;
    }

    /************************************************** 
     * @MethodName : getRequestMap
     * @Description: Setting the parameter value map
     * @param request
     * @return HashMap<String,String>
     * @Author     : Won-Joon. Lee
     * @Version    : 2016. 01. 14.
    **************************************************/
    public static HashMap<String, String> getRequestMap(HttpServletRequest request) {
        HashMap<String, String> map = new HashMap<String, String>();
        String reqName = "";

        for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();) {
            reqName = e.nextElement();
            map.put(reqName, request.getParameter(reqName)).trim();
        }
        
        return map;
    }

    /************************************************** 
     * @MethodName : jsonObjToMap
     * @Description: Setting the parameter json value map
     * @param obj
     * @return HashMap<String,String>
     * @Author     : Won-Joon. Lee
     * @Version    : 2016. 01. 14.
    **************************************************/
    public static HashMap<String, String> jsonObjToMap(JSONObject obj){
        HashMap<String, String> map = new HashMap<String, String>();
        Iterator<?> keys = obj.keySet().iterator();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            map.put(key, (String) obj.get(key));
        }
        return map;
    }

    /************************************************** 
     * @MethodName : getRequestDataMap
     * @Description: Setting the parameter value DataMap
     * @param request
     * @return DataMap
     * @Author     : Won-Joon. Lee
     * @Version    : 2016. 01. 14.
    **************************************************/
	@SuppressWarnings("unchecked")
    public static DataMap getRequestDataMap(HttpServletRequest request) {
    	DataMap map = new DataMap();
        String reqName = "";
        
        for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();) {
            reqName = e.nextElement();
            String val = request.getParameter(reqName).trim();
            map.put(reqName, val);
            logger.info("reqName : {}, value : {}", reqName, val);
        }

        return map;
    }

	/************************************************** 
     * @MethodName : jsonObjToDataMap
     * @Description: Setting the parameter json value DataMap
     * @param obj
     * @return DataMap
     * @Author     : Won-Joon. Lee
     * @Version    : 2016. 01. 14.
    **************************************************/
    @SuppressWarnings("unchecked")
	public static DataMap jsonObjToDataMap(JSONObject obj){
    	DataMap map = new DataMap();
        Iterator<?> keys = obj.keySet().iterator();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            map.put(key, (String) obj.get(key));
        }
        return map;
    }

	public static boolean testInet(String url, int port) {
		Socket sock = new Socket();
		InetSocketAddress addr = new InetSocketAddress(url, port);
		try {
			sock.connect(addr,3000);
			return true;
		} catch (IOException e) {
			return false;
		} finally {
			try {sock.close();}
			catch (IOException e) {}
		}
	}
	
	public static String getMacAddress() throws UnknownHostException, SocketException{
		InetAddress ipAddress = InetAddress.getLocalHost();
		NetworkInterface networkInterface = NetworkInterface.getByInetAddress(ipAddress);
		byte[] macAddressBytes = networkInterface.getHardwareAddress();
		StringBuilder macAddressBuilder = new StringBuilder();
		
		for (int macAddressByteIndex = 0; macAddressByteIndex < macAddressBytes.length; macAddressByteIndex++){
		    String macAddressHexByte = String.format("%02X",macAddressBytes[macAddressByteIndex]);
		    macAddressBuilder.append(macAddressHexByte);
		
		    if (macAddressByteIndex != macAddressBytes.length - 1){
		        macAddressBuilder.append(":");
		    }
		}
	
		logger.info("::::::: " + macAddressBuilder.toString());
		return macAddressBuilder.toString();
	}
	
	/************************************************** 
	 * @MethodName : getParams
	 * @Description: 파라미터 정보 페이지 전달
	 * @param paramMap
	 * @param model void
	 * @Author     : Won-Joon. Lee
	 * @Version    : 2017. 5. 13.
	**************************************************/
	@SuppressWarnings("unchecked")
	public static void getParams(DataMap paramMap, Model model){
		
		for(Iterator<String> it = paramMap.keySet().iterator();it.hasNext();){
			String key = it.next();
			String value = paramMap.getString(key);
//			logger.info("model param set ::: key : {}, value : {}", key, value);
			if(StringUtils.isNotEmpty(value)) model.addAttribute(key, value);
		}
	}
	
	/************************************************** 
	 * <PRE>
     * PC의 HOST명 가져오기 <br>     
     * getHostName() = "localhost-PC" <br>
     * ClassName    : Util <br>
     * MethodName   : getHostName <br>
     * 처리내용       :
     * - Biz Logic (간략)
     *   PC의 HOST명 가져오기     getHostName() = "localhost-PC"
     * </PRE>
	 * @MethodName : getHostName
	 * @Description: 해당 프로젝트가 서버 2대에 배포되고 있는데... 1대의 서버에서만 스케줄링하기 위한 구분값??
	 * @return String
	 * @Author     : Won-Joon. Lee
	 * @Version    : 2018. 1. 29.
	**************************************************/
	public static String getHostName(){
		
		String hostName = "";
		
        try{
            InetAddress ownIP = InetAddress.getLocalHost();
            hostName = ownIP.getHostName();
        }catch (Exception e){
            logger.error("host name load error : {}", e.getMessage());
        }
        
		logger.info("hostName : {}", hostName);
		
		return hostName;
	}
}
