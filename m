Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB7929A0;
	Wed,  7 May 2025 19:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644578; cv=none; b=qa6hELHSW/txY0OWCeq/8viHBHX3ia0MI2oEh7+qaLALfLy3USyJbqAI1G2/N/J7YzPHpOB5NXTcvRPIfXy89RJr+yMw7mtWAEffwl9tan7kMPnn1ukw9H21ACCTubdadfvmIyqiE0i1j3vBSnHYBiI2lKuqOez660oZJjE6Al0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644578; c=relaxed/simple;
	bh=M1p2vb/OAs+UC5KPRJQgT1DdLwtbznCdxvy3Wm8r14I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxXh8pFiO9ApEelUHlmqZjnlFuy51eu/zwZUo5z9GrXvwZmv/SZr7PS/8UKS+k19zrdscpHLKoTBMlQpYpMTeY6W/cGsPefUnGv6IPb/eVRq7Il/Wc4fUQ3gtAVnqe3/rikSVQbX/oAv3dKtVAUyyHPqPv2K2i0oDVrq75Eq//0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hV4TrmNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hV4TrmNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73298C4CEE2;
	Wed,  7 May 2025 19:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644577;
	bh=M1p2vb/OAs+UC5KPRJQgT1DdLwtbznCdxvy3Wm8r14I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hV4TrmNnc4KHQR5jcYugsRqKtyhuV+ijKDHleCa048VIWfaQeeNUmPTHA7cQVRwpi
	 J7KBUmCVcF9BH88hjYFn6AEUhU64hMkdK8LUrgH+apioKx6QgdwK47ue5nobe1eisM
	 rXJOpqU4OLZubmmo/SQbgkw3JmPn6R0/GHO0iorQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 059/164] ALSA: hda/realtek - Enable speaker for HP platform
Date: Wed,  7 May 2025 20:39:04 +0200
Message-ID: <20250507183823.329266258@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 494d0939b1bda4d4ddca7d52a6ce6f808ff2c9a5 ]

The speaker doesn't mute when plugged headphone.
This platform support 4ch speakers.
The speaker pin 0x14 wasn't fill verb table.
After assigned model ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX.
The speaker can mute when headphone was plugged.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/eb4c14a4d85740069c909e756bbacb0e@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4171aa22747c3..5a36cb2969b08 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -440,6 +440,10 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 		alc_update_coef_idx(codec, 0x67, 0xf000, 0x3000);
 		fallthrough;
 	case 0x10ec0215:
+	case 0x10ec0236:
+	case 0x10ec0245:
+	case 0x10ec0256:
+	case 0x10ec0257:
 	case 0x10ec0285:
 	case 0x10ec0289:
 		alc_update_coef_idx(codec, 0x36, 1<<13, 0);
@@ -447,12 +451,8 @@ static void alc_fill_eapd_coef(struct hda_codec *codec)
 	case 0x10ec0230:
 	case 0x10ec0233:
 	case 0x10ec0235:
-	case 0x10ec0236:
-	case 0x10ec0245:
 	case 0x10ec0255:
-	case 0x10ec0256:
 	case 0x19e58326:
-	case 0x10ec0257:
 	case 0x10ec0282:
 	case 0x10ec0283:
 	case 0x10ec0286:
@@ -10687,8 +10687,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8caf, "HP Elite mt645 G8 Mobile Thin Client", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8cbd, "HP Pavilion Aero Laptop 13-bg0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
-	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8cde, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
+	SND_PCI_QUIRK(0x103c, 0x8cde, "HP OmniBook Ultra Flip Laptop 14t", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8cdf, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ce0, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
-- 
2.39.5



