<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style type="text/css">
	table
	{
		border-collapse: collapse;
		border-spacing: 0px;
		width:100%;
	}
	table, th, td
	{
		padding: 5px;
		border: 1px solid black;
	}
	
	.tt input, textarea {width:99%;}
</style>

<script type="text/javascript">
	function fn_save(){
		jsSubmit.ajaxForm("userFrm", "/sample/input.json", "post", true, true, "확인", "저장하시겠습니까?", fn_saveReturn);		
	}
	
	function fn_saveReturn(data){
		console.log("data : " + JSON.stringify(data));
		if(data.sw){
			jsAlert.alert("확인", "저장되었습니다.", null, fn_list);
		}else{
			jsAlert.alert("확인", "저장에 실패했습니다.");
		}
	}
	
	function fn_list(){
		goMenu('/sample/list')
	}
</script>

<h1> sample input</h1>

<div class="tt">
	<form name="userFrm" id="userFrm">
		<table>
			<colgroup>
				<col width="25%"/>
				<col />
			</colgroup>
			<tr>
				<th>userId</th>
				<td>
					<input type="text" name="userId" id="userId" alt="아이디" value="" required/>
				</td>
			</tr>
			<tr>
				<th>password</th>
				<td>
					<input type="text" name="pwd" id="pwd" alt="비밀번호" value="" required/>
				</td>
			</tr>
			<tr>
				<th>userName</th>
				<td>
					<input type="text" name="name" id="name" alt="이름" value="" required/>
				</td>
			</tr>
			<tr>
				<th>department</th>
				<td>
					<input type="text" name="department" id="department" alt="부서" value="" required/>
				</td>
			</tr>
			<tr>
				<th>position</th>
				<td>
					<input type="text" name="position" id="position" alt="직급" value="" required/>
				</td>
			</tr>
		</table>
		
		<div style="text-align:right;margin-top:10px;">
			<button type="button" onclick="fn_save()">저장</button>
			<button type="button" onclick="fn_list()">목록</button>
		</div>
	</form>
</div>