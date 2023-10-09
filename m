Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0BC18B00
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuSIiA5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB69FC433C9;
	Mon,  9 Oct 2023 13:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856934;
	bh=iQngd4J7yINUWxaNiWC0m1RX2lchhpP/glpuAJ2YQwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuSIiA5QKrpXGXc5B0OgkMdJhsn2k4pJqeemjenMLmqV9TuXzdKMSi0iRfniScaSJ
	 UvDQDjC+eVTDFb+JtxVVhYkzGcQrYdiEZ+8Hd1aPUv/dobOzr8upf7DCNvO/4w0SZb
	 Ve54M7m2xkISAwOxxnC4y1lhvxNBTJmM9hedIIBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Vogt <fabian@ritter-vogt.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 003/163] ALSA: hda/realtek: Add quirk for mute LEDs on HP ENVY x360 15-eu0xxx
Date: Mon,  9 Oct 2023 14:59:27 +0200
Message-ID: <20231009130124.118004625@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabian Vogt <fabian@ritter-vogt.de>

[ Upstream commit c99c26b16c1544534ebd6a5f27a034f3e44d2597 ]

The LED for the mic mute button is controlled by GPIO2.
The mute button LED is slightly more complex, it's controlled by two bits
in coeff 0x0b.

Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>
Link: https://lore.kernel.org/r/2693091.mvXUDI8C0e@fabians-envy
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 41b07476da38 ("ALSA: hda/realtek - ALC287 Realtek I2S speaker platform support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 00051c14e263a..57bd11c6057d5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7310,6 +7310,7 @@ enum {
 	ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	ALC287_FIXUP_TAS2781_I2C,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
+	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9398,6 +9399,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_coefbit,
 	},
+	[ALC245_FIXUP_HP_X360_MUTE_LEDS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_mute_led_coefbit,
+		.chained = true,
+		.chain_id = ALC245_FIXUP_HP_GPIO_LED
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9640,6 +9647,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x887a, "HP Laptop 15s-eq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x888a, "HP ENVY x360 Convertible 15-eu0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8896, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_MUTE_LED),
-- 
2.40.1



