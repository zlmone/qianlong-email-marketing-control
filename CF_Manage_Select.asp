
<!--#include file="CF_Manage_2.asp"-->
<!--#include file="CF_Manage_3.asp"-->

<%
If Action="jsqset" Then

Response.write "<script>"               &Chr(13)&Chr(10)
Response.write "function myshow()"      &Chr(13)&Chr(10)
Response.write "{"					    &Chr(13)&Chr(10)
Response.write  Show                    &Chr(13)&Chr(10)
Response.write "clearInterval(myst);"   &Chr(13)&Chr(10)
Response.write "}"                      &Chr(13)&Chr(10)
Response.write "myst=setInterval('myshow()',1);"  &Chr(13)&Chr(10)
Response.write "</script>"              &Chr(13)&Chr(10)
End If
%>