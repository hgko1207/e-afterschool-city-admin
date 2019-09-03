<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/jsp/common/tagLib.jsp"%>

<c:import url="/WEB-INF/jsp/common/pageHeader.jsp" >
  	<c:param name="icon" value="icon-bubble-notification"/>
  	<c:param name="title" value="전체 공지사항"/>
  	<c:param name="lastname" value="공지사항"/>
</c:import>

<div class="content">
	<div class="row">
		<div class="col-md-2">
			<div class="card">
				<div class="card-header bg-transparent header-elements-inline">
					<span class="text-uppercase font-size-md font-weight-bold">검색 조건</span>
					<div class="header-elements">
						<div class="list-icons">
	                		<a class="list-icons-item" data-action="collapse"></a>
	               		</div>
	          		</div>
				</div>
				<div class="card-body">
					<div class="font-size-xs text-muted mb-2">지역 선택</div>
					<div class="form-group">
						<select class="form-control form-control-select2" name="city">
							<option value="전체">- 전 체 -</option>
							<c:forEach var="city" items="${cities}" varStatus="status">
								<option value="${city.name}">${city.name}</option>
			 				</c:forEach>
						</select>
					</div>
					<div class="font-size-xs text-muted mb-2">카테고리</div>
					<div class="form-group">
						<select class="form-control form-control-select2" name="searchType">
							<c:forEach var="searchType" items="${searchTypes}" varStatus="status">
								<option value="${searchType}">${searchType}</option>
			 				</c:forEach>
						</select>
					</div>
					<div class="form-group">
						<input type="search" class="form-control" placeholder="내용" name="content">
					</div>
					<button type="button" id="searchBtn" class="btn bg-blue-400 btn-block">
						<i class="icon-search4 mr-2"></i>검 색
					</button>
				</div>
			</div>
			
			<div class="card">
				<div class="card-header bg-transparent header-elements-inline">
					<span class="text-uppercase font-size-sm font-weight-semibold">Action</span>
					<div class="header-elements">
						<div class="list-icons">
	                		<a class="list-icons-item" data-action="collapse"></a>
	               		</div>
	          		</div>
				</div>
				<div class="card-body">
					<a href="${pageContext.request.contextPath}/notice/regist" class="btn bg-teal-400 btn-block">
						<i class="icon-pencil5 mr-2"></i>공지사항 등록
					</a>
				</div>
			</div>
		</div>
		
		<div class="col-md-10">
			<div class="card">
				<div class="card-header">
					<h5 class="card-title">공지사항 목록</h5>
				</div>
				<div class="table-responsive">
					<table class="table" id="noticeTable">
						<thead class="text-center">
							<tr class="table-active">
								<th>번 호</th>
								<th>제 목</th>
								<th>글쓴이</th>
								<th>날 짜</th>
								<th>지 역</th>
								<th>조 회</th>
								<th>첨부파일</th>
							</tr>
						</thead>
						<tbody class="text-center"></tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

<!-- 이미지 모달창 -->
<div id="imageModal" class="modal fade" role="dialog">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header bg-primary">
                <h5 class="modal-title">
                    <i class="icon-images2 mr-2"></i>공지사항 첨부파일
                </h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body text-center">
               <div id="image-viewer"></div>
            </div>
        </div>
    </div>
</div>

<script>
var NoticeManager = function() {
	var DataTable = {
		ele: "#noticeTable",
		table: null,
		option: {
			columns: [{
		    	width: "10%",
		    	render: function(data, type, row, meta) {
		    		return meta.row + 1
		    	}
		    }, {
	        	render: function(data, type, row, meta) {
		    		return '<a href="${pageContext.request.contextPath}/notice/detail/' + row.id + '"'
		    		 + 'class="text-default font-weight-bold">' + row.title + '</a>';
		    	}
		    }, {
		    	width: "15%",
		        data: "userName"
		    }, {
		    	width: "16%",
		    	render: function(data, type, row, meta) {
		    		return moment(new Date(row.createDate)).format("YYYY-MM-DD HH:mm:ss");
		    	}
		    }, {
		    	width: "10%",
		    	data: "city"
		    }, {
		    	width: "10%",
		    	data: "hit"
		    }, { 
		    	width: "10%",
			    render: function(data, type, row, meta) {
				    return '<button type="button" class="btn btn-outline bg-primary text-primary-600 btn-sm"'
				    	+ 'onClick="NoticeManager.imageModal(' + row.id + ')"><i class="icon-images2"></i></button>';
			    }
			}]
		},
		init: function() {
			this.table = Datatables.order(this.ele, this.option, [3]);
			this.search();
		},
		search: function() {
			var param = new Object();
			param.searchType = $("select[name=searchType]").val();
			param.content = $("input[name=content]").val();
			Datatables.rowsAdd(this.table, contextPath + "/notice/search", param);
		}
	}

	var searchControl = function() {
		$("#searchBtn").click(function() {
			DataTable.search();
		});
	}
	
	return {
		init: function() {
			DataTable.init();
			searchControl();
		},
		imageModal: function(id) {
			$("#image-viewer").empty();
			
			$.ajax({
		        url: contextPath + "/notice/file/get",
		        type: "GET",
		        data: {"id" : id},
		        success : function(response) {
			        $.each(response.uploadedFiles, function(index, file){ 
			        	var imageContent = `<img src="data:\${file.fileContentType};base64,\${file.content}" class="img-fluid"/>`;
				        $("#image-viewer").append(imageContent);
			        });

		        	$("#imageModal").modal();
		        }
		    });
		}
	}
}();

document.addEventListener('DOMContentLoaded', function() {
	NoticeManager.init();
});
</script>