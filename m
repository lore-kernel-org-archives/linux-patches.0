Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9A03382F0;
	Mon,  6 Apr 2026 11:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775473563; cv=none; b=LuRwTI0bBwXdStKK0nWSJFp2Nuj2Fgw1QIAq1EadMKrYLE9FDQWtPtffJ8NeuEQnJHDAeYGvnc5MMPDoeFWt5O5rHgKZ7jS1QzgxhLe+bNCbnpOrSvFIeax5waOibPAjRybxfWRXE3m5WJ1M69lldjJOvbS0Iz3UJjdD0DR62GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775473563; c=relaxed/simple;
	bh=JAYOeWHxEzIhpHJT+74rHD7g5O/Iqd87+CMYHpju3kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CjaLafdqHn96ZtNktwD29fNW3YI0MPFEnqtA9Ho1Q0m3/+RZYtCulbFxl4se+oFubs83e/ePYPp+iUaLDYJYeApajNxCiXvNGI8GRy4AymbLEh6BuoH4YUX+xKa6MQCosOebaGIgnOX0UGkEWt9QXRkpLjmdC8oWe20PbJ6qWDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MZfb7wB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MZfb7wB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C6CC2BC9E;
	Mon,  6 Apr 2026 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775473563;
	bh=JAYOeWHxEzIhpHJT+74rHD7g5O/Iqd87+CMYHpju3kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZfb7wB2MkmJg8mLf6fcRVTsUBn+sOgKaSZzTHIa6DOiWt2oBKPpbLykboPyYvJ3V
	 6Q7iQvvV9bl3WFRH2DWpWuplKX/2YN4jEbmhO5wQKakCd1AgbZkOLFo3l/pQ/EKvpv
	 siVEosbvL7M2pU8EYQsWSMKWNYElY9QZ4Y1w6xkL4n0SeuMfVJY2MdQDkE+uZYqu/l
	 qfmhEZ56D/74F6vg+MXwXRJRTZQ4g1Su0Ar+/ui+UxUcTCT3bGMsZBlv1P0bLk1epE
	 zlPj+Sx+Ln9JlllQ3x2Zj2TUKOW8HpnCaRyh2GPn5akXYB/Io1noSuuUzk5i7R5RTz
	 78xpn8ZZI5QMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Phil Willoughby <willerz@gmail.com>,
	Yue Wang <yuleopen@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex
Date: Mon,  6 Apr 2026 07:05:41 -0400
Message-ID: <20260406110553.3783076-7-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406110553.3783076-1-sashal@kernel.org>
References: <20260406110553.3783076-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.11
Content-Transfer-Encoding: 8bit

From: Phil Willoughby <willerz@gmail.com>

[ Upstream commit bc5b4e5ae1a67700a618328217b6a3bd0f296e97 ]

The NeuralDSP Quad Cortex does not support DSD playback. We need
this product-specific entry with zero quirks because otherwise it
falls through to the vendor-specific entry which marks it as
supporting DSD playback.

Cc: Yue Wang <yuleopen@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Phil Willoughby <willerz@gmail.com>
Link: https://patch.msgid.link/20260328080921.3310-1-willerz@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is crucial. The lookup iterates the table and **returns on first
match** (line 2572). Since DEVICE_FLG entries (product-specific) come
BEFORE VENDOR_FLG entries in the table, the product-specific entry for
0x152a:0x880a will be found first, preventing the VENDOR_FLG(0x152a,
QUIRK_FLAG_DSD_RAW) from being applied.

The zero flags entry with `return` means the device gets no quirk flags
at all - exactly what's needed for a device that doesn't support DSD.

Record: [Lookup is first-match-wins. Product entry precedes vendor
entry. Fix is trivially correct.]

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE?

The vendor entry (commit 68e851ee4cfd2a) is confirmed present in v5.15+.
All active stable trees (5.15.y, 6.1.y, 6.6.y, 6.12.y) contain this
vendor-level entry that incorrectly applies DSD_RAW to all Thesycon-
based devices including the NeuralDSP Quad Cortex.

Record: [Bug exists in all active stable trees v5.15+]

### Step 6.2: BACKPORT COMPLICATIONS
This is a 2-line addition to a sorted table. The surrounding entries may
differ slightly in stable trees, but the table structure is the same.
The entry needs to be placed in the correct sorted position (by vendor
ID 0x152a).

Record: [Clean apply expected, possibly minor context differences due to
different table entries]

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY SUBSYSTEM
- **Subsystem:** sound/usb (USB audio) - part of the ALSA subsystem
- **Criticality:** IMPORTANT - USB audio devices are widely used (audio
  interfaces, headsets, DACs)
- **Maintainer:** Takashi Iwai applied this commit directly

Record: [ALSA USB audio subsystem, IMPORTANT criticality, applied by
subsystem maintainer]

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Users of the NeuralDSP Quad Cortex (a popular guitar effects processor /
audio interface used by musicians).

Record: [Affected: NeuralDSP Quad Cortex users (device-specific)]

### Step 8.2: TRIGGER CONDITIONS
The bug triggers every time the device is connected to a Linux system -
the incorrect DSD quirk is always applied.

Record: [Trigger: every device connection, 100% reproducible]

### Step 8.3: FAILURE MODE SEVERITY
With DSD_RAW incorrectly applied, the device may:
- Present DSD playback modes that the device doesn't support
- Potentially cause audio failures or incorrect audio routing
- Confuse audio applications about device capabilities

Record: [Failure mode: incorrect device capabilities reported, potential
audio dysfunction. Severity: MEDIUM]

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** Makes a specific USB audio device work correctly on Linux
- **Risk:** Essentially zero - 2-line table entry, only affects this one
  device, zero flags means "no quirks"
- **Ratio:** Very favorable - high benefit (device works correctly),
  essentially no risk

Record: [Benefit: HIGH for affected users. Risk: VERY LOW. Ratio:
strongly favorable]

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a real hardware issue for NeuralDSP Quad Cortex users
- This is a hardware quirk entry - an explicit exception category for
  stable
- 2-line change, trivially correct, zero regression risk
- Applied by ALSA subsystem maintainer (Takashi Iwai)
- Bug exists in all active stable trees (v5.15+)
- First-match-wins lookup logic is well-understood and the fix mechanism
  is proven

**AGAINST backporting:**
- No explicit Cc: stable tag (expected - that's why it's being reviewed)
- Device-specific (only affects Quad Cortex users)
- No crash/security/data-corruption - "just" incorrect device behavior

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - trivially correct table entry
2. Fixes a real bug? **YES** - incorrect DSD quirk applied to
   unsupported device
3. Important issue? **MEDIUM** - not a crash, but makes device
   unusable/buggy for its users
4. Small and contained? **YES** - 2 lines in one file
5. No new features or APIs? **YES** - no new features
6. Can apply to stable trees? **YES** - simple table entry

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**YES - This is a hardware quirk/workaround.** This is explicitly listed
as an exception category that is automatically YES for stable. It's a
device-specific entry in a USB quirk table to fix incorrect behavior for
a specific device.

### Step 9.4: DECISION
This is a textbook hardware quirk entry for stable. It's a 2-line
addition to a quirk table that prevents incorrect DSD flags from being
applied to a specific USB audio device. The fix is trivially correct,
zero risk, and falls squarely in the "hardware quirks" exception
category.

## Verification

- [Phase 1] Parsed tags: Cc to maintainers, Signed-off-by from author
  and Takashi Iwai (maintainer). No Fixes tag, no Reported-by.
- [Phase 2] Diff analysis: +2 lines, adds DEVICE_FLG(0x152a, 0x880a, 0)
  to quirk_flags_table[]
- [Phase 3] git blame: VENDOR_FLG(0x152a) introduced by commit
  68e851ee4cfd2a (2021-07-29), confirmed present in v5.15
- [Phase 3] git merge-base: confirmed 68e851ee is ancestor of v5.15
- [Phase 5] Code analysis: snd_usb_init_quirk_flags_table() at line 2562
  uses first-match-wins (returns on line 2572), so product-specific
  DEVICE_FLG entries override VENDOR_FLG entries
- [Phase 5] VENDOR_FLG(0x152a) at line 2434 sets QUIRK_FLAG_DSD_RAW for
  all Thesycon devices
- [Phase 6] Bug exists in all active stable trees (v5.15.y, 6.1.y,
  6.6.y, 6.12.y)
- [Phase 6] Expected clean apply (simple sorted table insertion)
- [Phase 7] Applied by Takashi Iwai, ALSA/USB audio subsystem maintainer
- [Phase 8] Failure mode: incorrect DSD capabilities reported for
  device, severity MEDIUM
- [Phase 8] Risk: essentially zero (2-line table entry with zero flags,
  affects only one device)
- UNVERIFIED: Could not access lore.kernel.org discussion due to bot
  protection. This does not affect the decision as the technical merits
  are clear.

This is a standard hardware quirk entry - one of the explicitly listed
exception categories for stable backporting. The fix is trivially
correct, minimal (2 lines), zero risk, and prevents incorrect behavior
for a specific USB audio device. It meets all stable criteria.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 09ed935107580..564e7ed9ac62c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2299,6 +2299,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x13e5, 0x0001, /* Serato Phono */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x152a, 0x880a, /* NeuralDSP Quad Cortex */
+		   0), /* Doesn't have the vendor quirk which would otherwise apply */
 	DEVICE_FLG(0x154e, 0x1002, /* Denon DCD-1500RE */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x154e, 0x1003, /* Denon DA-300USB */
-- 
2.53.0

