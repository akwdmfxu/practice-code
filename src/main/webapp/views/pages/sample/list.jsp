<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<style type="text/css">
	table
	{
		border-collapse: collapse;
		border-spacing: 0px;
	}
	table, th, td
	{
		padding: 5px;
		border: 1px solid black;
	}
	
	.sc{text-align:center;}
</style>

<h1> Sample list</h1>

<div style="text-align:right;">
	<button type="button" onclick="goMenu('/sample/cachelist')">캐싱리스트</button>
	<button type="button" onclick="goMenu('/sample/input')">등록</button>
</div>

<br/>

<table >
	<colgroup>
		<col width="12%"/>
		<col width="12%"/>
		<col width="12%"/>
		<col />
		<col width="14%"/>
	</colgroup>
	<thead>
		<tr>
			<th>userId</th>
			<th>userName</th>
			<th>position</th>
			<th>etc</th>
			<th>regDttm</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="item" items="${rstList}" varStatus="status">
			<tr>
				<td class="sc">${item.userId }</td>
				<td class="sc">${item.name }</td>
				<td class="sc">${item.department }</td>
				<td class="sc">${item.position }</td>
				<td class="sc">${item.regDttm }</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
