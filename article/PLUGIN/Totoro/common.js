totoro_statsbar("Loading TotoroⅡ....");

function totoro_cmmnginit(){
	$("tr").each(function(i){
		if(i!=0){
		var cmid=$(this).children("td:first-child").html();
		$(this).append("<td align=\"center\" id=\"totoro_" + cmid + "\"><a href=\"javascript:ThisCmIsSpam(" + cmid + ")\">[这是SPAM]</a></td>");
		}else{
		$(this).append("<td width=\"10%\" align=\"center\">Totoro<a href=\"javascript:alert('点击[这是SPAM]将此评论中包含的网址加入TotoroⅡ黑词列表，并按照设置将其删除或进入审核')\">Ⅱ</a></td>");
		}
		});
	totoro_statsbar();
}

function totoro_tbmnginit(){
	$("tr").each(function(i){
		if(i!=0){
		var tbid=$(this).children("td:first-child").next().next().html();
		tbid=String(String(tbid.match(/tb[0-9]+/)).match(/[0-9]+/));
		$(this).append("<td align=\"center\" id=\"totoro_" + tbid + "\"><a id=\"totoro\" href=\"javascript:ThisTbIsSpam(" + tbid + ")\">[这是SPAM]</a></td>");
		}else{
		$(this).append("<td width=\"10%\" align=\"center\">Totoro<a href=\"javascript:alert('点击[这是SPAM]将此Trackback中包含的网址加入TotoroⅡ黑词列表，并按照设置将其删除或进入审核')\">Ⅱ</a></td>");
		}
	});
	$("a[href$=400]").each(function(i){
		this.href=this.href.replace(/width=400/, "width=300");
	});
	totoro_statsbar();
}

function totoro_statsbar(stats){
	if(stats){
		if(!$("#totoro_statsbar").length){
			$("body").prepend("<span id=\"totoro_statsbar\" style=\"position:absolute;top:10px;right:10px;height:15px;z-index:999;padding:5px 10px;background:#8B0000;color:#FFFFFF;font-size:12px;\">  </span>");
		}
		$("#totoro_statsbar").html(stats);
	}else{
		$("#totoro_statsbar").remove();
	}
}

function ThisCmIsSpam(cmid){
	$("#totoro_" + cmid).html("<span style=\"color:#800000;\">提交中</span>").prev().html("").prev().html("").prev().html("");
	$.post("../plugin/totoro/ajaxdel.asp", { act: "delcm", id: cmid } ,
	function(data){
	$("#totoro_" + cmid).html("<span style=\"color:#008000;\">已提交</span>").prev().prev().prev().prev().prev().prev().html(data);
	});
}

function ThisTbIsSpam(tbid){
	$("#totoro_" + tbid).html("<span style=\"color:#800000;\">提交中</span>").prev().html("").prev().html("");
	$.post("../plugin/totoro/ajaxdel.asp", { act: "deltb", id: tbid } ,
	function(data){
	$("#totoro_" + tbid).html("<span style=\"color:#008000;\">已提交</span>").prev().prev().prev().html(data);
		});
}