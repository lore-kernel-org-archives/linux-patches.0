Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831267;
	b=RwyotjSH/2sqWsHJKRxk31GnNS1DiFV+gG8yx/EuwPzo2kxaBxFz/bZ7MPN84zU4k36S
	 Cp8idQcMto//d0AznLpZPgq6GZLp1yW49S3KeME84tSrxkGPmoz34TWNAe4SqSjBhiU+P
	 dah6CQQFyvZkAG3f3IG6dlhxLiKmTEoGop3wtvOZWK5VF6SKh8IX40c3HUWxF0rxOrV2m
	 k2vtBGCHGJMtJmgJA62vIE532hvYGja8IPVO/IAWlSpEixQkR5WT3gS2Jy8mJ8QDTci5x
	 qO5Y/d2MEdrF9Uutz+1WoTCKqmuc1uqDEzIyBz14zsaPZSZRtjZJkwV2zfPu3EB4NGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M55KiIq3HeULdG/Ez1p5+EQ+gB5rI/B3ne5essSvhvU=;
	b=AsynPnltSPTyQaW8Dz/7IPn/jTHfLQ6UCaAoImVHYXI2y6W+S7ypkBYfL4gBOoD+r0Lq
	 rQNALjpGl8nT/tSDHolL7Op5RlxL+QhMsBr/gCN/EqS8gE1+L0U9LO8Cwhz7Zuq6h50tr
	 kkVfMwXpeIl7XASFqo4rfhBeY3YYRQfJmsnxvXNLC5jIrvl0dNWaVRpoixoS9t6xC085x
	 B4yDaL26MdUMoKxZZmb/AshcZ635/YmuvsFLNy3mA7zaDCfv+rTHW0MQXJRLUhp58doM7
	 ObC0rPPgluZkF4l8qpJQLXaxmdeBsT9YHxRdB21GFLBl5u2VSSLFrzzEEbHarNq1vbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSjZiXnI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C842606EE93;
	Wed,  4 Nov 2026 22:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PSjZiXnI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82361F000C1;
	Wed,  4 Nov 2026 22:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831267;
	bh=M55KiIq3HeULdG/Ez1p5+EQ+gB5rI/B3ne5essSvhvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSjZiXnIgQd/2YA3yZdkTvoqRvbR7ZzHThzdKaJWz1RlRycVCEPuJPUs/9xcQxIiR
	 GIkrc9xdg34ClA/QrLPXD3LWc3Aq6tMhfXLe2KG2jfH5z7XR6txPHcrptFXH+EP2Rp
	 Rkfjw/bPAWg4DgAxC3UxURqQgfYVuBfrikld6RVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0602/1005] ALSA: hda/realtek: add quirk for Acer Nitro ANV15-51
Date: Wed,  4 Nov 2026 16:05:35 -0500
Message-ID: <20261104211100.714372033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit aa4876fe2d9fcbcaa0592b25f34ec6f6ea7876c1 ]

fix mute/micmute LEDs and headset microphone for Acer Nitro ANV15-51.

[ The headset microphone issue is solved by Kailang]

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220279
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260209134149.3076957-1-zhangheng@kylinos.cn
Stable-dep-of: 819f6aacbb1d ("ALSA: hda/realtek: Add micmute LED quirk for Acer Swift SFG16-72")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a25c92834e722..d26277907b6a8 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4007,6 +4007,7 @@ enum {
 	ALC269_FIXUP_POSITIVO_P15X_HEADSET_MIC,
 	ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK,
 	ALC256_FIXUP_VAIO_RPL_MIC_NO_PRESENCE,
+	ALC245_FIXUP_ACER_MICMUTE_LED,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6576,6 +6577,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		},
 		.chained = true,
 		.chain_id = ALC269_FIXUP_LIMIT_INT_MIC_BOOST
+	},
+	[ALC245_FIXUP_ACER_MICMUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_coef_micmute_led,
+		.chained = true,
+		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
 	}
 };
 
@@ -6630,6 +6637,11 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x171e, "Acer Nitro ANV15-51", ALC245_FIXUP_ACER_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x172c, "Acer Nitro ANV16-41", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1731, "Acer Predator PHN16-72", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x173a, "Acer Swift SFG14-73", ALC245_FIXUP_ACER_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x1758, "Acer Nitro ANV15-41", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
-- 
2.53.0



