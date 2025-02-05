<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, org.json.simple.JSONArray, org.json.simple.JSONObject" %>

<%
    request.setCharacterEncoding("UTF-8");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    JSONArray projectList = new JSONArray();

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521/XE", "park", "1111");

        System.out.println("🔍 SQL 실행 시작");

        // 실행할 SQL 로그 출력
        String sql = "SELECT ProjectID, ProjectName, TO_CHAR(CreatedAt, 'YYYY-MM-DD') AS CreatedAt FROM Projects ORDER BY CreatedAt DESC, ProjectID ASC";
        System.out.println("✅ 실행할 SQL: " + sql);

        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        int count = 0;
        while (rs.next()) {
            JSONObject project = new JSONObject();
            project.put("no", rs.getInt("ProjectID"));
            project.put("name", rs.getString("ProjectName"));
            project.put("created_at", rs.getString("CreatedAt"));
            projectList.add(project);
            count++;

            System.out.println("📌 프로젝트 추가됨: " + project.toJSONString()); // ✅ 개별 프로젝트 확인 로그
        }

        System.out.println("✅ 최종 조회된 프로젝트 개수: " + count); // ✅ 총 개수 확인
        System.out.println("✅ 최종 JSON 결과: " + projectList.toJSONString()); // ✅ 최종 JSON 출력

    } catch (Exception e) {
        e.printStackTrace();
        System.out.println("❌ SQL 실행 오류 발생");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }

    out.print(projectList.toJSONString());
%>
