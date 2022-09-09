{ pkgs }: {
	deps = [
		pkgs.rWrapper
                pkgs.R
                pkgs.clang_12
		pkgs.ccls
		pkgs.gdb
		pkgs.gnumake
	];
}
