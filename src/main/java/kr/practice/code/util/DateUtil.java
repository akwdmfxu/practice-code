package kr.practice.code.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.apache.commons.lang.StringUtils;


public class DateUtil {
	
	public static String getSimpleDate() {
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMddHHmmssSSS");
		return format.format(new Date());
	}

	public static String getSimpleDate(String dateFormat) {
		SimpleDateFormat format = new SimpleDateFormat(dateFormat);
		return format.format(new Date());
	}

	/**
	 * Date pattern change
	 * @param ymd - Enter dates
	 * @param pattern - Current patterns
	 * @param returnPattern - Changing patterns
	 * @return
	 * @throws Exception
	 */
	public static String dateParse(String ymd, String pattern, String returnPattern){
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		Date date = null;
		
		try {
			date = sdf.parse(ymd);
		} catch (ParseException e) {
			System.out.println("날짜 변환 오류 : " + e);
		}

		sdf = new SimpleDateFormat(returnPattern);
		return sdf.format(date);
	}

	/**
	 * Date difference calculation
	 * @param begin - Started
	 * @param end - End
	 * @return
	 * @throws Exception
	 */
	public static long diffOfDate(String begin, String end) {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMdd");

		Date beginDate = null;
		Date endDate = null;
		try {
			beginDate = formatter.parse(begin);
			endDate = formatter.parse(end);
		} catch (ParseException e) {
			System.out.println("날짜 변환 오류 : " + e);
		}

		long diff = endDate.getTime() - beginDate.getTime();
		long diffDays = diff / (24 * 60 * 60 * 1000);

		return diffDays;
	}

	/**************************************************
	 * @MethodName : calculationDate
	 * @Description: Date of +/- calculation at a given date
	 * @param ymd
	 * @param nowPattern
	 * @param newPattern
	 * @param plusNum
	 * @param minusNum
	 * @return String
	 * @throws Exception
	 * @Author     : Won-Joon. Lee
	 * @Version    : 2014. 11. 14.
	**************************************************/
	@SuppressWarnings("static-access")
    public static String calculationDate(String ymd, String nowPattern, String newPattern, int plusNum, int minusNum){
		SimpleDateFormat sdf = new SimpleDateFormat(nowPattern);

		Date date = null;
		
		try {
			date = sdf.parse(ymd);
		} catch (ParseException e) {
			System.out.println("날짜 변환 오류 : " + e);
		}

		Calendar cal = Calendar.getInstance();

		cal.setTime(date);

		if(plusNum > 0){
			cal.add(cal.DATE, plusNum);
		}else if(minusNum > 0){
			cal.add(cal.DATE, - minusNum);
		}

		sdf = new SimpleDateFormat(newPattern);

		return sdf.format(cal.getTime());
	}
	
	/**************************************************
	 * @MethodName : calculationMonth
	 * @Description: Date of +/- calculation at a given date
	 * @param ym
	 * @param nowPattern
	 * @param returnPattern
	 * @param plusNum
	 * @param minusNum
	 * @return String
	 * @throws Exception
	 * @Author     : Won-Joon. Lee
	 * @Version    : 2014. 11. 14.
	**************************************************/
	@SuppressWarnings("static-access")
    public static String calculationMonth(String ymd, String nowPattern, String returnPattern, int plusNum, int minusNum){
		SimpleDateFormat sdf = new SimpleDateFormat(nowPattern);

		Date date = null;
		try {
			date = sdf.parse(ymd);
		} catch (ParseException e) {
			System.out.println("날짜 변환 오류 : " + e);
		}

		Calendar cal = Calendar.getInstance();

		cal.setTime(date);

		if(plusNum > 0){
			cal.add(cal.MONTH, plusNum);
		}else if(minusNum > 0){
			cal.add(cal.MONTH, - minusNum);
		}

		sdf = new SimpleDateFormat(returnPattern);

		return sdf.format(cal.getTime());
	}
	
	public static String diffTimes(String dttm1, String dttm2, String pattern){
		
		long min = 0;
		
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		
		try{
			Date date1 = sdf.parse(dttm1);
			Date date2 = sdf.parse(dttm2);
			
			long s = date1.getTime();
			long e = date2.getTime();
			
			min = (e - s) / 60000;			
		}catch(Exception e){
			System.out.println("날짜 변환 오류 : " + e);
		}
		
		System.out.println("시간의 차이는 " + min + "분 입니다.");
		
		return String.valueOf(min);
	}
	
	public static String calculationTime(String dttm, String pattern, String returnPattern, int num){
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);

		Date date = null;
		try {
			date = sdf.parse(dttm);
		} catch (ParseException e) {
			System.out.println("날짜 변환 오류 : " + e);
		}

		Calendar cal = Calendar.getInstance();

		cal.setTime(date);

		cal.add(cal.MINUTE, num);

		sdf = new SimpleDateFormat(returnPattern);

		return sdf.format(cal.getTime());
	}
	
	public static String getLastDayFromMonth(String ymd, String nowPattern, String returnPattern){
		SimpleDateFormat sdf = new SimpleDateFormat(nowPattern);
		Date date = null;
		Calendar calendar = Calendar.getInstance();
		
		try {
			date = sdf.parse(ymd);
		} catch (ParseException e) {
			System.out.println("날짜 변환 오류 : " + e);
		}
		
		calendar.set(date.getYear(), date.getMonth(), 1);
		Integer DayOfMonth =calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

		sdf = new SimpleDateFormat(returnPattern);

		return DayOfMonth.toString();
	}
	
	@SuppressWarnings("unchecked")
	public static DataMap getThisWeek(String pattern){
		
		DataMap map = new DataMap();
		
		SimpleDateFormat sdf = new SimpleDateFormat(pattern);
		
		Date date = new Date();
		
		Calendar cal = Calendar.getInstance(Locale.KOREA);
		cal.setTime(date);		
		cal.add(Calendar.DATE, 1 - cal.get(Calendar.DAY_OF_WEEK));		
		map.put("startYmd", sdf.format(cal.getTime()));
		
		cal.setTime(date);
		cal.add(Calendar.DATE, 7 - cal.get(Calendar.DAY_OF_WEEK));
		map.put("endYmd", sdf.format(cal.getTime()));
		
		return map;
	}
	
	public static List<DataMap> getPeriodDate(String startYmd, String endYmd, String datePattern, String returnPattern, String addPattern){
		
		SimpleDateFormat sdf = new SimpleDateFormat(datePattern);
		
		Date sDate = null;
		Date eDate = null;
		try {
			sDate = sdf.parse(startYmd);
			eDate = sdf.parse(endYmd);
		} catch (ParseException e) {
			System.out.println("날짜 변환 오류 : " + e);
		}
		
		sdf = new SimpleDateFormat("yyyyMMdd");		
		String sYmd = sdf.format(sDate);
		String eYmd = sdf.format(eDate);
		
		long diffDate = diffOfDate(sYmd, eYmd);
		
		List<DataMap> dateList = new ArrayList<DataMap>();
		
		sdf = new SimpleDateFormat(returnPattern);
		
		if(StringUtils.isEmpty(addPattern)) addPattern = "d일";
		SimpleDateFormat dayPtt = new SimpleDateFormat(addPattern);
		
		Calendar cal = Calendar.getInstance();	
		
		for(int i=0;i<=diffDate;i++){
			cal.setTime(sDate);
			cal.add(Calendar.DATE, i);
			
			DataMap tmpMap = new DataMap();
			tmpMap.put("ymd", sdf.format(cal.getTime()));
			tmpMap.put("day", dayPtt.format(cal.getTime()));
			
			dateList.add(tmpMap);
		}
		
		return dateList;
	}
	
	public static void main(String[] args) throws Exception {
//		System.out.println(dateParse("1979/08/25", "yyyy/MM/dd", "yyyyMMdd"));
//		String min = diffTimes("2017-06-25 22:30", "2017-06-25 23:30", "yyyy-MM-dd HH:mm");
//		String time = calculationTime("201706252330", "yyyyMMddHHmm", "HH:mm", Integer.parseInt(min));
//		System.out.println("time : " + time);
//		DataMap map = getThisWeek("yyyy-MM-dd");
//		System.out.println("map : " + map);
		
		List<DataMap> dateList = getPeriodDate("2018-03-08", "2018-03-08", "yyyy-MM-dd", "yyyyMMdd", "M월 d일");
		for(int i=0;i<dateList.size();i++){
			System.out.println("i : " + i + ", date : " + dateList.get(i));
		}			
	}
}