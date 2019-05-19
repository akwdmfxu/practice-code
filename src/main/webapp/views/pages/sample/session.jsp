<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<h1> Index!!</h1>

<p>principal : <sec:authentication property="principal"/></p>
<sec:authentication var="user" property="principal" />

<c:choose>
 	<c:when test="${user eq 'anonymousUser'}"><p>로그인 정보가 없습니다.</p></c:when>
 	<c:otherwise>
		<p>principal.userId : <sec:authentication property="principal.userId"/></p>
		<p>principal.userName : <sec:authentication property="principal.userName"/></p>
		<p>principal.department : <sec:authentication property="principal.department"/></p>
		<p>principal.position : <sec:authentication property="principal.position"/></p>
		<p>principal.grade : <sec:authentication property="principal.grade"/></p>
		<p>principal.accountNonExpired : <sec:authentication property="principal.accountNonExpired"/></p> 
 	</c:otherwise>
</c:choose>

<%-- 

 --%>

<button type="button" onClick="fn_ajax()">ajax test</button>
<button type="button" onClick="fn_ajaxSessionTimeout()">ajax Session Timeout test</button>
<div id="ajaxReturn"></div>
<script type="text/javascript">
	function fn_ajax(){
		//현재 sample경로에 로그인 제외처리 되어 있어서 기능 확인은 안됨.
		var json = new Object();
		json.str1 = "str1";
		json.str2 = "str2";
		json.str3 = "str3";
		var params = "param=" + JSON.stringify(json);
		ajaxParamExecute(params, "/sample/ajaxTest", "get", true, true, fn_html);
	}
	
	function fn_html(data){
		$('#ajaxReturn').html(JSON.stringify(data));
	}
	
	function fn_ajaxSessionTimeout(){
		ajaxParamExecute("", "/logout", "get", true, true, fn_ajax);
	}
</script>