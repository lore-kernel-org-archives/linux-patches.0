Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590802;
	b=178H/STciNUWsZmKdnThAEUpFtT+cJiM+xrVFe/ptuvB5FJffNAu45EVT9NO2eir1PIv
	 oT/padMVosQmNKGipVZEbsiUkMlauIZ8gJq4b8XFvn2yu1vkrIWAUfMlqFAQXgl9A71nj
	 cPDDRRNS3F7T4T7LzDH2/pugczqSAO0/ApFtvo0leEnqP8Yi/w+AsN1yXq43DOh+036/g
	 dIEuOGsUcUskmRzdeQHy98p4OBkpQ/J7S7No9c3cEQCJrU7P5eqlQQgjO+OIyr6HqkfLB
	 Jzx8nxNC+b5r8ms8kwWhIM47Q4XzIDk/VdFCcFGjmAXDEechSLePNOv7VyDTGN6NE8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sKHDKfKAJFPrw7kg5HW2VWoboacYV3AiygJrzx87G8Q=;
	b=Zi/4krsqlQR0nTgG1C7qTlavHkPjIPEtDBsv0I6YBHq+vndHljQiLgboDMr873W7B+VL
	 fcC4YJevJzvt+qj3xXLkPm2uESl39t+axYBRWD/vjPrthKRpxr36JMGgQ7uh8uVACuUSJ
	 hM9KIjCtHN6UU0LeXcK2CiyHjEuZG5LOMQAHhBZhnWyo0HZxqdccyyhddD7yM0S8zdPdg
	 fMLzIC2navh7eoo5554pPyuWVvKBBz59qVOX44wA+oTF4ZpMZtSr6te+TOJdcniIRTvw+
	 Cx8aav1LjYxMsT5m6VRxeJczMczFHC0cNuBxN/fiPmP/sfiwFFmZok10nUl0EZmU0jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="VA/GDKYG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E251607D2E1;
	Fri, 13 Nov 2026 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VA/GDKYG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3DD1F000C4;
	Fri, 13 Nov 2026 17:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590802;
	bh=sKHDKfKAJFPrw7kg5HW2VWoboacYV3AiygJrzx87G8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VA/GDKYG2a9u5tYXgAR/g4HxMmQ0qkj46ybUnz232gEHs1uiYK/gijLQKbyeCFt/I
	 Dr7ge3a4jbiQ5K/ea5ev5uTsiWsU3fU9RdfLF3p8TkzAh27zm8V9+OFgnPkTv4G/8J
	 fksxVc1k+eMfNH/SqR4ItLgfQMq+qkK/pRzGpC4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgeny Akhtimirov <evgeny@devduty.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 654/686] ALSA: hda/realtek: Enable all four speaker amps on Lenovo ThinkBook X G2 IAH
Date: Fri, 13 Nov 2026 10:53:07 -0500
Message-ID: <20261113153843.910979105@linuxfoundation.org>
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

From: Evgeny Akhtimirov <evgeny@devduty.com>

[ Upstream commit f2293e7b2ddd803b1461e0490f9b2f32089c1dd0 ]

The Lenovo ThinkBook X G2 IAH (MTM 21TU) has an ALC287 codec with four
CS35L41 amplifiers on I2C (CSC3551). It reports codec SSID 17aa:3929,
which it shares with the ThinkBook 13x Gen 5, and PCI SSID 17aa:3842.

Since PCI SSID 17aa:3842 has no quirk entry, the codec SSID matches
ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD. That fixup binds only
two amps (cs35l41-hda.0 and .1), while the CS35L41 configuration table
describes four for 17AA3929. Amps .2 and .3 probe and load firmware,
but they are never bound to the codec, so half of the speakers stay
silent.

Add a ThinkPad-style fixup chain that binds four I2C amps, and match the
laptop by its PCI SSID so the ThinkBook 13x Gen 5 is not affected.

Tested with hda_model=1028:0c4d (alias to ALC287_FIXUP_CS35L41_I2C_4):
all four amps bind, apply their calibration and are runtime-active
during playback.

Cc: stable@vger.kernel.org
Signed-off-by: Evgeny Akhtimirov <evgeny@devduty.com>
Link: https://patch.msgid.link/20261009-thinkbook-x-g2-iah-v1-1-56012188aee0@devduty.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Replaced the unavailable alc287_fixup_tb_vmaster_led() callback with alc287_fixup_bind_dacs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 68b5648d51119..fabe56399f015 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3979,6 +3979,8 @@ enum {
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
+	ALC287_FIXUP_CS35L41_I2C_4_THINKPAD_ACPI,
+	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_4_THINKPAD,
 	ALC2XX_FIXUP_HEADSET_MIC,
 	ALC289_FIXUP_DELL_CS35L41_SPI_2,
 	ALC294_FIXUP_CS35L41_I2C_2,
@@ -6441,6 +6443,18 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
 	},
+	[ALC287_FIXUP_CS35L41_I2C_4_THINKPAD_ACPI] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_i2c_four,
+		.chained = true,
+		.chain_id = ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
+	},
+	[ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_4_THINKPAD] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_bind_dacs,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_CS35L41_I2C_4_THINKPAD_ACPI,
+	},
 	[ALC2XX_FIXUP_HEADSET_MIC] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc2xx_fixup_headset_mic,
@@ -7579,6 +7593,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x383d, "Legion Y9000X 2019", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3842, "ThinkBook X G2 IAH", ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_4_THINKPAD),
 	SND_PCI_QUIRK(0x17aa, 0x3843, "Lenovo Yoga 9i / Yoga Book 9i", ALC287_FIXUP_LENOVO_YOGA_BOOK_9I),
 	/* Yoga Pro 7 14IMH9 shares PCI SSID 17aa:3847 with Legion 7 16ACHG6;
 	 * use codec SSID to distinguish them
-- 
2.53.0



