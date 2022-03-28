<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html" ; charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Upload with Ajax</h1>
	<div class='uploadDiv'>
		<input type='file' name='uploadFile' multiple>
	</div>
	<button id='uploadBtn'>Submit</button>

	<div class='uploadResult'>
		<ul></ul>
	</div>



	<script src="https://code.jquery.com/jquery-3.6.0.js"
		integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk="
		crossorigin="anonymous"></script>
	<script>
		$(document)
				.ready(
						function() {
							var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
							var maxSize = 524880;
							function checkExtension(fileName, fileSize) {
								if (fileSize >= maxSize) {
									alert("파일 사이즈 초과");
									return false;
								}
								if (regex.test(fileName)) {
									alert("해당 종류의 파일은 업로드할 수 없습니다.");
									return false;
								}
								return true;
							}

							var cloneObj = $(".uploadDiv").clone();
							$("#uploadBtn")
									.on(
											"click",
											function(e) {
												var formData = new FormData();
												var inputFile = $("input[name='uploadFile']");
												var files = inputFile[0].files;
												console.log(files);
												for (var i = 0; i < files.length; i++) {
													if (!checkExtension(
															files[i],
															files[i].size)) {
														return false;
													}
													formData.append(
															"uploadFile",
															files[i]);
												}
												$
														.ajax({
															url : '/uploadAjaxAction',
															processData : false,
															contentType : false,
															data : formData,
															type : 'POST',
															dataType : 'json',
															success : function(
																	result) {
																console
																		.log(result);
																showUploadedFile(result);
																$(".uploadDiv")
																		.html(
																				cloneObj
																						.html());
																alert("Uploaded");
															}
														}); // ajax end
											});// uploadbutton end
							var uploadResult = $(".uploadResult ul");
							function showUploadedFile(uploadResultArr) {
								var str = "";
								$(uploadResultArr)
										.each(
												function(i, obj) {
													if (!obj.image) {
														str += "<li><img src='/resources/img/attach.png'>"
																+ obj.fileName
																+ "</li>";
													} else {

														var fileCallPath = encodeURIComponent(obj.uploadPath
																+ "/s_"
																+ obj.uuid
																+ "_"
																+ obj.fileName);
														str += "<li><img src = '/display?fileName="
																+ fileCallPath
																+ "'></li>";

														console
																.log(str);
													}
												});
								uploadResult.append(str);
							}
						});
	</script>
</body>
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 20px;
}
</style>
</html>