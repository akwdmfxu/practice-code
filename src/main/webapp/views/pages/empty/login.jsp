<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	$(document).ready(function(){
		
		// 아이디 입력 후 엔터시 패스워드 쪽으로 포커싱 바뀜
		$('#userId').keypress(function(e) {
			if(e.keyCode == "13") {
				$("#pwd").focus();
				e.preventDefault();
			}
		});

		// 패스워드 입력 후 엔터시 로그인 펑션 탐
		$('#pwd').keypress(function(e) {
			if(e.keyCode == "13") {
				fn_login();
				e.preventDefault();
			}
		});
		
		//페이지 로딩 후 아이디 저장 여부에 따른 페이지 셋팅
		//아이디는 로컬 스토리지에 저장된다.
		var rememberId = getLocalStorage("rememberId");
		if(storageNotEmpty(rememberId)){
			$('#userId').val(rememberId);
			$('#rememberId').attr("checked", true);
		}else{
			$('#userId').val("");
			$('#rememberId').attr("checked", false);
		}
	});
	
	function fn_login(){
		if (checkValidation("loginFrm")) {
			//아이디 저장
			if($('#rememberId').is(":checked")){
				setLocalStorage("rememberId", $('#userId').val());
			}else{
				removeLocalStorage("rememberId");
			}
			
			$('#loginFrm').submit();	
		}
	}

</script>

<div class="login_box">
	<h1 class="login_tit"><img src="images/login_tit.gif" alt="라이프시맨틱스 서비스현황판" /></h1>
	
	<form name="loginFrm" id="loginFrm" method="post" action="${base}/login/check">
		<ul class="login_input">
			<li class="id_area"><input type="text" name="userId" id="userId" alt="아이디" placeholder="아이디" required/></li>
			<li class="pass_area"><input type="password" name="pwd" id="pwd" alt="비밀번호" placeholder="비밀번호" required/></li>
		</ul>
		<p class="ckeck_area"><input type="checkbox" class="check_box" id="rememberId" /> <label for="check1">아이디 저장</label></p>
		<p class="log_btn_area"><a href="javascript:fn_login()"><img src="images/btn_login.png" alt="로그인" /></a></p>
	</form>
</div>
<div class="login_footer">
	<div class="login_footer_con">
		<p class="txt_copyright">&copy;Lifesemantics <span class="txt_gray">All rights reserved.</span></p>
	</div>
</div>