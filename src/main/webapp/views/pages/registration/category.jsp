<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style type="text/css">
	.cp-basic {overflow:hidden; line-height:0; font-size:0; text-indent:-1000px; cursor:pointer;}
</style>
<script type="text/javascript" src="${base}/js/lib/run_prettify.js"></script>
<script type="text/javascript" src="${base}/js/lib/jquery.tablednd.js"></script>
<script type="text/javascript" src="${base}/js/lib/jquery-ui.js"></script>
<script type="text/javascript" src="${base}/js/lib/jquery.colorpicker.js"></script>

<input type="hidden" id="regUid" value="<sec:authentication property="principal.userId"/>"/>

<div class="contents">
	<div class="contents_con">
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
			<tr>
				<th rowspan="2">구분</th>
				<th rowspan="2">일일현황</th>
				<th rowspan="2">상세현황</th>
				<th colspan="4">활성화 여부</th>
				<th colspan="5">현황 활성화 여부</th>
				<th colspan="2">차트 색상</th>
				<th rowspan="2">사용 여부</th>
			</tr>
			<tr>
				<th>회원</th>
				<th>Android</th>
				<th>iOS</th>
				<th>WEB</th>
				<th>회원현황</th>
				<th>다운로드현황</th>
				<th>앱사용현황</th>
				<th>웹사용현황</th>
				<th>UV현황</th>
				<th>Android<br />(기본)</th>
				<th>iOS</th>
			</tr>
		</table>
		<form id="categoryFrm">
			<table class="tb01 dragable" id="contentTable">
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
				
				<c:forEach items="${list}" var="i" varStatus="status">
					<tr id="${status.count}">
						<td class="txt_left" id="nameTd_${status.count}">
							${i.serviceName}
							<input type="hidden" id="svcSeqNo_${status.count}" value="${i.svcSeqNo}">
							<a href="#none" class="btn_cateup" onclick="updateNm('${status.count}','${i.svcSeqNo}','${i.serviceName}')">수정</a>
						</td>
						<td>
							<c:if test="${i.dailyYn eq 'Y'}">
								<input type="checkbox" id="dailyYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.dailyYn eq 'N'}">
								<input type="checkbox" id="dailyYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.detailYn eq 'Y'}">
								<input type="checkbox" id="detailYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.detailYn eq 'N'}">
								<input type="checkbox" id="detailYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.memberYn eq 'Y'}">
								<input type="checkbox" id="memberYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.memberYn eq 'N'}">
								<input type="checkbox" id="memberYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.androidYn eq 'Y'}">
								<input type="checkbox" id="androidYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.androidYn eq 'N'}">
								<input type="checkbox" id="androidYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.iosYn eq 'Y'}">
								<input type="checkbox" id="iosYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.iosYn eq 'N'}">
								<input type="checkbox" id="iosYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.webYn eq 'Y'}">
								<input type="checkbox" id="webYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.webYn eq 'N'}">
								<input type="checkbox" id="webYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.memSvcYn eq 'Y'}">
								<input type="checkbox" id="memSvcYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.memSvcYn eq 'N'}">
								<input type="checkbox" id="memSvcYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.dwnSvcYn eq 'Y'}">
								<input type="checkbox" id="dwnSvcYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.dwnSvcYn eq 'N'}">
								<input type="checkbox" id="dwnSvcYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.appSvcYn eq 'Y'}">
								<input type="checkbox" id="appSvcYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.appSvcYn eq 'N'}">
								<input type="checkbox" id="appSvcYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.webSvcYn eq 'Y'}">
								<input type="checkbox" id="webSvcYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.webSvcYn eq 'N'}">
								<input type="checkbox" id="webSvcYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td>
							<c:if test="${i.uvSvcYn eq 'Y'}">
								<input type="checkbox" id="uvSvcYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.uvSvcYn eq 'N'}">
								<input type="checkbox" id="uvSvcYn_${i.svcSeqNo}" />
							</c:if>
						</td>
						<td class="color_picker">
							<div class="tab-input">
								<input type="text" class="cp-basic" id="colorAndroid_${i.svcSeqNo}" value="${i.colorAndroid}"/>
							</div>
						</td>
						<td class="color_picker">
							<div class="tab-input">
								<input type="text" class="cp-basic" id="colorIos_${i.svcSeqNo}" value="${i.colorIos}"/>
							</div>
						</td>
						<td>
							<c:if test="${i.useYn eq 'Y'}">
								<input type="checkbox" id="useYn_${i.svcSeqNo}" checked="checked" />
							</c:if>
							<c:if test="${i.useYn eq 'N'}">
								<input type="checkbox" id="useYn_${i.svcSeqNo}" />
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
		</form>
		<div class="btn_area">
			<a href="#none" class="btn_add" id="addBtn">항목추가</a>
			<a href="#none" class="btn_save" id="saveBtn">저장</a>
		</div>
	</div>
</div>
<script type="text/javascript">
	var defaultColor = '';
	var idVal = $("#contentTable tr").length;
	
	$(document).ready(function(){
		
		<c:forEach items="${list}" var="i" varStatus="status">
			
			if("${i.colorAndroid}" == null || "${i.colorAndroid}" == ""){
				$('#colorAndroid_${i.svcSeqNo}').css("background-color", "#fff");
			}else{
				$('#colorAndroid_${i.svcSeqNo}').css("background-color", "${i.colorAndroid}");
			}
			if("${i.colorIos}" == null || "${i.colorIos}" == ""){
				$('#colorIos_${i.svcSeqNo}').css("background-color", "#fff");
			}else{
				$('#colorIos_${i.svcSeqNo}').css("background-color", "${i.colorIos}");
			}
			
		</c:forEach>
		
		$(".dragable").tableDnD({
			onDragClass: "dragRow"
		});
		
        editColorVal();
        
     	// 저장버튼 클릭시 동작
        $("#saveBtn").click(function(){
        	
        	if(checkValidation('categoryFrm')){   	
	        	var list = new Array();
	        	
	        	$("#contentTable tr").each(function(i){
	        		
	        		var data = new Object();
	        		
	        		data.dspSeq = i+1;
	        		
	        		if($(this).find("td input[type=hidden]").eq(0).val() != null){ // 새로운 항목 추가안했을 경우
		        		
	        			data.svcSeqNo = $(this).find("td input[type=hidden]").eq(0).val(); // 기본 primary키 설정
		        		
		        		if($(this).find("td input[type=text]").eq(2).val() != null){ // 수정 input이 생겼을 경우
							data.serviceName = $(this).find("td input[type=text]").eq(0).val();
		        			
		        			if($(this).find("td input[type=text]").eq(1).val().charAt(0) != "#"){
		        				data.colorAndroid = "#" + $(this).find("td input[type=text]").eq(1).val();
		        			}else{
		        				data.colorAndroid = $(this).find("td input[type=text]").eq(1).val();
		        			}

		        			if($(this).find("td input[type=text]").eq(2).val().charAt(0) != "#"){
		        				data.colorIos = "#" + $(this).find("td input[type=text]").eq(2).val();
		        			}else{
		        				data.colorIos = $(this).find("td input[type=text]").eq(2).val();
		        			}
		        		}else{
		        			if($(this).find("td input[type=text]").eq(0).val().charAt(0) != "#"){
		        				data.colorAndroid = "#" + $(this).find("td input[type=text]").eq(0).val();
		        			}else{
		        				data.colorAndroid = $(this).find("td input[type=text]").eq(0).val();
		        			}

		        			if($(this).find("td input[type=text]").eq(1).val().charAt(0) != "#"){
		        				data.colorIos = "#" + $(this).find("td input[type=text]").eq(1).val();
		        			}else{
		        				data.colorIos = $(this).find("td input[type=text]").eq(1).val();
		        			}
		        		}
		        		
	        		}else{
	        			
	        			data.serviceName = $(this).find("td input[type=text]").eq(0).val();
	        			
	        			if($(this).find("td input[type=text]").eq(1).val().charAt(0) != "#"){
	        				data.colorAndroid = "#" + $(this).find("td input[type=text]").eq(1).val();
	        			}else{
	        				data.colorAndroid = $(this).find("td input[type=text]").eq(1).val();
	        			}

	        			if($(this).find("td input[type=text]").eq(2).val().charAt(0) != "#"){
	        				data.colorIos = "#" + $(this).find("td input[type=text]").eq(2).val();
	        			}else{
	        				data.colorIos = $(this).find("td input[type=text]").eq(2).val();
	        			}
	        			
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(0).is(":checked") == true){
	        			data.dailyYn = 'Y';
	        		}else{
	        			data.dailyYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(1).is(":checked") == true){
	        			data.detailYn = 'Y';
	        		}else{
	        			data.detailYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(2).is(":checked") == true){
	        			data.memberYn = 'Y';
	        		}else{
	        			data.memberYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(3).is(":checked") == true){
	        			data.androidYn = 'Y';
	        		}else{
	        			data.androidYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(4).is(":checked") == true){
	        			data.iosYn = 'Y';
	        		}else{
	        			data.iosYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(5).is(":checked") == true){
	        			data.webYn = 'Y';
	        		}else{
	        			data.webYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(6).is(":checked") == true){
	        			data.memSvcYn = 'Y';
	        		}else{
	        			data.memSvcYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(7).is(":checked") == true){
	        			data.dwnSvcYn = 'Y';
	        		}else{
	        			data.dwnSvcYn = 'N';
	        		}
		        	
	        		if($(this).find("td input[type=checkbox]").eq(8).is(":checked") == true){
	        			data.appSvcYn = 'Y';
	        		}else{
	        			data.appSvcYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(9).is(":checked") == true){
	        			data.webSvcYn = 'Y';
	        		}else{
	        			data.webSvcYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(10).is(":checked") == true){
	        			data.uvSvcYn = 'Y';
	        		}else{
	        			data.uvSvcYn = 'N';
	        		}
	        		
	        		if($(this).find("td input[type=checkbox]").eq(11).is(":checked") == true){
	        			data.useYn = 'Y';
	        		}else{
	        			data.useYn = 'N';
	        		}
	        		
	        		data.regUid = $("#regUid").val();
	        		
	        		list.push(data);
	        		
	        	});
	        	
	        	var jsonData = JSON.stringify(list);
	        	
	        	// ajax 로딩 추가
	        	appendAjaxLoading();
	        	
	        	$.ajax({
				       type: "POST",
				       url: "${base}/registration/setServiceCategory",
				       data: jsonData,
				       dataType: "json",
				       contentType : 'application/json',
				       success: function(data) {
				    	  // ajax 로딩 제거
				    	   removeAjaxLoading();
				    	   
				    	   if(data.message == "OK"){
				    		  jsAlert.alert("확인", "저장이 완료되었습니다.", null, fn_refresh);
				    	   }
				    	   else if(data.message == "Fail"){
				    		  jsAlert.alert("확인", "오류가 발생하였습니다.");
				    	   }
				       }
				});
        	}   	
        });
        
        // 항목추가 버튼 클릭시 동작
		$("#addBtn").click(function(){
			
			var putHtml = "";
			idVal = idVal + 1;
			
			putHtml += "<tr id=" + idVal + ">";
			putHtml += "<td class='txt_left'><input type='text' alt='서비스명' required/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td><input type='checkbox'/></td>";
			putHtml += "<td class='color_picker'><div class='tab-input'>";
			putHtml += "<input type='text' class='cp-basic' value='#FFF'/></div></td>";
			putHtml += "<td class='color_picker'><div class='tab-input'>";
			putHtml += "<input type='text' class='cp-basic' value='#FFF'/></div></td>";
			putHtml += "<td><a href='#none' class='btn_del' onclick='delTr(" + idVal + ");'>삭제</a></td>";
			putHtml += "</tr>";
			
			$("#contentTable").append(putHtml);
			
			editColorVal();
			
			$(".dragable").tableDnD({
				onDragClass: "dragRow"
			});
			
		});
		
	});
	
	// color 선택시 배경 변경 및 value 입력
	function editColorVal(){
		
		$('.color_picker').tabs();
		$('.cp-basic').colorpicker();
		
		$('.cp-basic').bind("click", function(){
			if($(this).val() == ""){
				defaultColor = "fff";
			}else{					
				defaultColor = $(this).val();
			}
			
		});

		$('.cp-basic').bind("change", function(){				
			if($(this).val() == ""){
				$(this).css("background-color", '#' + defaultColor);
			}else{					
				$(this).css("background-color", '#' + $(this).val());
				$(this).val($(this).val());
			}
		});
		
	}
	
	//삭제 버튼 클릭시 table 행 제거
    function delTr(val){
    	$("#"+val).remove();
    }
	
	// 새로고침
	function fn_refresh(){
		location.href="${base}/registration/setCategory";
	}
	
	// 수정 input 추가
	function updateNm(count, seqNo, serviceNm){
		var htmlVal = "";
		htmlVal += "<input type='hidden' id='svcSeqNo_"+seqNo+"' value='"+seqNo+"'/>";
		htmlVal += "<input type='text' alt='서비스명' value='"+serviceNm+"' required/>"
		
		$("#nameTd_" + count).html(htmlVal);
	}
	
</script>