package kr.practice.code.util;

import java.util.Random;

public class RandomUtil {

	public static int getRandom(int num){
		Random rand = new Random();
		int rnd = rand.nextInt(num);
		return rnd;
	}
	
	public static int getRGBColor(){
		Random rand = new Random();		 
		return rand.nextInt(255);
	}
}
