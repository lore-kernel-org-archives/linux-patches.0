Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43411ADC97;
	Sat, 14 Feb 2026 01:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031037; cv=none; b=XvPnKKtsIRpd9GMGa8EKDZa8s8+JW+FYUYoQ9IVDCd4shYRsRqUvV0Z92qVMVE6ocXMYWQywatQBoJCdwVnaiJ5R5ShGjoqWaW/xUWX4edqW8suBC6CW8+5zc84YEYwGUprTZA+5k06vZy+1u6Tt0w1694LYK3HRu3RULtAPQAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031037; c=relaxed/simple;
	bh=wp6srzVUS+Ym29uhNw1bZLJfaEjg1qWRMSXqHd2mJKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YE3kQlBU/1lJwbHVB9dihjq6C+sLL3wK4gtGC1v+hX1+40c7YNLrilUYm2oK2P+e1CTuH2kA0lmfhWw1w8yU3qNrqTsur/D9ZCcLGLEfbJoFAMn7uVLfQrIxUKRB5uiC6QDAgRgv+rXYdpl0mw++XruAet8wWoKgacKLIJRhtAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uyyuo7vL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uyyuo7vL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B65DC16AAE;
	Sat, 14 Feb 2026 01:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031037;
	bh=wp6srzVUS+Ym29uhNw1bZLJfaEjg1qWRMSXqHd2mJKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uyyuo7vL7p+LssRm3jmBgbYQzjGmXVdiBY3V19hpRKx86v8dH4sE6pqOQW1IIzSZl
	 IoqRErdNOLLaurTO1DViMGuog3cwsJOcuYIsnKluj+wwt9ymgsh3fR9I8l2g4HZs+H
	 zyswyBPbxOrpflGxwoNoA3piDwl3ahNR/Y8f5wFDpSH7HpxNrlzkoW4PFqodfFXm89
	 jLiE2JjWRpKFn1nm64Puc4AtGx1k+AoSTTQ76ZI5nSYB6u6cKlOgz3sly8PZhu9fGt
	 cuTNrFtQBI03mRVXcCSXn4kUPd59nsXsPACxkuudeKFbaIXw+Xhdl49Rl7W61sjo1+
	 RWkf5OV2k4MtA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qihang Guo <v-conet@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	cryolitia@uniontech.com,
	pav@iki.fi,
	hulianqin@vivo.com,
	neil.armstrong@linaro.org,
	jussi@sonarnerd.net,
	yelangyan@huaqin.corp-partner.google.com,
	roy.vegard.ovesen@gmail.com
Subject: [PATCH AUTOSEL 6.19] ALSA: usb-audio: Add DSD support for iBasso DC04U
Date: Fri, 13 Feb 2026 19:58:33 -0500
Message-ID: <20260214010245.3671907-33-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qihang Guo <v-conet@outlook.com>

[ Upstream commit fe7cd89f0e29f0852316857b4861309f9b891370 ]

Vendor ID 0x0661 is assigned to Hamamatsu Photonics K.K.,
but is used by iBasso for iBasso DC04U (0x0661:0x0883),
which supports native DSD playback.

This patch adds QUIRK_FLAG_DSD_RAW for iBasso DC04U, enabling
native DSD playback (DSD_U32_BE). The change has been verified
on Arch Linux using mpd and pw-cat.

Signed-off-by: Qihang Guo <v-conet@outlook.com>
Link: https://patch.msgid.link/TYYPR01MB14098529E0BD900921BE6F42CF465A@TYYPR01MB14098.jpnprd01.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis
This commit adds a USB device quirk flag (`QUIRK_FLAG_DSD_RAW`) for the
iBasso DC04U (USB ID `0x0661:0x0883`), enabling native DSD playback
support. The author has verified the change on Arch Linux with mpd and
pw-cat.

### Code Change Analysis
The change is a **two-line addition** to the `quirk_flags_table[]` array
in `sound/usb/quirks.c`:

```c
DEVICE_FLG(0x0661, 0x0883, /* iBasso DC04 Ultra */
           QUIRK_FLAG_DSD_RAW),
```

This is a textbook **hardware quirk addition** — adding a device-
specific flag entry to an existing table using the existing `DEVICE_FLG`
macro and existing `QUIRK_FLAG_DSD_RAW` flag. No new code paths, no new
infrastructure, no functional changes to any other device.

### Classification
This falls squarely into the **"QUIRKS and WORKAROUNDS"** exception
category for stable backports. Hardware quirks for specific devices are
explicitly allowed and common in stable trees because:

1. They only affect the specific device (vendor `0x0661`, product
   `0x0883`)
2. They use existing infrastructure (`QUIRK_FLAG_DSD_RAW` already
   exists)
3. They enable hardware to function correctly for users who own the
   device
4. Zero risk of regression for any other device or subsystem

### Risk Assessment
- **Risk: Extremely low.** This is a two-line, data-only change to a
  device table. It cannot affect any other device. The `DEVICE_FLG`
  macro and `QUIRK_FLAG_DSD_RAW` flag already exist in stable trees.
- **Benefit: Enables native DSD playback** for iBasso DC04U users on
  stable kernels. Without this quirk, the device cannot use its native
  DSD playback capability.
- **Dependencies: None.** The `QUIRK_FLAG_DSD_RAW` flag and the quirk
  table infrastructure already exist in stable kernels.

### Scope and Impact
- 1 file changed, 2 lines added
- Only affects users with the specific iBasso DC04U device
- Verified/tested by the author on real hardware
- Accepted by the ALSA subsystem maintainer (Takashi Iwai)

### Nuance
While this doesn't fix a crash or security issue, it's a hardware
enablement quirk — the kind of change that is routinely and explicitly
accepted into stable trees. The device simply doesn't work properly (no
native DSD playback) without this entry. Users of this USB audio device
on stable kernels would benefit from having it.

### Conclusion
This is a minimal, zero-risk hardware quirk addition that enables
correct functionality for a specific USB audio device. It follows the
well-established pattern of device quirk entries in
`sound/usb/quirks.c`, uses existing infrastructure, and has been tested
on real hardware. This is exactly the type of addition that stable
kernel rules explicitly allow.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 2d9f28558874c..d550c84e7752f 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2236,6 +2236,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x0644, 0x806c, /* Esoteric XD */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY |
 		   QUIRK_FLAG_IFACE_DELAY | QUIRK_FLAG_FORCE_IFACE_RESET),
+	DEVICE_FLG(0x0661, 0x0883, /* iBasso DC04 Ultra */
+		   QUIRK_FLAG_DSD_RAW),
 	DEVICE_FLG(0x06f8, 0xb000, /* Hercules DJ Console (Windows Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
-- 
2.51.0

