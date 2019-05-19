package kr.practice.code.util.security;

import java.security.MessageDigest;

public class SHA256 {
	
	public static String encode(String value) {
		
		MessageDigest	md			= null;
		StringBuffer	string		= new StringBuffer();
		StringBuffer	hexString	= new StringBuffer();
		byte[]			bip;

		try {
			md = MessageDigest.getInstance("SHA-256");
		}
		catch (Exception e) {
			return "";
		}

		md.update(value.getBytes());

		bip = md.digest();

		for (int i=0; i < bip.length; i++) {
			string.append(Integer.toString((bip[i] & 0xff) + 0x100, 16).substring(1));
        }

		for (int i=0; i < bip.length; i++) {
			String hex = Integer.toHexString(0xff & bip[i]);

			if (hex.length() == 1) hexString.append('0');

	    	hexString.append(hex);
        }

		return string.toString();
	}
	
}
