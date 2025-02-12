{ pkgs }:

pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    clang_15
    lld_15
    llvm_15
    clang-tools_15
    ncurses
    pkg-config
    qemu qemu_kvm qemu-utils
  ];
  inputsFrom = [ pkgs.linux ];
  shellHook = ''
    export LLVM=1
  '';
}
