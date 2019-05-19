<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="contents">
	<div class="contents_con">
		<div class="search_all">
			<div class="pc_date">
				<input type="text" id="datepicker" class="datepicker" style="cursor:pointer;" />
			</div>
		</div>
		<input type="hidden" id="regUid" value="<sec:authentication property="principal.userId"/>"/>
		
		<table class="tb01">
			<colgroup>
				<col style="width:*;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
				<col style="width:6%;" />
			<colgroup>
			<thead>
				<tr>
					<th rowspan="2">구분</th>
					<th colspan="2">가입</th>
					<th colspan="2">해지</th>
					<th colspan="2">탈퇴</th>
					<th colspan="2">다운로드</th>
					<th colspan="2">APP 사용자</th>
					<th colspan="2">APP UV</th>
					<th>방문자</th>
					<th>노출수</th>
				</tr>
				<tr>
					<c:forEach begin="0" end="5">
						<th>Android</th>
						<th>iOS</th>
					</c:forEach>
					<th>WEB</th>
					<th>WEB</th>
				</tr>
			</thead>
			<tbody id="valueArea">
			</tbody>
		</table>
	
		<div class="btn_area2">
			<a href="#" class="btn_delete" id="delBtn">삭제</a>
			<a href="#" class="btn_save" id="chkBtn">저장</a>
		</div>
	</div>
</div>

<script>
	
	$(function(){
		
		//초기날짜 setting
		var date = getFormatDate(new Date());
		$("#datepicker").val(date);
		
		//datepicker 불러오기
		$(".datepicker").datepicker({
			language: "kr",
			buttonText: "달력",
			endDate: "+0d",
			todayHighlight: true,
			autoclose: true
		})
		.on('changeDate', function(ev){ 
			// 날짜 클릭시 데이터 Loading
			if(ev.format() != ""){
				var chkDate = dateFormAjax(ev.format());
				ajaxParamExecute(chkDate, "${base}/registration/getServiceData", "GET", true, true, fn_returnServiceData);
			}
			
		});
		
		var chkDate = dateFormAjax($("#datepicker").val());
		ajaxParamExecute(chkDate, "${base}/registration/getServiceData", "GET", true, true, fn_returnServiceData);
		
	});
	
	$(document).ready(function(){
		
		// 저장 버튼 클릭시 동작
		$("#chkBtn").click(function(){
			
			var list = new Array();
			
			$("#valueArea tr").each(function(i){
				
				var data = new Object();
				data.regYmd = $("#datepicker").val().substring(0,4) + $("#datepicker").val().substring(5,7) + $("#datepicker").val().substring(8,10);
				
				data.regUid = $("#regUid").val();
				data.svcSeqNo = $(this).find("td input[type=hidden]").eq(0).val();
				data.cnt1 = $(this).find("td input[type=text]").eq(0).val();
				data.cnt2 = $(this).find("td input[type=text]").eq(1).val();
				data.cnt3 = $(this).find("td input[type=text]").eq(2).val();
				data.cnt4 = $(this).find("td input[type=text]").eq(3).val();
				data.cnt5 = $(this).find("td input[type=text]").eq(4).val();
				data.cnt6 = $(this).find("td input[type=text]").eq(5).val();
				data.cnt13 = $(this).find("td input[type=text]").eq(6).val();
				data.cnt15 = $(this).find("td input[type=text]").eq(7).val();
				data.cnt8 = $(this).find("td input[type=text]").eq(8).val();
				data.cnt9 = $(this).find("td input[type=text]").eq(9).val();
				data.cnt20 = $(this).find("td input[type=text]").eq(10).val();
				data.cnt21 = $(this).find("td input[type=text]").eq(11).val();
				data.cnt11 = $(this).find("td input[type=text]").eq(12).val();
				data.cnt23 = $(this).find("td input[type=text]").eq(13).val();
				
				list.push(data);
				
			});
			
			var jsonData = JSON.stringify(list);
			
			$.ajax({
			       type: "POST",
			       url: "${base}/registration/setServiceData",
			       data: jsonData,
			       contentType : 'application/json',
			       success: function(data) {
			    	   if(data.message == "OK"){
			    		   jsAlert.alert("확인", "저장이 완료되었습니다.", null, null);
			    	   }
			    	   else if(data.message == "Fail"){
			    		   jsAlert.alert("확인", "저장에 실패했습니다.");
			    	   }
			       }
			});
			
		});
		
		// 삭제 버튼 클릭시 동작
		$("#delBtn").click(function(){
		
			var regYmd = $("#datepicker").val().substring(0,4) + $("#datepicker").val().substring(5,7) + $("#datepicker").val().substring(8,10);
			var jsonData = JSON.stringify(regYmd);
			
			$.ajax({
			       type: "POST",
			       url: "${base}/registration/deleteServiceData",
			       data: jsonData,
			       contentType : 'application/json',
			       success: function(data) {
			    	   
			    	   if(data.message == "OK"){
			    		   jsAlert.alert("확인", "삭제가 완료되었습니다.", null, fn_refresh);
			    	   }
			    	   else if(data.message == "Nothing"){
			    		   jsAlert.alert("확인", "등록된 데이터가 없습니다.");
			    	   }
			    	   else if(data.message == "Fail"){
			    		   jsAlert.alert("확인", "오류가 발생하였습니다.");
			    	   }
			       }
			});
			
		});
		
	});
	
	// 받아온 데이터 그려주기
	function fn_returnServiceData(list){
		
		var htmlVal = "";
		
		if(list.length != 0){
			
			for(var i=0; i<list.length; i++){
				
				htmlVal += "<tr>";
				htmlVal += "<td class='txt_left'>"+list[i].serviceName+"<input type='hidden' id='seq_"+list[i].svcSeqNo+"' value='"+list[i].svcSeqNo+"'></td>";
				
				// 회원 관련
				htmlVal += disableChk(list[i].memberYn, list[i].androidYn, 'regiAnd_'+list[i].svcSeqNo, list[i].regiAnd);
				htmlVal += disableChk(list[i].memberYn, list[i].iosYn, 'regiIos_'+list[i].svcSeqNo, list[i].regiIos);
				htmlVal += disableChk(list[i].memberYn, list[i].androidYn, 'closeAnd_'+list[i].svcSeqNo, list[i].closeAnd);
				htmlVal += disableChk(list[i].memberYn, list[i].iosYn, 'closeIos_'+list[i].svcSeqNo, list[i].closeIos);
				htmlVal += disableChk(list[i].memberYn, list[i].androidYn, 'withdAnd_'+list[i].svcSeqNo, list[i].withdAnd);
				htmlVal += disableChk(list[i].memberYn, list[i].iosYn, 'withdIos_'+list[i].svcSeqNo, list[i].withdIos);
	
				// APP 관련
				htmlVal += disableChk('Y', list[i].androidYn, 'downAnd_'+list[i].svcSeqNo, list[i].downAnd);
				htmlVal += disableChk('Y', list[i].iosYn, 'downIos_'+list[i].svcSeqNo, list[i].downIos);
				htmlVal += disableChk('Y', list[i].androidYn, 'useAnd_'+list[i].svcSeqNo, list[i].useAnd);
				htmlVal += disableChk('Y', list[i].iosYn, 'useIos_'+list[i].svcSeqNo, list[i].useIos);
				htmlVal += disableChk('Y', list[i].androidYn, 'uvAnd_'+list[i].svcSeqNo, list[i].uvAnd);
				htmlVal += disableChk('Y', list[i].iosYn, 'uvIos_'+list[i].svcSeqNo, list[i].uvIos);
				
				// WEB 관련
				htmlVal += disableChk('Y', list[i].webYn, 'visitWeb_'+list[i].svcSeqNo, list[i].visitWeb);
				htmlVal += disableChk('Y', list[i].webYn, 'exposureWeb_'+list[i].svcSeqNo, list[i].exposureWeb);
				
				htmlVal += "</tr>";
				
			}
			
		}else{
			
			htmlVal += "<tr><td colspan='15'>입력된 내용이 없습니다<td></tr>";
			
		}
		
		$("#valueArea").html(htmlVal);
		
	}
	
	// Input textbox disable처리 관련
	function disableChk(chk, deviceChk, name, value){
		
		var htmlVal = "";
		
		if(chk == 'Y'){ // 회원가입 체크가 Y일 경우
			if(deviceChk == 'Y'){ // 해당하는 디바이스의 체크가 Y일 경우
				htmlVal = "<td class='input_td'><input type='text' id='"+name+"' value='"+value+"' class='numberOnly'></td>"
			}else{
				htmlVal = "<td class='input_td'><input type='text' id='"+name+"' value='"+value+"' disabled></td>"
			}
		}else{ // 회원가입 체크가 Y가 아닐 경우
			htmlVal = "<td class='input_td'><input type='text' id='"+name+"' value='"+value+"' disabled></td>"
		}
		
		return htmlVal;
	}
	
	//초기 date format
	function getFormatDate(date){

		var year = date.getFullYear();
		var month = (1 + date.getMonth());
		
		month = month >= 10 ? month : '0' + month;

		var day = date.getDate();

		day = day >= 10 ? day : '0' + day;

		return  year + '-' + month + '-' + day;

	}
	
	//ajax용 date foramt
	function dateFormAjax(date){
		var val = "ymd=";
		
		val += date.substring(0,4);
		val += date.substring(5,7);
		val += date.substring(8,10);
		
		return val;		
	}
	
	// 화면 새로고침
	function fn_refresh(){
		location.href="${base}/registration/setService";
	}
	
</script>