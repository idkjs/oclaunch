(******************************************************************************)
(* Copyright © Joly Clément, 2014-2015                                        *)
(*                                                                            *)
(*  leowzukw@oclaunch.eu.org                                                  *)
(*                                                                            *)
(*  Ce logiciel est un programme informatique servant à exécuter              *)
(*  automatiquement des programmes à l'ouverture du terminal.                 *)
(*                                                                            *)
(*  Ce logiciel est régi par la licence CeCILL soumise au droit français et   *)
(*  respectant les principes de diffusion des logiciels libres. Vous pouvez   *)
(*  utiliser, modifier et/ou redistribuer ce programme sous les conditions    *)
(*  de la licence CeCILL telle que diffusée par le CEA, le CNRS et l'INRIA    *)
(*  sur le site "http://www.cecill.info".                                     *)
(*                                                                            *)
(*  En contrepartie de l'accessibilité au code source et des droits de copie, *)
(*  de modification et de redistribution accordés par cette licence, il n'est *)
(*  offert aux utilisateurs qu'une garantie limitée.  Pour les mêmes raisons, *)
(*  seule une responsabilité restreinte pèse sur l'auteur du programme,  le   *)
(*  titulaire des droits patrimoniaux et les concédants successifs.           *)
(*                                                                            *)
(*  A cet égard  l'attention de l'utilisateur est attirée sur les risques     *)
(*  associés au chargement,  à l'utilisation,  à la modification et/ou au     *)
(*  développement et à la reproduction du logiciel par l'utilisateur étant    *)
(*  donné sa spécificité de logiciel libre, qui peut le rendre complexe à     *)
(*  manipuler et qui le réserve donc à des développeurs et des professionnels *)
(*  avertis possédant  des  connaissances  informatiques approfondies.  Les   *)
(*  utilisateurs sont donc invités à charger  et  tester  l'adéquation  du    *)
(*  logiciel à leurs besoins dans des conditions permettant d'assurer la      *)
(*  sécurité de leurs systèmes et ou de leurs données et, plus généralement,  *)
(*  à l'utiliser et l'exploiter dans les mêmes conditions de sécurité.        *)
(*                                                                            *)
(*  Le fait que vous puissiez accéder à cet en-tête signifie que vous avez    *)
(*  pris connaissance de la licence CeCILL, et que vous en avez accepté les   *)
(*  termes.                                                                   *)
(******************************************************************************)

open Core.Std;;

(* Module containing code to parse command ids *)

(* An atom contains at least one number and at most one "-"
   This way, atoms are things like "1,2" or "1-3" but not "1,3,4-5" *)
type atom =
  | Between of (int * int) (* Like 1-4 *)
  | Unique of int (* Like 2 *)
;;

(* Test whether a given string may be an atom, and return its type *)
let is_atom str =
  let open Str in
  (* Regexp to test atoms *)
  let between = regexp "\\([0-9]+\\)-\\([0-9]+\\)" in
  let unique = regexp "\\([0-9]+\\)" in

  if string_match between str 0; then
    (* String is like "1-5" *)
    ( (replace_first between "\\1" str), (replace_first between "\\2" str) )
    |> ( fun (a,b) -> Between ((Int.of_string a), (Int.of_string b)) )
    |> Option.some
  else if string_match unique str 0; then
    (* String is like "1-5" *)
    Unique (Int.of_string (replace_first unique "\\1" str))
    |> Option.some
  else None
;;

(* Create small substring (atoms), like this "1,2,6-10" -> [ "1,2" ; "6-10"],
 * raising error on malformed input like "1e" *)
let atomise human_ids =
  String.split ~on:',' human_ids
  |> List.filter_map ~f:is_atom
;;
(* Turn interval (Between (,)) to list of Unique *)
let deinter = function
  | Unique a -> [Unique a]
  | Between (a,b) ->
    (* Note that (a-b+1) is the length of interval [a;b] *)
    List.init (abs(a-b)+1) ~f:(fun i -> Unique (a + i))
;;

(* Transform string (separated) as follow:
 * 1,5 -> [ 1; 5 ]
 * 1-5 -> [1; 2; 3; 4; 5]
 * Multiple occurances should stay, i.e.
 * 1,3,1-4 → [1,3,1,2,3,4] *)
(* TODO Test it
 * 1a -> [1]
 * 1,2 -> [ 1; 2 ]
 * 1,2,1a -> [ 1; 2 ]
 * 3-4,5,1,6-6 -> [1; 3; 4; 5; 6] *)
let list_from_human human =
  atomise human
  |> List.map ~f:deinter
  |> List.concat
  (* Return final list of int *)
  |> List.map ~f:(function
    Unique a -> a | _ -> assert false)
;;

