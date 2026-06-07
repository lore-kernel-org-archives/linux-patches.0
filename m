Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6761C3242DF;
	Sun,  7 Jun 2026 10:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829959; cv=none; b=g6+D0CKk25Qlz3oRqebiMf2zGFA/iBtI+Yfih64wOVPYff+1Ih9nqdrRrGca+TajuufnCYiB9Vaki3TJxjEqPAbn+euJG9rHW1UGp6l3/XrhljjY5VenAw0ykls7VjX2PdYukEi6wzY5AqomAUZYMbGVk64/O1WChTi70BVkmXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829959; c=relaxed/simple;
	bh=XpIfhth1euCG4Ky75Ghrags8Wnc7C3XSFfL/Qh5fGpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdzpgIkDTJwfekdWXhf9UMulaBZ8UFLNXG2wClT49grC3wSgEzPYQUS+6dHH/S2jCvtyTUxdosfzUkAVSK4JxAug5Xv3GX7nmFSvPrqM4uVdYtVIyweL58PPfY4kH/HXWllkrrpkBQpym9z59esFdNTAG5MwjY40teXNaTkJytI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZMeDwtM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZMeDwtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0D61F00893;
	Sun,  7 Jun 2026 10:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829958;
	bh=PyMzI4NqXwgwkEzt0se74Ynj8SwYuV+4WHSVUsVuc88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0ZMeDwtMUU9q/oSkWgkfMtCJ3KMU2eHLv7T0/zVJoyNLpzhGV0pf+XVVUOKVBs2mP
	 M6JihdFcYTK9jPfcllL8HF0IFQoE+a5YKwYdFvN89BTC9YH09PTpskOyhg/2UJVmUY
	 SkgQ86Fkhrp/rIZKK97zFcBUGhU2Z15BAxQPHqNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Antunez Antonio <fer.antunez24antonio@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 323/332] ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP Envy X360 15-fh0xxx
Date: Sun,  7 Jun 2026 12:01:32 +0200
Message-ID: <20260607095739.987565985@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Antunez Antonio <fer.antunez24antonio@gmail.com>

[ Upstream commit dc1e0172be54e742bccb28d5f14c0c395e28c098 ]

This enables the mute and mic-mute LEDs on the HP Envy X360 15-fh0xxx
2-in-1 laptops.
The quirk 'ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX' has been created and
is now enabled for this device.

This is my first patch, and I'm still getting to grips with the code,
so there's probably a better way to implement this fix.
I apologize for any inconvenience caused by the constant release of
new versions of this patch.

Signed-off-by: Fernando Antunez Antonio <fer.antunez24antonio@gmail.com>
Link: https://patch.msgid.link/20260504-hpenvy-muteled-fix-v3-1-5567fd9b3d25@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 9e5fb6098d21 ("ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP 16 Piston OmniBook X")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4132,6 +4132,7 @@ enum {
 	ALC245_FIXUP_ACER_MICMUTE_LED,
 	ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED,
 	ALC236_FIXUP_HP_DMIC,
+	ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6678,6 +6679,12 @@ static const struct hda_fixup alc269_fix
 			{ 0x12, 0x90a60160 }, /* use as internal mic */
 			{ }
 		},
+	},
+	[ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_i2c_two,
+		.chained = true,
+		.chain_id = ALC245_FIXUP_HP_X360_MUTE_LEDS
 	}
 };
 
@@ -7096,7 +7103,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8be6, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be7, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy x360 2-in-1 Laptop 15-fh0xxx", ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),


