# BLACK MAGIC TOP LAYER

{ lib }:

let
  recurse = dir:
    lib.mapAttrs
      (name: type:
        let path = dir + "/${name}";
        in
        if type == "directory" then
          if builtins.pathExists (path + "/default.nix") then
            path
          else
            recurse path
        else
          null)
      (builtins.readDir dir);
in
recurse ./. 
