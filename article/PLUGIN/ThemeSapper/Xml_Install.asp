<%@ CODEPAGE=65001 %>
<%
'///////////////////////////////////////////////////////////////////////////////
'// 插件应用:    1.8 Pre Terminator 及以上版本, 其它版本的Z-blog未知
'// 插件制作:    haphic(http://haphic.com/)
'// 备    注:    主题管理插件
'// 最后修改：   2008-6-28
'// 最后版本:    1.2
'///////////////////////////////////////////////////////////////////////////////
%>
<% Option Explicit %>
<% On Error Resume Next %>
<% Response.Charset="UTF-8" %>
<% Response.Buffer=True %>
<% Server.ScriptTimeout=99999999 %>
<!-- #include file="../../c_option.asp" -->
<!-- #include file="../../function/c_function.asp" -->
<!-- #include file="../../function/c_system_lib.asp" -->
<!-- #include file="../../function/c_system_base.asp" -->
<!-- #include file="../../function/c_system_plugin.asp" -->
<!-- #include file="c_sapper.asp" -->
<!-- #include file="../p_config.asp" -->
<%
Call System_Initialize()

'检查非法链接
Call CheckReference("")

'检查权限
If BlogUser.Level>1 Then Call ShowError(6)

If CheckPluginState("ThemeSapper")=False Then Call ShowError(48)

BlogTitle = "从服务器安装主题"
%><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<%=ZC_BLOG_LANGUAGE%>" lang="<%=ZC_BLOG_LANGUAGE%>">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta http-equiv="Content-Language" content="<%=ZC_BLOG_LANGUAGE%>" />
	<meta name="robots" content="noindex,nofollow"/>
	<link rel="stylesheet" rev="stylesheet" href="../../CSS/admin.css" type="text/css" media="screen" />
	<link rel="stylesheet" rev="stylesheet" href="images/style.css" type="text/css" media="screen" />
	<title><%=BlogTitle%></title>
</head>
<body>
<div id="divMain">
	<div class="Header">Theme Sapper-主题安装 - 在线安装您选择的主题.</div>
	<%Call SapperMenu("0")%>
<div id="divMain2">
	<div>
<%
Dim Install_Error
Install_Error=0

Dim Install_Url,Install_ID,Install_Pack,Install_Path,Install_Data
Install_Url=Request.QueryString("url")
Install_ID=Mid(Install_Url, InStrRev(Install_Url, "theme=")+6)

If Install_Url="" Then
	Response.Write "<p><font color=""red""> × 主题的下载地址为空.</font></p>"
	Install_Error=Install_Error+1

Else

	'验证所要安装的主题是否存在
	Action=Request.QueryString("act")

	If Action<>"confirm" Then
		Response.Write "<p id=""loading"">正在验证更新, 请稍候...  如果长时间停止响应, 请 <a href=""javascript:window.location.reload();"" title=""点此重试"">[点此重试]</a></p>"
		Response.Flush

		Set objXmlVerChk=New ThemeSapper_CheckVersionViaXML
		objXmlVerChk.XmlDataWeb=(getHTTPPage(Resource_URL & Install_ID & "/verchk.xml"))
		objXmlVerChk.XmlDataLocal=(LoadFromFile(BlogPath & "/THEMES/" & Install_ID & "/Theme.xml","utf-8"))

		If Action="update" Then
			If (LCase(objXmlVerChk.Item_ID_Web)=LCase(Install_ID)) Then
				Response.Write "<p class=""status-box"">您将对这个主题 <b>("& objXmlVerChk.Item_Name_Web &")</b> 进行修复或升级, 如果继续安装会将其<b>完全覆盖</b>.<br/> 请在继续前确认您对主题中自定义的部分进行了备份.<br/><br/>"

				Response.Write "您当前插件版本为: <b>"& objXmlVerChk.Item_Version_Local &"</b>. 发布日期为: <b>"& objXmlVerChk.Item_PubDate_Local &"</b>. 最后修改日期为: <b>"& objXmlVerChk.Item_Modified_Local &"</b>.<br/>"
				Response.Write "将要安装的版本为: <b>"& objXmlVerChk.Item_Version_Web &"</b>. 发布日期为: <b>"& objXmlVerChk.Item_PubDate_Web &"</b>. 最后修改日期为: <b>"& objXmlVerChk.Item_Modified_Web &"</b><br/><br/>"

				If objXmlVerChk.Item_Url_Web<>Empty Then
					Response.Write "<a href="""& objXmlVerChk.Item_Url_Web &""" target=""_blank"" title=""查看主题的发布页面"">点此查看主题的发布信息!</a><br/><br/>"
				End If

				Response.Write objXmlVerChk.OutputResults & "<br/><br/>"

				Response.Write "<a href=""Xml_Install.asp?act=confirm&amp;url="& Server.URLEncode(Install_Url) &""" title=""继续安装"">[继续安装]</a> 或 <a href=""javascript:history.back(1);"" title=""返回上一页面"">[取消安装]</a><p>"
			Else
				Response.Write "<p class=""status-box"">对不起, 这个主题 <b>("& objXmlVerChk.Item_Name_Local &")</b> 不支持在线安装或升级, 请返回上一页. <br/><br/><a href=""javascript:history.back(1);"" title=""返回上一页面"">[返回上一页]</a><p>"
			End If
			Install_Error=Install_Error+1
		Else
			If (LCase(objXmlVerChk.Item_ID_Local)=LCase(Install_ID)) Then
				Response.Write "<p class=""status-box"">您已安装过这个主题 <b>("& objXmlVerChk.Item_Name_Local &")</b>, 主题文件已存在于你的博客内, 如果继续安装会将其<b>完全覆盖</b>, 这可能会导致您对该主题的个性化修改丢失, 是否继续安装?<br/><br/>"

				Response.Write "您当前插件版本为: <b>"& objXmlVerChk.Item_Version_Local &"</b>. 发布日期为: <b>"& objXmlVerChk.Item_PubDate_Local &"</b>. 最后修改日期为: <b>"& objXmlVerChk.Item_Modified_Local &"</b>.<br/>"
				Response.Write "将要安装的版本为: <b>"& objXmlVerChk.Item_Version_Web &"</b>. 发布日期为: <b>"& objXmlVerChk.Item_PubDate_Web &"</b>. 最后修改日期为: <b>"& objXmlVerChk.Item_Modified_Web &"</b><br/><br/>"

				If objXmlVerChk.Item_Url_Web<>Empty Then
					Response.Write "<a href="""& objXmlVerChk.Item_Url_Web &""" target=""_blank"" title=""查看主题的发布页面"">点此查看主题的发布信息!</a><br/><br/>"
				End If

				Response.Write objXmlVerChk.OutputResults & "<br/><br/>"

				Response.Write "您还可以跳过安装步骤, 直接查看已安装的主题, 并在该页面中选择应用它. <b>(推荐)</b><br/><br/>"

				Response.Write "<a href=""Xml_Install.asp?act=confirm&amp;url="& Server.URLEncode(Install_Url) &""" title=""继续安装"">[继续安装]</a> 或 <a href=""javascript:history.back(1);"" title=""返回上一页面"">[取消安装]</a> 或 <span class=""notice""><a href=""ThemeDetail.asp?theme=" & Server.URLEncode(Install_ID) & """ title=""直接查看已安装过的("& Install_ID &")主题"">[直接查看已安装过的 """& Install_ID &""" 主题]</a></span><p>"
				Install_Error=Install_Error+1
			End If
		End If
		Set objXmlVerChk=Nothing
		Response.Write "<script language=""JavaScript"" type=""text/javascript"">document.getElementById('loading').style.display = 'none';</script>"
		If Install_Error<>0 Then Response.End
	End If


	Response.Write "<p id=""loading"">正在安装主题, 请稍候...  如果长时间停止响应, 请 <a href=""javascript:window.location.reload();"" title=""点此重试"">[点此重试]</a></p>"
	Response.Flush

	'下载安装主题
	Response.Write "<p class=""status-box"">正在下载 ZTI 主题安装包文件... <img id=""status"" align=""absmiddle"" src=""images/loading.gif"" /><p>"
	Response.Flush

	Install_Data = getHTTPPage(Install_Url)
	Install_Pack = BlogPath & "THEMES/Install.zti"
	Install_Path = BlogPath & "THEMES/"

	If Install_Data = False Then
		Response.Write "<p><font color=""red""> × ZTI 文件下载失败.</font></p>"
		Install_Error=Install_Error+1
	Else
		Response.Write "<p><font color=""green""> √ ZTI 文件下载完成.</font></p>"
	End If
	Response.Write "<script language=""JavaScript"" type=""text/javascript"">document.getElementById('status').style.display = 'none';</script>"
	Response.Flush

	Call SaveToFile(Install_Pack,Install_Data,"utf-8",False)
	Response.Write "<p><font color=""green""> √ ZTI 文件 ""THEMES/Install.zti"" 已被保存到您的空间内.</font></p>"
	Response.Flush

	Response.Write "<p class=""status-box"">ZTI 文件 ""THEMES/Install.zti"" 正在解包安装...<p>"
	Response.Flush


	Dim objXmlVerChkFile
	Dim objNodeList
	Dim objFSO
	Dim objStream
	Dim i,j

	Set objXmlVerChkFile = Server.CreateObject("Microsoft.XMLDOM")
		objXmlVerChkFile.async = False
		objXmlVerChkFile.ValidateOnParse=False
		objXmlVerChkFile.load(Install_Pack)
		
		If objXmlVerChkFile.readyState<>4 Then
			Response.Write "<p><font color=""red""> × ZTI 文件未准备就绪, 无法解包.</font></p>"
			Install_Error=Install_Error+1
		Else
			If objXmlVerChkFile.parseError.errorCode <> 0 Then
				Response.Write "<p><font color=""red""> × ZTI 文件有错误, 无法解包.</font></p>"
				Install_Error=Install_Error+1
			Else

				Dim Pack_ver,Pack_Type,Pack_For,Pack_ID,Pack_Name
				Pack_Ver = objXmlVerChkFile.documentElement.SelectSingleNode("//root").getAttributeNode("version").value
				Pack_Type = objXmlVerChkFile.documentElement.selectSingleNode("//root").getAttributeNode("type").value
				Pack_For = objXmlVerChkFile.documentElement.selectSingleNode("//root").getAttributeNode("for").value
				Pack_ID = objXmlVerChkFile.documentElement.selectSingleNode("id").text
				Pack_Name = objXmlVerChkFile.documentElement.selectSingleNode("name").text

				If (CDbl(Pack_Ver) > CDbl(XML_Pack_Ver)) Then
					Response.Write "<p><font color=""red""> × ZTI 文件的 XML 版本为 "& Pack_Ver &", 而你的解包器版本为 "& XML_Pack_Ver &", 请升级您的 ThemeSapper, 安装被中止.</font></p>"
					Install_Error=Install_Error+1
				ElseIf (LCase(Pack_Type) <> LCase(XML_Pack_Type)) Then
					Response.Write "<p><font color=""red""> × 不是 ZTI 文件, 而可能是 "& Pack_Type &", 安装被中止.</font></p>"
					Install_Error=Install_Error+1
				ElseIf (LCase(Pack_For) <> LCase(XML_Pack_Version)) Then
					Response.Write "<p><font color=""red""> × ZTI 文件版本不符合, 该版本可能是 "& Pack_For &", 安装被中止.</font></p>"
					Install_Error=Install_Error+1
				Else

					Response.Write "<blockquote><font color=""Teal"">"

					Set objNodeList = objXmlVerChkFile.documentElement.selectNodes("//folder/path")
					Set objFSO = CreateObject("Scripting.FileSystemObject")
						
						j=objNodeList.length-1
						For i=0 To j
							If objFSO.FolderExists(Install_Path & objNodeList(i).text)=False Then
								objFSO.CreateFolder(Install_Path & objNodeList(i).text)
							End If
							Response.Write "创建目录" & objNodeList(i).text & "<br/>"
							Response.Flush
						Next
					Set objFSO = Nothing
					Set objNodeList = Nothing
					Set objNodeList = objXmlVerChkFile.documentElement.selectNodes("//file/path")
					
						j=objNodeList.length-1
						For i=0 To j
							Set objStream = CreateObject("ADODB.Stream")
								With objStream
									.Type = 1
									.Open
									.Write objNodeList(i).nextSibling.nodeTypedvalue
									.SaveToFile Install_Path & objNodeList(i).text,2
									Response.Write "释放文件" & objNodeList(i).text & "<br/>"
									Response.Flush
									.Close
								End With
							Set objStream = Nothing
						Next
					Set objNodeList = Nothing
					Response.Write "</font></blockquote>"

				End If

			End If
		End If
		
	Set objXmlVerChkFile = Nothing

	If Err.Number<>0 Then Install_Error=Install_Error+1
	Err.Clear

	Response.Write "<p>"
	Install_Error = Install_Error + DeleteFile(BlogPath & "THEMES/" & "Install.zti")
	Response.Write "</p>"

	If Install_Error = 0 Then 
		Response.Write "<p>"
		Install_Error = Install_Error + DeleteFile(BlogPath & "THEMES/" & Pack_ID & "/verchk.xml")
		Response.Write "</p>"
	End If

	Response.Flush

End If

If Install_Error = 0 Then
	Response.Write "<p class=""status-box""> √ 主题安装完成. 如果您的浏览器没能自动跳转, 请 <a href=""ThemeDetail.asp?theme=" & Server.URLEncode(Pack_ID) & "&amp;themename=" & Server.URLEncode(Pack_Name) & """>[点击这里]</a>.</p>"
	Response.Write "<script>setTimeout(""self.location.href='ThemeDetail.asp?theme=" & Server.URLEncode(Pack_ID) & "&themename=" & Server.URLEncode(Pack_Name) & "'"",3000);</script>"
Else
	Response.Write "<p class=""status-box""><font color=""red""> × 主题安装失败. "
	Response.Write "<a href=""javascript:window.location.reload();"" title=""返回上一个页面""><span>[点此重试]</span></a> 或 <a href=""Xml_List.asp"" title=""返回资源列表页""><span>[点此返回资源列表页]</span></a></font></p>"
End If

Response.Write "<script language=""JavaScript"" type=""text/javascript"">document.getElementById('loading').style.display = 'none';</script>"
%>
	</div>
</div>
</div>
</body>
</html>
<%
Call System_Terminate()

If Err.Number<>0 Then
	Call ShowError(0)
End If
%>