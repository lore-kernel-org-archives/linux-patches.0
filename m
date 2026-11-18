Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034367;
	b=44OtNcL6U0Yg5DkBkv0lU+jOQ5/x/tpYvfS3zKpNfBqHArOsIJltvbALaowjR/U9IVKM
	 UmEkOJbe/mQqsLbwe/9Ws/rmDf6DFWUszFW04z2sTgcT2Smie0T+oHRppT5HX1Qy+VzmD
	 hisqwSbgSevqtsWdr111lPEr10pwA1OwRKOb89n7OqYIxNxTQIvyjYdnZxshmuEGfuGK5
	 XtTg5dLj0jUgas+rCl4RwkA+BRfa6zLEA4bv4DnGCn5JLh4CMN0Ofe1dtalzkp0yHMyfg
	 TrtNd1sJ8KTzS+7V2+g9lkADBcCeh5IUtQtHYX2my6bG4jj0AWNoLR4PyC4HiJHTL1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E+r9erCliiz2Tzdx3Gbn1YuhbVh7UzlZcx5pLTIxMy0=;
	b=UQbxM3R9WqpI6PaJF4GMxIcUa/MykFQxci6AXk923m7gkV7UaRzxj/hk48sHsbnAj+10
	 WJi4UzxOqr7RHPFcv9K2Y/9iQa3pjsvBCuUg5ealtruPDNYrP7LCIvdgS6mBDjsxakGLm
	 nHCn2lLudQLlQCkKRiZYr5fD6uNc4v853K/42dZRUv3zGs3aLMExLOQkcXy/MKfyPHm5R
	 4M4h6IURaqGBiP3dYJK5YNEd/V5lJ26kPSVM01Nz0IPstcyuYlvs8V4QAnuEcrCV90K+U
	 p0fqHqHFVgyh+u7o5NGswNxsIKhWangxo5M47qMHG+Oni/PG69qJeYT2dcwfI1sG/Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgInPUzP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A02E606A31C;
	Wed, 18 Nov 2026 20:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mgInPUzP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67ED1F000C4;
	Wed, 18 Nov 2026 20:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034367;
	bh=E+r9erCliiz2Tzdx3Gbn1YuhbVh7UzlZcx5pLTIxMy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mgInPUzPjbhb6f1JMgc0lqU+iZ1PGjBDhWPhifQW0Nsjp89WJs9WLmFiNeO9oTyh3
	 hR+u8t9QdEo/sTfffqQXXscwB1xjztx1Mja7M2EJ4DXMGqBSsScdOa/S5Q+cDj8wOe
	 xx3rO0y0WnYnyGYDuwqnWxfMnsqJEx8Gas+9qkr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tarun Noonemunthala <ntarun2000@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0345/3318] ALSA: hda/realtek: Add quirk for HP ENVY 13-aq1xxx
Date: Wed, 18 Nov 2026 15:16:07 +0100
Message-ID: <20261118150326.372172025@linuxfoundation.org>
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

From: Tarun Noonemunthala <ntarun2000@gmail.com>

[ Upstream commit a01a223bd685be42e908d970de32eeb3646097f3 ]

The HP ENVY Laptop 13-aq1xxx (PCI SSID 103c:86ad) uses an ALC285 codec
with two speaker pairs: front (pin 0x14) and bottom (pin 0x17).

The BIOS leaves pin 0x14 as [N/A] ("not connected"), so the generic
parser never enables the front pair and only the bottom speakers are
audible.  The vendor driver (RTKVHD64.sys) programs that pin with the
value 0x90170150 and runs the HP amplifier initialization, which is
already implemented in the driver as ALC285_FIXUP_HP_GPIO_AMP_INIT.

Add a board fixup that applies the pin configuration for 0x14 and chains
to the existing amplifier init fixup.

The pin value was recovered from the vendor driver's own configuration
data.  The patch and this changelog were prepared with an AI coding
assistant (see the Assisted-by tag below); the change was reviewed and
tested by the submitter on the affected machine.

Tested on an HP ENVY 13-aq1xxx by rebuilding snd-hda-codec-alc269 from
the Fedora 7.1.10 source and loading it: the codec now reports
"line_outs=2 (0x14/0x17)", pin 0x14 comes up as an output (Pin-ctls
0x40) with its amplifier unmuted, and both speaker pairs play.

Assisted-by: OpenCode:deepseek-v4.1-flash checkpatch
Signed-off-by: Tarun Noonemunthala <ntarun2000@gmail.com>
Link: https://patch.msgid.link/20260923094014.58867-1-ntarun2000@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dda1cc3592cca..06a72fafdb8d3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7455,6 +7455,7 @@ enum {
 	ALC285_FIXUP_HP_SPECTRE_X360_EB1,
 	ALC285_FIXUP_HP_SPECTRE_X360_DF1,
 	ALC285_FIXUP_HP_ENVY_X360,
+	ALC285_FIXUP_HP_ENVY_13AQ,
 	ALC288_FIXUP_DELL_HEADSET_MODE,
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
 	ALC288_FIXUP_DELL_XPS_13,
@@ -9534,6 +9535,15 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_GPIO_AMP_INIT,
 	},
+	[ALC285_FIXUP_HP_ENVY_13AQ] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170150 }, /* front speakers */
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC285_FIXUP_HP_GPIO_AMP_INIT,
+	},
 	[ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_ideapad_s740_coef,
@@ -10130,6 +10140,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x86ad, "HP ENVY 13-aq1xxx", ALC285_FIXUP_HP_ENVY_13AQ),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
-- 
2.53.0



