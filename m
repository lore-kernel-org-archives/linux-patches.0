Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043663;
	b=s9uG7VkQZ0usqHf/MeLupPvSrI2IZy2wk5+2mvPO2RchZzZd3grX6nMnBeWrmmjGR/c1
	 iw5sLrXIZ54kMeI/MpFHGkAucbXZbvThEjvluI9PliTHhtXLDx+cs5STeJ66mZmAwEWZy
	 VPL04OMyd8avwnmDdj/tO5PUH0fFH4Ehnn8WYapivtgO7LXhFxS8oqqnEGupgBcIhlzbj
	 KkNPWbECf+UzdFUxPHoXBTzpUBVlMeoP+ARD9wwPU9+XmkzPSarmNVZ5jiHZfs85mLjdv
	 tJ3W9yC5qOmK18Y0O3duuFuCD8mTomykkOh9gj6N62VJpI0WEHELOpK80Oo0NoLLiaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rkmRm790r7g8kVoDc5h+Ho1H4mF3fDw1XEGfo2drNnU=;
	b=V3FP1E9/YlI4zqfAqem7dJN+L3+jC0gwoTl8QXP5ho9gjzvVnyl7szNdtzog1XyXsZqf
	 Z8lydd3is0+tfinm9PzKKkbZ4vZHvqEgG7qb8xXxTUTEj1SqZ6voFcFb5mploQPMVpI+/
	 JNGAHW5C0O4LSIiMzp9z2JHUlH5p2K49gEhJik81dramuYBqzcBIEPpmr2HHfNLS+C8CK
	 m9HP/LKOcOOCsMNN3HT1q3ASSQy7oMma0riMMgxYs5gfd/MmFuHaOdsILcGm0qLJ02jYR
	 J3ftqd3Qq3ShQmOxMqPqOdOYTAUof9zAEUB+LXuMoFWVF2sGoirujWPo7IJNq/a/RbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GYW2zrcb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262F6606A31C;
	Wed, 18 Nov 2026 23:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GYW2zrcb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6A01F000C4;
	Wed, 18 Nov 2026 23:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043663;
	bh=rkmRm790r7g8kVoDc5h+Ho1H4mF3fDw1XEGfo2drNnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYW2zrcbP2kWzEmvEWuBCFsKyEWss4DV12PDNSpYK8Hn5RCNjL0EiXsYzzR4yGRhS
	 +re7qhAAoyUlmE94mcC/viBxQ6mCckXzeLHj/6xSPkkloFTbnO0VJ8lRUlF9OiN0zV
	 KKzdG+xv0I43ZjY+w/Ix70m97L0vPNaOUQpIzlmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hernan Ganzo <gp@sneemgp.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0291/2857] ALSA: hda/realtek: Limit internal mic boost on HP Pavilion 15 (103c:2164)
Date: Wed, 18 Nov 2026 15:22:05 +0100
Message-ID: <20261118150211.894960862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hernan Ganzo <gp@sneemgp.com>

[ Upstream commit 786fb6b3f513937f712db5a9ba6a12cbc6982ba9 ]

The HP Pavilion 15 with the ALC3227 codec (SSID 103c:2164) exposes the full
four-step internal mic boost on pin 0x12: nsteps=3 with stepsize=0x2f, that is
0, 12, 24 and 36 dB. Combined with the ADC capture gain of +30 dB the analogue
cascade reaches 66 dB, and the internal microphone clips on the ambient noise of
a quiet room; the upper two steps are unusable at any useful input level. This
is the defect class ALC269_FIXUP_LIMIT_INT_MIC_BOOST exists for.

The machine matches no SSID quirk and falls through to the pin table, which
selects ALC269_FIXUP_HP_MUTE_LED_MIC1 through a pin signature shared with
several other HP models. Add an SSID entry instead, using
ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED: the existing fixup that applies
alc269_fixup_limit_int_mic_boost() and chains to the same mute LED fixup, as
already done for 103c:218b. The boost becomes 0 or 12 dB and the LED handling is
unchanged.

Tested on the affected machine by selecting the same fixup through the model
string (snd-hda-intel.model), which bypasses the SSID and pin tables, with the
driver confirming the selection:

  snd_hda_codec_alc269 hdaudioC1D0: ALC3227: picked fixup limit-mic-boost (model specified)

With that, Internal Mic Boost reports Limits 0 - 1 (0 or 12 dB) instead of 0 - 3
(0 to 36 dB), so alc269_fixup_limit_int_mic_boost() clamps this codec's internal
mic pin as intended. Note that /proc/asound/card1/codec#0 keeps printing the
unclamped hardware caps (nsteps=0x03): that file reads codec parameters uncached
by design, while the fixup overrides the driver's cached parameter that the
control is built from.

This does not by itself make the default capture volume sane -- the remaining
12 dB on top of the +30 dB ADC gain is still hotter than this machine's usable
operating point. It removes the two unusable steps from the hardware range, which
is what a quirk of this class can do.

Signed-off-by: Hernan Ganzo <gp@sneemgp.com>
Link: https://patch.msgid.link/20260921205538.41192-1-gp@sneemgp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0fb7607817e76..f2450c59e661c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9860,6 +9860,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x18e6, "HP", ALC269_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x2164, "HP Pavilion 15 Notebook PC", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x218b, "HP", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x21f9, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2210, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
-- 
2.53.0



