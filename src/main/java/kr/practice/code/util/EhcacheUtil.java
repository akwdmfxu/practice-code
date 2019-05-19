package kr.practice.code.util;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

/************************************************** 
 * @FileName   : EhcacheUtil.java
 * @Description: Ehcache management class
 * @Author     : joon
 * @Version    : 2016. 01. 14.
 **************************************************/
public class EhcacheUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EhcacheUtil.class);
	
	/************************************************** 
	 * @MethodName : getCache
	 * @Description: Get cached data
	 * @param cacheNm
	 * @return Object
	 * @Author     : joon
	 * @Version    : 2016. 01. 14.
	**************************************************/
	public static Object getCache(String cacheNm) {
		
		CacheManager cacheManager = CacheManager.getInstance();
		Cache cache = cacheManager.getCache(cacheNm);
//		logger.debug("{} cache: {}", cacheNm, cache);
//		
//		for (Object key: cache.getKeys()) {
//			Element element = cache.get(key);
//			logger.debug("element: {}", element);
//		}
		
		Object key = cache.getKeys().get(0);
		Element element = cache.get(key);
		Object object = element.getObjectValue();
		
		return object;
	}

	/************************************************** 
	 * @MethodName : mapListFromlist
	 * @Description: One of the key map list set
	 * @param list
	 * @param key
	 * @return Map<String,List<DataMap>>
	 * @Author     : joon
	 * @Version    : 2016. 01. 14.
	**************************************************/
	public static Map<String, List<DataMap>> mapListFromlist(List<DataMap> list, String key) {
		Map<String, List<DataMap>> rtnMap = new TreeMap<String, List<DataMap>>();
		
		for(DataMap map : list){
			String listKey = map.getString(key);
			rtnMap.put(listKey, null);
		}
		
		for(String rtnKey : rtnMap.keySet()){
			List<DataMap> listMap = new ArrayList<DataMap>();
			
			for(DataMap map : list){
				String listKey = map.getString(key);
				if(rtnKey.equals(listKey)){
					listMap.add(map);
				}
			}
			
			//for(DataMap map : listMap){
			//	logger.debug("{}:{}", rtnKey, map);
			//}
			rtnMap.put(rtnKey, listMap);
		}
		
		return rtnMap;
	}
	
	/************************************************** 
	 * @MethodName : mapListFromlist
	 * @Description: Two of the key map list set
	 * @param list
	 * @param key1
	 * @param key2
	 * @return Map<String,DataMap>
	 * @Author     : joon
	 * @Version    : 2016. 01. 14.
	**************************************************/
	public static Map<String, DataMap> mapDataFromlist(List<DataMap> list, String key1, String key2) {
		Map<String, DataMap> rtnMap = new TreeMap<String, DataMap>();

		for(DataMap dMap : list){
			String mapKey = dMap.getString(key1);
			if(StringUtils.isNotEmpty(key2)){
				mapKey += ("-"+dMap.getString(key2));
			}
			
			logger.debug("{}:{}", mapKey, dMap);
			rtnMap.put(mapKey, dMap);
		}
		
		return rtnMap;
	}
}