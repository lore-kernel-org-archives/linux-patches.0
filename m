Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA7447799B;
	Mon, 20 Apr 2026 13:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691846; cv=none; b=F8wjdeXtIuBCh/h67GFYlQ0EYNsMGhLPib6OzHdDehJdZYWjPyIMi5pwm/AHIYfX6m8K/BtMpLseRaJbK5b9QG7xUbI0GagFJHlmroQ925WxhMgTii8v2g4BgBLMuZuv5/LK8B5YvpwJ/lyCubqEEzgVgc5oia+n9hq3DTJ64CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691846; c=relaxed/simple;
	bh=lJ7eIvqq60QyAW0GBDng2apvzHdbc3nol6hDSeLn33I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZX49zm/ozseavlPUlUhlu8gGosHj/QSsj9FWh5e4AyLGwLhW+jX+9gkCUoFI9k2Rqlmlb4FcbeOoeKd5mlDG9RVel+8hKrrgg4lvf1Z2eHNo7/2SBLu2I4g/Ts81zhwj6SUWsyR3sVNQHEDB3EvL2rFSXsQ3GyJ5uBbwOR88RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpOBXuPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpOBXuPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B57AC19425;
	Mon, 20 Apr 2026 13:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691845;
	bh=lJ7eIvqq60QyAW0GBDng2apvzHdbc3nol6hDSeLn33I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpOBXuPeC8PPlD7zL3a6IzpPhbf0ZRP7xaDiIIkApWhRhd0ObyaLF0DkU/aazQciS
	 OLtp5cEOY/hSfI6YIWZO4Fnbp5Qqoe/8RYSB7yqsr9ETi35PDUW01jD+e0oFL9mP/8
	 zbkgnUggITUYKRmBimkKxU6QF8gzdkgHyGAHX7FDLt5d0vNa+BaBGSFUBtpNtQTr7H
	 WSJBDHvLFj1v3p9kxk7rSbefgEzXb9wm52fFfBKnMWIDrVumPf1Qa43x7YMkqKXKnF
	 8LVfs1TyfiRk8sE5LO98GOtZ393Bjsw8wyL6LYmOZYaSCs/dxykEsjEgIV8aJ4x1iE
	 y8WYIRbmFMZlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Frederic Popp <frederic.l.popp@t-online.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] ALSA: usb-audio: add Studio 1824 support
Date: Mon, 20 Apr 2026 09:20:22 -0400
Message-ID: <20260420132314.1023554-228-sashal@kernel.org>
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

From: Frederic Popp <frederic.l.popp@t-online.de>

[ Upstream commit c4791ce96b88a444b04c7089ae2827a3b3ae1877 ]

Adapt the already implemented support for the Studio 1824c
audio interface to the predecessor Studio 1824.

Basically just a change adding the
different hardware ID in the relevant places.

Tested as much as possible.
All implemented functionality seemingly works.

Signed-off-by: Frederic Popp <frederic.l.popp@t-online.de>
Link: https://patch.msgid.link/20260308153334.50433-2-frederic.l.popp@t-online.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The context matches the diff perfectly. The patch would apply cleanly.
Now I have all the information needed.

---

## Complete Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Parse the Subject Line**
- Subsystem: `ALSA: usb-audio`
- Action verb: "add" (add support)
- Summary: Adding USB device ID for Presonus Studio 1824 to existing
  driver
Record: [ALSA: usb-audio] [add] [Studio 1824 device support via ID
addition to existing 1824c code paths]

**Step 1.2: Parse All Commit Message Tags**
- Signed-off-by: Frederic Popp <frederic.l.popp@t-online.de> (author)
- Link: https://patch.msgid.link/20260308153334.50433-2-
  frederic.l.popp@t-online.de (patch 2 in a series)
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer, accepted
  the patch)
- No Fixes: tag (expected)
- No Cc: stable (expected)
- No Reported-by: tag (author is the user of this hardware)
Record: Author SOB, maintainer SOB, link suggests patch 2 of a series.
Maintainer Takashi Iwai applied it.

**Step 1.3: Analyze the Commit Body Text**
The commit message says: "Adapt the already implemented support for the
Studio 1824c audio interface to the predecessor Studio 1824. Basically
just a change adding the different hardware ID in the relevant places."
Author states they tested it: "Tested as much as possible. All
implemented functionality seemingly works."
Record: No bug described. This adds hardware support for an existing
device family. The Studio 1824 is a predecessor of the 1824c with a
different USB product ID (0x0107 vs 0x010d).

**Step 1.4: Detect Hidden Bug Fixes**
This is not a hidden bug fix. It is straightforwardly adding a new USB
device ID to an existing driver to enable a hardware device. This falls
under the "NEW DEVICE IDs" exception category.
Record: Not a hidden bug fix. This is a device ID addition.

### PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: Inventory the Changes**
- `sound/usb/format.c`: +4 lines (new device ID check for sample rate
  filtering)
- `sound/usb/mixer_quirks.c`: +3 lines (new case in switch for mixer
  init)
- `sound/usb/mixer_s1810c.c`: +2 lines in two locations (new case labels
  in switches)
- Total: ~9 lines added, 0 removed
- Functions modified: `parse_uac2_sample_rate_range()`,
  `snd_usb_mixer_apply_create_quirk()`, `snd_s1810c_init_mixer_maps()`,
  `snd_sc1810_init_mixer()`
Record: 3 files, +9 lines, all adding `USB_ID(0x194f, 0x0107)` case
entries. Scope: trivial device ID addition.

**Step 2.2: Code Flow Change**
Each hunk adds the Presonus Studio 1824 USB ID (0x194f, 0x0107) to the
same code paths that already handle the 1824c (0x194f, 0x010d):
1. `format.c`: Before: 1824 rates not filtered. After: invalid sample
   rates filtered using same `s1810c_valid_sample_rate()` function.
2. `mixer_quirks.c`: Before: 1824 not recognized. After: calls
   `snd_sc1810_init_mixer()` like the 1824c does.
3. `mixer_s1810c.c` (init_mixer_maps): Before: 1824 not handled. After:
   falls through to 1824c case for initial mix setup.
4. `mixer_s1810c.c` (snd_sc1810_init_mixer): Before: 1824 not handled.
   After: falls through to 1824c case for mono switch init.
Record: All hunks simply add the 1824 USB ID alongside the existing
1824c ID to follow the same code paths.

**Step 2.3: Bug Mechanism**
Category: Hardware enablement - device ID addition. Not a bug fix per
se, but enables a hardware device that is otherwise non-functional or
partially functional without proper mixer initialization and sample rate
filtering.
Record: [Device ID addition] [Without this, the Studio 1824 would lack
proper mixer initialization and sample rate filtering]

**Step 2.4: Fix Quality**
- Obviously correct: Yes. Identical pattern to the existing 1824c
  entries.
- Minimal/surgical: Yes. Only device ID additions, 9 lines total.
- Regression risk: Essentially zero. Only affects users who plug in a
  Presonus Studio 1824 (USB ID 0x194f:0x0107). Cannot affect any other
  device.
- No red flags.
Record: Fix quality excellent. Zero regression risk. Trivial, obviously
correct.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame the Changed Lines**
The code being modified was introduced by:
- `8dc5efe3d17cd` (v5.7-rc1): Initial 1810c support by Nick Kossifidis
- `080564558eb13` (v6.15-rc1): 1824c device ID addition by Amin Dandache
- `0ca29010d426e` (v6.18-rc1): 1824c initial mixer maps by Roy Vegard
  Ovesen
- `659169c4eb21f` (v6.18-rc1): 1824c mono switch by Roy Vegard Ovesen
Record: Driver has been in the tree since v5.7. The 1824c support (which
this 1824 commit mirrors) landed in v6.15/v6.18.

**Step 3.2: Follow the Fixes: tag**
No Fixes: tag present (expected - this is a device ID addition, not a
bug fix).
Record: N/A

**Step 3.3: File History**
The mixer_s1810c.c file has seen active development recently with 1824c
improvements (initial mix, mono switch, cleanups). The Studio 1824
support piggybacks on all of this.
Record: Active file with recent 1824c-related improvements. This commit
adds 1824 on top of that work.

**Step 3.4: Author's Other Commits**
Frederic Popp has no other commits in this tree. First-time contributor
with tested hardware support. Patch was accepted by subsystem maintainer
Takashi Iwai.
Record: First-time contributor. Patch vetted by ALSA maintainer.

**Step 3.5: Dependencies**
The commit depends on:
1. `080564558eb13` - 1824c basic support (v6.15) - **IN TREE**
   (verified)
2. `0ca29010d426e` - 1824c initial mixer maps (v6.18) - **IN TREE**
   (verified)
3. `659169c4eb21f` - 1824c mono switch (v6.18) - **IN TREE** (verified)
4. `d1d6ad7f6686e` - Removal of skip_setting quirk for 1824c - **IN
   TREE** (verified)

All dependencies present. The message-id suggests patch 2 of a series,
but the diff is self-contained (patch 1 was likely a cover letter or an
unrelated companion change).
Record: All dependencies present in tree. Commit is self-contained.

### PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.5: Mailing List**
Lore.kernel.org is blocking automated access (Anubis protection). b4 dig
could not find the commit (not yet in the tree). However, the Link: tag
confirms the patch was submitted to the ALSA mailing list and was
accepted by Takashi Iwai (the ALSA subsystem maintainer).
Record: Could not access lore discussion. Patch was accepted by ALSA
maintainer Takashi Iwai.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.5: Functions Modified**
The changes are all switch case additions:
- `parse_uac2_sample_rate_range()` - called during USB audio format
  parsing
- `snd_usb_mixer_apply_create_quirk()` - called during mixer creation
- `snd_s1810c_init_mixer_maps()` - called during mixer initialization
- `snd_sc1810_init_mixer()` - called during mixer initialization

All are in the device probe/initialization path. The code paths are only
triggered when a device with USB ID 0x194f:0x0107 is connected.
Record: All changes in probe/init path, device-ID gated. No impact on
any other device.

### PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: Does the Code Exist in Stable Trees?**
This is for stable tree 7.0.y. The v7.0 tree has all prerequisites. For
older stable trees (6.12.y, 6.6.y, etc.), the 1824c support may not
exist, making this patch inapplicable there.
Record: Applies to 7.0.y. May not apply to older stable trees without
1824c support (added in v6.15/v6.18).

**Step 6.2: Backport Complications**
The patch would apply cleanly to the 7.0 tree - verified that the
context lines match exactly.
Record: Clean apply expected.

**Step 6.3: Related Fixes Already in Stable**
No related fixes for Studio 1824 in any stable tree (this is the first
time this device is supported).
Record: No prior fixes exist.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem Criticality**
- Subsystem: ALSA USB audio (`sound/usb/`)
- Criticality: IMPORTANT (USB audio is widely used)
Record: ALSA USB audio, IMPORTANT criticality.

**Step 7.2: Subsystem Activity**
Active subsystem with frequent device-specific additions and quirk
updates.
Record: Active subsystem.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
Only users of Presonus Studio 1824 hardware. Without this patch, the
device would operate as a generic UAC2 device but lack proper mixer
initialization, sample rate filtering, and control switches.
Record: Driver-specific, affects Presonus Studio 1824 owners.

**Step 8.2: Trigger Conditions**
Triggered when a user plugs in a Presonus Studio 1824 USB audio
interface.
Record: Device-specific trigger. Common for users of this hardware.

**Step 8.3: Failure Mode**
Without this patch: improper mixer setup, potentially wrong sample
rates, missing controls. Not a crash or security issue, but a hardware
enablement gap.
Record: Severity: MEDIUM (hardware not fully functional without the
patch)

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Enables proper hardware support for Presonus Studio 1824
  owners on stable kernels.
- RISK: Essentially zero. 9 lines of device ID additions, affecting only
  one specific USB device. Cannot regress any other functionality.
Record: Very high benefit-to-risk ratio.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**
FOR backporting:
- Classic device ID addition to existing driver (exception category)
- Trivially small (9 lines) and obviously correct
- Mirrors existing 1824c entries exactly
- Author tested on real hardware
- Accepted by ALSA subsystem maintainer Takashi Iwai
- Zero regression risk (device-ID gated)
- All dependencies are in the 7.0 tree
- Would apply cleanly

AGAINST backporting:
- Not a bug fix; it's new hardware enablement
- First-time contributor (mitigated by maintainer acceptance)
- Could not verify mailing list discussion (lore blocked)

UNRESOLVED:
- Could not access lore discussion (Anubis protection)
- Could not determine if there was a companion patch 1 in the series

**Step 9.2: Stable Rules Checklist**
1. Obviously correct? YES - identical pattern to existing entries
2. Fixes a real bug? NO (but falls under Device ID exception)
3. Important issue? Device enablement for existing hardware family
4. Small and contained? YES - 9 lines across 3 files
5. No new features or APIs? Correct - no new APIs, just ID table
   additions
6. Can apply to stable? YES - clean apply verified

**Step 9.3: Exception Categories**
This is a **Device ID addition** to an existing driver. The Presonus
Studio 1824 uses USB product ID 0x194f:0x0107, and the existing driver
already supports its successor (1824c, ID 0x194f:0x010d). The commit
adds the 1824's ID to the same code paths. This is the textbook
definition of a stable-eligible device ID addition.

**Step 9.4: Decision**
This is a straightforward device ID addition - one of the explicitly
allowed exception categories for stable backports. It's trivially small,
obviously correct, zero regression risk, and enables real hardware for
real users.

### Verification

- [Phase 1] Parsed tags: SOB from author and maintainer Takashi Iwai,
  Link to patch submission
- [Phase 2] Diff analysis: +9 lines across 3 files, all adding
  USB_ID(0x194f, 0x0107) to existing switch/if chains
- [Phase 3] git merge-base: confirmed all prerequisite commits
  (080564558eb13, 0ca29010d426e, 659169c4eb21f, d1d6ad7f6686e) are
  ancestors of HEAD
- [Phase 3] git describe: 1810c support in v5.7, 1824c support in
  v6.15/v6.18
- [Phase 3] git show 080564558eb13: confirmed 1824c was added via
  identical pattern
- [Phase 4] b4 dig: could not find commit (not yet in tree) - EXPECTED
  for candidate
- [Phase 4] lore access: blocked by Anubis - UNVERIFIED: mailing list
  discussion details
- [Phase 5] Code paths: all changes are device-ID gated, only triggered
  for USB ID 0x194f:0x0107
- [Phase 6] Context match verified: diff hunks match current tree state
  exactly, clean apply expected
- [Phase 6] No 0x0107 entries exist in sound/usb/ for Presonus vendor ID
  (confirmed via grep)
- [Phase 8] Risk: zero (device-ID gated, 9 lines, mirrors existing code
  exactly)

**YES**

 sound/usb/format.c       | 4 ++++
 sound/usb/mixer_quirks.c | 3 +++
 sound/usb/mixer_s1810c.c | 2 ++
 3 files changed, 9 insertions(+)

diff --git a/sound/usb/format.c b/sound/usb/format.c
index 1207c507882ad..030b4307927a2 100644
--- a/sound/usb/format.c
+++ b/sound/usb/format.c
@@ -455,6 +455,10 @@ static int parse_uac2_sample_rate_range(struct snd_usb_audio *chip,
 			if (chip->usb_id == USB_ID(0x194f, 0x010d) &&
 			    !s1810c_valid_sample_rate(fp, rate))
 				goto skip_rate;
+			/* Filter out invalid rates on Presonus Studio 1824 */
+			if (chip->usb_id == USB_ID(0x194f, 0x0107) &&
+			    !s1810c_valid_sample_rate(fp, rate))
+				goto skip_rate;
 
 			/* Filter out invalid rates on Focusrite devices */
 			if (USB_ID_VENDOR(chip->usb_id) == 0x1235 &&
diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 11e205da7964d..1d2a74df7ab09 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -4477,6 +4477,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 	case USB_ID(0x194f, 0x010d): /* Presonus Studio 1824c */
 		err = snd_sc1810_init_mixer(mixer);
 		break;
+	case USB_ID(0x194f, 0x0107): /* Presonus Studio 1824 */
+		err = snd_sc1810_init_mixer(mixer);
+		break;
 	case USB_ID(0x2a39, 0x3fb0): /* RME Babyface Pro FS */
 		err = snd_bbfpro_controls_create(mixer);
 		break;
diff --git a/sound/usb/mixer_s1810c.c b/sound/usb/mixer_s1810c.c
index 7eac7d1bce647..2e5a8d37ec578 100644
--- a/sound/usb/mixer_s1810c.c
+++ b/sound/usb/mixer_s1810c.c
@@ -362,6 +362,7 @@ static int snd_s1810c_init_mixer_maps(struct snd_usb_audio *chip)
 		snd_s1810c_send_ctl_packet(dev, a, 3, 0, 1, MIXER_LEVEL_0DB);
 		break;
 
+	case USB_ID(0x194f, 0x0107): /* 1824 */
 	case USB_ID(0x194f, 0x010d): /* 1824c */
 		/* Set all output faders to unity gain */
 		a = SC1810C_SEL_OUTPUT;
@@ -685,6 +686,7 @@ int snd_sc1810_init_mixer(struct usb_mixer_interface *mixer)
 			return ret;
 
 		break;
+	case USB_ID(0x194f, 0x0107): /* Presonus Studio 1824 */
 	case USB_ID(0x194f, 0x010d): /* Presonus Studio 1824c */
 		ret = snd_s1810c_switch_init(mixer, &snd_s1824c_mono_sw);
 		if (ret < 0)
-- 
2.53.0

