{ lib, ... }:

{
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      UseDns = lib.mkDefault false;
    };
  };
}
