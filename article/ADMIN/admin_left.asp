<%@ CODEPAGE=65001 %>
<% Option Explicit %>
<% On Error Resume Next %>
<% Response.Charset="UTF-8" %>
<!-- #include file="../c_option.asp" -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=ZC_BLOG_LANGUAGE%>" lang="<%=ZC_BLOG_LANGUAGE%>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="Content-Language" content="<%=ZC_BLOG_LANGUAGE%>" />
	<link rel="stylesheet" rev="stylesheet" href="../CSS/admin.css" type="text/css" media="screen" />
	<style>
body{
	margin:0;
	padding:0;
	background-color:#F0F6FC;
	background:url("../image/common/topbacking4.gif") repeat-y;

}
p.button{
	margin:0 0 0 0;
	padding:4px 0 0 20px;
	height:18px;
	width:130px;
	background:url("../image/common/topbacking3.gif") no-repeat;
}
p.button1{
	margin:0 0 0 0;
	padding:4px 0 0 20px;
	height:18px;
	width:130px;
	background:none;
}
	</style>
	<script>
function changeButtonColor(btnNow){
	var p=document.getElementsByTagName("p");
	for (var j = 0; j < p.length; j++){
		p[j].className="button1";
	}
	btnNow.parentNode.className="button";
	return true;
}
	</script>
</head>
<body>
<p class="button1" style="cursor:pointer;"><a onclick='changeButtonColor(this)' href="../" target="_top"><%=ZC_MSG065%></a></p>
<p class="button" ><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=SiteInfo" target="main"><%=ZC_MSG245%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=ArticleEdt&type=<%=ZC_BLOG_WEBEDIT%>" target="main"><%=ZC_MSG168%>(<%=ZC_MSG100%>)</a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=ArticleEdt" target="main"><%=ZC_MSG168%>(<%=ZC_MSG101%>)</a></p>
<!-- <p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=BlogReBuild" target="main"><%=ZC_MSG072%></a></p> -->
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=AskFileReBuild" target="main"><%=ZC_MSG073%></a></p>
<div style="height:5px;"> </div>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=ArticleMng" target="main"><%=ZC_MSG067%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=CategoryMng" target="main"><%=ZC_MSG066%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=TagMng" target="main"><%=ZC_MSG141%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=CommentMng" target="main"><%=ZC_MSG068%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=TrackBackMng" target="main"><%=ZC_MSG069%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=FileMng" target="main"><%=ZC_MSG071%></a></p>
<div style="height:5px;"> </div>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=SettingMng" target="main"><%=ZC_MSG247%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=ThemesMng" target="main"><%=ZC_MSG291%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=PlugInMng" target="main"><%=ZC_MSG107%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=UserMng" target="main"><%=ZC_MSG070%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=LinkMng" target="main"><%=ZC_MSG298%></a></p>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=SiteFileMng" target="main"><%=ZC_MSG210%></a></p>
<div style="height:5px;font-size:5px;"> </div>
<p class="button1"><a onclick='return changeButtonColor(this)' href="../cmd.asp?act=logout" target="_top"><%=ZC_MSG020%></a></p>
</body>
</html>