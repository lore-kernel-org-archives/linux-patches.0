Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30C294FC8CF;
	Mon, 31 Aug 2026 13:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183693; cv=none; b=JdikJzWmwzFqbUGR5IYH8VuPiQScPHXADbSY4D4CE6ZS70tVdUDNctjZHY7GnaRxmD9kXVnZYrHg7sIaz+WACNJoZw6WPP8vg91mlcB8q52uknD2j9MlIPy4pyhJ7ijJ9b8WjOGP62oVppiOYZYUtwGsNeeoj+vTThjKa7rzWRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183693; c=relaxed/simple;
	bh=PwVfhAOEpAmaDDpoTnMUb/MiiDIf6yBZ5fWx5vd4pzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SBuKHKF5C5Jm5g9m6PnAaafYFjP14uwE1GF+a3nuvbK9xZre/eTUqojZuilqKkF5l65cKq5t7Hmr6BBZtyz1L/7Xz2YAOoMpFV7vGUTfkfii3+dW4i4l+DEVVSofKUdglcF+N1ZtNbASIEP/7nPsb8tgZBWfujPQ+SUQzDuhw7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEIYeETe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEIYeETe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E187B1F00ADE;
	Mon, 31 Aug 2026 13:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183691;
	bh=lWD9cnuLWkuP+cU5btROzGO7xunztgw6qOPQuNCtHMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEIYeETejoZ80bk5AXUxq4TzG6U1tpC8+TP7o4lPXe2CA8YqlsaWmQuVrLyWt+qUa
	 dCjf+JtGv8pxA6jHxiS0SiGdOSAZN4+khO9dbM0lmnqP8xQCySeSYSgso2LBqk3+sn
	 NpfBKst1xusFGoeKUXEg0rM661NIsNsijIetEQ1mJn83MP5truRhr18pVdUjoWKYcs
	 zTRjp4L2Tlj/9Nk3t5ZdAYdFZ+alqjYwhe56Qbcx8uLEv3kLyXb0msQd/EgoEjzWpN
	 COoENzo39CUzgtZDh/nc1Ilh/zr3hBc61DV1CNhbUiJoMa0cSiE9Igme0DcmIdOI2c
	 Kyp8ReFmvGtNw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robert Abrahamse <denobyte2@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usb-audio: Add quirk for Corsair Virtuoso (later revision)
Date: Mon, 31 Aug 2026 09:24:35 -0400
Message-ID: <20260831133314.4125787-247-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robert Abrahamse <denobyte2@gmail.com>

[ Upstream commit cee046679655b4822f76efc9658f19efee9ac979 ]

Add USB mixer mapping quirk for later revisions of the Corsair Virtuoso
headset with USB IDs 0x1b1c:0x0a43 (wired) and 0x1b1c:0x0a44
(wireless). These devices exhibit the same mixer label collision as
earlier Virtuoso variants: all controls are labelled "Headset", causing
applications like PulseAudio to move the sidetone control instead of
the main playback volume.

Signed-off-by: Robert Abrahamse <denobyte2@gmail.com>
Link: https://patch.msgid.link/20260728140314.11601-1-denobyte2@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA usb-audio Corsair Virtuoso (later
revision) quirk

**Local tree:** `v6.18.44` (6.18.y stable, `git describe HEAD` →
`v6.18.44-2-g1b9e1abadee04`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[ALSA: usb-audio] [add] [quirk for Corsair Virtuoso later-
revision USB IDs 0x1b1c:0x0a43 and 0x1b1c:0x0a44]`

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none (maintainer applied directly)
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260728140314.11601-1-denobyte2@gmail.com`
- **Cc: stable:** none (expected for manual review)
- **Signed-off-by:** Robert Abrahamse `<denobyte2@gmail.com>` (author)
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer)
- **Notable:** Maintainer acceptance ("Applied now. Thanks." in lore
  thread). No syzbot, no NAKs.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Later-revision Corsair Virtuoso headsets (USB IDs
  `0x1b1c:0x0a43` wired, `0x1b1c:0x0a44` wireless) expose all mixer
  controls with the label "Headset".
- **Symptom:** Desktop audio stacks (e.g. PulseAudio/PipeWire) cannot
  distinguish main playback volume from sidetone; adjusting system
  volume changes sidetone instead of main output.
- **Root cause:** USB mixer topology label collision — same issue
  already fixed for earlier Virtuoso variants via
  `corsair_virtuoso_map`.
- **Version info:** None stated; fix extends existing quirk table to new
  hardware revisions.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised as cleanup. This is an explicit hardware quirk
for broken/mislabeled USB mixer descriptors. Functionally a correctness
fix for volume control on real hardware.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `sound/usb/mixer_maps.c` only (+10 lines, 0 removed)
- **Functions modified:** none directly; extends static
  `usbmix_ctl_maps[]` table
- **Scope:** Single-file, surgical hardware-quirk addition

### Step 2.2: Code flow change
**Record:**
- **Hunk (after 0x0a42 entries):** Before → no mapping for
  `0x1b1c:0x0a43`/`0x0a44`, so `state.map` stays NULL during mixer
  parse. After → these IDs match `corsair_virtuoso_map`, giving controls
  distinct names ("Mic Capture", "Sidetone Playback") instead of generic
  "Headset".
- **Path affected:** USB audio device probe/enumeration for these
  specific Corsair headsets.

### Step 2.3: Identify bug mechanism
**Record:**
- **Category:** Hardware workaround / mixer label collision
- **Mechanism:** Without the name map, `check_mapped_name()` in
  `mixer.c` cannot rename ambiguous controls. Applications pick the
  wrong control when all are named "Headset". The fix reuses the proven
  `corsair_virtuoso_map` for the new device IDs.

### Step 2.4: Assess fix quality
**Record:**
- **Quality:** Obviously correct — identical pattern to six existing
  Corsair Virtuoso/HS80 entries already in the tree.
- **Regression risk:** Very low. Only affects two new USB IDs; no logic
  changes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `corsair_virtuoso_map` and existing Virtuoso entries
(`0x0a41`, `0x0a42`, etc.) are present in current HEAD (blamed to
`5d324e5159d9e`, 2025-11-28 merge). The prerequisite map and table
structure have been in this 6.18.y tree since initial release.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug is inherent to Corsair firmware
reporting duplicate control names; earlier Virtuoso IDs were fixed
separately in the same file.

### Step 3.3: Related file history
**Record:** `git log --oneline -20 -- sound/usb/mixer_maps.c` shows only
the 6.18 merge in this checkout's history. The `corsair_virtuoso_map`
infrastructure is fully present. Standalone patch — not part of a series
(b4 dig shows only v1).

### Step 3.4: Author's other commits
**Record:** No other commits by Robert Abrahamse found in this tree's
reachable history. Author appears to be a hardware user/contributor
reporting a device-specific issue.

### Step 3.5: Prerequisites
**Record:** Requires `corsair_virtuoso_map` and `usbmix_ctl_maps[]` —
both exist in this 6.18.44 tree. No other commits needed. Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260728140314.11601-1-denobyte2@gmail.com
- **Revisions:** v1 only (no v2/v3)
- **Reviewer feedback:** Takashi Iwai (ALSA maintainer): "Applied now.
  Thanks."
- **Stable nominations:** None in thread
- **NAKs/concerns:** None

### Step 4.2: Reviewers from b4 dig -w
**Record:** CC'd: `linux-sound@vger.kernel.org`, `perex@perex.cz`,
`tiwai@suse.com`, `linux-kernel@vger.kernel.org`. Appropriate subsystem
lists and maintainer included.

### Step 4.3: Bug report
**Record:** No external bug tracker or syzbot link. Bug described by
hardware owner in patch submission. Severity from user perspective:
broken volume control on a popular gaming headset.

### Step 4.4: Related patches/series
**Record:** Standalone single-patch submission. Same pattern as prior
Corsair Virtuoso quirk commits in `mixer_maps.c`.

### Step 4.5: Stable mailing list
**Record:** Not searched separately; no stable discussion found in the
patch thread itself.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions/structures
**Record:** Modifies `usbmix_ctl_maps[]` static table; references
existing `corsair_virtuoso_map[]`.

### Step 5.2: Trace callers
**Record:** `usbmix_ctl_maps` is iterated in `sound/usb/mixer.c` during
mixer parsing (~line 3270):

```3270:3277:sound/usb/mixer.c
        for (map = usbmix_ctl_maps; map->id; map++) {
                if (map->id == state.chip->usb_id) {
                        state.map = map->map;
                        state.selector_map = map->selector_map;
                        mixer->connector_map = map->connector_map;
                        break;
                }
        }
```

Called during USB audio device probe — standard hotplug path when a
Corsair Virtuoso is connected.

### Step 5.3: Trace callees
**Record:** `state.map` is passed to `build_connector_control()` and
used by `find_map()` / `check_mapped_name()` to rename mixer controls
during enumeration.

### Step 5.4: Call chain / reachability
**Record:** USB headset plug-in → `snd_usb_create_mixer()` → table
lookup by `usb_id` → control naming. Triggered by any user plugging in
the device. No special privileges needed.

### Step 5.5: Similar patterns
**Record:** Six existing Corsair entries in the same table
(`0x0a3d`–`0x0a42`, `0x0a3f`–`0x0a40`, `0x0a6a`–`0x0a6b`) all use
`corsair_virtuoso_map`. This commit extends the same pattern to
`0x0a43`/`0x0a44`.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the buggy code exist?
**Record:** **YES.** `corsair_virtuoso_map` and entries for
`0x0a41`/`0x0a42` exist, but `0x0a43`/`0x0a44` are **missing** from
HEAD. `git merge-base --is-ancestor bf2991ffee460 HEAD` → **NOT IN
HEAD**. Users with later-revision hardware hit the bug in this tree
today.

### Step 6.2: Backport complications
**Record:** `git show bf2991ffee460 -- sound/usb/mixer_maps.c | git
apply --check` → **passes cleanly** on current HEAD. Expected: clean
apply, no rework.

### Step 6.3: Related fixes already present?
**Record:** No duplicate fix for `0x0a43`/`0x0a44`. The infrastructure
fix (map definition + earlier Virtuoso IDs) is already in tree; only the
new IDs are missing.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `sound/usb` (ALSA USB audio driver). **IMPORTANT** — affects
desktop/laptop users with USB headsets; not core kernel but widely used.

### Step 7.2: Subsystem activity
**Record:** USB audio mixer quirk table is actively maintained; Corsair
Virtuoso family has multiple prior quirk entries in this tree,
indicating ongoing hardware support pattern.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of later-revision Corsair Virtuoso headsets
(`0x1b1c:0x0a43`, `0x1b1c:0x0a44`) on systems running
`CONFIG_SND_USB_AUDIO`. Driver-specific, but Corsair Virtuoso is a
popular device.

### Step 8.2: Trigger conditions
**Record:** Plug in headset → ALSA enumerates mixer → all controls named
"Headset" → desktop environment adjusts wrong control. **Common/likely**
for affected hardware owners. Unprivileged user can trigger (device
hotplug).

### Step 8.3: Failure mode severity
**Record:** Incorrect volume/sidetone control behavior. **Severity:
MEDIUM** — not a crash, oops, or data corruption, but a significant
usability defect making system volume control unreliable. Falls under
the stable exception for hardware quirks.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** HIGH for affected hardware owners (restores correct
  volume control)
- **Risk:** VERY LOW (10 lines, two table entries, reuses existing map,
  no logic change)
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backporting:**
- Real hardware bug with clear user-visible symptom (wrong volume
  control)
- Classic hardware quirk — explicitly allowed stable exception category
- Tiny, surgical, obviously correct (copy of six existing entries)
- ALSA maintainer (Takashi Iwai) reviewed and applied upstream
- Prerequisites (`corsair_virtuoso_map`) present in 6.18.44
- Applies cleanly to current HEAD
- Commit not yet in this tree — backport fills a real gap

**AGAINST backporting:**
- Not a crash/security/data-corruption issue (severity is usability, not
  critical)
- No explicit stable nomination in mailing list
- No syzbot or multi-reporter evidence

**Unresolved:** None that affect the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — identical to existing
   entries; maintainer applied
2. Fixes a real bug affecting users? **PASS** — broken volume control on
   real hardware
3. Important issue? **PASS** — hardware usability defect (quirk
   exception applies)
4. Small and contained? **PASS** — 10 lines, one file
5. No new features or APIs? **PASS** — device ID additions to existing
   quirk table (allowed exception)
6. Can apply to local tree? **PASS** — clean apply verified;
   prerequisites present

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — adding USB device IDs to
existing `corsair_virtuoso_map` in `usbmix_ctl_maps[]`. This is one of
the most common and safest stable backport categories.

### Step 9.4: Decision rationale

For the **6.18.y tree checked out locally**, this commit should be
backported. The `corsair_virtuoso_map` infrastructure and quirk pattern
are already present; only the two new device IDs for later hardware
revisions are missing. Without them, owners of those headsets get broken
volume control — the exact problem already fixed for earlier Virtuoso
variants. The change is minimal, maintainer-approved, applies cleanly,
and matches established stable policy for USB audio hardware quirks.

---

## Verification

- [Phase 1] Parsed subject, tags, body; found Link tag, Takashi Iwai
  SOB; no Fixes/Reported-by/syzbot
- [Phase 1] Mbox thread: maintainer "Applied now. Thanks." — no NAKs, no
  stable Cc
- [Phase 2] Diff: +10 lines in `sound/usb/mixer_maps.c`, two
  `usbmix_ctl_maps[]` entries
- [Phase 2] Read `corsair_virtuoso_map` at lines 367–375 and table at
  lines 621–640
- [Phase 3] `git blame`: `corsair_virtuoso_map` and `0x0a41`/`0x0a42`
  entries present since 6.18 merge
- [Phase 3] `git merge-base --is-ancestor bf2991ffee460 HEAD` → NOT IN
  HEAD
- [Phase 3] `git show bf2991ffee460` and upstream `cee046679655`
  confirmed identical content
- [Phase 4] `b4 dig -c bf2991ffee460` → lore URL found
- [Phase 4] `b4 dig -w` → linux-sound, perex, tiwai CC'd
- [Phase 4] `b4 dig -a` → v1 only, no series dependencies
- [Phase 4] `b4 dig -m /tmp/virtuoso.mbx` → maintainer acceptance
  confirmed
- [Phase 5] `grep usbmix_ctl_maps` → used in `mixer.c:3270` during probe
- [Phase 5] Read `find_map()` / `check_mapped_name()` in `mixer.c`
- [Phase 6] `git describe HEAD` → v6.18.44; `grep 0x0a43/0x0a44` → not
  in HEAD
- [Phase 6] `git apply --check` on commit diff → applies cleanly
- [Phase 6] Verified `corsair_virtuoso_map` exists (prerequisite met)
- [Phase 8] Assessed severity: MEDIUM usability, not crash — quirk
  exception applies

**YES**The analysis is complete for **ALSA: usb-audio: Add quirk for
Corsair Virtuoso (later revision)** on the local **6.18.44** tree.

**Verdict: YES** — backport it.

This is a small hardware quirk (adds USB IDs `0x1b1c:0x0a43` and
`0x0a44` to the existing `corsair_virtuoso_map` table) that fixes broken
volume control on later Virtuoso headsets. The map and earlier Virtuoso
entries are already in this tree; only these two IDs are missing. The
patch applies cleanly, and Takashi Iwai accepted it upstream.

 sound/usb/mixer_maps.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index 4d8dca04f87d0..ce27fc871f513 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -638,6 +638,16 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x1b1c, 0x0a42),
 		.map = corsair_virtuoso_map,
 	},
+	{
+		/* Corsair Virtuoso (wired mode, later revision) */
+		.id = USB_ID(0x1b1c, 0x0a43),
+		.map = corsair_virtuoso_map,
+	},
+	{
+		/* Corsair Virtuoso (wireless mode, later revision) */
+		.id = USB_ID(0x1b1c, 0x0a44),
+		.map = corsair_virtuoso_map,
+	},
 	{
 		/* Corsair HS80 RGB Wireless (wired mode) */
 		.id = USB_ID(0x1b1c, 0x0a6a),
-- 
2.53.0

