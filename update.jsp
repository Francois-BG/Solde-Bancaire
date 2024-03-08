<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import = "java.sql.*"%>

<% if (request.getParameter("submit")!=null) 
    {
        String id = request.getParameter("id");
        String numcompte = request.getParameter("numcompte");
        String nom = request.getParameter("nom");
        String solde = request.getParameter("solde");
        
        Connection con ;
        PreparedStatement pst;
        ResultSet rs;
                try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clientbancaire","root","");
            pst = con.prepareStatement("update client set numcompte = ?, nom = ?, solde = ? where id = ?");
            pst.setString(1, numcompte);
            pst.setString(2, nom);
            pst.setString(3, solde);
            pst.setString(4, id);
            pst.executeUpdate();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
%>
        
<script>
    alert("Modifier avec Succès");
    window.location.replace("index.jsp"); // Redirection vers index.jsp après la mise à jour
</script>
<%        
    }
%>
        

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css"/>
        <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
        <title>Modifier un client</title>
    </head>
    <body>
        <br>
        <h1>Client Bancaire</h1>
        <br>
        <div class="row">
            <div class="col-sm-4">
                    <form method="post" action="">
                       <%
                        Connection con ;
                        PreparedStatement pst;
                        ResultSet rs;
        
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost/clientbancaire","root",""); 
                        
                        String id = request.getParameter("id");
                        pst  = con.prepareStatement("SELECT*FROM client Where id = ?");
                        pst.setString(1,id);
                        rs = pst.executeQuery();
                        while(rs.next())
                        {     
                        %>
                        <div alight="left">
                            <label class="form-label"> Numbancaire </label>
                            <input type="text" class="form-control" value = "<%=rs.getString("numcompte") %> " name="numcompte" id="numcompte" required>
                        </div>

                        <div alight="left">
                            <label class="form-label"> Nom </label>
                            <input type="text" class="form-control" value = "<%=rs.getString("nom") %>" name="nom" id="nom" required>
                        </div>

                        <div alight="left">
                            <label class="form-label"> Solde </label>
                            <input type="text" class="form-control" value = "<%=rs.getString("solde")%> " name="solde" id="solde" required>
                        </div>
                        <%
                            }
                        %>

                        <br>

                        <div alight ="right">
                            <input type="submit" id ="submit" value="Modifier" name ="submit" class="btn btn-primary">
                        </div>

                    </form>
            </div>
    </body>
</html>
