<%@page import = "java.sql.*"%>

<% 
        String id = request.getParameter("id");       
        Connection con ;
        PreparedStatement pst;
        ResultSet rs;
        
        
    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost/clientbancaire", "root", "");
        pst = con.prepareStatement("delete from client where id = ?");
        pst.setString(1, id);
        pst.executeUpdate();
        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    response.sendRedirect("index.jsp"); // Redirection vers index.jsp après la suppression

        %>
