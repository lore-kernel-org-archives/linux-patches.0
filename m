Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF6951A156;
	Mon, 19 Oct 2026 13:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418110; cv=none; b=jowmghB7tI32+jTGnWD+JoRXpnJD0qt17c7WLrESQ4QfqTaxpD5XjiK0/s/QLZ2rU4kRQPwzohLnOOjSbG1WdRPOeNyEluJgsVvaRFcAAju0z7Ldrr7nPJ0gdxtX6j/8LsAz1nkg8n53h/dcQ2gVacFZDIycRYZ8C4S5HHlg+gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418110; c=relaxed/simple;
	bh=lZ/xr+KvCONhgQNAJwYVyRysQZbRmWPUIntCI8rlXoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AhJ8QNVnTndEl6Oe5L5V7ZEGLNl/W1+fa8eA/mHf8qkZhtr7y8vZ6V7oKINbg2RJXcqgs0EXGg/x/O1uVhBdhrICs/KPPeGyIN6fOCTOUuiMIgvTTljJpJ5/dQ4I3LCHfPbmatf74HAHo4lPaUQV3ATxL80YTXXL+kFeXc31s3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zngt5FPq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zngt5FPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B55E1F000C6;
	Mon, 19 Oct 2026 13:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418107;
	bh=E3uHqtJGn3K0/BPaGidR4/EjNYDS0MywQbMZ4OjHCCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zngt5FPqyVyBs4tfII0JpPY/eiWf+bNzm/P6L/0hSEc+SdTWfm5qKoLjFyESO5IZ5
	 zqkQLB3ESfEFmCJ5uJOWIKvWjMzh3xchRPy2SotzYO7O7OViNal+brWZYPyn7WDhSy
	 Es3YFN5VD8+WbMiN+MP5v4eSlT7X9W770BQSMqIB1coTNgomr57LvTt3nwoDtTt/fq
	 5v3CXLzTxOCg/ynfEbtYGFY6Xt9+6qBArS5V0QZjh409Nd1Phb07E8KDX6q3r7eIjZ
	 2H1VaqirgB9BhMV2qJiU0Zcekzyg+CeuF40MQx/ok7jECXhjWPclVUrLW8MlqhyPu4
	 Q4ci7g8xPsqqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chad Talbott <chad.talbott@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: usb-audio: Add MIN_MUTE quirk for Creative Sound Blaster Play! 3
Date: Mon, 19 Oct 2026 09:45:08 -0400
Message-ID: <20261019135441.1420968-17-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chad Talbott <chad.talbott@gmail.com>

[ Upstream commit 352cef030f9036a658e6eb03d6bb85fa19c7c103 ]

The Creative Sound Blaster Play! 3 (041e:324d) exposes a Feature Unit
volume control with a range of -44.00 dB .. 0.00 dB over raw values
0..88, but raw value 0 is in fact a hard mute rather than -44.00 dB.

Tested on hardware.

Signed-off-by: Chad Talbott <chad.talbott@gmail.com>
Link: https://patch.msgid.link/20260819003237.452807-1-chad.talbott@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a hardware quirk for an existing USB-audio device. The local
tree is **6.12.111** (`p-6.12-3-gc504cf0baa3d8`). The MIN_MUTE machinery
is already here; only the device ID is missing.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA: usb-audio:] [Add] [MIN_MUTE quirk for Creative Sound
Blaster Play! 3 (041e:324d)]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Chad Talbott <chad.talbott@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260819003237.452807-1-
  chad.talbott@gmail.com`
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer applied
  it)
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (absence is expected)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: Play! 3 reports Feature Unit volume as -44.00 dB .. 0.00 dB over
  raw 0..88, but raw 0 is a **hard mute**, not -44 dB.
- Symptom: userspace (PulseAudio/PipeWire) treats the bottom of the
  slider as a quiet but audible level. Volume mapping is wrong; audio
  stays silent until the slider is raised well above 0.
- Version info: none in the message. The device is existing USB audio
  hardware, not a new kernel-era device.
- Root cause: device firmware lies about the meaning of the minimum
  volume value. The kernel must advertise `DB_MINMAX_MUTE` via TLV.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit hardware quirk. Same class as
the C-Media min-mute fix (`0f174b3525a43`, 2017, originally `Cc:
stable`) and later MIN_MUTE device-ID additions already in this tree.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `sound/usb/quirks.c` only (`+2` lines)
- Function/table: `quirk_flags_table[]`
- Scope: single-file, two-line table entry

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `041e:324d` has no quirk-flag match. Probe still binds the
  generic USB-audio driver.
- After: `snd_usb_init_quirk_flags()` sets
  `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE` (mainline name) /
  `QUIRK_FLAG_MIXER_MIN_MUTE` (this tree).
- Path: mixer Feature Unit setup, playback volume TLV. Not an error
  path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: **hardware workaround** (quirk table entry)
- Mechanism: `snd_usb_mixer_fu_apply_quirk()` sees the flag and, for
  controls whose name contains `"Playback"`, sets `cval->min_mute = 1`.
  `snd_usb_mixer_vol_tlv()` then reports `SNDRV_CTL_TLVT_DB_MINMAX_MUTE`
  instead of a plain dB min/max.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: one VID:PID added next to other Creative `0x041e`
  entries, using an existing flag.
- Minimal: no API, no data-structure, no locking changes.
- Regression risk: very low; the flag is scoped to this ID and only
  changes TLV metadata for playback volume. Other devices are untouched.
- Backport note: this tree uses `QUIRK_FLAG_MIXER_MIN_MUTE`, not
  `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`. Same effect: the local handler
  already limits the flag to Playback controls.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Insertion is between existing Creative entries:
- `DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */)` —
  `3c69dc9134130d` (Takashi Iwai, 2021)
- `DEVICE_FLG(0x041e, 0x4080, /* Creative Live Cam VF0610 */)` —
  `4d4dee0aefec36` (Takashi Iwai, 2021)
The table and adjacent IDs have been stable for years. The Play! 3 ID is
simply missing.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The “bug” is device firmware
behavior, not a kernel regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related commits already in this tree:
- `c2564438d30a8` — “move mixer_quirks' min_mute into common quirk”
  (upstream `2c3ca8cc55a3`)
- `2368ce440dfbc` — “Add mute TLV for playback volumes on more devices”
  (same pattern: extra `QUIRK_FLAG_MIXER_MIN_MUTE` IDs)
- `0f174b3525a43` — original C-Media min-mute (2017, `Cc: stable`)
Standalone device-ID addition, not part of a series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: No other `Chad Talbott` / `chad.talbott` commits under
`sound/usb/` in this tree. One-off hardware report, applied by the ALSA
maintainer.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Prerequisite is the MIN_MUTE flag. Confirmed present: `git
merge-base --is-ancestor c2564438d30a8 HEAD` succeeds.
`QUIRK_FLAG_MIXER_MIN_MUTE` is defined in `sound/usb/usbaudio.h` as `(1U
<< 24)`. Can apply standalone after renaming the flag.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 mbox` on msgid `20260819003237.452807-1-chad.talbott@gmail.com`
  saved `/tmp/sbplay3` (2 messages).
- Original submission: 18 Aug 2026, To: Takashi Iwai, Jaroslav Kysela;
  Cc: linux-sound, linux-kernel. Single patch, not a series.
- Reply from Takashi Iwai (`87cxvenu39.wl-tiwai@suse.de`, 19 Aug 2026):
  **“Applied now. Thanks.”** No NAK, no requested revisions, no stable
  discussion.
- `b4 dig -c` was not usable: the commit is not in this checkout.
- Direct lore WebFetch returned HTTP 403; the mbox from `b4` is the
  source of truth.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients were the ALSA maintainers and linux-sound. Maintainer
applied v1 as-is.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. Evidence is the author’s “Tested on
hardware” and the concrete VID:PID plus measured dB range.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone `[PATCH]`, not `X/Y`. Thread has only the patch and
the apply ack.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch returned 403. No stable-list
discussion found via `git log --grep` on `sound/usb/`. No evidence this
was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body changed. Data consumed by
`snd_usb_init_quirk_flags()` and `snd_usb_mixer_fu_apply_quirk()`.

**Step 5.2: TRACE CALLERS**
Record:
- `snd_usb_init_quirk_flags()` called from `sound/usb/card.c:666` during
  USB-audio probe.
- `snd_usb_mixer_fu_apply_quirk()` called from `sound/usb/mixer.c:1818`
  while building Feature Unit controls.
- `snd_usb_mixer_vol_tlv()` is the TLV callback userspace reads.

**Step 5.3: TRACE CALLEES**
Record: The new row only sets `chip->quirk_flags`. Later, `min_mute`
changes TLV type to `SNDRV_CTL_TLVT_DB_MINMAX_MUTE`
(`include/uapi/sound/tlv.h`).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Plug in Play! 3 → USB-audio probe → mixer create → userspace
reads volume TLV. Reachable from normal device use, not a rare config.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same `QUIRK_FLAG_MIXER_MIN_MUTE` already used for Conexant,
C-Media, Realtek, OnePlus, HECATE, HONOR, etc. in this tree’s
`quirk_flags_table`. This is another instance of a known, already-
backported pattern.

Semcode MCP tools: not available; used grep/read.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. USB-audio mixer + MIN_MUTE flag exist. `041e:324d` is
**not** in `sound/usb/quirks.c` (or elsewhere under `sound/usb/`). The
device will enumerate as generic USB audio with the wrong mute TLV. Bug
introduced by hardware, not by a post-6.12 kernel change.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Expected difficulty: **minor** (one-token rename).
- Insertion context `0x041e, 0x3000` then `0x041e, 0x4080` is present at
  `quirks.c:2154-2157`.
- `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE` is **not** defined here.
- Use `QUIRK_FLAG_MIXER_MIN_MUTE` instead; local
  `snd_usb_mixer_fu_apply_quirk()` already gates on `"Playback"`.
- Nearby mainline-only entries (`0x040b:0x0897`, `0x045e:0x070f`) are
  not required.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: MIN_MUTE infrastructure and other device IDs are here. No Play!
3 entry. No alternate fix for `041e:324d`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `sound/usb/` ALSA USB-audio. **IMPORTANT** for USB
DACs/headsets; not core mm/fs. Play! 3 is a real consumer USB DAC.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained; this 6.12 tree already carries later USB-
audio quirk backports (JBL FIXED_RATE, AB13X reset, DSD IDs, extra
MIN_MUTE IDs). Quirk-table additions are routine here.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: owners of Creative Sound Blaster Play! 3
(`041e:324d`). Zero effect on other hardware.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every time the device is used with a dB-aware mixer
(PulseAudio/PipeWire). Not a race. Unprivileged users hit it via the
volume slider. Very likely for this hardware.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Incorrect volume/mute mapping: silence at “low” volume, min
position not treated as mute. Not a panic or corruption. **MEDIUM**
functionally, but it is the standard USB-audio min-mute hardware bug.
Original 2017 fix was stable-bound; later MIN_MUTE ID lists are already
in 6.12.y.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for Play! 3 users (usable volume curve).
- Risk: very low (2 lines, ID-matched, TLV only).
- Ratio: strongly favors backport with the flag-name tweak.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Classic USB-audio hardware quirk (stable exception category).
- Real, tested-on-hardware volume/mute lie from the device.
- Two-line table add; no new APIs.
- MIN_MUTE flag and handler already in this 6.12.111 tree.
- Same pattern already backported (`c2564438d30a8`, `2368ce440dfbc`).
- ALSA maintainer applied v1 with no concerns.
- Insertion point exists next to other Creative IDs.

AGAINST:
- Original patch uses `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE` (needs rename
  to `QUIRK_FLAG_MIXER_MIN_MUTE`).
- Not a crash/UAF/security issue.
- Affects one consumer DAC.

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403). No indication of a
  prior reject.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — hardware-tested; maintainer
   applied.
2. Fixes a real bug that affects users? **PASS** — wrong mute/volume
   mapping on a real DAC.
3. Important issue? **PASS** under the hardware-quirk exception (not a
   crash).
4. Small and contained? **PASS** — +2 lines, one file.
5. No new features or APIs? **PASS** — existing quirk flag, new device
   ID only.
6. Can apply to the local tree? **PASS** with trivial backport
   (`MIXER_PLAYBACK_MIN_MUTE` → `MIXER_MIN_MUTE`).

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** (USB-audio mixer min-mute),
equivalent in spirit to USB/PCI quirk table additions.

**Step 9.4: MAKE YOUR DECISION**
Backport. The local tree already has the quirk flag; this only adds the
Play! 3 ID. Rename the flag during apply.

------------------------------------------------
What problem it solves, and why it matters here
------------------------------------------------
Play! 3 reports -44 dB at raw 0, but raw 0 is mute. Without the TLV mute
bit, PulseAudio/PipeWire keep the device “silent until ~30% volume.”
That is the same class of bug already documented in this tree’s MIN_MUTE
commit (PipeWire MR / Arch wiki). 6.12 users with this DAC still hit it.

Risk vs benefit: two-line, ID-scoped TLV change vs broken volume on a
supported USB-audio device. Benefit wins.

Concerns: mechanical apply of the mainline diff will not compile until
the flag is renamed. That is a one-token stable backport, not a missing-
prerequisite situation.

Verification:
- [Phase 1] Parsed tags: author SOB, Link msgid, Takashi Iwai SOB; no
  Fixes/Reported-by/Cc:stable
- [Phase 1] Body: 041e:324d, -44 dB vs hard mute at raw 0, tested on
  hardware
- [Phase 2] Diff: +2 lines in `sound/usb/quirks.c` `quirk_flags_table[]`
- [Phase 2] Handler in this tree: `mixer_quirks.c:4504-4506` sets
  `cval->min_mute` for Playback when `QUIRK_FLAG_MIXER_MIN_MUTE` is set
- [Phase 2] TLV: `mixer.c:555-556` uses `SNDRV_CTL_TLVT_DB_MINMAX_MUTE`
- [Phase 3] Blame: Creative neighbors from 2021 (`3c69dc9134130d`,
  `4d4dee0aefec36`)
- [Phase 3] `git merge-base --is-ancestor c2564438d30a8 HEAD`: MIN_MUTE
  infra **is** in this tree
- [Phase 3] `2368ce440dfbc` already added more MIN_MUTE IDs to this tree
- [Phase 3] No `Fixes:` tag (N/A)
- [Phase 3] `git log --author='Chad Talbott' -- sound/usb/`: no other
  commits
- [Phase 4] `b4 mbox` msgid
  `20260819003237.452807-1-chad.talbott@gmail.com`: 2-message thread;
  Iwai “Applied now”
- [Phase 4] lore WebFetch 403; stable-list search 403
- [Phase 5] Callers: `snd_usb_init_quirk_flags` from `card.c:666`;
  `snd_usb_mixer_fu_apply_quirk` from `mixer.c:1818`
- [Phase 5] semcode unavailable
- [Phase 6] `git describe HEAD` → `p-6.12-3-gc504cf0baa3d8`; `make
  kernelversion` → 6.12.111
- [Phase 6] `0x324d` absent; `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`
  absent; `QUIRK_FLAG_MIXER_MIN_MUTE` present; sandwich context present
- [Phase 8] Failure mode: wrong volume/mute TLV on one USB DAC; not a
  kernel oops
- UNVERIFIED: full lore.kernel.org HTML thread (403); whether a later
  mainline commit renamed MIN_MUTE → PLAYBACK_MIN_MUTE (flag absent
  here; local Playback filter makes the names equivalent)

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b08e07324f830..8dcba375bd4a3 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2152,6 +2152,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x041e, 0x324d, /* Creative Sound Blaster Play! 3 */
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x041e, 0x4080, /* Creative Live Cam VF0610 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x045e, 0x083c, /* MS USB Link headset */
-- 
2.53.0

