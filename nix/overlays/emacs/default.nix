{ emacs, emacsPackagesGen, notmuch, unstablePkgs }:
let
  emacsClientMotif = (
    emacs.override {
      withGTK2 = false;
      withGTK3 = false;
    }
  ).overrideAttrs (
    attrs: {
      postInstall = (attrs.postInstall or "") + ''
        rm $out/share/applications/emacs.desktop
      '';
    }
  );

in
let
  emacsWithPackages = (unstablePkgs.emacsPackagesGen emacsClientMotif).emacsWithPackages;
in
  emacsWithPackages (
    epkgs: (
      with epkgs.melpaStablePackages; [


        magit # ; Integrate git <C-x g>
        zerodark-theme # ; Nicolas' theme
        flycheck

      ]
    ) ++ (
      with epkgs.melpaPackages; [

        fira-code-mode
        avy
        use-package
        lsp-mode
        nix-mode
        projectile
        dap-mode
        which-key
        counsel
        multiple-cursors

      ]
    ) ++ (
      with epkgs.elpaPackages; [


        undo-tree # ; <C-x u> to show the undo tree
        auctex # ; LaTeX mode
        beacon # ; highlight my cursor when scrolling
        nameless # ; hide current package name everywhere in elisp code
      ]
    ) ++ [
      notmuch # From main packages set 


    ]
  )
