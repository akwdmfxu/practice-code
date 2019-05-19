<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%-- 로그인 세션 정보 --%>
<sec:authentication var="user" property="principal" />

<div class="header">
	<div class="header_con">
		<div class="logo">
			<h1><a href="${base}/index"><img src="${base}/images/logo.gif" alt="" /></a></h1>
			<p class="menu_detail"><a href="${base}/status/daily"><img src="${base}/images/menu_detail.gif" /></a></p>
		</div>
		<p class="btn_logout"><a href="${base}/logout">로그아웃</a></p>
		
		<%-- 권한(GRADE)의 값이 'S'인 사용자만 등록/관리 메뉴 노출 --%>
		<c:if test="${user.grade eq 'S'}">
			<div class="btn_menu_all">
				<a href="#" class="btn_menu" style="background-position-x:110%;">관리</a>
				<ul class="depth_all">
					<li><a href="${base}/registration/setService">서비스 현황 등록</a></li>
					<%-- li><a href="${base}/registration/setSales">매출 현황 등록</a></li--%>
					<li><a href="${base}/registration/setCategory"">서비스 상품 관리</a></li>
					<%--li><a href="#">매출 상품 관리</a></li--%>
				</ul>
			</div>
			<script type="text/javascript">
				var urlArg = location.href.replace("#", "").split("/");
				var checkUrl = urlArg[urlArg.length - 1];
				$.each($('.depth_all li a'), function(){
					var href = $(this).attr("href");
					if(href.indexOf(checkUrl) > -1){
						$('a.btn_menu').html($(this).text());
						return false;
					}
				});
			</script>
		</c:if>
	</div>
</div>