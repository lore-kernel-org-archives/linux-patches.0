Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37D1221DAC;
	Tue, 30 Dec 2025 13:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767100987; cv=none; b=uKKPwBfqyHMIykynngERpf0BnCY7Xde+2Xm2CtSNay1jwmZRgJjtMBSe83BGxoJPuqUsIO4SOiv4h5iriydhhgr6i5fY+ZV0+jheMn6xSiifH57tHbZzJcjrcND3xch/1bWqzD0/uxl5cP29D7WB2WQNO3BhiUupJkHbmaE8eEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767100987; c=relaxed/simple;
	bh=rv2sKhmGE05VDEL1Ymi+TRJTNaAzFADUYTVidiG52HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X498wvA+ePw/Bq7yIfIt4QM8Sj1a+rf6/ldYmDm4BH24faL1gUhrcantRs72cnFE1ScB9Fx3jTfIFT+l5fOvBRimxAOqKd5AGUzrnE+UbAj8t03xZW3w8yGs+H49lfiM4USdkb4mXLRzRsm43TV/m7sBlKdzyjUf9b8uwrM0cS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YTI2PcOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YTI2PcOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD90C116C6;
	Tue, 30 Dec 2025 13:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767100987;
	bh=rv2sKhmGE05VDEL1Ymi+TRJTNaAzFADUYTVidiG52HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTI2PcORwKT+wlrQCgBYZF34YoIrTYLVZZqQ3jYoA+u33Otvr8Mt938vv5XJVsigd
	 nodQveVs8tv571WcS+hTT/pI56gm84H9miAitpQJunid7UcBsG1wPHihy/X054u2aL
	 7zpnaGkh8gz15MImt2AfxSHh8NLJRD54ALvgadr/RlfJdSd8uwOyD5iko3HyCxDxgo
	 89XurmCTrFTvAL80uuBv1JI4sHzzkU9nZPk0IJwYMcahcSqiC8quWkFBvbAhjBa/0r
	 EVeJtPUdvFyyUGKrwpblXt5ZZmH//FRz4gcqXcY3Ic+1eLpCcVHEaRHKd/AWGemaTo
	 7/UHe/2PXRT2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jussi Laako <jussi@sonarnerd.net>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	cryolitia@uniontech.com,
	pav@iki.fi,
	hulianqin@vivo.com,
	roy.vegard.ovesen@gmail.com
Subject: [PATCH AUTOSEL 6.18-6.6] ALSA: usb-audio: Update for native DSD support quirks
Date: Tue, 30 Dec 2025 08:22:55 -0500
Message-ID: <20251230132303.2194838-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251230132303.2194838-1-sashal@kernel.org>
References: <20251230132303.2194838-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.2
Content-Transfer-Encoding: 8bit

From: Jussi Laako <jussi@sonarnerd.net>

[ Upstream commit da3a7efff64ec0d63af4499eea3a46a2e13b5797 ]

Maintenance patch for native DSD support.

Add set of missing device and vendor quirks; TEAC, Esoteric, Luxman and
Musical Fidelity.

Signed-off-by: Jussi Laako <jussi@sonarnerd.net>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251211152224.1780782-1-jussi@sonarnerd.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: ALSA: usb-audio: Update for native DSD support
quirks

### 1. COMMIT MESSAGE ANALYSIS

- **Subject:** "ALSA: usb-audio: Update for native DSD support quirks"
- **Description:** "Maintenance patch" adding "missing device and vendor
  quirks" for TEAC, Esoteric, Luxman, and Musical Fidelity audio devices
- No crash/bug keywords, but no Cc: stable or Fixes: tag is expected for
  commits under review
- Proper sign-offs from author and maintainer (Takashi Iwai, the ALSA
  maintainer)

### 2. CODE CHANGE ANALYSIS

The changes are purely **data table additions** to `sound/usb/quirks.c`:

**Device-specific entries (3):**
1. `0x0644:0x807d` - TEAC UD-507 (DSD DAC + timing quirks)
2. `0x0644:0x806c` - Esoteric XD (DSD DAC + timing quirks)
3. `0x3255:0x0000` - Luxman D-10X (DSD DAC + timing quirk)

**Vendor-wide entry (1):**
4. `0x2772` - Musical Fidelity devices (DSD_RAW quirk)

**Quirk flags used:**
- `QUIRK_FLAG_ITF_USB_DSD_DAC` - Device supports native DSD playback
- `QUIRK_FLAG_CTL_MSG_DELAY` / `QUIRK_FLAG_IFACE_DELAY` - Timing
  workarounds for device communication issues
- `QUIRK_FLAG_DSD_RAW` - Raw DSD mode support

### 3. CLASSIFICATION

This is a **device ID and quirk addition** - explicitly listed as an
allowed exception in stable kernel rules:

> "NEW DEVICE IDs (Very Common): Adding PCI IDs, USB IDs, ACPI IDs, etc.
to existing drivers"
> "QUIRKS and WORKAROUNDS: Hardware-specific quirks for broken/buggy
devices"

The entries follow the exact same pattern as dozens of existing entries
in the file.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** ~8 lines added (4 entries)
- **Files changed:** 1 file
- **Complexity:** Trivial - pure data table additions
- **Risk:** Extremely low
  - Only affects devices matching specific USB vendor:product IDs
  - No code logic changes whatsoever
  - Cannot affect any other devices
  - Uses pre-existing, well-tested quirk infrastructure

### 5. USER IMPACT

**Benefit:** Owners of these specific high-end audio DACs get:
- Working native DSD playback
- Proper device communication (timing quirks prevent USB control message
  issues)

**Without fix:** These DACs may experience:
- DSD format not working
- Audio glitches or communication failures due to missing timing delays

**Scope:** Narrow (specific device owners only), but critical for those
users.

### 6. STABILITY INDICATORS

- Signed off by Takashi Iwai (ALSA maintainer) - trusted subsystem
  expert
- Follows identical pattern to existing entries
- Zero new code paths introduced

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- All quirk flags (`ITF_USB_DSD_DAC`, `CTL_MSG_DELAY`, `IFACE_DELAY`,
  `DSD_RAW`) already exist in stable kernels
- The quirk_flags_table infrastructure has existed for many kernel
  versions

### DECISION RATIONALE

**This is a textbook stable backport candidate under the device ID/quirk
exception:**

1. **Meets stable criteria for exceptions:** Pure USB device ID and
   quirk additions to existing driver infrastructure
2. **Obviously correct:** Follows exact pattern of adjacent entries in
   the file
3. **Fixes real issue:** Enables hardware that users own to function
   properly
4. **Small and contained:** 8 lines of data-only changes in 1 file
5. **No new features:** DSD support already exists; this just identifies
   which devices can use it
6. **Zero regression risk:** Only activates for specific USB IDs; cannot
   affect other devices

The timing quirks (`CTL_MSG_DELAY`, `IFACE_DELAY`) are particularly
important as they fix actual device communication issues, not just
feature enablement.

**YES**

 sound/usb/quirks.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 61bd61ffb1b2..94a8fdc9c6d3 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2230,6 +2230,12 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x0644, 0x806b, /* TEAC UD-701 */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
 		   QUIRK_FLAG_IFACE_DELAY),
+	DEVICE_FLG(0x0644, 0x807d, /* TEAC UD-507 */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
+		   QUIRK_FLAG_IFACE_DELAY),
+	DEVICE_FLG(0x0644, 0x806c, /* Esoteric XD */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
+		   QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x06f8, 0xb000, /* Hercules DJ Console (Windows Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
@@ -2388,6 +2394,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x3255, 0x0000, /* Luxman D-10X */
+		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x339b, 0x3a07, /* Synaptics HONOR USB-C HEADSET */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
@@ -2431,6 +2439,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2622, /* IAG Limited devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2772, /* Musical Fidelity devices */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x278b, /* Rotel? */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x292b, /* Gustard/Ess based devices */
-- 
2.51.0

