Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619234;
	b=yKX++NWzDXQR8DSci2ZSjRBMUSWnON7XcbyF+l1OyRA3cZ6XwD6m0/JTdypPvKKP8C3I
	 z16g6d7Et33rU99Ijuuw0alGoffv54iEVxyUTSFT/MnVkE3kdxnfnmoCvSv+Vy/WvqlSZ
	 ckgm1t9pWvxv/kWSj+meMXWSBefK+1O60q838XV0zoNcstg0PF/k7NWilMKECpgF40CzY
	 bq1trSd/GQgio14Q2wkhZbSEIGmRSZRor0lfs0ZPSzk7eK1MD9bQr6RcJAocBc1mA4HDr
	 wPHAVe2Us3JrWh3JVTLBV6XdK9ZOmyWFlajm8G4u2cqWkNj3n7vSSIfZSqvQr4t8Lug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qRyc5cdWZdE3JlFnjM2MDtpVB9sI9t9FQSmOvG9QT6I=;
	b=Iqkh4aEgv2spZY4tG+bAq31NxvsIY71T8ypMOxG40olmQ6MiZmtIE7vEl2Uf2SZJx/8S
	 aPJqNZyWzqArq9WBUK6pt4ejWp5nu5lcS456uOhQxcCcqIAg2OBVEl1Du+Qn8ltyM/G69
	 y/A4yrhnbUFfBqKfLZ6gqJtBoQvAvvDxdl/DSkLiQnhBRuEVZdm1Nzs+vBKBUI3+dCKwX
	 n88+g1RpdCoV9GXuSbxt0HABiEnsJHM97kz83M52Ja2nmuta7Mo3WNqYiZYWZlRfz6yyu
	 7KRT6P2VJ3LYC/ddhxhynPAepO3Fpw1Yj4edni8zAOhxvKbB5uHCCN0xGpedfoe6vFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEOOyfZ5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9284C606A31E;
	Wed, 25 Nov 2026 15:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eEOOyfZ5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCA11F000C4;
	Wed, 25 Nov 2026 15:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619233;
	bh=qRyc5cdWZdE3JlFnjM2MDtpVB9sI9t9FQSmOvG9QT6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eEOOyfZ5Y/u0xmCrm0GbCEAv7mc9t1VpZmWelNtUFMhzOpYPgMOaUQ0wMEzTmRp2g
	 1P3zb0Y/j28+eSAopEVxfiEclZl8eztvY+xG4z2jNtuk+q2Anh5UiUJaxM6xGr//eN
	 oCGMHmFfbs94J0cLbe/0YsIq/nGz6zkdz4lX7Jws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0531/1005] ALSA: hda/realtek - remove headphone MIC support for Dell Pro QC1255
Date: Wed, 25 Nov 2026 15:31:09 +0100
Message-ID: <20261125143834.186498627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 1da5e525f0526a0b8e3b6c8c3208e6fad920f126 ]

This unit don't support headphone MIC.
The popping sound will disappear when you remove it.

Fixes: 97272a5704bf ("ALSA: hda/realtek - Fixed Headphone noise issue for Dell QCM1255")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/3c8129fbfa6d4ee2b464735f2f31dffa@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index a54cd3ebaa5cd..6e62886795d8d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4436,7 +4436,6 @@ enum {
 	ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO,
 	ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX,
 	ALC287_FIXUP_ACER_MICMUTE_LED,
-	ALC236_FIXUP_DELL_HP_POP_NOISE,
 	ALC274_FIXUP_HP_89E9_GPIO,
 	ALC274_FIXUP_HP_VERBS,
 	ALC287_FIXUP_AW88399_I2C_2,
@@ -7226,12 +7225,6 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
 	},
-	[ALC236_FIXUP_DELL_HP_POP_NOISE] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = alc285_fixup_invalidate_dacs,
-		.chained = true,
-		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
-	},
 	[ALC274_FIXUP_HP_89E9_GPIO] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc274_fixup_hp_89e9_amp,
@@ -7469,12 +7462,12 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0cc3, "Dell Oasis 14 Low Weight MTL-U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0cc4, "Dell Oasis 16 MTL-H/U", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0cc5, "Dell Oasis 14", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
-	SND_PCI_QUIRK(0x1028, 0x0d56, "Dell Pro Tower QCT1255", ALC236_FIXUP_DELL_HP_POP_NOISE),
-	SND_PCI_QUIRK(0x1028, 0x0d58, "Dell Pro Micro QCM1255", ALC236_FIXUP_DELL_HP_POP_NOISE),
-	SND_PCI_QUIRK(0x1028, 0x0d5a, "Dell Pro Slim QCS1255", ALC236_FIXUP_DELL_HP_POP_NOISE),
-	SND_PCI_QUIRK(0x1028, 0x0e6b, "Dell Pro Tower QCT1255", ALC236_FIXUP_DELL_HP_POP_NOISE),
-	SND_PCI_QUIRK(0x1028, 0x0e6c, "Dell Pro Slim QCS1255", ALC236_FIXUP_DELL_HP_POP_NOISE),
-	SND_PCI_QUIRK(0x1028, 0x0e6d, "Dell Pro Micro QCM1255", ALC236_FIXUP_DELL_HP_POP_NOISE),
+	SND_PCI_QUIRK(0x1028, 0x0d56, "Dell Pro Tower QCT1255", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0d58, "Dell Pro Micro QCM1255", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0d5a, "Dell Pro Slim QCS1255", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0e6b, "Dell Pro Tower QCT1255", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0e6c, "Dell Pro Slim QCS1255", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0e6d, "Dell Pro Micro QCM1255", ALC255_FIXUP_DELL2_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
-- 
2.53.0



