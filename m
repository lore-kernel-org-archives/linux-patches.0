Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034359;
	b=g1wT3b4jXIEJ44PxDN3xmeJ65oqY9k3sVhNOxstAtdhs35THPNZDvuLbczq8gBx2G9j2
	 QbB1NSesEn+uT4OcMKGi+jxaEVVZHPalookEZNE1c1yXbSthONczv0A6v/WrWJyYh3gE3
	 CLpPcLbN7iNlNaJ4zCsX1Eal1TuLjCbPyBVKqnjGb4ILo2SAVwv+EAxidfUboFkfoqWPv
	 +ASFweFvNjvTI/k6F9KGpbekcVJ/j5C5zeHFqvOdM3wwNEdscj2rGWISSqOcbhRgV/gGM
	 HerapC04S1yJNULM678ZIKk/NNUlczd7KT6e+G/fwl4lIYV2aVjDYtZEaCXPbbHJZkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034359;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nn3hS8FhRan9aIgkakE8ddQzj9006u4VjJde4Ygq+Tw=;
	b=Erh2WedUcsT5WZx+/4heSG418u83/AdCIUxok6Og2g5cKsh2W24xH/FyrBUrHtfbr4n9
	 NcdOuMDDb8fWxc74T17YSq+jzeHMmaRKq/yBx4Qafjihqxbt4+juLF5CZ+fB5C8e3N+it
	 vPRtN6MQJWkZoFeHeDlQ2Ik6p7mxYYJkvLxp+k1TBg6CAcJ86UqwUonW9wKdmpkq6Zwrr
	 YFuxDN5vJtEtk9DhMAXmEJM4KHjMngx7kq5IuhRirXVio0w2i22PdBj+RvUAzZLPF6Io5
	 wFq2ZDjmA1AP82k0o4MJYScywD10tUZy20WU90q3Q17MFqEwfOny4bU9qbJ810WbQ3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWK8P6iN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5221B606A320;
	Wed, 18 Nov 2026 20:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWK8P6iN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644CC1F000C4;
	Wed, 18 Nov 2026 20:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034358;
	bh=nn3hS8FhRan9aIgkakE8ddQzj9006u4VjJde4Ygq+Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWK8P6iN+QgbB89sBVk3govDw1NknvgVtWN4GgotE5fRkyKkyqBhxBdTse7U05hbE
	 4+CXNKBgfWLLUc3fbjVMvgzvNQMYw97vwLvmrM9EfbcP/p2+fmGh7vGS8GeJ0mrgbT
	 ZyXG64A0gdPZjtnwLOowpYGAIr3Llqw3FC1YU9Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hernan Ganzo <gp@sneemgp.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0342/3318] ALSA: hda/realtek: Limit internal mic boost on HP Pavilion 15 (103c:2164)
Date: Wed, 18 Nov 2026 15:16:04 +0100
Message-ID: <20261118150326.261679080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4499d4fb1d869..921331681a4ca 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10045,6 +10045,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x18e6, "HP", ALC269_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x2164, "HP Pavilion 15 Notebook PC", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x218b, "HP", ALC269_FIXUP_LIMIT_INT_MIC_BOOST_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x21f9, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
 	SND_PCI_QUIRK(0x103c, 0x2210, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC1),
-- 
2.53.0



