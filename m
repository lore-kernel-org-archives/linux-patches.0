Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78020314D0B;
	Mon,  2 Feb 2026 21:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068817; cv=none; b=MYvj9k8xtw9G1OHQz1NIGweNuc92f/uDSOTEk48Fm4nD5MzJ6mI6lCgcap0OCw3hey3EkRllJfUhVG4uuedXfpuQ/RYpxsXH3W+mFHRC25Iqs7VVpfStv4j+QabJ4MFl8PBlMBdS7CKJyYFeaFGsIQW/kVwLqt4ju2X7zeDFNis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068817; c=relaxed/simple;
	bh=FL7myEeyGHFrOKugpv3PS/Na7Tf919couL7+Cr2mTpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SQa6+UHuxMiC+LzOaRxbYIowZGfi5pfOyBw1SJ2ip8yI2ZJcP+T/e8bbYvX8RFUxWyny7mi2+PIyJUKoFR2afu13vQ/sEBK9JSMtmSkDcIeh6pgtRu42L+5wD4mCErO3rhc8lzokmhF8jbxqllfV9G61HLYKJgi72Idc3D0r40Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdSm2yYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdSm2yYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41833C4AF0B;
	Mon,  2 Feb 2026 21:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068817;
	bh=FL7myEeyGHFrOKugpv3PS/Na7Tf919couL7+Cr2mTpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdSm2yYJJ8QE/lz7hCcHn9q7u66zCHgYBDEOprtFp4zCaCvvL+tRV9GtMtEa1lKKz
	 gD3agOHCrrHxzUvzEB5Kh73uCOg4K8J9kJs0qYvAdNgI6Kj5nF5DdfR5NGbae35qUH
	 w0g+PottUFeNFvQGQjeg13+Y+aRTpF1Wwpk7Iw8cGtxlXBao/BwAw3Hew6muKjC3UJ
	 y1rXmbPDbqkYeC0F98XHvZN/HfriAb901QcpaIDyYxOKp03Rg//BFziGiCHvPX5A3T
	 KkoXmVtWrkOmfYzpMcx1orGun7TfwZvRKOrbXvtdMkKVIzmEa/wOONnC96zTg2/QPk
	 5PY4qPOF2Zvpg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lianqin Hu <hulianqin@vivo.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	pav@iki.fi,
	jussi@sonarnerd.net,
	roy.vegard.ovesen@gmail.com
Subject: [PATCH AUTOSEL 6.18] ALSA: usb-audio: Add delay quirk for MOONDROP Moonriver2 Ti
Date: Mon,  2 Feb 2026 16:46:00 -0500
Message-ID: <20260202214643.212290-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Transfer-Encoding: 8bit

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit 49985bc466b51af88d534485631c8cd8c9c65f43 ]

Audio control requests that sets sampling frequency sometimes fail on
this card. Adding delay between control messages eliminates that problem.

usb 1-1: New USB device found, idVendor=2fc6, idProduct=f06b
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: MOONDROP Moonriver2 Ti
usb 1-1: Manufacturer: MOONDROP
usb 1-1: SerialNumber: MOONDROP Moonriver2 Ti

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Reviewed-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB6217911EFC7E9224935FA507D28DA@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** "ALSA: usb-audio: Add delay quirk for MOONDROP Moonriver2
Ti"

**Key indicators:**
- The commit describes a real hardware issue: "Audio control requests
  that sets sampling frequency sometimes fail on this card"
- The fix is adding a workaround: "Adding delay between control messages
  eliminates that problem"
- The commit has proper sign-offs and review tags (Reviewed-by, Signed-
  off-by from maintainer Takashi Iwai)
- Device identification is clearly provided (idVendor=2fc6,
  idProduct=f06b)

**Missing tags:** As expected for commits needing manual review, there's
no `Cc: stable@vger.kernel.org` or `Fixes:` tag. This is NOT a negative
signal - it's why this commit needs review.

### 2. CODE CHANGE ANALYSIS

The diff shows a simple two-line addition to `sound/usb/quirks.c`:

```c
DEVICE_FLG(0x2fc6, 0xf06b, /* MOONDROP Moonriver2 Ti */
           QUIRK_FLAG_CTL_MSG_DELAY),
```

This adds a USB device ID (vendor 0x2fc6, product 0xf06b) to a quirk
flags table with the `QUIRK_FLAG_CTL_MSG_DELAY` flag.

**Technical mechanism:**
- The USB audio device (MOONDROP Moonriver2 Ti DAC/amp) has buggy
  firmware that cannot handle rapid control messages
- Without the delay, sampling frequency setting fails intermittently
- The `QUIRK_FLAG_CTL_MSG_DELAY` flag tells the USB audio driver to add
  delays between control messages for this specific device
- This is a well-established workaround pattern - other devices in the
  same file use the same quirk (e.g., Luxman D-10X, iBasso DC07 Pro)

### 3. CLASSIFICATION

**This is a HARDWARE QUIRK addition** - one of the explicitly allowed
exception categories for stable backports.

- **NOT a new feature:** The quirk mechanism already exists; this just
  adds a device to the list
- **Fixes a real bug:** Audio device fails to work properly without the
  quirk
- **Zero code logic changes:** Just a table entry addition

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- 2 lines added
- 1 file changed (quirks.c)
- No logic changes, no new code paths

**Risk:** **EXTREMELY LOW**
- The change only affects the specific USB device (0x2fc6:0xf06b)
- Users without this device are completely unaffected
- The quirk mechanism is mature and well-tested
- Similar quirk entries exist for many other devices (visible in the
  context)
- If the quirk were somehow wrong, it would only affect this one device
  model

### 5. USER IMPACT

**Who is affected:**
- Users of the MOONDROP Moonriver2 Ti USB DAC/amp
- This is a commercially available audio device that users connect to
  Linux systems

**Severity without fix:**
- Audio control requests fail intermittently
- Device may not work properly at certain sample rates
- This is a functional bug preventing normal use of hardware

**Impact of fix:**
- Device works correctly
- No negative impact on any other hardware

### 6. STABILITY INDICATORS

- **Reviewed-by:** Cryolitia PukNgae from Uniontech (likely a testing/QA
  role)
- **Signed-off-by:** Takashi Iwai (ALSA maintainer at SUSE) - trusted
  maintainer acceptance
- The pattern follows identical entries in the same file
- The quirk flag used (`QUIRK_FLAG_CTL_MSG_DELAY`) is well-established

### 7. DEPENDENCY CHECK

**Dependencies:** None
- The `QUIRK_FLAG_CTL_MSG_DELAY` flag already exists in stable kernels
- The `DEVICE_FLG` macro already exists
- The quirk handling code already exists
- This is a pure data addition to an existing table

**Applies cleanly:** The change is a simple table entry insertion that
should apply cleanly to any stable tree that has the USB audio quirks
infrastructure.

### Summary

This commit is a **textbook example** of what SHOULD be backported to
stable:

1. **Obviously correct:** Simple device ID + existing quirk flag
2. **Fixes a real bug:** Hardware doesn't work properly without it
3. **Small and contained:** 2 lines, no logic changes
4. **No new features:** Uses existing infrastructure
5. **No new APIs:** Just a table entry
6. **Falls under explicit exception:** Hardware quirk addition

The fix enables a commercial USB audio device to work correctly on
Linux. The risk is essentially zero since the change only affects this
specific device model, and the benefit is direct hardware enablement for
users who own this device.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 94a8fdc9c6d3c..8a646891ebb44 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2390,6 +2390,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d99, 0x0026, /* HECATE G2 GAMING HEADSET */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x2fc6, 0xf06b, /* MOONDROP Moonriver2 Ti */
+		   QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
-- 
2.51.0

