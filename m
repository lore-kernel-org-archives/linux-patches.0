Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3126A1E5B63;
	Sat, 14 Feb 2026 01:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031239; cv=none; b=c9M6QxGw9VvYza1v5uANAJC4ZbwFwfP0qJQcb9zgiEkiBedywF9xV4DFKh9BVtTz1JsK2JZtdmCJ5h2hODRv+WrRzTbwVGDBuE1JCKH7y3CQdPEJddOIlWFY0Q+BM2FkFbS541BjOMKfzWPACsajul8czFaFnjufHM9BerpxE4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031239; c=relaxed/simple;
	bh=+/pcj5Bw0GbA9F+PHYBt/UzOqu37C4GZtbaUyZ/Rmrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HnlkfNQJAxx6XKC5YB4LLNmFjTuIAWa0098t7cX6G0X0qPZimhDdO/61HgoacDWhm4HEW46L5/in4SrYZOdH4sYxmglIBsvya8HwJg7ggf5F3Q4xh21WtT3pgtdNHEwxwGPNX4M+xs23+467Mi1uezcPb/ErmIRSpLFU/vWwHPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qG+8gvBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qG+8gvBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03575C116C6;
	Sat, 14 Feb 2026 01:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031239;
	bh=+/pcj5Bw0GbA9F+PHYBt/UzOqu37C4GZtbaUyZ/Rmrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qG+8gvBxVIbLz8XFWTF7lVm50M8z24iYqCVa1/xt7b/oYkt2GiBciSfE3FkcCPH/7
	 Xu+fMyo0Tz5M7SGDLNTiTsOVdoK/+GYkXxhvbYJE37WrgFGxwQVVOzhOB0K84DoNXc
	 164+tAjpdpOY324746JMSt1PZ9rbOTD/boKFxCp4jPqFrsqszygYO8dwn4tmIgbJaW
	 3+4pOaVhzTQ3PvKUhvzQEOBEZ/lvDfkoEhyc85AYysLw3AmuAYxS6ZwpPcrFEKobLJ
	 J2LQmqx51PfKqjXnAVJfTuTXyHKFHVD+EGFixLnv9wPy/KshLaTH0F2YTFg6mhWvCZ
	 16q06ac5b4KVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lianqin Hu <hulianqin@vivo.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	cryolitia@uniontech.com,
	pav@iki.fi,
	neil.armstrong@linaro.org,
	jussi@sonarnerd.net,
	yelangyan@huaqin.corp-partner.google.com,
	roy.vegard.ovesen@gmail.com
Subject: [PATCH AUTOSEL 6.19-5.15] ALSA: usb-audio: Add iface reset and delay quirk for AB13X USB Audio
Date: Fri, 13 Feb 2026 19:59:55 -0500
Message-ID: <20260214010245.3671907-115-sashal@kernel.org>
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

From: Lianqin Hu <hulianqin@vivo.com>

[ Upstream commit ac656d7d7c70f7c352c7652bc2bb0c1c8c2dde08 ]

Setting up the interface when suspended/resumeing fail on this card.
Adding a reset and delay quirk will eliminate this problem.

usb 1-1: New USB device found, idVendor=001f, idProduct=0b21
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: AB13X USB Audio
usb 1-1: Manufacturer: Generic
usb 1-1: SerialNumber: 20210926172016

Signed-off-by: Lianqin Hu <hulianqin@vivo.com>
Link: https://patch.msgid.link/TYUPR06MB6217522D0DB6E2C9DF46B56ED265A@TYUPR06MB6217.apcprd06.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of ALSA: usb-audio: Add iface reset and delay quirk for
AB13X USB Audio

### Commit Message Analysis

The commit message clearly describes a **suspend/resume failure** on the
AB13X USB Audio device (vendor 0x001f, product 0x0b21). The fix adds two
quirk flags (`QUIRK_FLAG_FORCE_IFACE_RESET` and
`QUIRK_FLAG_IFACE_DELAY`) to work around the hardware's broken behavior
during interface setup on suspend/resume cycles.

### Code Change Analysis

The change is a **two-line addition** (plus a comment) to the
`quirk_flags_table[]` array in `sound/usb/quirks.c`:

```c
DEVICE_FLG(0x001f, 0x0b21, /* AB13X USB Audio */
           QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY),
```

This is inserted in the correct sorted position (by vendor ID) in the
existing quirk flags table. The quirk flags
`QUIRK_FLAG_FORCE_IFACE_RESET` and `QUIRK_FLAG_IFACE_DELAY` are pre-
existing flags already used by other devices in the table — no new
infrastructure is introduced.

### Classification: Hardware Quirk

This falls squarely into the **hardware quirks/workarounds** exception
category for stable backporting:

- **It uses existing quirk infrastructure** — the flags and the table
  mechanism already exist in the kernel
- **It targets a specific device** (USB vendor 0x001f, product 0x0b21) —
  zero risk to any other device
- **It fixes a real user-facing bug** — suspend/resume failure means the
  audio device stops working after a laptop suspends and resumes, which
  is a common operation for laptop users
- **The pattern is identical to many other entries** in the same table
  (e.g., the HP 320 FHD Webcam, Creative SB Extigy, MS USB Link headset,
  etc.)

### Scope and Risk Assessment

- **Lines changed**: 2 (plus comment) — trivially small
- **Files touched**: 1 (`sound/usb/quirks.c`)
- **Risk**: Essentially zero — this only activates for the specific USB
  device ID 0x001f:0x0b21, and the quirk flags are well-tested
  mechanisms used by many other devices
- **Dependencies**: None — the quirk flags and table infrastructure have
  existed for a long time in stable kernels

### User Impact

- **Who is affected**: Users with the AB13X USB Audio device (Generic
  brand, manufactured 2021+)
- **Severity without fix**: Audio device fails on suspend/resume — a
  significant usability problem for laptop users
- **Severity of fix**: Adds a reset and delay during interface setup,
  which is a standard workaround for USB audio devices with timing
  issues

### Stability Indicators

- Accepted by Takashi Iwai (ALSA maintainer) — the subsystem maintainer
  reviewed and merged this
- The same quirk pattern is used by dozens of other devices in the same
  table with no issues
- The change is data-only (adding an entry to a table) with no logic
  changes

### Conclusion

This is a textbook example of a **hardware quirk addition** that belongs
in stable trees. It:
1. Fixes a real bug (suspend/resume failure)
2. Is obviously correct (uses existing, well-tested quirk
   infrastructure)
3. Is tiny and self-contained (2-line table entry addition)
4. Has zero risk of regression (device-specific, no logic changes)
5. Has no dependencies on other commits

**YES**

 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index d550c84e7752f..9fb823b11caaa 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2147,6 +2147,8 @@ struct usb_audio_quirk_flags_table {
 
 static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	/* Device matches */
+	DEVICE_FLG(0x001f, 0x0b21, /* AB13X USB Audio */
+		   QUIRK_FLAG_FORCE_IFACE_RESET | QUIRK_FLAG_IFACE_DELAY),
 	DEVICE_FLG(0x03f0, 0x654a, /* HP 320 FHD Webcam */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */
-- 
2.51.0

