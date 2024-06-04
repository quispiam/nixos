{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ld-rs = {
      url = "github:nix-community/nix-ld-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #nixos-wsl.url = "github:nix-community/nixos-wsl";
    #nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
  };

  #outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
  outputs = inputs: with inputs; {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
#        nixos-wsl.nixosModules.wsl
        nixos-wsl.nixosModules.default #not sure which of these is better?

#        nix-ld.nixosModules.nix-ld
#        { programs.nix-ld-rs.dev.enable = true; }


        ./configuration.nix
      ];

    };
  };
}
