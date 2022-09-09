{ pkgs }: {
	deps = [
                pkgs.R
                pkgs.clang_12
		pkgs.ccls
		pkgs.gdb
		pkgs.gnumake
	];
}
