open Http_client.Convenience;;

let post_para = [(*("Host", "www.google.com");*)
		 ("Content-Type", "application/json; charset=utf-8");
		 ("X-GWT-Permutation", "475BAF4AEBA848B4F2A7E0E8803D533E");
		 ("X-GWT-Module-Base", "http://www.google.com/flights/static/");
		 ("Referer", "http://www.google.com/flights/");
		 (*("Content-Length", "275");
		 ("Cookie", "PREF=ID=2dc218fc830df28d:U=29aaf343dd519bca:FF=0:TM=1307225398:LM=1308065727:GM=1:S=RWC3dYzVvVSpkrlz; NID=52=VTp1QILW1ntPlrkLx7yLUtOYhchNk35G4Lk35KBd7A3lCznVV5glz7lwDoDP2RkjtTJVNZSomv3iffPqiJz4oXfpoph3ljb2eInGOe-FwosvrmSXPpnLkEWxMHIbuaid; S=travel-flights=YFCjkd9M9h3Z_uEqBmgynA");
		 ("Pragma", "no-cache");
		 ("Cache-Control", "no-cache");*)
		 ("data", "[,[[,\"fs\",\"[,[,[\\\"SJC\\\"]\n,\\\"2012-04-05\\\",[\\\"EWR\\\",\\\"JFK\\\",\\\"LGA\\\"]\n,\\\"2012-04-12\\\"]\n]\n\"]],[,[[,\"b_ca\",\"54\"],[,\"f_ut\",\"search;f=SJC;t=EWR,JFK,LGA;d=2013-09-05;r=2013-10-12\"],[,\"b_lr\",\"11:36\"],[,\"b_lr\",\"1:1528\"],[,\"b_lr\",\"2:1827\"],[,\"b_qu\",\"3\"],[,\"b_qc\",\"1\"]]]]")];;

let search () = try (http_post "http://www.google.com/flights/rpc" post_para) with
    Http_client.Http_error (id, msg) -> msg;;

(*let _ = print_endline (search());;*)

let fs_body = "[,[[,\"fs\",\"[,[,[\\\"SJC\\\"]\n,\\\"2012-04-05\\\",[\\\"EWR\\\",\\\"JFK\\\",\\\"LGA\\\"]\n,\\\"2012-04-12\\\"]\n]\n\"]],[,[[,\"b_ca\",\"54\"],[,\"f_ut\",\"search;f=SJC;t=EWR,JFK,LGA;d=2013-09-05;r=2013-10-12\"],[,\"b_lr\",\"11:36\"],[,\"b_lr\",\"1:1528\"],[,\"b_lr\",\"2:1827\"],[,\"b_qu\",\"3\"],[,\"b_qc\",\"1\"]]]]";;

let _ =
  let call = new Http_client.post_raw "http://www.google.com/flights/rpc" fs_body
    in
    call#set_req_header "Content-Type" "application/json; charset=utf-8";
    call#set_req_header "X-GWT-Permutation" "475BAF4AEBA848B4F2A7E0E8803D533E";
    call#set_req_header "X-GWT-Module-Base" "http://www.google.com/flights/static/";
    call#set_req_header "Referer" "http://www.google.com/flights/";
    let pipeline = new Http_client.pipeline in
    pipeline#add call;
    pipeline#run ();
    match call # status with
      | `Client_error -> print_endline "Client_error"
      | `Http_protocol_error exn -> print_endline "http_protocol_error"
      | `Server_error -> print_endline ((call # response_body) # value)
      | `Unserved -> print_endline "unserved"
      | `Successful -> print_endline ((call # response_body) # value)
      | _ -> print_endline "failed";;
