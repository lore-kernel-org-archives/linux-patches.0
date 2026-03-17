Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E559D3AD529;
	Tue, 17 Mar 2026 11:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747181; cv=none; b=WwNlh1fjnSIa+G6/HA7GxmF82rIP3kj0jPshOigubd8PnkQOfbQvnx7RzCE2BYHpZZnPlM+UpspaEa0oQVsz284c7/UX/8mEShzJICta0zI88OYmIiJBDEcxbCBKT1/d+TWEYbjvlnpS3ojRJdOOaRblLysnEqZoV8hHFY8GnFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747181; c=relaxed/simple;
	bh=CzgQrQGavzr07umH5YZpLcH8Rt8BobUHo2uBy57QL6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T11PYxzcXSgcV4L8W+A5LEhlGs7WhZpbawwG1/21agpmTTYWMP7PPupTvhzSvJe/yAv1HeAl2cOmXlbH8a9XkJY47XrEtO7aQ1GTIpqIKwlTtCvdq3nOCwPM9H1Qi3uVR/QD4k/tdaGL22AWE7NK81DgUJ0dZajKL/QDBxqoU2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rxo52Wpd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rxo52Wpd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C758EC2BC9E;
	Tue, 17 Mar 2026 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773747180;
	bh=CzgQrQGavzr07umH5YZpLcH8Rt8BobUHo2uBy57QL6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rxo52Wpd0EjkCeNsXHg5Gln387o8OOlgU13VV++Zh4BTx2TOgxYwAmo2DGgEyhyyA
	 O8+VQhyn7HleO0HX0x8ioHCAggh5RLS0TV9Bg48WsDJkBbxuGCvlKvZxn+c3jJjUY4
	 v6iLQRlX0BlIUsM1Z4M8gpDhttQb9pf2yKat/qigKF7DSU4FsSM3Q5JpUkasdT/8+M
	 /XZK9RrJBuYFig3e2q9YS/ztbDQvLfFl3AOCBlefo8V3ieild0LKZNlnt0cuPY0jvT
	 VBftShIPizPst9HUoXgAkubxQ6Wh5Xj9Trh5ENor6xoJqFlg+zk6+vaqrt7M6eP7bw
	 gVbFSxgcUrZCQ==
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
Subject: [PATCH AUTOSEL 6.19] ALSA: usb-audio: Add iface reset and delay quirk for SPACETOUCH USB Audio
Date: Tue, 17 Mar 2026 07:32:39 -0400
Message-ID: <20260317113249.117771-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260317113249.117771-1-sashal@kernel.org>
References: <20260317113249.117771-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit 5182e5ec4355dd690307f5d5c28cbfc5b2c06a97 ]

Setting up the interface when suspended/resumeing fail on this card.
Adding a reset and delay quirk will eliminate this problem.

usb 1-1: New USB device found, idVendor=0666, idProduct=0880
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: USB Audio
usb 1-1: Manufacturer: SPACETOUCH
usb 1-1: SerialNumber: 000000000

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/TYUPR06MB6217ACC80B70BE25D87456B0D247A@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Summary
This commit adds a USB audio quirk entry for the SPACETOUCH USB Audio
device (vendor `0x0666`, product `0x0880`), applying
`QUIRK_FLAG_FORCE_IFACE_RESET` and `QUIRK_FLAG_IFACE_DELAY` flags. The
commit message states this fixes suspend/resume failures on this device.

### Code Change Analysis
The change is a **two-line addition** inserting a `DEVICE_FLG()` entry
into the sorted `quirk_flags_table[]` array. It uses existing quirk
flags (`QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY`) that are
already used by many other devices in the same table (e.g., TEAC UD-701,
Esoteric D-05X, etc.).

### Classification: Hardware Quirk
This is a textbook **hardware quirk addition** — one of the explicitly
listed exception categories that ARE appropriate for stable backporting
despite being "additions." The quirk:
- Uses an existing driver and existing quirk infrastructure
- Only targets a specific USB device by vendor/product ID
- Applies well-understood flags already used by other devices
- Fixes a real user-facing problem (suspend/resume failure)

### Bug Being Fixed
The commit fixes a **suspend/resume failure** on the SPACETOUCH USB
Audio device. Without the interface reset and delay quirk, the USB audio
interface fails to set up properly when resuming from suspend. This is a
real hardware issue that affects users of this specific device.

### Risk Assessment
- **Scope**: Minimal — only affects this specific USB device
  (0x0666:0x0880)
- **Risk of regression**: Near zero — the flags only apply to this one
  device, and the same flags work correctly on many other devices
- **Dependencies**: None — the quirk infrastructure and flags already
  exist in all stable trees
- **Lines changed**: 2 lines added, no lines removed or modified

### Stable Kernel Rules Check
1. **Obviously correct and tested**: Yes — simple table entry, same
   pattern as dozens of others, signed off by the ALSA maintainer
   (Takashi Iwai)
2. **Fixes a real bug**: Yes — suspend/resume failure
3. **Important issue**: Yes — device unusable after suspend/resume cycle
4. **Small and contained**: Yes — 2-line addition to a quirk table
5. **No new features**: Correct — uses existing quirk mechanism
6. **Applies cleanly**: Should apply cleanly to any tree containing the
   quirk flags table

### Verification
- Reviewed the diff: confirmed it's a simple 2-line `DEVICE_FLG()`
  addition, inserted in sorted vendor ID order
- Confirmed `QUIRK_FLAG_FORCE_IFACE_RESET` and `QUIRK_FLAG_IFACE_DELAY`
  are used by multiple existing entries in the same table (visible in
  the diff context)
- Commit is signed off by Takashi Iwai (ALSA subsystem maintainer),
  indicating proper review
- The commit message includes USB device identification strings showing
  the exact hardware affected

This is a zero-risk, high-benefit hardware quirk that fixes
suspend/resume for a specific USB audio device. It meets all stable
kernel criteria.

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index a89ea2233180a..ce6f479353b22 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2239,6 +2239,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_IFACE_DELAY | QUIRK_FLAG_FORCE_IFACE_RESET),
 	DEVICE_FLG(0x0661, 0x0883, /* iBasso DC04 Ultra */
 		   QUIRK_FLAG_DSD_RAW),
+	DEVICE_FLG(0x0666, 0x0880, /* SPACETOUCH USB Audio */
+		   QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x06f8, 0xb000, /* Hercules DJ Console (Windows Edition) */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
 	DEVICE_FLG(0x06f8, 0xd002, /* Hercules DJ Console (Macintosh Edition) */
-- 
2.51.0

