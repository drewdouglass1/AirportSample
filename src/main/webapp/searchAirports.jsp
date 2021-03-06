<%@page import="java.util.SortedSet"%>


<% SortedSet<String> allCodes = (SortedSet<String>) session.getValue("allCodes"); %>

<script type="text/javascript">
require([
    "dojo/ready", "dojo/store/Memory", "dijit/form/FilteringSelect"
], function(ready, Memory, FilteringSelect){
    var codeStore = new Memory({
        data: [ <% if (allCodes!= null) {
        			int i = 1; %>
        			<% for (String code : allCodes) { 
        				if (i == 1) { %>
            				{name:"<%=code%>", id:"<%=code%>"}
            			<% i++; 
            			} else { %>
            				,{name:"<%=code%>", id:"<%=code%>"}
            			<% }
            		} %> 
            	<% } %>
        ]
    });

    ready(function(){
        var filteringSelect = new FilteringSelect({
            id: "codeSelect",
            name: "code",
            store: codeStore,
            searchAttr: "name"
        }, "codeSelect");
    });
});
</script>
<div  style="height: 200px;">

<%
   SortedSet<String> prevSearches = (SortedSet<String>) session.getValue("prevSearches");
   if (prevSearches != null && prevSearches.size() > 0) {
%>
<div id="history" style="float: right;
     margin: 0 0 10px 10px;
     border: 1px solid #666;
     width: 150px;
     padding: 25px;">
<h3>Search History</h3>
  <form>
    <select multiple="false" name="code">
<%
      for (String code : prevSearches) {
%>
      <option value="<%=code%>" style="width:100px"><%=code%></option>
<%
      }
%>
    </select>
    <br/>
    <input type="submit" name="action" value="Search"/>
  </form>
</div>
<%
   }
%>
<div style="float: right; padding: 2px;">
<form>
  <input type="submit" value="Insert New" name="newEntry"/>
</form>
</div>
<div id="search">Search by Airport Code:
  <form>
    <input name="code" id="codeSelect">
    <input type="submit" name="action" value="Search"/>
  </form>
</div>
</div>