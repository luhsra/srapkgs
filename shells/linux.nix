{ pkgs }:

pkgs.mkShellNoCC {
  buildInputs = with pkgs; [
    clang_18
    lld_18
    llvm_18
    clang-tools_18
    ncurses
    pkg-config
    qemu qemu_kvm qemu-utils
  ];
  inputsFrom = [ pkgs.linux ];
  shellHook = ''
    export LLVM=1
  '';
}
