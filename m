Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F673A9D8A;
	Mon, 20 Apr 2026 13:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690980; cv=none; b=aoDFncb55jZjawdZSPzlqYragrB4nUZ8MY5wknqge4hNKSDSfeUWdCGBkph8ouibr7+o3v79qBHgxCLlnmAecITPZuyzQ2sCbCCiYfdbLbrVjXUj6ByAYT80HpH71SQ2F0AuiEx6jTL48Z5/ClNcfSOQUotLyVsFUn98HFK+8uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690980; c=relaxed/simple;
	bh=Ky2L1ya5Cap63y6Tv5MzFer5KRrTDUhVt3asN3TlwSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aEOTJaFABV8D7EFlxGB3+Zajxx5YT7u5VclwABvx6rheBEg/jP8aH6PL+zj3gEceGbcY2eknpXkNUzEOR12PRs/l/i2oJclgf7im6oR04+A7IRQqs5WEH+VUAdgZZm+mQlZofJ0YCBjzoVrLjyRF8vnzGRssVquY49i+fT9BygE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cpd1o9n+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cpd1o9n+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D62C2BCC4;
	Mon, 20 Apr 2026 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690979;
	bh=Ky2L1ya5Cap63y6Tv5MzFer5KRrTDUhVt3asN3TlwSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cpd1o9n+VFfdfE9sNWlbxYsyDUWrdAghAAj+eilTNFfWo7C6mSzuszJBF60+qzwP4
	 0ndhyGz4q24c1YyfNTkl8U8zj7fr28A/1X5ExUpF6EJcEnD2NzupAaO+Ox7ydFo6u8
	 qoyqQ1Ra4A92ac40glWYiWB0jq8wP6SY5blAvYqd0x84U0snAZInb+W6vtl3JuMuwd
	 hiucz8m9P0+tyuBkvFJyGDq8DTeCmM8RXktdN4ZwkxKs1gqAc8f6ICtHDcX8WYcd91
	 QUt6H0ZkLUUYcCUJIrKodRwAX1+fvWYmuhDnDN0bAeOhxlw6ANO+PW53Xos0CroLLk
	 yV3FGGt5VU3Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Phil Willoughby <willerz@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] ALSA: usb-audio: Add quirks for Arturia AF16Rig
Date: Mon, 20 Apr 2026 09:08:09 -0400
Message-ID: <20260420131539.986432-23-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Phil Willoughby <willerz@gmail.com>

[ Upstream commit 0da18c2dd1cc2a026416222ed206e2f269edf055 ]

The AF16Rig supports 34 channels at 44.1k/48k, 18 channels at 88.2k/96k
and 10 channels at 176.4k/192k.

This quirks is necessary because the automatic probing process we would
otherwise use fails. The root cause of that is that the AF16Rig clock is
not readable (its descriptor says that it is but the reads fail).

Except as described below, the values in the audio format quirks were
copied from the USB descriptors of the device. The rate information is
from the datasheet of the device. The clock is the internal clock of the
AF16Rig.

Tested-By: Phil Willoughby <willerz@gmail.com>
I have tested all the configurations enabled by this patch.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Phil Willoughby <willerz@gmail.com>
Link: https://patch.msgid.link/20260328112426.14816-1-willerz@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** ALSA: usb-audio
- **Action verb:** "Add" (quirks)
- **Summary:** Adds USB audio quirks for the Arturia AF16Rig device

### Step 1.2: Tags
- **Tested-By:** Phil Willoughby <willerz@gmail.com> — the author tested
  all configurations
- **Cc:** Jaroslav Kysela (ALSA maintainer), Takashi Iwai (ALSA/USB-
  audio maintainer)
- **Signed-off-by:** Phil Willoughby (author), Takashi Iwai (maintainer,
  applied the patch)
- **Link:**
  https://patch.msgid.link/20260328112426.14816-1-willerz@gmail.com
- No Fixes: tag (expected for quirk additions)
- No Cc: stable (expected — that's why we're reviewing)

### Step 1.3: Commit Body
The commit explains that the AF16Rig supports multiple channel/rate
configurations (34ch@44.1k/48k, 18ch@88.2k/96k, 10ch@176.4k/192k). The
**root cause is that the AF16Rig clock is broken** — its USB descriptor
claims the clock is readable but reads fail, which causes the automatic
probing process to fail entirely. Without this quirk, the device simply
does not work.

### Step 1.4: Hidden Bug Fix Detection
This IS a hardware workaround for a broken device. The device's USB
descriptors are incorrect (clock readability is falsely advertised),
causing the standard enumeration path to fail. This is the textbook
definition of a USB audio device quirk.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 file (`sound/usb/quirks-table.h`)
- **Lines added:** ~165 lines (purely data — struct initializers in the
  quirk table)
- **Lines removed:** 0
- **Scope:** Single-file, data-only addition to an existing quirk table

### Step 2.2: Code Flow Change
The patch adds a new entry to the USB audio quirks table for USB VID:PID
`0x1c75:0xaf20`. It defines:
- 1 standard mixer interface (interface 0)
- 3 playback audio format configurations (interface 1) for different
  sample rates
- 3 capture audio format configurations (interface 2) for the same rates
- 1 ignored interface (interface 3, firmware update)

The entry is inserted between the last `QUIRK_RME_DIGIFACE` entry and
the `#undef` lines at the end of the file.

### Step 2.3: Bug Mechanism
Category: **Hardware workaround (h)**. The device has a broken clock
descriptor — it claims the clock is readable but reads fail. This
prevents the standard UAC2 enumeration from working. The quirk bypasses
automatic probing by providing the correct audio format information
directly.

### Step 2.4: Fix Quality
- All macros used (`QUIRK_DATA_AUDIOFORMAT`, `QUIRK_DATA_COMPOSITE`,
  `QUIRK_DRIVER_INFO`, `QUIRK_DATA_STANDARD_MIXER`, `QUIRK_DATA_IGNORE`,
  `QUIRK_COMPOSITE_END`) are already defined in the same file (verified
  at lines 41, 49, 58, 72, 78, 87)
- Pure data — no logic changes, no control flow changes
- Only affects the specific USB device `0x1c75:0xaf20`
- Zero regression risk for any other device or code path
- Author tested all configurations enabled by the patch

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The insertion point is at the end of the quirks table after the RME
Digiface entries. The macros were introduced by `0c3ad39b791c2` ("Define
macros for quirk table entries") and `d79e13f8e8abb` ("Replace complex
quirk lines with macros"), both of which are present in this tree.

### Step 3.2: Fixes Tag
No Fixes: tag — this is a new device quirk, not a fix for a specific
regression.

### Step 3.3: File History
The file has a long history of similar quirk additions: Pioneer DJ
DJM-V10, RME Digiface USB, Pioneer DDJ-800, Mythware XA001AU, Mbox3,
etc. This is a well-established pattern.

### Step 3.4: Author
Phil Willoughby also contributed `bc5b4e5ae1a67` ("Fix quirk flags for
NeuralDSP Quad Cortex") around the same date, showing familiarity with
the USB audio quirk system.

### Step 3.5: Dependencies
The patch uses macros already present in the stable tree. No
prerequisite commits are needed. The insertion point
(`QUIRK_RME_DIGIFACE(0x3fa0)` followed by `#undef`) exists at lines
3901-3903, confirming clean applicability.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
b4 dig could not find the commit (it's not yet in the tree we're on).
Lore was blocked by anti-bot protection. However, the commit message
includes a Link to the patch submission, and Takashi Iwai (the USB audio
maintainer) signed off on it, confirming maintainer review and
acceptance.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.5
This is purely a data table addition. There are no new functions, no
logic changes, no callers/callees to trace. The quirk table is consumed
by the existing USB audio driver infrastructure which already handles
all the macros and format types used.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence in Stable
The quirks table and all macros used exist in this 7.0 stable tree.
Verified: `QUIRK_DATA_AUDIOFORMAT` at line 87, `QUIRK_DATA_COMPOSITE` at
line 78, `QUIRK_DRIVER_INFO` at line 41, etc.

### Step 6.2: Backport Complications
The patch should apply cleanly. The insertion point (between
`QUIRK_RME_DIGIFACE(0x3fa0),` at line 3901 and `#undef
USB_DEVICE_VENDOR_SPEC` at line 3903) is present and matches the diff
context exactly.

### Step 6.3: Related Fixes
No prior fixes for AF16Rig exist — this is the first support entry.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1
- **Subsystem:** sound/usb (USB audio drivers)
- **Criticality:** IMPORTANT — USB audio is used by musicians, content
  creators, and professionals who rely on specific hardware

### Step 7.2
Active subsystem with regular quirk additions (verified: 10+ recent
commits adding device quirks).

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
Users of the Arturia AF16Rig USB audio interface. Without this quirk,
the device is **completely non-functional** under Linux.

### Step 8.2: Trigger Conditions
Every time the device is plugged in. The broken clock descriptor causes
enumeration failure immediately.

### Step 8.3: Failure Mode
Without quirk: Device probing fails, no audio functionality at all.
**Severity: HIGH** (total device failure).

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — enables a professional audio device that is
  otherwise non-functional
- **Risk:** VERY LOW — pure data addition to a quirk table, device-
  specific, affects no other hardware, uses existing macros, tested by
  the author
- **Ratio:** Strongly favorable

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Hardware quirk/workaround for a broken device (clock descriptor lie)
- Pure data addition, no logic changes
- Zero regression risk for any other device
- Uses macros already present in stable
- Tested by the author on all configurations
- Accepted by subsystem maintainer (Takashi Iwai)
- Well-established pattern (dozens of similar entries in the same file)
- Falls squarely into the "QUIRKS and WORKAROUNDS" exception category

**AGAINST backporting:**
- Large (~165 lines), though entirely data
- New device support rather than fixing a regression in existing support

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — data copied from USB
   descriptors, tested by author
2. Fixes a real bug? **YES** — device completely non-functional without
   it (broken clock descriptor)
3. Important issue? **YES** — total hardware failure for users of this
   device
4. Small and contained? **YES** — single file, data-only, device-
   specific
5. No new features or APIs? **YES** — no new APIs, just quirk data
6. Can apply to stable? **YES** — insertion point and all macros exist

### Step 9.3: Exception Category
**Hardware quirk/workaround** — this is explicitly listed as a YES-by-
default category in the stable kernel rules analysis.

## Verification

- [Phase 1] Parsed tags: Tested-by from author, Signed-off-by from
  maintainer Takashi Iwai
- [Phase 2] Diff analysis: ~165 lines of struct initializer data added
  to quirks-table.h; zero logic changes
- [Phase 2] Verified all macros used: QUIRK_DATA_AUDIOFORMAT (line 87),
  QUIRK_DATA_COMPOSITE (line 78), QUIRK_DRIVER_INFO (line 41),
  QUIRK_DATA_STANDARD_MIXER (line 58), QUIRK_DATA_IGNORE (line 49),
  QUIRK_COMPOSITE_END (line 72)
- [Phase 3] git log --oneline -20 -- sound/usb/quirks-table.h: confirmed
  long history of similar quirk additions
- [Phase 3] git show bc5b4e5ae1a67: confirmed author has other USB audio
  work (NeuralDSP fix)
- [Phase 4] b4 dig failed to find match (commit not in tree); lore
  blocked by anti-bot; maintainer sign-off confirmed from commit
  metadata
- [Phase 5] No functions to trace — pure data table entry
- [Phase 6] Verified insertion point exists at lines 3901-3903
  (QUIRK_RME_DIGIFACE followed by #undef); patch should apply cleanly
- [Phase 6] Verified Arturia VID 0x1c75 has no existing entries (grep
  returned no matches)
- [Phase 7] Subsystem is actively maintained with regular quirk
  additions
- [Phase 8] Failure mode: complete device non-functionality; severity
  HIGH; risk VERY LOW (data-only, device-specific)
- UNVERIFIED: Could not access mailing list discussion due to anti-bot
  protection; relying on maintainer sign-off as evidence of review

This is a textbook USB audio device quirk addition. The Arturia AF16Rig
has a broken clock descriptor that prevents standard enumeration, making
the device completely non-functional without this quirk. The patch is
pure data, uses existing macros, and affects only the specific device.
It carries essentially zero regression risk.

**YES**

 sound/usb/quirks-table.h | 165 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index eafc0d73cca1f..8f79a15055a6a 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -3900,5 +3900,170 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 QUIRK_RME_DIGIFACE(0x3f8c),
 QUIRK_RME_DIGIFACE(0x3fa0),
 
+/* Arturia AudioFuse 16Rig Audio */
+/* AF16Rig MIDI has USB PID 0xaf21 and appears to work OK without quirks */
+{
+	USB_DEVICE(0x1c75, 0xaf20),
+	QUIRK_DRIVER_INFO {
+		.vendor_name = "Arturia",
+		.product_name = "AF16Rig",
+		QUIRK_DATA_COMPOSITE {
+			{ QUIRK_DATA_STANDARD_MIXER(0) },
+			{
+				QUIRK_DATA_AUDIOFORMAT(1) { /* Playback */
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 34,
+					.fmt_type = UAC_FORMAT_TYPE_I_PCM,
+					.fmt_bits = 24,
+					.fmt_sz = 4,
+					.iface = 1,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
+					.protocol = UAC_VERSION_2,
+					.maxpacksize = 0x03b8,
+					.rates = SNDRV_PCM_RATE_44100|
+						 SNDRV_PCM_RATE_48000,
+					.rate_min = 44100,
+					.rate_max = 48000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 44100, 48000 },
+					.clock = 41,
+				}
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(1) { /* Playback */
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 18,
+					.fmt_type = UAC_FORMAT_TYPE_I_PCM,
+					.fmt_bits = 24,
+					.fmt_sz = 4,
+					.iface = 1,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
+					.protocol = UAC_VERSION_2,
+					.maxpacksize = 0x03a8,
+					.rates = SNDRV_PCM_RATE_88200|
+						 SNDRV_PCM_RATE_96000,
+					.rate_min = 88200,
+					.rate_max = 96000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 88200, 96000 },
+					.clock = 41,
+				}
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(1) { /* Playback */
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 10,
+					.fmt_type = UAC_FORMAT_TYPE_I_PCM,
+					.fmt_bits = 24,
+					.fmt_sz = 4,
+					.iface = 1,
+					.altsetting = 3,
+					.altset_idx = 3,
+					.endpoint = 0x01,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
+					.protocol = UAC_VERSION_2,
+					.maxpacksize = 0x03e8,
+					.rates = SNDRV_PCM_RATE_176400|
+						 SNDRV_PCM_RATE_192000,
+					.rate_min = 176400,
+					.rate_max = 192000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 176400, 192000 },
+					.clock = 41,
+				}
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(2) { /* Capture */
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 34,
+					.fmt_type = UAC_FORMAT_TYPE_I_PCM,
+					.fmt_bits = 24,
+					.fmt_sz = 4,
+					.iface = 2,
+					.altsetting = 1,
+					.altset_idx = 1,
+					.endpoint = 0x81,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
+					.protocol = UAC_VERSION_2,
+					.maxpacksize = 0x03b8,
+					.rates = SNDRV_PCM_RATE_44100|
+						 SNDRV_PCM_RATE_48000,
+					.rate_min = 44100,
+					.rate_max = 48000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 44100, 48000 },
+					.clock = 41,
+				}
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(2) { /* Capture */
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 18,
+					.fmt_type = UAC_FORMAT_TYPE_I_PCM,
+					.fmt_bits = 24,
+					.fmt_sz = 4,
+					.iface = 2,
+					.altsetting = 2,
+					.altset_idx = 2,
+					.endpoint = 0x81,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
+					.protocol = UAC_VERSION_2,
+					.maxpacksize = 0x03a8,
+					.rates = SNDRV_PCM_RATE_88200|
+						 SNDRV_PCM_RATE_96000,
+					.rate_min = 88200,
+					.rate_max = 96000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 88200, 96000 },
+					.clock = 41,
+				}
+			},
+			{
+				QUIRK_DATA_AUDIOFORMAT(2) { /* Capture */
+					.formats = SNDRV_PCM_FMTBIT_S32_LE,
+					.channels = 10,
+					.fmt_type = UAC_FORMAT_TYPE_I_PCM,
+					.fmt_bits = 24,
+					.fmt_sz = 4,
+					.iface = 2,
+					.altsetting = 3,
+					.altset_idx = 3,
+					.endpoint = 0x81,
+					.ep_attr = USB_ENDPOINT_XFER_ISOC|
+						   USB_ENDPOINT_SYNC_ASYNC,
+					.datainterval = 1,
+					.protocol = UAC_VERSION_2,
+					.maxpacksize = 0x03e8,
+					.rates = SNDRV_PCM_RATE_176400|
+						 SNDRV_PCM_RATE_192000,
+					.rate_min = 176400,
+					.rate_max = 192000,
+					.nr_rates = 2,
+					.rate_table = (unsigned int[]) { 176400, 192000 },
+					.clock = 41,
+				}
+			},
+			{ QUIRK_DATA_IGNORE(3) }, /* Firmware update */
+			QUIRK_COMPOSITE_END
+		}
+	}
+},
+
 #undef USB_DEVICE_VENDOR_SPEC
 #undef USB_AUDIO_DEVICE
-- 
2.53.0

