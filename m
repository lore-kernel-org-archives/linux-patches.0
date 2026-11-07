Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064867;
	b=u3aWcdPT/Gk4AIlmq2hqCXbvPETinTNxAZn8qLyHXMb2VmfKW7p3U7gVtrq3E0yzVBa5
	 ZL8u0jPA6WtpodnGi4KVOK5omq2nEoG0KiWT6a3RjVtr53/iJ+ldgHh4K2RzBNU7NP1rY
	 lOCn3FjRYzfx+YsF7MlUM2u+hfZLK2dOzFgxigTaN/SWBOvqPa84lPO5kd6aMgrg98tbK
	 3Mbq1ebrkkLL43vbxdj2kvSGJIDZ9mnF1oTov3yT1VYG8eU9uRRPd2UiP75DRDb2DzyCM
	 QdUG+UmigXF+S0uv7nEJCoWOqsk5DUKh+srrB6mJcQs3I9Kw3eMSB5twMg+tuMccWgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6dl3sOrPSvSnMp63wks8QTqZnguj9F/IqGRvvsR+khQ=;
	b=eilabkaPRAN+hNLnkqpdhlMTJI1espRwvApkxmyR+JDkING5csG+CT1fnAMurAu8I7Wl
	 deNA3jNOiPtPOoqfwdks9mWimXnZkbzQ++ImLHy4kZZOaCZ2lTKGn8hegcjE9oFS/fcvI
	 CZrjMlH1CraJ6LLgFR72qkenFxXasLw/hetkigGEkZWiYRJujAWUpf32nSLjKzBk0X2BG
	 aOkUWFQUX40kjIgEnVJbZ2VRny+w0EBKTHjbv/4YDD0PH3HHZpiqmB4B70pbCNKpDnl2n
	 kAIW99wXVYOCx1PzmshzodMU/8cIERZuuFPIfUvca1njWaiiH3IY1QzRf4oWvbft+Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bBPHGc9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DECE606A9D2;
	Sat,  7 Nov 2026 15:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bBPHGc9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0A01F0089F;
	Sat,  7 Nov 2026 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064867;
	bh=6dl3sOrPSvSnMp63wks8QTqZnguj9F/IqGRvvsR+khQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bBPHGc9c8q+8IQ1nIi8yBYeSG6ce1I7RypuyQ5zndjpV+nEXkjbLZ1D3izzBsG4o
	 UumATXWKTZQs3+M+cPv/NxOWV0h+y+mjCAehD2yuvAmObD2ftuy5DnOcClBoQW3szh
	 0Y4pA2W5p703KGpdNlwvhZOYwQ3lvLggFRzFAK7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0784/1257] ALSA: hda/realtek: Fix quirk for HP Laptop 15-fc0xxx
Date: Sat,  7 Nov 2026 08:51:20 -0500
Message-ID: <20261107135000.971753938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 044d41b43ee19aa29cb0c9b7b8e77fd113336522 ]

The HP Laptop 15-fc0xxx is based on an AMD platform where the digital
microphone is provided by the snd-soc-acp6x-mach driver, not by the
HDA codec. The ALC236_FIXUP_HP_DMIC quirk configures pin 0x12 as an
internal DMIC, which is a misconfiguration for this machine: the pin
is not wired to a codec DMIC and the setting has no effect on the
actual microphone path (which works via ACP6x).

Replace ALC236_FIXUP_HP_DMIC with
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO, the standard quirk used by the
closely related HP Laptop 15-fd0xxx and other ALC236 HP machines. This
removes the misleading DMIC pin config and adds proper mute LED and
micmute LED support that was missing from the original quirk.

Fixes: 720460722310 ("ALSA: hda/realtek: add quirk for HP Laptop 15-fc0xxx")
Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221233
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222044
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20261015065640.377466-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 94593267a5b82..58948a3bbda04 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4379,7 +4379,6 @@ enum {
 	ALC245_FIXUP_BASS_HP_DAC,
 	ALC245_FIXUP_ACER_MICMUTE_LED,
 	ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED,
-	ALC236_FIXUP_HP_DMIC,
 	ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO,
 	ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX,
 	ALC287_FIXUP_ACER_MICMUTE_LED,
@@ -7126,13 +7125,6 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2,
 	},
-	[ALC236_FIXUP_HP_DMIC] = {
-		.type = HDA_FIXUP_PINS,
-		.v.pins = (const struct hda_pintbl[]) {
-			{ 0x12, 0x90a60160 }, /* use as internal mic */
-			{ }
-		},
-	},
 	[ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -7775,7 +7767,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8da1, "HP 16 Clipper OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da8, "HP 16 Piston OmniBook X", ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX),
-	SND_PCI_QUIRK(0x103c, 0x8dc9, "HP Laptop 15-fc0xxx", ALC236_FIXUP_HP_DMIC),
+	SND_PCI_QUIRK(0x103c, 0x8dc9, "HP Laptop 15-fc0xxx", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8dd4, "HP EliteStudio 8 AIO", ALC274_FIXUP_HP_AIO_BIND_DACS),
 	SND_PCI_QUIRK(0x103c, 0x8dd7, "HP Laptop 15-fd0xxx", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8de8, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
-- 
2.53.0



