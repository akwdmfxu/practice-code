package kr.practice.code.common;

import java.util.HashMap;
import java.util.Map;

public class ErrorMessage {

	public static final int BAD_REQUEST = 400;
	public static final int UNAUTHORIZED = 401;
	public static final int FORBIDDEN = 403;
	public static final int NOT_FOUND = 404;
	public static final int METHOD_NOT_ALLOWED = 405;
	public static final int INTERNAL_SERVER_ERROR = 500;
	public static final int SERVICE_UNAVAILABLE = 503;
	
	private static Map<Integer, String> resultMsgs;
	
	static {
		resultMsgs = new HashMap<Integer, String>();
		
		resultMsgs.put(BAD_REQUEST, "잘못된 요청입니다.");
		resultMsgs.put(UNAUTHORIZED, "접근 권한이 없습니다.");
		resultMsgs.put(FORBIDDEN, "접근이 금지되었습니다.");
		resultMsgs.put(NOT_FOUND, "요청하신 페이지가 존재하지 않습니다.");
		resultMsgs.put(METHOD_NOT_ALLOWED, "요청된 메소드가 허용되지 않습니다.");
		resultMsgs.put(INTERNAL_SERVER_ERROR, "서버에 오류가 발생하였습니다.");
		resultMsgs.put(SERVICE_UNAVAILABLE, "서비스를 사용할 수 없습니다.");
	}
	
	public static String getMessage(int errorCode) {
		return resultMsgs.get(errorCode);
	}
}
