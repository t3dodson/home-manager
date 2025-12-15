{ lib, ... }: {
  imports = let
    modules = lib.fileset.fileFilter (file: file.hasExt "nix") ./.;
    modulesWithoutDefault = lib.fileset.difference modules ./default.nix;
    imports = lib.fileset.toList modulesWithoutDefault;
  in imports;
}
