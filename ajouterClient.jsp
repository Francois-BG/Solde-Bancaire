<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    String numcompte = request.getParameter("numcompte");
    String nom = request.getParameter("nom");
    String solde = request.getParameter("solde");

    Connection con = null;
    PreparedStatement pst = null;

    try {
        Class.forName("com.mysql.jdbc.Driver");
        con = DriverManager.getConnection("jdbc:mysql://localhost/clientbancaire", "root", "");
        String query = "INSERT INTO client (numcompte, nom, solde) VALUES (?, ?, ?)";
        pst = con.prepareStatement(query);
        pst.setString(1, numcompte);
        pst.setString(2, nom);
        pst.setString(3, solde);
        pst.executeUpdate();
        response.sendRedirect("index.jsp"); // Redirection vers votre page principale après l'ajout
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Fermeture des objets de connexion
        if (pst != null) {
            try {
                pst.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
%>
