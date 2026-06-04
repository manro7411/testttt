
var asCatdataTable = null;
var rpNodeIdSize=0;
var idpNodeIdSize=0;

function resetTable(dataTable,tableId) {
	$("#as_p").hide();
	if(dataTable != null){
		dataTable.clear();
		dataTable.draw();
		dataTable.destroy();
	}
	dataTable = null;
	$(tableId).hide();
}

function showTable(tableId) {
	$(tableId).show();
}

function hideTable(tableId){
	$(tableId).hide();
}

function callTableASCatalogue(tableId,label,serviceId) {
	$("#as_p").hide();
	hideTable(tableId);
	$.ajax({
		type : 'POST',
		url : 'ASServiceCatalogueServlet',
		dataType : 'json',
		data : {
			label : label,
			serviceId : serviceId,
			payload : ""
		},
		success : function(data) {	
			console.log(data)
			if (data != null) {
				console.log(tableId);
				showTable(tableId);
				asCatdataTable = generateASCatalogue(data,tableId);
			}
		},
		error : function(data) {
			hideTable(tableId);
			$("#as_p").show();
			$("#as_p").text("Fail to recieve data from server.");			
		}
	});
}

function generateASCatalogue(data,tableId){
	dataTable = $(tableId).DataTable({
	   	    "bJQueryUI": true,
	   	    "bFilter": false,
	        "bInfo": true,
	        "aaSorting": [],
		"aaData" : data,
		"aoColumns" : 
			[{
				"mData" : "serviceIdEdit",
				"mRender": function(data) {
					if(data != null){
						return "<a href=\"#\" onclick=\"showDataByServiceId('"+data+"')\">Click to view and edit</a>";
					}
					else
						return "";
				}
			},{
				"mData" : "serviceId",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "description",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "nodeRole",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "minAal",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "minIal",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "idpAllowNodeId",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "idpAllowIndustry",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "rpAllowNodeId",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "rpAllowIndustry",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}, {
				"mData" : "returnDataByIdp",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			},{
				"mData" : "rpAllowNodeId2",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			},{
				"mData" : "rpAllowNodeId3",
				"mRender": function(data) {
					if(data != null)
						return data;
					else
						return "";
				}
			}
			/* Additional rp_allow_node_id_2 :-> Ratchanon Traitiprat edited date: 29-05-26*/
			/* Additional rp_allow_node_id_2 :-> Ratchanon Traitiprat edited date: 29-05-26*/
			],
   	    "bAutoWidth":false,
 		"aoColumnDefs" : [
 			{"className":"dt-center","aTargets":[3,4,5,8]},
 			{"className":"dt-left","aTargets":[0,1,2,6,7,9,10]}
 		],
 		"sDom":'<"bottom"l>t<"clear"><"pull-left"ip>',
	  	"iDisplayLength": 10,
	  	"sPaginationType": "full_numbers",				  
         "oLanguage": {
             "sEmptyTable": "Transaction Not Found."
         },
	});
	return dataTable;
}
function addRpNode() {
    var value = $("#rpInput").val().trim();
    if (value === "") return;
    var textarea = $("#rpAllowField").find("textarea");
    let current = textarea.val()
        ? textarea.val().split("\n").map(s => s.trim())
        : [];

    if (current.includes(value)) {
        alert("Duplicate value");
        return;
    }
    current.push(value);
    textarea.val(current.join("\n"));
    $("#rpInput").val("");
}

function addIdpNode() {
    var value = $("#idpInput").val().trim();
    if (value === "") return;
    var textarea = $("#idpAllowField").find("textarea");

    let current = textarea.val()
        ? textarea.val().split("\n").map(s => s.trim())
        : [];

    if (current.includes(value)) {
        alert("Duplicate value");
        return;
    }
    current.push(value);
    textarea.val(current.join("\n"));
    $("#idpInput").val("");
}

function showDataByServiceId(serviceId){	
	var label = "getConfigByServiceId";
	$.ajax({
		type : 'POST',
		url : 'ASServiceCatalogueServlet',
		dataType : 'json',
		data : {
			label : label,
			serviceId : serviceId,
			payload : ""
		},
		success : function(data) {			
		    console.log("DATA =>", data);
			if (data != null && data.length == 1) {
				//set data to input text 
				$("#service_id").empty();
				$("#headerField").empty();
				$("#rpAllowField").empty();
				/*
				 * Additional RP Allow Node ID fields (Node ID 2 & 3)
				 * Updated by Ratchanon Traitiprat on 29-05-2026
				 * - Added support for multiple RP Node ID groups
				 * - Improved UI handling for dynamic textarea rendering
				 */
				$("#rpAllowField2").empty();
				$("#rpAllowField3").empty();

				$("#idpAllowField").empty();
				$("#rpAllowField").removeClass("hidden");
				$("#rpAllowField2").removeClass("hidden");
				$("#rpAllowField3").removeClass("hidden");
				$("#idpAllowField").removeClass("hidden");
				$("#service_id").removeClass("hidden");
				$("#headerField").removeClass("hidden");
				$("#submit").removeClass("hidden");
				
				$("#line").removeClass("hidden");
				
				var serviceInfo = data[0];
				$("#service_id").append("<h2 id=\"serviceIdTxt\">"+serviceInfo.serviceId+"</h2> <br/>");
				
				$("#headerField").append("<div id=\"servDesc\" class=\"row\"></div>");
				$("#servDesc").append("<p class=\"col-sm-3 medium\">Service Description</p>");
				$("#servDesc").append("<input type=\"text\" class=\"col-md-3\" style=\"width:40%\" value=\""+serviceInfo.description+"\"/> <br/>");
				
				$("#headerField").append("<div id=\"servNodeRole\" class=\"row\"></div>");
				$("#servNodeRole").append("<p class=\"col-sm-3 medium\">Node Role</p>");
				$("#servNodeRole").append("<input type=\"text\" class=\"col-md-2\" style=\"width:40%\" value=\""+serviceInfo.nodeRole+"\"/> <br/>");
				
				$("#headerField").append("<div id=\"servMinAal\" class=\"row\"></div>");
				$("#servMinAal").append("<p class=\"col-sm-3 medium\">Min Aal</p>");
				$("#servMinAal").append("<input type=\"text\" class=\"col-md-2\" style=\"width:40%\" value=\""+serviceInfo.minAal+"\"/> <br/>");
				
				$("#headerField").append("<div id=\"servMinIal\" class=\"row\"></div>");
				$("#servMinIal").append("<p class=\"col-sm-3 medium\">Min Ial</p>");
				$("#servMinIal").append("<input type=\"text\" class=\"col-md-2\" style=\"width:40%\" value=\""+serviceInfo.minIal+"\"/> <br/>");
				
				$("#headerField").append("<div id=\"servReturnDataByIdp\" class=\"row\"></div>");
				$("#servReturnDataByIdp").append("<p class=\"col-sm-3 medium\">Return Data By IDP</p>");
				$("#servReturnDataByIdp").append("<input type=\"text\" class=\"col-md-2\" style=\"width:40%\" value=\""+serviceInfo.returnDataByIdp+"\"/> <br/>");
				
				
				$("#rpAllowField").append("<div id=\"servRpAllowIndustry\" class=\"row\"></div>");
				if(serviceInfo.asAllowIndustry == null){
					$("#servRpAllowIndustry").append("<p class=\"col-sm-3\">RP Allow Industry</p>");
					$("#servRpAllowIndustry").append("<input id=\"rpAllowIndustry\" type=\"text\" class=\"col-md-2\" style=\"width:40%\"/> <br/>");
				}
				else{
					$("#servRpAllowIndustry").append("<p class=\"col-sm-3\">RP Allow Industry</p>");
					$("#servRpAllowIndustry").append("<input id=\"rpAllowIndustry\" type=\"text\" class=\"col-md-2\" style=\"width:40%\" value=\""+serviceInfo.asAllowIndustry+"\"/> <br/>");
				}
				//RP1
				if(serviceInfo.rpAllowNodeId != null){
					
					var rpNodeId = serviceInfo.rpAllowNodeId.split(",");		
					var rpNodeText = "";
					
					for(var i = 0 ; i < rpNodeId.length ; i++){
						rpNodeText += rpNodeId[i].trim();
						
						if(i !== rpNodeId.length - 1){
							rpNodeText += "\n";
						}
					}
					console.log(rpNodeText);					
				    $("#rpAllowField").append("<div id=\"servRpNodeId1\" class=\"row\"></div>");
				    $("#servRpNodeId1").append("<p class=\"col-sm-3\" style=\"margin-top:6px;\">RP Allow Node ID 1</p>");
						
				    $("#servRpNodeId1").append(
				    		  "<textarea id=\"rpAllowNodeId\" class=\"col-md-2\" " +
				    		  "style=\"width:40%; height:300px; margin-top:5px; margin-bottom:5px;\">" +
				    		  rpNodeText +
				    		  "</textarea>"
				    		);
				}
				else{
					$("#rpAllowField").append("<div id=\"servRpNodeId1\" class=\"row\"></div>");
					$("#servRpNodeId1").append("<p class=\"col-sm-3\">RP Allow Node ID 1</p>");
					$("#servRpNodeId1").append("<textarea id=\"rpAllowNodeId\" class=\"col-md-2\" " +"style=\"width:40%; height:120px;\"></textarea>");

				}
			
				$("#rpAllowField").append(`
					    <div id="rpAddSection" class="row" style="margin-top:15px;">
					        <p class="col-sm-3"></p>

					        <div style="display:flex; gap:10px; width:40%;">
					            <input id="rpInput"
					                   type="text"
					                   placeholder="Add RP Allow Node ID"
					                   style="flex:1; padding:8px;">

					            <button onclick="addRpNode()"
					                    style="padding:8px 12px;">
					                + Add
					            </button>
					        </div>
					    </div>

					    <div id="rpList" style="margin-top:15px;"></div>
					`);
				
				/* Additional rp_allow_node_id_2 :-> Ratchanon Traitiprat edited date: 29-05-26*/				
				//Rp2
				if(serviceInfo.rpAllowNodeId2 != null && serviceInfo.rpAllowNodeId2 !== ""){

				    var rpNodeId2 = serviceInfo.rpAllowNodeId2.split(",");
				    var rpNodeText2 = "";

				    for(var i = 0; i < rpNodeId2.length; i++){
				        rpNodeText2 += rpNodeId2[i].trim();

				        if(i !== rpNodeId2.length - 1){
				            rpNodeText2 += "\n";
				        }
				    }

				    $("#rpAllowField2").append("<div id=\"servRpNodeId2\" class=\"row\"></div>");
				    $("#servRpNodeId2").append("<p class=\"col-sm-3\" style=\"margin-top:6px;\">RP Allow Node ID 2</p>");				    
				    $("#servRpNodeId2").append(
				    		  "<textarea id=\"rpAllowNodeId2\" class=\"col-md-2\" " +
				    		  "style=\"width:40%; height:300px; margin-top:5px; margin-bottom:5px;\">" +
				    		  rpNodeText2 +
				    		  "</textarea>"
				    );
				}
				else{				
					$("#rpAllowField2").append("<div id=\"servRpNodeId2\" class=\"row\"></div>");
					$("#servRpNodeId2").append("<p class=\"col-sm-3\">RP Allow Node ID 2</p>");
					$("#servRpNodeId2").append("<textarea id=\"rpAllowNodeId2\" class=\"col-md-2\" " +"style=\"width:40%; height:120px;\"></textarea>");
				}
				//Rp3
				if(serviceInfo.rpAllowNodeId3 != null && serviceInfo.rpAllowNodeId3 !== ""){

				    var rpNodeId3 = serviceInfo.rpAllowNodeId3.split(",");
				    var rpNodeText3 = "";

				    for(var i = 0; i < rpNodeId3.length; i++){
				        rpNodeText3 += rpNodeId3[i].trim();

				        if(i !== rpNodeId3.length - 1){
				            rpNodeText3 += "\n";
				        }
				    }
				    
				    $("#rpAllowField3").append("<div id=\"servRpNodeId3\" class=\"row\"></div>");
				    $("#servRpNodeId3").append("<p class=\"col-sm-3\" style=\"margin-top:6px;\">RP Allow Node ID 3</p>");						
				    $("#servRpNodeId3").append(
				    		  "<textarea id=\"rpAllowNodeId3\" class=\"col-md-2\" " +
				    		  "style=\"width:40%; height:300px; margin-top:5px; margin-bottom:5px;\">" +
				    		  rpNodeText3 +
				    		  "</textarea>"
				    		);
				}
				else{
					
					$("#rpAllowField3").append("<div id=\"servRpNodeId3\" class=\"row\"></div>");
					$("#servRpNodeId3").append("<p class=\"col-sm-3\">RP Allow Node ID 3</p>");
					$("#servRpNodeId3").append("<textarea id=\"rpAllowNodeId3\" class=\"col-md-2\" " +"style=\"width:40%; height:120px;\"></textarea>");

				}
				
				/* Additional rp_allow_node_id_2 :-> Ratchanon Traitiprat edited date: 29-05-26*/

				//IDP
				$("#idpAllowField").append("<div id=\"servIdpAllowIndustry\" class=\"row\"></div>");
				if(serviceInfo.idpAllowIndustry == null){
					$("#servIdpAllowIndustry").append("<p class=\"col-sm-3\">IDP Allow Industry</p>");
					$("#servIdpAllowIndustry").append("<input id=\"idpAllowIndustry\" type=\"text\" class=\"col-md-2\" style=\"width:40%\"/> <br/>");
				}
				else{
					$("#servIdpAllowIndustry").append("<p class=\"col-sm-3\">IDP Allow Industry</p>");
					$("#servIdpAllowIndustry").append("<input id=\"idpAllowIndustry\" type=\"text\" class=\"col-md-2\" style=\"width:40%\" value=\""+serviceInfo.idpAllowIndustry+"\"/> <br/>");
				}
				
				if(serviceInfo.idpAllowNodeId != null){
					var idpNodeId = serviceInfo.idpAllowNodeId.split(",");
					var idpNodeText="";
					
					for(var i = 0; i< idpNodeId.length; i++){
						idpNodeText+=idpNodeId[i].trim();
						
						if(i !== idpNodeId.length - 1){
							idpNodeText += "\n";
						}
					}
					console.log("IDP INFO : ",idpNodeText);
					$("#idpAllowField").append("<div id=\"servIdpNodeId0\" class=\"row\"></div>");
					$("#servIdpNodeId0").append("<p class=\"col-sm-3\">IDP Allow Node ID</p>");
					
				    $("#servIdpNodeId0").append(
				    		  "<textarea id=\"idpAllowNodeId\" class=\"col-md-2\" " +
				    		  "style=\"width:40%; height:300px; margin-top:5px; margin-bottom:5px;\">" +
				    		  idpNodeText +
				    		  "</textarea>"
				    );
				}else{
					$("#idpAllowField").append("<div id=\"servIdpNodeId0\" class=\"row\"></div>");
					$("#servIdpNodeId0").append("<p class=\"col-sm-3\">IDP Allow Node ID</p>");
					$("#servIdpNodeId0").append("<textarea id=\"idpAllowNodeId\" class=\"col-md-2\" " +"style=\"width:40%; height:120px;\"></textarea>");

				}
				$("#idpAllowField").append(`
					    <div id="idpAddSection" class="row" style="margin-top:15px;">
					        <p class="col-sm-3"></p>

					        <div style="display:flex; gap:10px; width:40%;">
					            <input id="idpInput"
					                   type="text"
					                   placeholder="Add IDP Allow Node ID"
					                   style="flex:1; padding:8px;">

					            <button onclick="addIdpNode()"
					                    style="padding:8px 12px;">
					                + Add
					            </button>
					        </div>
					    </div>

					    <div id="idpList" style="margin-top:15px;"></div>
					`);
			}
		},
		error : function(data) {
			hideTable(tableId);
			$("#as_p").show();
			$("#as_p").text("Fail to recieve data from server.");
		}
	});
}

function addIdpTextBox(rowId){
	idpNodeIdSize += 1;
	
	$("#addIdpNodeIdBtn").remove();
	
	$("#idpAllowField").append("<div id=\"servIdpNodeId"+rowId+"\" class=\"row\"></div>");
	$("#servIdpNodeId"+rowId).append("<p class=\"col-sm-3\"></p>");
	$("#servIdpNodeId"+rowId).append("<input type=\"text\" class=\"col-md-2\" style=\"width:40%\"/>");
	$("#servIdpNodeId"+rowId).append("<button class=\"w3-button \" style=\"margin-left:10px;\" value=\"Remove\" " +
										"onclick=\"removeTextBox('servIdpNodeId"+rowId+"')\"> " +
											"<img src=\"../media/images/delete.png\" style=\"width:15px;height:15px\">" +
									"</button> <br/>");
	
	$("#idpAllowField").append("<div id=\"addIdpNodeIdBtn\" class=\"row\"></div>");
	$("#addIdpNodeIdBtn").append("<p class=\"col-sm-3\"></p>");
	$("#addIdpNodeIdBtn").append("<input type=\"button\" class=\"submit\" value=\"Add IDP Allow Node ID\" onClick=\"addIdpTextBox("+(idpNodeIdSize+1)+")\" /> <br/>");
}

function addRpTextBox(rowId){
	rpNodeIdSize += 1;
	
	$("#addRpNodeIdBtn").remove();
	
	$("#rpAllowField").append("<div id=\"servRpNodeId"+rowId+"\" class=\"row\"></div>");
	$("#servRpNodeId"+rowId).append("<p class=\"col-sm-3\"></p>");
	$("#servRpNodeId"+rowId).append("<input type=\"text\" id=\"txtRP"+rowId+"\" class=\"col-md-2\" style=\"width:40%\"/>");
	$("#servRpNodeId"+rowId).append("<button class=\"w3-button \" style=\"margin-left:10px;\" value=\"Remove\" " +
										"onclick=\"removeTextBox('servRpNodeId"+rowId+"')\"> " +
											"<img src=\"../media/images/delete.png\" style=\"width:15px;height:15px\">" +
									"</button> <br/>");
	
	$("#rpAllowField").append("<div id=\"addRpNodeIdBtn\" class=\"row\"></div>");
	$("#addRpNodeIdBtn").append("<p class=\"col-sm-3\"></p>");
	$("#addRpNodeIdBtn").append("<input type=\"button\" class=\"submit\" value=\"Add RP Allow Node ID\" onClick=\"addRpTextBox("+(rpNodeIdSize+1)+")\"/> <br/><br/>");
}

function removeTextBox(txtId){
	$("#"+txtId).remove();
}

function submitAsCat(){
	var jsonObj = new Object();
	var serviceIdField = $("#serviceIdTxt").text();
	var headerField = $("#headerField :input");// get all Text box element inside <div id="headerField">
	var rpAllowField = $("#rpAllowField :input");// get all Text box element inside <div id="rpAllowField">
	var rpAllowField2 = $("#rpAllowField2 :input");// get all Text box element inside <div id="rpAllowField">
	var rpAllowField3 = $("#rpAllowField3 :input");// get all Text box element inside <div id="rpAllowField">

	var idpAllowField = $("#idpAllowField :input");// get all Text box element inside <div id="idpAllowField">
	
	// Ratchanon Traitiprat
	var rpAllowNodeIdText = $("#rpAllowField").find("textarea").val() || "";
	var rpAllowNodeId = "";
	if (rpAllowNodeIdText && rpAllowNodeIdText.trim() !== "") {
	    rpAllowNodeId = rpAllowNodeIdText
	        .split("\n")
	        .map(function(s){ return s.trim(); })
	        .filter(function(s){ return s !==""; })
	        .join(",");
	}
	var rpAllowIndustry = $("#rpAllowIndustry").val() || "";
	
	var idpAllowNodeIdText = $("#idpAllowField").find("textarea").val() || "";
	var idpAllowNodeId = "";
	if (idpAllowNodeIdText && idpAllowNodeIdText.trim() !== ""){
		idpAllowNodeId = idpAllowNodeIdText
	        .split("\n")
	        .map(function(s){ return s.trim(); })
	        .filter(function(s){ return s !==""; })
	        .join(",");
	}
	var idpAllowIndustry = $("#idpAllowIndustry").val() || "";
	
	var rpAllowNodeIdText2 = $("#rpAllowField2").find("textarea").val() || "";
	console.log("incoming req ->",rpAllowNodeIdText2)
	var rpAllowNodeId2 = "";
	if (rpAllowNodeIdText2 && rpAllowNodeIdText2.trim() !== "") {
	    rpAllowNodeId2 = rpAllowNodeIdText2
	        .split("\n")
	        .map(function(s){ return s.trim(); })
	        .filter(function(s){ return s !==""; })
	        .join(",");
	}
	var rpAllowIndustry = $("#rpAllowIndustry").val() || "";
	
	var rpAllowNodeIdText3 = $("#rpAllowField3").find("textarea").val() || "";
	console.log("incoming req ->",rpAllowNodeIdText3)
	var rpAllowNodeId3 = "";
	if (rpAllowNodeIdText3 && rpAllowNodeIdText3.trim() !== "") {
	    rpAllowNodeId3 = rpAllowNodeIdText3
	        .split("\n")
	        .map(function(s){ return s.trim(); })
	        .filter(function(s){ return s !==""; })
	        .join(",");
	}
	var rpAllowIndustry = $("#rpAllowIndustry").val() || "";
	
	console.log("rpAllowNodeId2 raw data ->",rpAllowNodeId2)
	console.log("rpAllowNodeId3 raw data ->",rpAllowNodeId3)

	// -------------------------------------------------------------------------
	jsonObj.serviceId = serviceIdField
	jsonObj.description = headerField[0].value;
	jsonObj.nodeRole = headerField[1].value;
	jsonObj.minAal = parseFloat(headerField[2].value);
	jsonObj.minIal = parseFloat(headerField[3].value);
	jsonObj.returnDataByIdp = headerField[4].value;
	jsonObj.rpAllowIndustry = rpAllowIndustry;
	jsonObj.rpAllowNodeId = rpAllowNodeId;
	jsonObj.idpAllowIndustry = idpAllowIndustry;
	jsonObj.idpAllowNodeId = idpAllowNodeId;
	jsonObj.rpAllowNodeId2 = rpAllowNodeId2;
	jsonObj.rpAllowNodeId3 = rpAllowNodeId3;
	
	var json = JSON.stringify(jsonObj);
	var label = "updateConfigByServiceId";
	var serviceId = serviceIdField;
	
	$.ajax({
		type : 'POST',
		url : 'ASServiceCatalogueServlet',
		dataType : 'json',
		data : {
			label : label,
			serviceId : serviceId,
			payload : json
		},
		success : function(data) {			
			if (data != null) {
				resetTable(asCatdataTable,"#NDID_ASServiceCatTable");
				$("#service_id").empty();
				$("#headerField").empty();
				$("#rpAllowField").empty();
				$("#rpAllowField2").empty();
				$("#rpAllowField3").empty();
				$("#idpAllowField").empty();
				$("#rpAllowField").addClass("hidden");
				$("#idpAllowField").addClass("hidden");
				$("#service_id").addClass("hidden");
				$("#headerField").addClass("hidden");
				$("#submit").addClass("hidden");
				
				$("#line").addClass("hidden");
				callTableASCatalogue("#NDID_ASServiceCatTable","getAllConfig","");
			}
		},
		error : function(data) {
			hideTable(tableId);
			$("#as_p").show();
			$("#as_p").text("Fail to recieve data from server.");
		}
	});
	
}

                          <%@page import="com.bbl.ndid.permission.UserPermission"%>
<%

	String usr = (String) session.getAttribute("usr");
	final UserPermission userPermission = new UserPermission(usr);
	final String pageName = userPermission.getPageNameFromURL(request.getRequestURI());
	session.setAttribute("usr", usr);
	session.setAttribute("usrPMS", userPermission);
	session.setAttribute("pageName", pageName);
	
%>
 <%@ include file="NDIDMonitorMenu.jsp"%>
		<!-- Javascript functions -->		
		<script src="./js/NDID_ASCatConfig.js" type="text/javascript"></script>
		
		<script type="text/javascript">
			$(document).ready(function() {
				tableId = "#NDID_ASServiceCatTable";
				callTableASCatalogue(tableId,"getAllConfig","");
			});
		</script>
	    
		<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main" style="margin-top: 5%;">
			<h2 class="sub-header" style="text-align:center">AS Services Catalog</h2>
			<div class="table-responsive">
				<div id="as_p" style=" text-align: center; color: red; margin-top:10px"></div>
				<table id="NDID_ASServiceCatTable" class="display cell-border compact nowrap">
					<thead>
						<tr>
							<td id="ServiceIdEdit"			class="columHeader" >Edit</td>
							<td id="ServiceId" 				class="columHeader" >ServiceId</td>
							<td id="description" 			class="columHeader" >Description</td>
							<td id="nodeRole" 				class="columHeader" >Node Role</td>
							<td id="minAal" 				class="columHeader" >Min Aal</td>
							<td id="minIal" 				class="columHeader" >Min Ial</td>
							<td id="idpAllowNodeId" 		class="columHeader" >IDP Allow Node ID</td>
							<td id="idpAllowNideIndustry" 	class="columHeader" >IDP Allow Industry</td>
							<td id="rpAllowNodeId" 			class="columHeader" >RP Allow Node ID_1</td>					
							<td id="rpAllowIndustry" 		class="columHeader" >RP Allow Industry</td>
							<td id="returnDataByIdp" 		class="columHeader" >Return Data By IDP</td>
							<td id="rpAllowNodeId2" 		class="columHeader" >RP Allow Node ID_2</td>
							<td id="rpAllowNodeId3" 		class="columHeader" >RP Allow Node ID_3</td>
						</tr>
					</thead>
				</table>
			</div>
			
			<div class="media-object">
				<br/><br/>
				<div id="line" style="width:100%;height:3px;background-color:gray" class="hidden"></div>
				<br/>
				
				<div id="service_id" class="hidden media-object"></div>
				<div id="headerField" class="hidden media-object">
					<!-- data here -->
				</div>
				<br/>
				<div id="rpAllowField" class="hidden media-object">
					<!-- data here -->
				</div>
				
				<!-- Additional rp_allow_node_id_2 :-> Ratchanon Traitiprat edited date: 29-05-26 -->
				<div id="rpAllowField2" class="hidden media-object">
					<!-- data here -->
				</div>
				<div id="rpAllowField3" class="hidden media-object">
					<!-- data here -->
				</div>
				<!-- Additional rp_allow_node_id_2 :-> Ratchanon Traitiprat edited date: 29-05-26 -->
				
				<br/>
				<div id="idpAllowField" class="hidden media-object">
					<!-- data here -->
				</div>
				<p id="test"></p>
				<div id="submit" class="container-fluid hidden media-object">
					<br/>
					<button id="submitBtn" style="margin-left:35%" onclick="submitAsCat()">Update Service Catalog</button>
					<p id="test"></p>
				</div>
			</div>
		</div>
		

	</body>
</html>
