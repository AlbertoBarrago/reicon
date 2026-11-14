# reicon

Custom icons for macOS apps, from the terminal. One zsh script, no dependencies.

```sh
reicon set OpenIDEA ~/Downloads/openidea.png
```

reicon uses the same mechanism as pasting an image into Finder's "Get Info" window
(`NSWorkspace.setIcon`), so the app itself is not modified beyond its custom icon and its
code signature stays valid. Unlike Finder, it remembers the icons you set and puts them
back after an app update with one command.

## Install

```sh
git clone https://github.com/AlbertoBarrago/reicon.git
cd reicon
./install.sh
```

`install.sh` links `reicon` into `~/.local/bin` and tells you if that folder is not in
your `PATH`. Remove the link with `./install.sh --uninstall`.

Requirements: macOS 11 or later. No Xcode or Command Line Tools needed.

## Usage

| Command | What it does |
| --- | --- |
| `reicon set <app> <image>` | Sets the icon and remembers it for `sync` |
| `reicon restore <app>` | Restores the original icon and forgets it |
| `reicon list` | Shows managed icons and their state |
| `reicon sync` | Re-applies icons dropped by app updates |
| `reicon help [command]` | General or per-command help |

`<app>` is a path to a `.app` bundle or just its name (`OpenIDEA`, `"Visual Studio Code"`),
looked up in `/Applications` and `~/Applications`. Images can be PNG, JPEG, ICNS or SVG.

`reicon list` reports each managed icon as:

- `ok`: the custom icon is in place
- `needs sync`: the app was updated and lost its icon, run `reicon sync`
- `app missing`: the app is no longer installed

Next to the state, each app shows the name to pass to `reicon restore` (quoted when it has
spaces, `-` when the app is missing), followed by its path.

## Preparing an icon

macOS does not reshape custom icons: the image is shown as it is. For an icon that sits
well in the Dock, use a 1024x1024 image with transparent corners and the body drawn
at about 824x824 in the middle (the standard macOS icon grid), leaving room for a soft shadow.

[`icons/openidea.svg`](icons/openidea.svg) and [`icons/rex-albz.svg`](icons/rex-albz.svg) are
examples built on that grid. SVG text is not guaranteed to render through `NSImage`, so for
icons with lettering pass a rendered PNG (each example ships one next to its SVG).

## Notes

- **App updates** replace the app bundle and drop the custom icon. Run `reicon sync`
  afterwards (or `reicon list` to see which apps need it).
- **Running apps** keep the icon they loaded at launch, so their Dock tile changes only
  after you relaunch them. `reicon` tells you when the app is running.
- **Permissions.** Apps you installed by dragging them into `/Applications` usually belong
  to you and need nothing else. Apps owned by root (App Store, installers) or by another
  user need `sudo`: `reicon` prints the exact command to run and, in a terminal, offers to
  re-run it with `sudo` for you.
- **App Management.** macOS can block changes to other apps' bundles until your terminal
  is allowed in System Settings > Privacy & Security > App Management (quit and reopen the
  terminal afterwards). This is checked on the terminal, not the user, so `sudo` does not
  bypass it. `reicon` checks the bundle after each change, tells you when this happens and
  offers to open that Settings pane.
- **System apps** in `/System/Applications` live on a read-only volume and cannot be changed.
- **Where data lives.** The registry and the copies of your images are in
  `~/.config/reicon` (or `$XDG_CONFIG_HOME/reicon`).

## License

MIT, see [LICENSE](LICENSE). The example icons in `icons/` are reworked versions of
third-party marks, which belong to their authors:

- `openidea.*`: the [OpenIDEA](https://github.com/l0ng-ai/openidea) logo (Apache-2.0)
- `rex-albz.*`: a personal, hand-redrawn take on the Rex app icon

reicon is not affiliated with OpenIDEA or Rex.
