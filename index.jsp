<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>

<%
    // Déclaration des variables minSolde, maxSolde, et totalSolde
    float minSolde = Float.MAX_VALUE;
    float maxSolde = Float.MIN_VALUE;
    float totalSolde = 0;
    
    // Code pour la modification d'un client
    if (request.getParameter("action") != null && request.getParameter("action").equals("modifier")) {
        String id = request.getParameter("id");
        String numcompte = request.getParameter("numcompte" + id);
        String nom = request.getParameter("nom" + id);
        String solde = request.getParameter("solde" + id);
        
        Connection con = null;
        PreparedStatement pst = null;
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost/clientbancaire", "root", "");
            String query = "UPDATE client SET numcompte=?, nom=?, solde=? WHERE id=?";
            pst = con.prepareStatement(query);
            pst.setString(1, numcompte);
            pst.setString(2, nom);
            pst.setString(3, solde);
            pst.setString(4, id);
            pst.executeUpdate();
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
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Solde De Client</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"></script>
    <link href="bootstrap/css/bootstrap.css" rel="stylesheet" type="text/css"/>
    <link href="bootstrap/css/bootstrap.min.css" rel="stylesheet" type="text/css"/>
    <!-- Inclure Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<br>
<h1 class="text-center">SOLDE DES CLIENTS</h1>
<br>
<div class="row">
    <div class="col-sm-4">
    <form method="post" action="ajouterClient.jsp"> 
        <div alight="left">
            <label class="form-label"> Numbancaire </label>
            <input type="text" class="form-control" placeholder="Numéro de compte" name="numcompte" id="numcompte"
                   required>
        </div>

        <div alight="left">
            <label class="form-label"> Nom </label>
            <input type="text" class="form-control" placeholder="Nom" name="nom" id="nom" required>
        </div>

        <div alight="left">
            <label class="form-label"> Solde </label>
            <input type="text" class="form-control" placeholder="Solde" name="solde" id="solde" required>
        </div>

        <br>

        <div alight="right">
            <input type="submit" id="submit" value="Ajouter" name="submit" class="btn btn-primary">
        </div>
    </form>
</div>


    <div class="col-sm-8">
        <div class="panel-body">
            <br>
            <!-- Tableau des clients -->
            <table id="tbl-Client" class="table table-responsive table-bordered" cellpading="0" width="100%">
                <thead class="table-dark">
                <tr>
                    <th> Numbancaire</th>
                    <th> Nom</th>
                    <th> Solde</th>
                    <th> Obs </th>
                    <th> Modifier</th>
                    <th> Supprimer</th>
                </tr>
                </thead>
                <% // Déclaration de la connexion, PreparedStatement et ResultSet ici
                    Connection con = null;
                    PreparedStatement pst = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("com.mysql.jdbc.Driver");
                        con = DriverManager.getConnection("jdbc:mysql://localhost/clientbancaire", "root", "");
                        String query = "SELECT * FROM client";
                        pst = con.prepareStatement(query);
                        rs = pst.executeQuery();

                        while (rs.next()) {
                            String id = rs.getString("id");
                            float soldeValue = Float.parseFloat(rs.getString("solde"));
                            String obs = "";
                            if (soldeValue < 1000)
                                obs = "Insuffisant";
                            else if (soldeValue >= 1000 && soldeValue <= 5000)
                                obs = "Moyen";
                            else
                                obs = "Élevé";
                            
                            // Mettre à jour les variables minSolde, maxSolde et totalSolde
                            if (soldeValue < minSolde)
                                minSolde = soldeValue;
                            if (soldeValue > maxSolde)
                                maxSolde = soldeValue;
                            totalSolde += soldeValue;
                %>
                <tr>
                    <td><%=rs.getString("numcompte")%></td>
                    <td><%=rs.getString("nom")%></td>
                    <td><%=rs.getString("solde")%></td>
                    <td><%=obs%></td>

                    <td>
                        <!-- Bouton pour ouvrir le modal de modification -->
                        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#modifierModal<%=id%>">
                            Modifier
                        </button>
                    </td>
                    <td>
                        <a href="delete.jsp?id=<%=id%>">
                            <!-- Bouton de suppression avec confirmation -->
                            <button type="button" class="btn btn-danger" onclick="confirmDelete('<%=id%>')">
                                Supprimer
                            </button>
                        </a>
                    </td>
                </tr>
                
                <!-- Modal de modification pour chaque client -->
                <div class="modal fade" id="modifierModal<%=id%>" tabindex="-1" role="dialog" aria-labelledby="modifierModalLabel<%=id%>" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="modifierModalLabel<%=id%>">Modifier un client</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Formulaire de modification -->
                            <form method="post" action="">
                                <div class="form-group">
                                    <label for="numcompte<%=id%>">Numbancaire</label>
                                    <input type="text" class="form-control" id="numcompte<%=id%>" name="numcompte<%=id%>" value="<%= rs.getString("numcompte") %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="nom<%=id%>">Nom</label>
                                    <input type="text" class="form-control" id="nom<%=id%>" name="nom<%=id%>" value="<%= rs.getString("nom") %>" required>
                                </div>
                                <div class="form-group">
                                    <label for="solde<%=id%>">Solde</label>
                                    <input type="text" class="form-control" id="solde<%=id%>" name="solde<%=id%>" value="<%= rs.getString("solde") %>" required>
                                </div>
                                <input type="hidden" name="id" value="<%=id%>">
                                <input type="hidden" name="action" value="modifier">
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Fermer</button>
                                    <button type="submit" class="btn btn-primary">Modifier</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>


                <% // Fermeture de la boucle while
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    // Fermeture des objets de connexion
                    if (rs != null) {
                        try {
                            rs.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
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
            </table>

            <!-- Affichage du solde minimal, maximal et total -->
            <div class="row">
                <div class="col-sm-6">
                    <h4>Solde Minimal: <%= minSolde %></h4>
                </div>
                <div class="col-sm-6">
                    <h4>Solde Maximal: <%= maxSolde %></h4>
                </div>
                <div class="col-sm-12">
                    <h4>Solde Total: <%= totalSolde %></h4>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Affichage de l'histogramme avec Chart.js -->
    <div class="col-sm-12">
        <h3>Histogramme de Solde</h3>
        <canvas id="histogramChart" width="100" height="40"></canvas>
        <script>
            var ctx = document.getElementById('histogramChart').getContext('2d');
            var histogramChart = new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: ['Solde Minimal', 'Solde Maximal', 'Solde Total'],
                    datasets: [{
                        label: 'Solde',
                        data: [<%= minSolde %>, <%= maxSolde %>, <%= totalSolde %>],
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.2)',
                            'rgba(54, 162, 235, 0.2)',
                            'rgba(255, 206, 86, 0.2)'
                        ],
                        borderColor: [
                            'rgba(255, 99, 132, 1)',
                            'rgba(54, 162, 235, 1)',
                            'rgba(255, 206, 86, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
            // Fonction pour confirmer la suppression
            function confirmDelete(id) {
                if (confirm("Êtes-vous sûr de vouloir supprimer ce client ?")) {
                    window.location.href = "delete.jsp?id=" + id;
                }
            }
        </script>
    </div>
</div>

</body>
</html>
