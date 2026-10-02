#!/usr/bin/env python3
"""
Wraps i3status and prepends a block showing the focused window's
app-id, queried live from Jay. Jay's bar renders the status program's
output right after the workspace tabs, so this block ends up exactly
where you wanted it: top-left, right of the workspace numbers.

Point Jay's [status].exec at this script instead of at i3status
directly (see notes at the bottom of the file / the chat explanation
for how to wire this in).
"""
import json
import re
import subprocess

# Resolve these with `which i3status` / `which jay` in your shell and
# hardcode the result — Jay's exec environment doesn't necessarily
# inherit your interactive shell's PATH, so a bare "i3status" / "jay"
# can silently fail to resolve even though it works fine at a prompt.
I3STATUS_CMD = ["i3status"]        # e.g. ["/run/current-system/sw/bin/i3status"]
JAY_CMD = "jay"                    # e.g. "/run/current-system/sw/bin/jay"

APP_ID_RE = re.compile(r"^\s*app-id:\s*(.+)$", re.MULTILINE)


def focused_app() -> str:
    """Return the app-id of the currently focused window, or "" if none."""
    try:
        result = subprocess.run(
            [
                JAY_CMD, "tree", "query", "match-windows",
                "-e", 'types = "client-window" focused = true',
            ],
            capture_output=True, text=True, timeout=1,
        )
    except Exception:
        return ""

    match = APP_ID_RE.search(result.stdout)
    if match:
        return match.group(1).strip()

    # TODO: X11 apps via Xwayland may not report an app-id — fall back
    # to parsing "x-class:" here if you want those covered too.
    return ""


def main() -> None:
    print('{"version":1}', flush=True)
    print("[", flush=True)

    proc = subprocess.Popen(I3STATUS_CMD, stdout=subprocess.PIPE, text=True)
    first = True

    for raw_line in proc.stdout:
        line = raw_line.strip()
        if not line or line.startswith('{"version"') or line == "[":
            continue  # swallow i3status's own header + opening bracket

        if line.startswith(","):
            line = line[1:]

        try:
            blocks = json.loads(line)
        except json.JSONDecodeError:
            continue

        blocks.insert(0, {
            "name": "focused_app",
            "full_text": f" {focused_app()} ",
        })

        out_line = json.dumps(blocks)
        print(out_line if first else "," + out_line, flush=True)
        first = False


if __name__ == "__main__":
    main()
