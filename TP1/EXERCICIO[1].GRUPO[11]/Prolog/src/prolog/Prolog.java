 /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package prolog;

import java.util.HashMap;
import java.util.Scanner;
import se.sics.jasper.*;

/**
 *
 * @author David
 */
public class Prolog {

    public static void main(String[] args) throws SPException, InterruptedException, Exception {
        SICStus sp;
        sp = new SICStus(args, null);
        sp.load("trabalho1.pl");
        HashMap map = new HashMap();
        Scanner scanner = new Scanner(System.in);
        int i = 0;
        while (i == 0) {
            System.out.println("\tLista dos Comandos:");
            System.out.println("TipoNodo <Nodo>");
            System.out.println("Caminho <Nodo> <Nodo>");
            System.out.println("Casa <Nodo>");
            System.out.println("Central <Nodo>");
            System.out.println("Predio <Nodo>");
            System.out.println("Distancia <Nodo> <Nodo>");
            System.out.println("Regiao <Coord> <Coord> <Coord> <Coord> <Nodo>");
            System.out.println("EncontraNodos <Coord> <Coord> <Coord> <Coord> <Nodo>");
            System.out.println("DistanciaNodos [<Nodo>]");
            System.out.println("CaminhoCurto [<Nodo>]");
            System.out.println("Indique o comando pretentido");
            String comando = scanner.nextLine();
            String[] cmd = comando.split(" ");
            switch (cmd[0]) {
                case "TipoNodo":
                    Query query9 = sp.openPrologQuery("tipoNodo(nodo" + cmd[1] + ",P).", map);
                    while (query9.nextSolution()) {
                        System.out.println(map.toString());
                    }

                    break;
                case "Caminho":
                    Query query = sp.openPrologQuery("path(nodo" + cmd[1] + ",nodo" + cmd[2] + ",P).", map);
                    while (query.nextSolution()) {
                        System.out.println(map.toString());
                    }

                    break;
                case "Casa":
                    // Imprima true ou false
                    String query1 = "casa(nodo" + cmd[1] + ").";
                    boolean b = sp.query(query1, map);
                    System.out.println(b);
                    break;
                case "Central":
                    // Imprima true ou false
                    String query2 = "central(nodo" + cmd[1] + ").";
                    boolean b2 = sp.query(query2, map);
                    System.out.println(b2);
                    break;
                case "Predio":
                    // Imprima true ou false
                    String query3 = "predio(nodo" + cmd[1] + ").";
                    boolean b3 = sp.query(query3, map);
                    System.out.println(b3);
                    break;
                case "Distancia":
                    Query query4 = sp.openPrologQuery("distancia(nodo" + cmd[1] + ",nodo" + cmd[2] + ",P).", map);
                    while (query4.nextSolution()) {
                        System.out.println(map.toString());
                    }
                    break;
                case "Regiao":
                    String query5 = "regiao(" + cmd[1] + "," + cmd[2] + "," + cmd[3] + "," + cmd[4] + ",nodo" + cmd[5] + ").";
                    boolean b5 = sp.query(query5, map);
                    System.out.println(b5);
                    break;
                case "EncontraNodos":
                    Query query6 = sp.openPrologQuery("encontrapontosregiao(" + cmd[1] + "," + cmd[2] + "," + cmd[3] + "," + cmd[4] + ",P).", map);
                    while (query6.nextSolution()) {
                        System.out.println(map.toString());
                    }
                    break;
                case "DistanciaNodos":
                    String list = "";
                    for (int j = 1; j < cmd.length; j++) {
                        if (j == cmd.length - 1) {
                            list += "nodo" + cmd[j];
                        } else {
                            list += "nodo" + cmd[j] + ",";
                        }

                    }
                    int o = 0;
                    Query query7 = sp.openPrologQuery("distpontos([" + list + "],P).", map);

                    while (query7.nextSolution() && o == 0) {

                        System.out.println(map.toString());

                    }
                    break;
                case "CaminhoCurto":
                    map.clear();
                    Query query8 = sp.openPrologQuery("cmc(nodo" + cmd[1] + ",nodo" + cmd[2] + ",Caminho,Custo).", map);

                    while (query8.nextSolution()) {
                        System.out.println(map.toString());

                    }
                    break;
                case "quit":

                    //SAIR
                    i++;
                    break;
            }
        }
    }
}
