<%@ CODEPAGE=65001 %>
<%
'///////////////////////////////////////////////////////////////////////////////
'//              Z-Blog 彩虹网志个人版
'// 作    者:    朱煊(zx.asd)
'// 版权所有:    RainbowSoft Studio
'// 技术支持:    rainbowsoft@163.com
'// 程序名称:    
'// 程序版本:    
'// 单元名称:    edit_fckeditor.asp
'// 开始时间:    2005.04.06
'// 最后修改:    
'// 备    注:    编辑页
'///////////////////////////////////////////////////////////////////////////////
%>
<% Option Explicit %>
<% On Error Resume Next %>
<% Response.Charset="UTF-8" %>
<% Response.Buffer=True %>
<!-- #include file="../c_option.asp" -->
<!-- #include file="../function/c_function.asp" -->
<!-- #include file="../function/c_system_lib.asp" -->
<!-- #include file="../function/c_system_base.asp" -->
<!-- #include file="../function/c_system_plugin.asp" -->
<!-- #include file="../plugin/p_config.asp" -->
<%

Call System_Initialize()

'plugin node
For Each sAction_Plugin_Edit_Fckeditor_Begin in Action_Plugin_Edit_Fckeditor_Begin
	If Not IsEmpty(sAction_Plugin_Edit_Fckeditor_Begin) Then Call Execute(sAction_Plugin_Edit_Fckeditor_Begin)
Next

'检查非法链接
Call CheckReference("")

'检查权限
If Not CheckRights("ArticleEdt") Then Call ShowError(6)

Dim EditArticle

Set EditArticle=New TArticle

If Not IsEmpty(Request.QueryString("id")) Then
	If EditArticle.LoadInfobyID(Request.QueryString("id")) Then
		If EditArticle.AuthorID<>BlogUser.ID Then
			If CheckRights("Root")=False Then 
				Call ShowError(6)
			End If
		End If
	Else
		Call ShowError(9)
	End If
Else
	EditArticle.AuthorID=BlogUser.ID
End If


On Error Resume Next
BlogTitle=EditArticle.HtmlUrl

If Err.Number=0 Then

	EditArticle.Title=TransferHTML(EditArticle.Title,"[html-japan]")
	EditArticle.Content=TransferHTML(EditArticle.Content,"[html-japan]")
	EditArticle.Intro=TransferHTML(EditArticle.Intro,"[html-japan]")

	EditArticle.Title=TransferHTML(EditArticle.Title,"[html-format]")
	EditArticle.Content=TransferHTML(EditArticle.Content,"[textarea]")
	EditArticle.Intro=TransferHTML(EditArticle.Intro,"[textarea]")

Else

	GetCategory()
	GetUser()

	EditArticle.Title=EditArticle.Title
	EditArticle.Content=TransferHTML(EditArticle.Content,"[&]")
	EditArticle.Intro=TransferHTML(EditArticle.Intro,"[&]")

End If
Err.Clear

BlogTitle=ZC_BLOG_TITLE & ZC_MSG044 & ZC_MSG047

%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=ZC_BLOG_LANGUAGE%>" lang="<%=ZC_BLOG_LANGUAGE%>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="Content-Language" content="<%=ZC_BLOG_LANGUAGE%>" />
	<link rel="stylesheet" rev="stylesheet" href="../CSS/admin.css" type="text/css" media="screen" />
	<script language="JavaScript" src="../script/common.js" type="text/javascript"></script>
	<script language="JavaScript" type="text/javascript" src="../admin/FCKeditor/fckeditor.js"></script>
	<link rel="stylesheet" href="../CSS/jquery.bettertip.css" type="text/css" media="screen">
	<script language="JavaScript" src="../script/jquery.bettertip.pack.js" type="text/javascript"></script>
	<script language="JavaScript" src="../script/jquery.tagto.js" type="text/javascript"></script>
	<script language="JavaScript" src="../script/jquery.textarearesizer.compressed.js" type="text/javascript"></script>
    <script type="text/javascript">
        (function($){
            $(document).ready(function(){
                $("#ulTag").tagTo("#edtTag");
            });    
        })(jQuery);
    </script>
	<title><%=BlogTitle%></title>
</head>
<body>
<div id="divMain">
<div class="Header"><%=ZC_MSG047%></div>
<%
	Response.Write "<div class=""SubMenu"">" & Response_Plugin_ArticleEdt_SubMenu & "</div>"
%>
<div class="form">
<% Call GetBlogHint() %>
<div id="divClick" style="display:none;"><a href="#" onclick="document.getElementById('divClick').style.display='none';document.getElementById('divAdv').style.display='block';document.getElementById('divFileSnd').style.display='block';document.getElementById('divIntro').style.display='block';Advanced();return false;"><%=GetSettingFormNameWithDefault("ZC_MSG316","Advanced Option&gt;&gt;")%><span style="font-size: 1.5em; vertical-align: -1px;">»</span></a></div>
<form id="edit" name="edit" method="post">
	<input type="hidden" name="edtID" id="edtID" value="<%=EditArticle.ID%>">
	<p><%=ZC_MSG060%>:<input type="text" name="edtTitle" id="edtTitle" style="width:470px;"  onblur="if(this.value=='') this.value='<%=ZC_MSG099%>'" onfocus="if(this.value=='<%=ZC_MSG099%>') this.value=''" value="<%=EditArticle.Title%>" />
	</p>
<%
Err.Clear
On Error Resume Next
BlogTitle=EditArticle.Tag

If Err.Number=0 Then
%>
	<p><%=ZC_MSG012%>:<select style="width:205px;" class="edit" size="1" id="cmbCate" onchange="edtCateID.value=this.options[this.selectedIndex].value"><option value="0"></option>
<%
	GetCategory()
	Dim Category
	For Each Category in Categorys
		If IsObject(Category) Then
			Response.Write "<option value="""&Category.ID&""" "
			If EditArticle.CateID=Category.ID Then Response.Write "selected=""selected"""
			Response.Write ">"&TransferHTML(Category.Name,"[html-format]")&"</option>"
		End If
	Next
%>
	</select><input type="hidden" name="edtCateID" id="edtCateID" value="<%=EditArticle.CateID%>">
	&nbsp;<%=ZC_MSG138%>:<input type="text" style="width:223px;" name="edtTag" id="edtTag" value="<%=TransferHTML(EditArticle.TagToName,"[html-format]")%>"> (<%=ZC_MSG296%>) <a href="" style="cursor:pointer;" onclick="if(document.getElementById('ulTag').style.display=='none'){document.getElementById('ulTag').style.display='block';}else{document.getElementById('ulTag').style.display='none'};return false;"><%=ZC_MSG139%><span style="font-size: 1.5em; vertical-align: -1px;">»</span></a>
	<ul id="ulTag" style="display:none;">
<%
	Dim objRS
	Set objRS=objConn.Execute("SELECT [tag_ID] FROM [blog_Tag] ORDER BY [tag_Name] ASC")
	If (Not objRS.bof) And (Not objRS.eof) Then
		Do While Not objRS.eof

			If InStr(EditArticle.Tag,"{"& objRS("tag_ID") & "}")>0 Then
				Response.Write "<a href='#' class='selected'>"& TransferHTML(Tags(objRS("tag_ID")).Name,"[html-format]") &"</a> "				
			Else
				Response.Write "<a href='#'>"& TransferHTML(Tags(objRS("tag_ID")).Name,"[html-format]") &"</a> "
			End If

			objRS.MoveNext
		Loop
	End If
	objRS.Close
	Set objRS=Nothing
%>
	</ul></p>
<%
End If
Err.Clear
%>
<div id="divAdv" style="display:block;">
<p><%=ZC_MSG003%>:<select style="width:205px;" class="edit" size="1" id="cmbUser" onchange="edtAuthorID.value=this.options[this.selectedIndex].value"><option value="0"></option>
<%
	GetUser()
	Dim User
	For Each User in Users
		If IsObject(User) Then
			If CheckRights("Root")=True Then
				Response.Write "<option value="""&User.ID&""" "
				If User.ID=EditArticle.AuthorID Then
					Response.Write "selected=""selected"""
				End If
				Response.Write ">"&TransferHTML(User.Name,"[html-format]")&"</option>"
			Else
				If User.ID=EditArticle.AuthorID Then
					Response.Write "<option value="""&User.ID&""" "
					Response.Write "selected=""selected"""
					Response.Write ">"&TransferHTML(User.Name,"[html-format]")&"</option>"
				End If
			End If
		End If
	Next
%>
	</select><input type="hidden" name="edtAuthorID" id="edtAuthorID" value="<%=EditArticle.AuthorID%>">
	&nbsp;<%=ZC_MSG061%>:<select style="width:230px;" class="edit" size="1" id="cmbArticleLevel" onchange="edtLevel.value=this.options[this.selectedIndex].value">
<%
	Dim ArticleLevel
	Dim i:i=0
	For Each ArticleLevel in ZVA_Article_Level_Name
		Response.Write "<option value="""& i &""" "
		If EditArticle.Level=i Then Response.Write "selected=""selected"""
		Response.Write ">"& ZVA_Article_Level_Name(i) &"</option>"
		i=i+1
	Next
%>
	</select><input type="hidden" name="edtLevel" id="edtLevel" value="<%=EditArticle.Level%>" />
<%
Err.Clear
On Error Resume Next
BlogTitle=EditArticle.Istop

If Err.Number=0 Then
%>
&nbsp;<%=ZC_MSG051%>
<%If EditArticle.Istop Then%>
<input type="checkbox" name="edtIstop" id="edtIstop" value="True" checked=""/>
<%Else%>
<input type="checkbox" name="edtIstop" id="edtIstop" value="True"/>
<%End If%>
<%
End If
Err.Clear
%>
	</p>
	<p><%=ZC_MSG062%>:<input type="text" name="edtYear" id="edtYear" style="width:40px;" value="<%=Year(EditArticle.PostTime)%>" />-<input type="text" name="edtMonth" id="edtMonth" style="width:21px;" value="<%=Month(EditArticle.PostTime)%>" />-<input type="text" name="edtDay" id="edtDay" style="width:21px;" value="<%=Day(EditArticle.PostTime)%>" />-<input type="text" name="edtTime" id="edtTime" style="width:73px;" value="<%= Hour(EditArticle.PostTime)&":"&Minute(EditArticle.PostTime)&":"&Second(EditArticle.PostTime)%>" />
	<%
Err.Clear
On Error Resume Next
BlogTitle=EditArticle.Alias
If Err.Number=0 Then
%>
	&nbsp;<%=ZC_MSG147%>:<input type="text" style="width:223px;" name="edtAlias" id="edtAlias" value="<%=TransferHTML(EditArticle.Alias,"[html-format]")%>"> .<%=ZC_STATIC_TYPE%>
<%
End If
Err.Clear
%>
</div>

<%
If Response_Plugin_Edit_Form<>"" Then
%>
<div><%=Response_Plugin_Edit_Form%></div>
<%
End If
%>


<div id="divFileSnd">
<%If CheckRights("FileSnd") Then%>
	<p id="filesnd"><iframe frameborder="0" height="78" marginheight="0" marginwidth="0" scrolling="no" width="100%" src="../cmd.asp?act=FileSnd"></iframe></p>
<%Else%>
<%End If%>
</div>
<div id="divContent" style="clear:both;">
<p><%=ZC_MSG055%>:(<span id="timemsg"></span><span id="msg2"></span><span id="msg"></span><SCRIPT LANGUAGE="JavaScript" src="c_autosaverjs.asp?act=edit&type=fckeditor"></SCRIPT>)<br/>
	<textarea style="display:none" rows="4" onchange="GetActiveText(this.id);" onclick="GetActiveText(this.id);" onfocus="GetActiveText(this.id);" name="txaContent" id="txaContent"><%=EditArticle.Content%></textarea>
	<input type="hidden" id="MyEditor___Config" value="Key1=Value1&Key2=Value2&... (Key/Value:HTML encoded)">
	<iframe class="resizable" id="MyEditor___Frame" src="FCKeditor/editor/fckeditor.html?InstanceName=txaContent&Toolbar=Default" width="100%" height="420" frameborder="no" scrolling="no"></iframe>
	</p>
</div>

<div id="divAutoIntro" class="anti_normal" style="display:<%If EditArticle.ID=0 And EditArticle.Intro="" Then Response.Write "block" Else Response.Write "none"%>;" onclick="this.style.display='none';document.getElementById('divIntro').style.display='block';AutoIntro();"><p><a title="<%=ZC_MSG297%>" href="javascript:AutoIntro()">[<%=ZC_MSG310%>]</a></p></div>
<div id="divIntro" style="display:<%If EditArticle.Intro="" Then Response.Write "none" Else Response.Write "block"%>;">
<!-- <div id="divIntro"> -->
	<p><%=ZC_MSG016%>:<a title="<%=ZC_MSG297%>" href="javascript:AutoIntro()">[<%=ZC_MSG310%>]</a><br/>
	<textarea style="display:none" rows="3" onchange="GetActiveText(this.id);" onclick="GetActiveText(this.id);" onfocus="GetActiveText(this.id);" name="txaIntro" id="txaIntro"><%=EditArticle.Intro%></textarea>
	<input type="hidden" id="MyEditor2___Config" value="Key1=Value1&Key2=Value2&... (Key/Value:HTML encoded)">
	<iframe id="MyEditor2___Frame" src="FCKeditor/editor/fckeditor.html?InstanceName=txaIntro&Toolbar=Basic" width="100%" height="250" frameborder="no" scrolling="no"></iframe>
	</p>
</div>
<%
If Response_Plugin_Edit_Form2<>"" Then
%>
<div><%=Response_Plugin_Edit_Form2%></div>
<%
End If
%>
	<p><input class="button" type="submit" value="<%=ZC_MSG087%>" id="btnPost" onclick='return checkArticleInfo();' /></p>
</form>
</div>

			</div>

</body>
<script>

	objActive="txaContent";

	var str10="<%=ZC_MSG115%>";
	var str11="<%=ZC_MSG116%>";
	var str12="<%=ZC_MSG117%>";

	function checkArticleInfo(){
		document.getElementById("edit").action="../cmd.asp?act=ArticlePst&type=fckeditor";

		if(document.getElementById("edtCateID").value==0){
			alert(str10);
			return false
		}

		if(!FCKeditorAPI.GetInstance('txaContent').GetHTML()){
			alert(str11);
			return false
		}
	}

	function AddKey(i) {
		var strKey=document.getElementById("edtTag").value;
		var strNow=","+i

		if(strKey==""){
			strNow=i
		}

		if(strKey.indexOf(strNow)==-1){
			strKey=strKey+strNow;
		}
		document.getElementById("edtTag").value=strKey;
	}
	function DelKey(i) {
		var strKey=document.getElementById("edtTag").value;
		var strNow="{"+i+"}"
		if(strKey.indexOf(strNow)!=-1){

			strKey=strKey.substring(0,strKey.indexOf(strNow))+strKey.substring(strKey.indexOf(strNow)+strNow.length,strKey.length)

		}
		document.getElementById("edtTag").value=strKey;
	}

	function AutoIntro() {
		FCKeditorAPI.GetInstance('txaIntro').SetHTML(FCKeditorAPI.GetInstance('txaContent').GetHTML().replace(/<[^>]+>/g, "").substring(0,200));     //FCK会自动处理未闭合的标签，我们不用多管它。要是标签被切了一半显示出来了自己编辑下就好。
	}

	function Advanced(){
		$("div.normal").css("display","block");
		$("div.anti_normal").css("display","none");
	}


	/* jQuery textarea resizer plugin usage 
	$(document).ready(function() {
		$('textarea.resizable:not(.processed)').TextAreaResizer();
		$('iframe.resizable:not(.processed)').TextAreaResizer();
	});*/

</script>
</html>
<% 
Call System_Terminate()

If Err.Number<>0 then
	Call ShowError(0)
End If
%>