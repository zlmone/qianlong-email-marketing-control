<%@ CODEPAGE=65001 %>
<%
'///////////////////////////////////////////////////////////////////////////////
'//              Z-Blog
'// 作    者:    朱煊(zx.asd)
'// 版权所有:    RainbowSoft Studio
'// 技术支持:    rainbowsoft@163.com
'// 程序名称:    
'// 程序版本:    
'// 单元名称:    c_error.asp
'// 开始时间:    2004.07.25
'// 最后修改:    
'// 备    注:    错误显示页
'///////////////////////////////////////////////////////////////////////////////
%>
<% Option Explicit %>
<% On Error Resume Next %>
<% Response.Charset="UTF-8" %>
<% Response.Buffer=True %>
<!-- #include file="../c_option.asp" -->
<!-- #include file="../function/c_function.asp" -->
<!-- #include file="../function/c_function_md5.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=ZC_BLOG_LANGUAGE%>" lang="<%=ZC_BLOG_LANGUAGE%>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="Content-Language" content="<%=ZC_BLOG_LANGUAGE%>" />
	<link rel="stylesheet" rev="stylesheet" href="../CSS/admin.css" type="text/css" media="screen" />
	<title><%=ZC_BLOG_TITLE & ZC_MSG044 & ZC_MSG045%></title>
</head>
<body>
<div id="divMain">
<div class="Header"><%=ZC_MSG045%></div>
<div id="divMain2">
<form id="edit" name="edit" method="post">
<%
	Response.Write "<p>" & ZC_MSG098 & ":" & ZVA_ErrorMsg(Request.QueryString("errorid")) & "</p>"

	If CLng(Request.QueryString("number"))<>0 Then
		Response.Write "<p>" & ZC_MSG076 & ":" & "" & CLng(Request.QueryString("number")) & "</p>"
		Response.Write "<p>" & ZC_MSG016 & ":" & "<br/>" & TransferHTML(Request.QueryString("description"),"[html-format]") & "</p>"
		Response.Write "<p>" & TransferHTML(Request.QueryString("source"),"[html-format]") & "</p>"
	End If

	If CheckRegExp(Request.QueryString("sourceurl"),"[homepage]")=True Then
		Response.Write "<p><a href=""" & TransferHTML(Request.QueryString("sourceurl"),"[html-format]") & """>" & ZC_MSG295 & "</a></p>"
	Else
		Response.Write "<p><a href=""" & ZC_BLOG_HOST & """>" & ZC_MSG295 & "</a></p>"
	End If

	If CLng(Request.QueryString("errorid"))=6 Then
		Response.Write "<p><a href=""../cmd.asp?act=login"">"& ZC_MSG009 & "</a></p>"
	End If
%>
</form>
</div>
</div>
</body>
</html>
<%
If Err.Number<>0 Then
	Response.Redirect ZC_BLOG_HOST & "function/c_error.asp"
End If
%>