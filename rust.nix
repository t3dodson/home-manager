{ fenixPkgs, ... }:
{
  home.packages = [
    fenixPkgs.default.toolchain
  ];
}
