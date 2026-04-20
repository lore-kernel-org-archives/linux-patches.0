Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836333D9DB5;
	Mon, 20 Apr 2026 13:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691438; cv=none; b=dezE1+DUFG52bs5oFsa8y948AFPmh9bVDytA7+Qkd1YIpumU3/E8xXBeIjthSWeOONav/6C2sIIuF4nK7YKtOOikzxhDYWC2fivXwyO3RxRlH+W4caoQOib+BN5OWmGTEp++IgN17lRQZpTL+SikoiAsRkzEKPz3a+m8fCZepUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691438; c=relaxed/simple;
	bh=k+qDVHRamoG2QcVX0PD+YqXjRA63+BQnKl2eDKgaWus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmqULjLRPLPQgrTcwcYnecoOVOGP9tEpfPuitCqkw07wxS68Y79f1kKkxB3gzGA24IyJb5t17zY8zgBDLoTR/UiNursSp1x/EbeYmjsccnMHvbfY/ag16ICuCLjt8jtBg+hUGHunxL3ZYlffiJS8cY/h9rk+zl8pjWhXlAHYBVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ApCRSG0c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ApCRSG0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED83C2BCB4;
	Mon, 20 Apr 2026 13:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691438;
	bh=k+qDVHRamoG2QcVX0PD+YqXjRA63+BQnKl2eDKgaWus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ApCRSG0c/gvXq463oaMfrwzPDjrW9LM2egBUYkdBatc9/2TdTmva/tp7TDikF4nKL
	 6mZhlG6jXBvHmQlsD4EFuzK9gDSmyhZXy8cN+nCIx0oLYIkdiykk5zikSQTYoZj7tg
	 +S9/WkWkrDyYZ/uN/QBFSBWdwSFUliP07l4tAo+UWvos94CSZAiLl7oKs6U834sz0E
	 ZoLhgdGCIbZdAoYUizYPhpruNSw00gJOV6CdNUcNEx4k4dJ53yx3k07r+ci3PV0Drz
	 TQfS8FYtK73G+q/C3V9WxXXTut8bkCxflRhvUcC2MmR+KYhQddTW2/3H2Q8q5ZqjBg
	 NIWuqhb2Pcl2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: usb-audio: Add iface reset and delay quirk for HUAWEI USB-C HEADSET
Date: Mon, 20 Apr 2026 09:17:01 -0400
Message-ID: <20260420132314.1023554-27-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit 9575766a682f50ec4bcb85ecd438685bdc09f9cc ]

Setting up the interface when suspended/resumeing fail on this card.
Adding a reset and delay quirk will eliminate this problem.

usb 1-1: new full-speed USB device number 2 using xhci-hcd
usb 1-1: New USB device found, idVendor=12d1, idProduct=3a07
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: HUAWEI USB-C HEADSET
usb 1-1: Manufacturer: bestechnic
usb 1-1: SerialNumber: 0296C100000000000000000000000

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Link: https://patch.msgid.link/TYUPR06MB62176A18EA7A9DD0AC2826BCD2582@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have sufficient information for a thorough analysis. Let me
compile everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
- **Subsystem**: `ALSA: usb-audio`
- **Action verb**: "Add" (adding quirk flags)
- **Summary**: Adds interface reset and delay quirk for HUAWEI USB-C
  HEADSET (0x12d1:0x3a07)

Record: [ALSA: usb-audio] [Add] [Hardware quirk flags for suspend/resume
fix on HUAWEI USB-C HEADSET]

### Step 1.2: Parse All Commit Message Tags
- **Signed-off-by**: Lianqin Hu <hulianqin@vivo.com> (author)
- **Signed-off-by**: Takashi Iwai <tiwai@suse.de> (ALSA subsystem
  maintainer)
- **Link**: https://patch.msgid.link/TYUPR06MB62176A18EA7A9DD0AC2826BCD2
  582@TYUPR06MB6217.apcprd06.prod.outlook.com
- No Fixes: tag (expected for quirk addition)
- No Reported-by: tag (the author discovered the issue themselves)
- No Cc: stable tag

Record: Accepted by Takashi Iwai (ALSA subsystem maintainer). Author
works at vivo (mobile phone manufacturer - plausible USB-C headset
user).

### Step 1.3: Analyze the Commit Body Text
The commit says: "Setting up the interface when suspended/resumeing fail
on this card." This describes a concrete bug: the USB audio interface
setup fails during suspend/resume cycles. The fix is adding
`QUIRK_FLAG_FORCE_IFACE_RESET` and `QUIRK_FLAG_IFACE_DELAY` flags. The
USB device info (VID/PID, manufacturer "bestechnic", product "HUAWEI
USB-C HEADSET") is included for identification.

Record: Bug = interface setup failure during suspend/resume. Symptom =
audio device non-functional after suspend/resume. Root cause = device
requires an interface reset and a 50ms delay during interface setup.

### Step 1.4: Detect Hidden Bug Fixes
This is not hidden - it's an explicit hardware workaround for a device
that fails during suspend/resume. This is a textbook USB audio quirk.

Record: Not a hidden bug fix; it's an explicit hardware
quirk/workaround.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
- **Files changed**: 1 (`sound/usb/quirks.c`)
- **Lines**: -2 / +3 (net +1 line)
- **Functions modified**: None - only a data table entry is changed
- **Scope**: Single-line modification to an existing quirk table entry

Record: Extremely minimal change. Only the existing DEVICE_FLG entry for
0x12d1, 0x3a07 is modified.

### Step 2.2: Understand the Code Flow Change
- **Before**: `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE |
  QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE`
- **After**: `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE |
  QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE | QUIRK_FLAG_FORCE_IFACE_RESET |
  QUIRK_FLAG_IFACE_DELAY`
- Also updated the comment from "Huawei Technologies Co., Ltd." to
  "HUAWEI USB-C HEADSET" (cosmetic)

The two new flags are consumed in existing code paths:
- `QUIRK_FLAG_IFACE_DELAY` causes a 50ms sleep in
  `snd_usb_endpoint_set_interface()` (endpoint.c:942-943) and in
  `snd_usb_init_sample_rate()` (clock.c:649-650)
- `QUIRK_FLAG_FORCE_IFACE_RESET` forces `need_prepare = true` and
  `need_setup = true` when stopping a stream (endpoint.c:1695-1700)

Record: Data-only change adding well-established flags to an existing
device entry. No logic changes.

### Step 2.3: Identify the Bug Mechanism
Category: **(h) Hardware workarounds**
- This is a device-specific quirk table entry modification
- The HUAWEI USB-C HEADSET (Bestechnic chipset) requires both an
  interface reset and a delay for proper operation during suspend/resume

Record: Hardware quirk. The device's USB audio firmware doesn't handle
interface re-setup correctly without a forced reset and delay.

### Step 2.4: Assess the Fix Quality
- Obviously correct: adds flags to a static data table, no logic change
- Minimal/surgical: 3 lines modified in a single entry
- Regression risk: Essentially zero. These flags are already used by 10+
  other devices. The only effect is a 50ms delay and a forced interface
  reset for this specific device.

Record: Fix quality = excellent. Regression risk = negligible.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
From git blame:
- `2cbe4ac193ed71` (qaqland, 2025-08-29): Added initial entry for
  0x12d1, 0x3a07 with `QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE`
- `806a38293fc0df` (Cryolitia PukNgae, 2025-09-03): Added
  `QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE`

The device entry was present since kernel ~6.17.

Record: Device entry exists in tree since ~v6.17. The flags being added
(FORCE_IFACE_RESET since 2022, IFACE_DELAY since 2021) are both long-
established.

### Step 3.2: Follow the Fixes: Tag
No Fixes: tag present. This is expected for a quirk addition.

### Step 3.3: Check File History
Recent changes to `sound/usb/quirks.c` show 5 nearly identical commits
by the same author adding `QUIRK_FLAG_FORCE_IFACE_RESET |
QUIRK_FLAG_IFACE_DELAY` for other devices:
- AB13X USB Audio (2 variants)
- AB17X USB Audio
- SPACETOUCH USB Audio
- GHW-123P

Record: The author has submitted numerous identical-pattern quirk
patches, all accepted by Takashi Iwai. This is a well-established
pattern.

### Step 3.4: Check the Author's Other Commits
Lianqin Hu has 10+ commits in the USB audio area, almost all adding
delay/reset quirks for specific devices. They are clearly a regular
contributor for USB audio quirks, likely working at vivo on mobile
device compatibility.

Record: Regular USB audio quirk contributor with a track record of
accepted patches.

### Step 3.5: Check for Dependent/Prerequisite Commits
The prerequisite is that the device entry (0x12d1, 0x3a07) exists in the
target tree. This was added in ~v6.17 (commit 2cbe4ac193ed71). Both
quirk flags have existed since v5.x era.

Record: Requires the base entry (v6.17+). Both flags exist since v5.x.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.2: Find the Original Patch Discussion
The Link: in the commit points to the patch submission. The patch was
accepted directly by Takashi Iwai (ALSA subsystem maintainer). Web
search confirms the pattern: identical patches for AB13X were submitted
with the same message format and accepted.

Record: Accepted by subsystem maintainer. Standard quirk addition
pattern.

### Step 4.3-4.5: Bug Report and Stable Context
No separate bug report link. The author discovered the suspend/resume
failure with this device directly. Similar quirk additions have been
routinely backported to stable in the past.

Record: Self-reported by hardware tester at vivo.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions in the Diff
No functions modified - only a data table entry.

### Step 5.2-5.4: Trace Callers
The flags are consumed by:
1. `snd_usb_endpoint_set_interface()` in endpoint.c (IFACE_DELAY: adds
   50ms sleep after usb_set_interface)
2. Stream stop path in endpoint.c (FORCE_IFACE_RESET: marks interface as
   needing re-setup)
3. `snd_usb_init_sample_rate()` in clock.c (IFACE_DELAY: 50ms sleep
   after rate change)

These are core USB audio paths that run during stream start/stop and
suspend/resume.

Record: The flags affect well-tested code paths in the USB audio stack.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Does the Buggy Code Exist in Stable Trees?
The device entry exists in 7.0. For older stable trees (6.6.y, 6.1.y,
etc.), the device entry does NOT exist (it was added in v6.17). So this
quirk would only be relevant for stable trees >= 6.17 (or wherever the
entry was backported to).

Record: Relevant for stable trees that contain the device entry
(v6.17+).

### Step 6.2: Backport Complications
The patch should apply cleanly to any tree that has the existing
DEVICE_FLG(0x12d1, 0x3a07, ...) entry. The diff is minimal.

Record: Clean apply expected for any tree with the base device entry.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: sound/usb (USB audio driver)
- **Criticality**: IMPORTANT - USB-C headsets are very common on laptops
  and phones

Record: USB audio = IMPORTANT subsystem. USB-C headsets are widely used.

### Step 7.2: Subsystem Activity
54 changes to `sound/usb/quirks.c` between v6.12 and v7.0. Extremely
active - this file gets frequent quirk additions.

Record: Highly active, many quirk additions routinely accepted.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Users of HUAWEI USB-C HEADSET (VID 0x12d1, PID 0x3a07, manufactured by
Bestechnic). This is a branded headset likely sold with Huawei phones
but also usable on any USB-C Linux device.

Record: Device-specific. Affects all users of this specific HUAWEI USB-C
headset.

### Step 8.2: Trigger Conditions
Triggered on every suspend/resume cycle when the headset is connected.
Very common for laptop users.

Record: Common trigger - any suspend/resume with device connected.

### Step 8.3: Failure Mode Severity
Without the quirk, the interface setup fails during resume. The headset
stops working after suspend/resume, requiring re-plugging. This is a
functional failure.

Record: Severity = HIGH for affected users (device non-functional after
suspend/resume).

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: Fixes suspend/resume for HUAWEI USB-C headset users
- **Risk**: Extremely low. Data table change only. The flags are used by
  10+ other devices already. No logic changes.

Record: Very high benefit/risk ratio.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Classic hardware quirk addition to existing device entry
- Fixes real suspend/resume failure
- Tiny, data-only change (3 lines in a static table)
- Both flags are well-established (2021/2022 vintage)
- Same flags used by 10+ other devices successfully
- Accepted by ALSA subsystem maintainer (Takashi Iwai)
- Author has track record of identical, accepted quirk patches
- Zero regression risk (device-specific, data-only)

**AGAINST backporting:**
- No Fixes: tag (expected for quirks)
- Limited to one specific device
- Base device entry only exists in v6.17+

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - data table change, accepted
   by maintainer
2. Fixes a real bug? **YES** - suspend/resume failure
3. Important issue? **YES** - device non-functional after suspend/resume
4. Small and contained? **YES** - 3 lines in one file
5. No new features or APIs? **YES** - just adds flags to existing entry
6. Can apply to stable trees? **YES** - clean apply for trees with the
   base entry

### Step 9.3: Exception Categories
**YES** - This is a hardware quirk/workaround, one of the explicitly
listed exception categories that are automatically YES for stable.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by Takashi Iwai (ALSA maintainer),
  Link to patch submission
- [Phase 2] Diff analysis: +1 net line, adds
  QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY to existing
  entry for 0x12d1:0x3a07
- [Phase 3] git blame: device entry introduced by 2cbe4ac193ed71 (v6.17
  era), flags exist since 2021/2022
- [Phase 3] Author commits: 10+ similar quirk patches all accepted by
  Takashi Iwai
- [Phase 4] Web search: confirmed identical pattern patches (AB13X,
  AB17X, etc.) accepted
- [Phase 5] Flag usage: IFACE_DELAY triggers 50ms sleep in
  endpoint.c:942, FORCE_IFACE_RESET forces re-setup in
  endpoint.c:1695-1700
- [Phase 5] 10+ other devices already use these same flags (verified via
  grep)
- [Phase 6] Base entry exists in 7.0 tree (confirmed via git blame)
- [Phase 7] sound/usb/quirks.c: 54 changes between v6.12-v7.0, highly
  active
- [Phase 8] Failure mode: device non-functional after suspend/resume,
  severity HIGH for affected users
- UNVERIFIED: Could not access lore.kernel.org directly due to anti-bot
  protection; relied on web search confirmation

This is a textbook USB audio hardware quirk addition. It adds two well-
established flags to an existing device entry, fixing suspend/resume
failure for a specific HUAWEI USB-C headset. The change is data-only,
obviously correct, zero regression risk, and accepted by the ALSA
subsystem maintainer.

**YES**

 sound/usb/quirks.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 4cfa24c06fcdf..d3a69995c1ad5 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2291,8 +2291,9 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x1101, 0x0003, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
-	DEVICE_FLG(0x12d1, 0x3a07, /* Huawei Technologies Co., Ltd. */
-		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE | QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE),
+	DEVICE_FLG(0x12d1, 0x3a07, /* HUAWEI USB-C HEADSET */
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE | QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE |
+		   QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */
-- 
2.53.0

