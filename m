Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED5C57D22B;
	Mon, 31 Aug 2026 13:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184176; cv=none; b=CCTetbhBnJIUanuigm0q337GoQBUIypiwgbRgM8MUSuSa0WguBTGey0fFBFPnOuluCt7n8AcTLPLdrwHXzsP2kaXphAUBvwOjB0fg5VGtnQLl80pWfeqg9X8stdaF6Vhr1OC+OrYKk6w839yWuGeGs+611FU/2H/8zau1XXTS9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184176; c=relaxed/simple;
	bh=7c27kdyBpwJ56t5jmsbrYobdCNqvCB8PMpDOKl6AHas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=htnbNx7D1ICbI2HdWB3orX8xMimIjm0GNnAM4s0vWUtCo1m3AspKyMOD5U8oyGoMu4Ouo8NZ3ZnJqOGtsvQ4e5aA+9VL3h5O17rcnkDRg9qQU++eqgIxb8ly2ewVpCqB2hT1VqZuBF2vfPvz8WaiIr7YQUXZJLdc2eKWLP8hJeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mm9r+PQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mm9r+PQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD331F00A3F;
	Mon, 31 Aug 2026 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184174;
	bh=E1fWNAQyhyduiZ4Ur1uA7C3ygVCcscds3kBe7eZBXA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mm9r+PQX9ZAZDbYqkU3MeGmSo3Jw1Qh8j5TV3VGGwQOYFsCiXYE7T7s45KfGzu1DS
	 TTP/QgIjr+8pm0lyEWYxEFHUwDjVenkNeUSQ1gCTsO/voc+EuUvFVzdvPccskXKDDr
	 QvsCt0aeCGW0G64znHTrtgHbPxNzuOl81va7xMpWXW/Jhq+DNJ891c3bJSfNO/MCbs
	 te2AzLjDLikIPx7S2G61xta+PXIsEHbMeU2K/CcosWD4/YguaFfkJY/RTNLpyA2AvT
	 /CJ1KYdgthbmGI9mcRbDU4GnqCQYqqxFC/S9f8qMiw19nCaerPwlbS7GVuTd0cGjtY
	 glkoGjEGQ+5ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20K=C3=BCchler?= <uwe@kuechler.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: usb-audio: Add quirk for Novation Mininova
Date: Mon, 31 Aug 2026 09:29:23 -0400
Message-ID: <20260831133314.4125787-535-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Uwe Küchler <uwe@kuechler.org>

[ Upstream commit b2e9d2cbbb71b00faf3e27fb741a27b9ad455edd ]

Add a device-specific quirk for the Novation Mininova synthesizer
(USB ID 1235:001e) to enable proper recognition and functionality
as a MIDI device.

Signed-off-by: Uwe Küchler <uwe@kuechler.org>
Link: https://patch.msgid.link/20260526162033.7513-1-uwe@kuechler.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA: usb-audio: Add quirk for Novation
Mininova

**Local tree:** `v6.18.44` (Linux 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
**Record:** `[ALSA: usb-audio] [add] [quirk for Novation Mininova
synthesizer USB ID 1235:001e]`

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Signed-off-by:** Uwe Küchler `<uwe@kuechler.org>` (author)
- **Link:**
  `https://patch.msgid.link/20260526162033.7513-1-uwe@kuechler.org`
- **Signed-off-by:** Takashi Iwai `<tiwai@suse.de>` (ALSA maintainer,
  applied the patch)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer SOB indicates the patch was accepted and applied

### Step 1.3: Analyze the Commit Body Text
**Record:**
- **Bug description:** The Novation Mininova (USB 1235:001e) is not
  properly recognized or functional as a MIDI device without a device-
  specific quirk.
- **Symptom/failure mode:** MIDI functionality does not work when the
  device is plugged in; the generic USB audio driver path cannot handle
  this device's non-standard interface correctly.
- **Version information:** None stated.
- **Root cause (author):** Device needs `QUIRK_MIDI_RAW_BYTES` handling
  on interface 0, same family as other Novation devices (Nocturn,
  Launchpad).

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not a hidden bug fix disguised as cleanup. This is an
explicit hardware quirk / device-enablement entry. It fixes a real
functional defect (MIDI non-operation) for a specific USB device,
falling under the hardware-quirk exception category for stable.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
**Record:**
- **Files changed:** `sound/usb/quirks-table.h` (+8 lines)
- **Functions modified:** None (data table entry only)
- **Scope classification:** Single-file, surgical quirk table addition

### Step 2.2: Understand the Code Flow Change
**Record:**
- **Hunk (before):** After the Novation Twitch (0x1235:0x0018) entry,
  the table jumps directly to ReMOTE25 (0x1235:0x4661). Mininova
  (0x1235:0x001e) has no entry.
- **Hunk (after):** New entry inserted:
  ```c
  {
  USB_DEVICE(0x1235, 0x001e),
  QUIRK_DRIVER_INFO {
  QUIRK_DATA_RAW_BYTES(0)
  }
  },
  ```
- **Execution path affected:** USB device probe → `usb_audio_ids[]`
  match → `usb_audio_probe()` → `snd_usb_create_quirk()` →
  `create_any_midi_quirk()` → `snd_usb_midi_v2_create()` with
  `QUIRK_MIDI_RAW_BYTES` ops on interface 0.
- **Path type:** Device initialization / probe path (plug-in time).

### Step 2.3: Identify the Bug Mechanism
**Record:**
- **Bug category:** Hardware workaround / device-specific quirk
- **Mechanism:** Without the quirk entry, the Mininova either fails to
  match the quirks table with the correct MIDI handler, or falls through
  to generic audio-class parsing that cannot handle its raw-bytes MIDI
  interface. `QUIRK_DATA_RAW_BYTES(0)` expands to `.ifnum = 0, .type =
  QUIRK_MIDI_RAW_BYTES`, which selects `snd_usbmidi_raw_ops` and
  `snd_usbmidi_detect_per_port_endpoints()` — the same pattern used for
  Novation Nocturn (0x000a) and Launchpad (0x000e).

### Step 2.4: Assess the Fix Quality
**Record:**
- **Fix quality:** Obviously correct; follows the exact established
  pattern of sibling Novation entries in the same file region.
- **Minimal/surgical:** Yes, 8 lines, one table entry.
- **Regression risk:** Very low — adds a new device ID match only; does
  not alter existing entries or code paths.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
**Record:** Insertion point is between Twitch (line 2133) and ReMOTE25
(line 2135) in `quirks-table.h`. Adjacent Novation Nocturn/Launchpad
`QUIRK_DATA_RAW_BYTES(0)` entries have been present in this tree's
quirks table. The Mininova device ID is absent — the "bug" is simply the
missing quirk entry for hardware that has existed since ~2012.

### Step 3.2: Follow the Fixes: Tag
**Record:** No Fixes: tag present. N/A.

### Step 3.3: Check File History for Related Changes
**Record:** This stable tree has limited per-file history (squashed
import). The Novation quirk section with Nocturn (0x000a), Launchpad
(0x000e), and Twitch (0x0018) is present. The Mininova entry is missing.
Standalone patch — not part of a series (v1→v3 were revisions of the
same single patch per lore thread).

### Step 3.4: Check the Author's Other Commits
**Record:** No commits by Uwe Küchler found in this tree. Author appears
to be an end-user/contributor, not a subsystem maintainer. Patch was
reviewed and applied by Takashi Iwai (ALSA/usb-audio maintainer).

### Step 3.5: Check for Dependent/Prerequisite Commits
**Record:** No dependencies. `QUIRK_DATA_RAW_BYTES` macro (line 68–69),
`QUIRK_MIDI_RAW_BYTES` enum, `create_any_midi_quirk()`, and
`snd_usbmidi_raw_ops` all exist in this 6.18.44 tree. Applies
standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Find the Original Patch Discussion
**Record:**
- **Lore URL:** `https://lore.kernel.org/linux-
  sound/20260526162033.7513-1-uwe@kuechler.org`
- **Series revisions:** v1 (20260526133517), v2 (20260526155606),
  v3/final (20260526162033) — v3 incorporated maintainer feedback
- **Key reviewer feedback:** Takashi Iwai suggested using
  `QUIRK_DATA_RAW_BYTES(0)` instead of explicit fields, and omitting
  vendor/product names (author complied in final version)
- **Maintainer response:** "Applied to for-next branch now. Thanks."
- **Stable nominations:** None in thread
- **NAKs/concerns:** None

### Step 4.2: Check Who Reviewed the Patch
**Record:** CC'd: `perex@perex.cz` (Jaroslav Kysela, ALSA co-
maintainer), `tiwai@suse.com` (Takashi Iwai). Takashi Iwai reviewed and
applied. Appropriate maintainers involved.

### Step 4.3: Search for the Bug Report
**Record:** No external bug report, syzbot, or user crash report. Bug is
functional: device MIDI doesn't work without the quirk. Severity from
reporter's perspective: hardware unusable for MIDI on Linux.

### Step 4.4: Check for Related Patches and Series
**Record:** Standalone single-patch submission. No series dependencies.

### Step 4.5: Check Stable Mailing List History
**Record:** No prior stable-list discussion found for Novation Mininova.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Identify Key Functions in the Diff
**Record:** No functions modified. Affected infrastructure:
- `usb_audio_probe()` in `card.c`
- `snd_usb_create_quirk()` in `quirks.c`
- `create_any_midi_quirk()` → `snd_usb_midi_v2_create()`
- `QUIRK_MIDI_RAW_BYTES` case in `midi.c`

### Step 5.2: Trace Callers
**Record:**
- `usb_audio_probe()` — USB core hotplug probe path, called on device
  plug-in
- `snd_usb_create_quirk()` — called from `usb_audio_probe()` at line
  1023
- `create_any_midi_quirk()` — quirk dispatch table entry for
  `QUIRK_MIDI_RAW_BYTES`
- **Impact surface:** Any user plugging in a Novation Mininova; common
  desktop/music-production scenario

### Step 5.3: Trace Callees
**Record:** `create_any_midi_quirk()` → `snd_usb_midi_v2_create()` →
sets `snd_usbmidi_raw_ops`, detects per-port endpoints. No allocations
or locks beyond normal MIDI device setup.

### Step 5.4: Follow the Call Chain
**Record:** USB hotplug → `usb_audio_probe()` → quirk table match on
`USB_DEVICE(0x1235, 0x001e)` → MIDI quirk creation. Reachable by any
user plugging in the device (no special privileges needed for device
recognition).

### Step 5.5: Search for Similar Patterns
**Record:** Identical `QUIRK_DATA_RAW_BYTES(0)` pattern at lines
2026–2039 for Novation Nocturn (0x000a) and Launchpad (0x000e). Mininova
is the same vendor (0x1235), same quirk type, same interface number.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: Does the Buggy Code Exist in This Tree?
**Record:** **Yes.** The quirks table in 6.18.44 has the Novation
section with Nocturn, Launchpad, Twitch, and ReMOTE25, but **no entry
for 0x1235:0x001e (Mininova)**. All supporting quirk infrastructure is
present. The device has never been supported in this tree.

### Step 6.2: Check for Backport Complications
**Record:** **Clean apply expected.** Insertion point between Twitch
(0x0018) and ReMOTE25 (0x4661) matches the upstream diff context
exactly. No conflicting changes in this region.

### Step 6.3: Check if Related Fixes Are Already Here
**Record:** No existing Mininova quirk or alternate fix found (`grep`
for "Mininova", "0x001e", "mininova" returned no matches in
`sound/usb/`).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Identify the Subsystem and Criticality
**Record:** **Subsystem:** `sound/usb` (ALSA USB audio driver).
**Criticality:** IMPORTANT — widely used driver for USB audio/MIDI
devices, but fix affects only Novation Mininova owners.

### Step 7.2: Assess Subsystem Activity
**Record:** Actively maintained; quirks table is routinely updated with
new device entries. USB audio quirk additions are a well-established
stable backport pattern.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Determine Who Is Affected
**Record:** **Driver-specific** — users of the Novation Mininova USB
synthesizer. Requires `CONFIG_SND_USB_AUDIO` (common on desktop
distributions).

### Step 8.2: Determine the Trigger Conditions
**Record:** Plugging in a Novation Mininova (USB 1235:001e). Trigger is
deterministic on device connect. Any user with physical access to the
USB port can trigger it. Very common for musicians using this hardware.

### Step 8.3: Determine the Failure Mode Severity
**Record:**
- **Without fix:** Device not properly recognized/functional as MIDI —
  hardware feature broken, no MIDI I/O
- **Severity:** MEDIUM — functional hardware failure, not a kernel
  crash, data corruption, or security issue
- **With fix:** MIDI works via raw-bytes quirk handler

### Step 8.4: Calculate Risk-Benefit Ratio
**Record:**
- **Benefit:** Enables MIDI functionality for Novation Mininova users on
  stable kernels; follows established quirk pattern
- **Risk:** Very low — 8-line table entry, no code logic changes, no API
  changes, cannot affect other devices
- **Ratio:** Favorable — minimal risk, real user benefit for affected
  hardware

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Compile the Evidence

**FOR backporting:**
- Hardware quirk exception category (explicitly allowed for stable)
- Identical pattern to existing Novation Nocturn/Launchpad entries
  already in 6.18.44
- Fixes real user-facing defect (MIDI non-functionality)
- Small (8 lines), surgical, obviously correct
- Reviewed and applied by ALSA maintainer Takashi Iwai
- All prerequisite infrastructure exists in this tree
- Clean apply expected
- Zero regression risk to other devices

**AGAINST backporting:**
- Not a crash, security, corruption, or deadlock fix
- Severity is functional hardware enablement (MEDIUM), not CRITICAL
- No syzbot/fuzzer report or widespread user reports
- Device has never worked in this tree — this is enablement, not fixing
  a regression introduced in stable

**UNRESOLVED:**
- None that affect the decision

### Step 9.2: Apply the Stable Rules Checklist
1. Obviously correct and tested? **PASS** — matches existing sibling
   entries; maintainer reviewed and applied
2. Fixes a real bug affecting users? **PASS** — MIDI doesn't work
   without the quirk
3. Important issue? **PASS (borderline)** — functional hardware failure
   for affected device; quirk exception category applies
4. Small and contained? **PASS** — 8 lines, one file
5. No new features or APIs? **PASS** — table entry only, no new APIs
6. Can apply to local tree? **PASS** — all prerequisites present, clean
   apply

### Step 9.3: Check for Exception Categories
**Record:** **Hardware quirk/workaround** — adds a USB device quirk
entry to the existing `snd-usb-audio` driver, enabling MIDI on non-
standard-interface hardware. Same exception category as Nocturn and
Launchpad quirks already in the tree.

### Step 9.4: Decision Rationale

This commit adds a standard ALSA USB-audio quirk for the Novation
Mininova, using the same `QUIRK_DATA_RAW_BYTES(0)` pattern as other
Novation devices already supported in 6.18.44. While not a crash or
security fix, hardware quirks for USB audio/MIDI devices are a well-
established stable backport category with very low risk and clear user
benefit. The patch is maintainer-reviewed, self-contained, and applies
cleanly to this tree where the supporting infrastructure already exists
but the device entry is missing.

---

## Verification

- [Phase 1] Parsed subject, tags; found Link and maintainer SOB; no
  Fixes/Reported-by
- [Phase 1] Commit body describes MIDI recognition/functionality failure
  for USB 1235:001e
- [Phase 2] Diff: +8 lines in `sound/usb/quirks-table.h`, one quirk
  table entry
- [Phase 2] `QUIRK_DATA_RAW_BYTES(0)` expands to `.ifnum = 0, .type =
  QUIRK_MIDI_RAW_BYTES` (verified lines 68–69)
- [Phase 2] `QUIRK_MIDI_RAW_BYTES` handled in `quirks.c:528` and
  `midi.c:2565-2578`
- [Phase 3] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 3] `grep Mininova/0x001e` in `sound/usb/`: no matches — entry
  absent from tree
- [Phase 3] Adjacent Novation entries (Nocturn 0x000a, Launchpad 0x000e)
  present at lines 2026–2039
- [Phase 4] Lore thread fetched via curl from `lore.kernel.org/linux-
  sound/20260526162033.7513-1-uwe@kuechler.org/t.mbox.gz`
- [Phase 4] Takashi Iwai review feedback and "Applied to for-next branch
  now. Thanks." confirmed
- [Phase 4] Three patch revisions (v1/v2/v3); final version matches
  committed diff
- [Phase 4] No stable@ nomination in thread; no NAKs
- [Phase 5] `usb_audio_probe()` at `card.c:917`; quirk dispatch at
  `quirks.c:509-528`
- [Phase 5] `create_any_midi_quirk()` calls `snd_usb_midi_v2_create()`
  at `quirks.c:79-84`
- [Phase 6] Buggy state confirmed: Mininova ID missing from quirks table
  in 6.18.44
- [Phase 6] Insertion context matches upstream diff (between 0x0018 and
  0x4661 entries)
- [Phase 8] Failure mode: MIDI non-functional (MEDIUM severity); no
  crash/corruption

**YES**

 sound/usb/quirks-table.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index eafc0d73cca1f..cf6a2bb5264d4 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2131,6 +2131,14 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 		}
 	}
 },
+{
+	USB_DEVICE(0x1235, 0x001e),
+	QUIRK_DRIVER_INFO {
+		/* .vendor_name = "Novation", */
+		/* .product_name = "Mininova", */
+		QUIRK_DATA_RAW_BYTES(0)
+	}
+},
 {
 	USB_DEVICE_VENDOR_SPEC(0x1235, 0x4661),
 	QUIRK_DRIVER_INFO {
-- 
2.53.0

