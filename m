Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590795;
	b=3Af5IsNUuLvJLehUuxg8DT6vT/Oi3h5VTh7LzzbUeHS/VMKvrklFtTtBXH2HsicwIwbq
	 PhNpliMGb6jZgltR77gYxZlfzicDK1OybpiWVU0NgQgmQz5ja+kJFq5AAaGpxNXA4I6KG
	 Z4om0SsBk6KU8w13CF1iOCHqHPYuJpwfib7ba8XL4tvZBE/QRby60HLs3VufkEhWFt5mW
	 k5H67/f6aBNJT4X/dW1X2tTt/9Q/zgt7/7Yb0bDtbDDHALrybnh8nYwypSBAfJCTrKuH/
	 ENviHpt8sZizKXeSj2nfYGdk4uF2ePZF0SUtU2A0bgUksbMkKF5v7sP8iWyFsiTO5Gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+kU8oHFm34uLqGc1lR3Bq8P9VvpBCAoxR+oU565Uwdw=;
	b=kuavPvEmv6BtRNMUGS5igCeV4GKdwvtcX7cIRt0WldIHr+t4afWYnKzWCBF+FVsrg01E
	 mgjm4a3M0WkozlBU8aYF7v+rjB80fyOsg07vN+0lnbBCzeAwDX5D4m6BNdO4VyLt8kLoE
	 1lyI0EzNCokjt7U2JjdiI8Es6XtP41lqskVbLHn64Rpwb/Faeqm3nngF2TgBACbUbIk9l
	 /Mtagh/Rc3LB3L2ihgKPs0Er6EmfPhfOCb62urR9sZ3g5oXWdLvtiaj665g9SfPIN4j8X
	 Nf3f0G1pZPwMjPD1gqU1Q6UTH0ySURYF+TckwQCwvQ85fOYLdMG+dPDcQ6SeaTtYyyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JqU3IcvD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B7B6607D2CD;
	Fri, 13 Nov 2026 17:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JqU3IcvD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFD61F000C6;
	Fri, 13 Nov 2026 17:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590794;
	bh=+kU8oHFm34uLqGc1lR3Bq8P9VvpBCAoxR+oU565Uwdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqU3IcvDtaNgkAB6T2iNjZqiVKzYVn1gegdeMceFOjlunx/zWwGR0Jekz/f7NDSsi
	 a26o5HdLJ5+4MpqfarDHG+S8qA+SdKT5C9GRm0wbgphdg5kdqyoFQX5dRLey6gc22f
	 Xd0VtNUCh/KukL0dBjTcKSzxRH/vquUY7qQN3plg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaeho Cho <jaeho2025@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 685/686] ALSA: hda/realtek: Enable mute LEDs on HP OmniBook 7 17-dc0xxx
Date: Fri, 13 Nov 2026 10:53:38 -0500
Message-ID: <20261113153844.832044052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Jaeho Cho <jaeho2025@gmail.com>

[ Upstream commit 1c4f6202876a74e752a8cfd3696955f761671c7a ]

The HP OmniBook 7 Laptop 17-dc0xxx (SSID 103c:8d9c) has mute and
mic-mute LEDs on its F6 and F9 keys, but neither lights up. Its quirk
entry only sets up the two CS35L41 amplifiers, so no LED control is
registered for either key.

Writing to the ALC245 by hand with hda-verb, the mute LED responds to
COEF 0x0b bits 2-3 and the mic-mute LED to GPIO 0x04, lit when the pin
is low. That appears to match what ALC245_FIXUP_HP_X360_MUTE_LEDS
already does, so add a fixup that chains the two-amp I2C setup to it
and use it for this model.

Tested on 7.2.4 with the patched module: hda::mute and hda::micmute
are registered, and both LEDs follow the speaker and microphone mute
state, including from the F6 and F9 keys.

Signed-off-by: Jaeho Cho <jaeho2025@gmail.com>
Link: https://patch.msgid.link/20260914142445.3476212-1-jaeho2025@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: c80286aaa4ac ("ALSA: hda/realtek: Enable mute LEDs on HP OmniBook X Flip 14-fm0xxx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index fabe56399f015..ebeb6297f4715 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3952,6 +3952,7 @@ enum {
 	ALC287_FIXUP_LEGION_16ACHG6,
 	ALC287_FIXUP_CS35L41_I2C_2,
 	ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED,
+	ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS,
 	ALC287_FIXUP_CS35L41_I2C_4,
 	ALC245_FIXUP_CS35L41_SPI_1,
 	ALC245_FIXUP_CS35L41_SPI_2,
@@ -6234,6 +6235,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC285_FIXUP_HP_MUTE_LED,
 	},
+	[ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_i2c_two,
+		.chained = true,
+		.chain_id = ALC245_FIXUP_HP_X360_MUTE_LEDS,
+	},
 	[ALC287_FIXUP_CS35L41_I2C_4] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_i2c_four,
@@ -7143,7 +7150,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dcd, "HP Victus 15-fa2xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8d9b, "HP 17 Turbine OmniBook 7 UMA", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8d9c, "HP 17 Turbine OmniBook 7 DIS", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8d9c, "HP 17 Turbine OmniBook 7 DIS", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8d9d, "HP 17 Turbine OmniBook X UMA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8d9e, "HP 17 Turbine OmniBook X DIS", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8d9f, "HP 14 Cadet (x360)", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.53.0



