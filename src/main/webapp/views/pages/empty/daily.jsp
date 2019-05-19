<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<script type="text/javascript">
	$(document).ready(function(){
		//데이트피커 설정
		$(".datepicker").datepicker({
			language: "kr",
			buttonText: "달력",
			todayHighlight: true,
			autoclose: true
		});
		
		//상단 서비스 셀렉트 박스
		fn_getServiceCombobox('combo', 'SVC', '', '서비스 선택', 'Y', 'Y');
		
		//버튼 액션
		$('.button').click(function(){
			alert(this.value);
		});
		
		//그래프 설정
		var json = ${json};					// 그래프 내용 불러옴
		var memList = json.memberData;		// 회원 현황 
		var memSeries = [];					// 차트에 들어갈 회원 현황 배열
		var dwnList = json.downloadData;	// 다운로드 현황
		var dwnSeries = [];					// 차트에 들어갈 다운로드 현황 배열
		var webList = json.webDataList;		// 웹 사용 현황 
		var webSeries = [];					// 차트에 들어갈 웹 현황 배열
		var appList = json.appData;			// 앱 사용 현황 
		var appSeries = [];					// 차트에 들어갈 앱 현황 배열
		var uvList = json.uvData;			// uv 사용 현황 
		var uvSeries = [];					// 차트에 들어갈 uv 현황 배열
		
		// 차트별 각 데이터 분류
		memSeries = parsingData(memList);
		dwnSeries = parsingData(dwnList);
		webSeries = parsingData(webList);
		appSeries = parsingData(appList);
		uvSeries = parsingData(uvList);
		
		// 회원 현황 그래프 
		$('#memGraph').highcharts({
		    chart: {
		        type: 'column'
		    },
		    title: {
		        text: 'Stacked column chart'
		    },
		    xAxis: {
		    	categories: json.xAxis
		    },
		    yAxis: {
		        min: 0,
		        title: {
		            text: 'Total fruit consumption'
		        },
		        stackLabels: {
		            enabled: true,
		            style: {
		                fontWeight: 'bold',
		                color: (Highcharts.theme && Highcharts.theme.textColor) || 'gray'
		            }
		        }
		    },
		    legend: {
		        align: 'right',
		        x: -80,
		        verticalAlign: 'top',
		        y: 25,
		        floating: true,
		        backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || 'white',
		        borderColor: '#CCC',
		        borderWidth: 1,
		        shadow: false
		    },
		    tooltip: {
		        headerFormat: '<b>{point.x}</b><br/>',
		        pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
		    },
		    plotOptions: {
		        column: {
		            stacking: 'normal',
		            dataLabels: {
		                enabled: true,
		                color: (Highcharts.theme && Highcharts.theme.dataLabelsColor) || 'white'
		            }
		        }
		    },
		    series: memSeries
		});
		
		// 다운로드 그래프 현황
		$('#dwnGraph').highcharts({

		    title: {
		        text: 'Solar Employment Growth by Sector, 2010-2016'
		    },
		    xAxis: {
		    	categories: json.xAxis
		    },
		    subtitle: {
		        text: 'Source: thesolarfoundation.com'
		    },

		    yAxis: {
		        title: {
		            text: 'Number of Employees'
		        }
		    },
		    legend: {
		        layout: 'vertical',
		        align: 'right',
		        verticalAlign: 'middle'
		    },
		    series: dwnSeries,
		});
		
		// 웹 사용현황 그래프 현황
		$('#webGraph').highcharts({

		    title: {
		        text: 'Solar Employment Growth by Sector, 2010-2016'
		    },
		    xAxis: {
		    	categories: json.xAxis
		    },
		    subtitle: {
		        text: 'Source: thesolarfoundation.com'
		    },

		    yAxis: {
		        title: {
		            text: 'Number of Employees'
		        }
		    },
		    legend: {
		        layout: 'vertical',
		        align: 'right',
		        verticalAlign: 'middle'
		    },

		    plotOptions: {
		        series: {
		            label: {
		                connectorAllowed: false
		            },
		            pointStart: 2010
		        }
		    },
		    series: webSeries,
		});
		
		// 웹 사용현황 그래프 현황
		$('#appGraph').highcharts({
		    title: {
		        text: 'Solar Employment Growth by Sector, 2010-2016'
		    },
		    xAxis: {
		    	categories: json.xAxis
		    },
		    subtitle: {
		        text: 'Source: thesolarfoundation.com'
		    },

		    yAxis: {
		        title: {
		            text: 'Number of Employees'
		        }
		    },
		    legend: {
		        layout: 'vertical',
		        align: 'right',
		        verticalAlign: 'middle'
		    },

		    plotOptions: {
		        series: {
		            label: {
		                connectorAllowed: false
		            },
		            pointStart: 2010
		        }
		    },
		    series: appSeries,
		});
		
		// 다운로드 그래프 현황
		$('#uvGraph').highcharts({

		    title: {
		        text: 'Solar Employment Growth by Sector, 2010-2016'
		    },
		    xAxis: {
		    	categories: json.xAxis
		    },
		    subtitle: {
		        text: 'Source: thesolarfoundation.com'
		    },

		    yAxis: {
		        title: {
		            text: 'Number of Employees'
		        }
		    },
		    legend: {
		        layout: 'vertical',
		        align: 'right',
		        verticalAlign: 'middle'
		    },
		    series: uvSeries,
		});
	});
	
	//셀렉트 박스 변경시 액션처리
	function cngComboBox() {
		alert($("#combo option:selected").val());
	}
	
	//그래프 데이터 파싱해서 생성
	function parsingData(list) {
		var series = [];
		
		if(list == null) return [];
		
		for(var i=0; i<list.length; i++){
			var data = [];
			
			for(var j=0; j<list[i].data.length; j++){
				data.push(list[i].data[j]*1);
			}
			series.push({color: list[i].color, data: data, name: list[i].serviceName});
		}
		return series;
	}
</script>

<!-- 상단 헤더부분 -->
<div>
	<select id="combo" onchange="cngComboBox()" ></select>
	<button class="button" value="today" >일</button>
	<button class="button" value="month">월</button>
	<button class="button" value="year">년</button>
	<input type="text" style="width:150px;" class="datepicker" />
</div>

<%-- <div>
	 ${json}
</div> --%> 
<!-- 헤더부분 끝 -->
${list}
<h1> 회원현황</h1>
<div>
	<table border="1">
		<tr>
			<th>서비스명 </th>
			<th>회원현황 : Today - android</th>
			<th>회원현황 : Today - ios </th>
			<th>회원현황 : 누적현황 - android</th>
			<th>회원현황 : 누적현황 - ios </th>
			<th>회원현황 : 누적현황 - total</th>
			<th>회원현황 : 누적현황 - 일평균 </th>
			
		</tr>
		<c:forEach items="${list}" var="i">
			<tr>
				<td>${i.serviceName}</td>
				<td>${i.todayAndApp}</td>
				<td>${i.todayIosApp}</td>
				<td>${i.accumAndMem}</td>
				<td>${i.accumIosMem}</td>
				<td>${i.totalMem}</td>
				<td>${i.dailyAvgMem}</td>
			</tr>
		</c:forEach>
	</table>
</div>


<h1>다운로드 현황</h1>
<div>
	<table border="1">
		<tr>
			<th>서비스명 </th>
			<th>다운로드 : Today - android</th>
			<th>다운로드 : Today - ios </th>
			<th>다운로드 : 누적현황 - android</th>
			<th>다운로드 : 누적현황 - ios </th>
			<th>다운로드 : 누적현황 - total</th>
			<th>다운로드 : 누적현황 - 일평균 </th>
			
		</tr>
		<c:forEach items="${list}" var="i">
			<tr>
				<td>${i.serviceName}</td>
				<td>${i.todayAndDwn}</td>
				<td>${i.todayIosDwn}</td>
				<td>${i.accumAndDwn}</td>
				<td>${i.accumIosDwn}</td>
				<td>${i.totalDwn}</td>
				<td>${i.dailyAvgDwn}</td>
			</tr>
		</c:forEach>
	</table>
</div>

<h1>APP 현황</h1>
<div>
	<table border="1">
		<tr>
			<th>서비스명 </th>
			<th>앱사용현황 : Today - android</th>
			<th>앱사용현황 : Today - ios </th>
			<th>앱사용현황 : Today - total</th>
			<th>앱사용현황 : 전체회원 대비 사용율 - android</th>
			<th>앱사용현황 : 전체회원 대비 사용율 - ios</th>
			<th>앱사용현황 : 전체회원 대비 사용율 - total</th>
			<th>앱사용현황 : 일평균 </th>
			
		</tr>
		<c:forEach items="${list}" var="i">
			<tr>
				<td>${i.serviceName}</td>
				<td>${i.todayAndApp}</td>
				<td>${i.todayIosApp}</td>
				<td>${i.totalApp}</td>
				<td>${i.useRateAnd}</td>
				<td>${i.useRateIos}</td>
				<td>${i.useRateTot}</td>
				<td>${i.useAppAvg}</td>
			</tr>
		</c:forEach>
	</table>
</div>

<h1>Web 현황</h1>
<div>
	<table border="1">
		<tr>
			<th>서비스명 </th>
			<th>웹사용현황 : Today</th>
			<th>웹사용현황 : 일평균</th>
			<th>웹사용현황 : 누적</th>
		</tr>
		<c:forEach items="${list}" var="i">
			<tr>
				<td>${i.serviceName}</td>
				<td>${i.todayWeb}</td>
				<td>${i.dailyAvgWeb}</td>
				<td>${i.webTotal}</td>
			</tr>
		</c:forEach>
	</table>
</div>

<h1>uv현황</h1>
<div>
	<table border="1">
		<tr>
			<th>서비스명 </th>
			<th>UV 현황 : Today - android</th>
			<th>UV 현황 : Today - ios</th>
			<th>UV 현황 : 누적 - android</th>
			<th>UV 현황 : 누적 - ios</th>
			<th>UV 현황 : 누적 - total</th>
		</tr>
		<c:forEach items="${list}" var="i">
			<tr>
				<td>${i.serviceName}</td>
				<td>${i.todayAndUv}</td>
				<td>${i.todayIosUv}</td>
				<td>${i.uvAndSum}</td>
				<td>${i.uvIosSum}</td>
				<td>${i.uvSum}</td>
			</tr>
		</c:forEach>
	</table>
</div>

<!-- 회원 그래프 부분 시작-->
<h1>회원 그래프</h1>
<div>
	<div id="memGraph"></div>
</div>
<!-- 회원 그래프 부분 끝-->

<!-- 다운로드 그래프 부분 시작-->
<h1>다운로드 그래프</h1>
<div>
	<div id="dwnGraph"></div>
</div>
<!-- 다운로드 그래프 부분 끝-->

<!-- 웹 그래프 부분 시작-->
<h1>웹 그래프</h1>
<div>
	<div id="webGraph"></div>
</div>
<!-- 웹 그래프 부분 끝-->

<!-- 앱 그래프 부분 시작-->
<h1>앱 그래프</h1>
<div>
	<div id="appGraph"></div>
</div>
<!-- 앱 그래프 부분 끝-->

<!-- uv 그래프 부분 시작-->
<h1>uv 그래프</h1>
<div>
	<div id="uvGraph"></div>
</div>
<!-- uv 그래프 부분 끝-->