function login() {
    var id = $("#id").val().trim();
    if (id == "") {
        alert("아이디를 입력해 주세요.");
        $("#id").focus();
        return;
    }
    var ps = $("#ps").val().trim();
    if (ps == "") {
        alert("패스워드를 입력해 주세요.");
        $("#ps").focus();
        return;
    }
    var url ="jsp/login.jsp?id=" + id + "&ps=" + ps;
    AJAX.call(url, null, function(data) {
        var code = data.trim();
        if(code == "NE") {
            alert("아이디가 존재하지 않습니다.");
        }
        else if(code == "PE") {
            alert("패스워드가 일치하지 않습니다.");
        }
        else {
            window.location.href = "MainPage.html";
        }
    });
}