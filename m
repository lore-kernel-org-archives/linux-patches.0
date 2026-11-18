Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037231;
	b=BFQHhExBra3SJNAq5jvgW0caQX9XQabxpi/qepoQfnl6Yt1yoX/fz8Oh0YisM6qwO28O
	 dYY76BYtI3h6EC5pdcczLBO2aVL1qSlPnqTYQ3WihQh/9yGlWFHMLOdXhUz4kZnfj+REq
	 SA0LzDlvXVQTdkbX/OKYLLuZ+PBqTYBM8lpCZyhs0d0arar19VYG0nXrcZEjxJmfl0rQ9
	 jxO0YYGif4U8GXbKIOoGzHcvBh9D/V3ttvBNpi+RdP08tJIAewOtMmvcnIkir6AphvPa9
	 DSNINt564y81AmKqdxuGopDCDH29oIl5R5jX0B4gtdyxbaR0FC/YsYDO+u1J35elMUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037231;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LrHK4mtWKNKFz9eJOnyXk5jdFd3kUZ45b7X6z76f0aQ=;
	b=hsk/FScxhNpm0zOAJ8XhbHmfnWZpnhHFu539W8umCgf1g+GPVfPQukAQcdlDS5Rl1CJB
	 L5ZFe1kxSHXWfcsdFENvgUi9b9f5/9EMu6rbl5LRBuWVGZIJw6GbLXCWaNCXmRiCsoyC5
	 ALP7W0L73WTOIfg44zLe6UiHKtpHKTxX13UjCDxIyVEH3pwWOAs1JQ6HE884MOa3JjYpg
	 nl8eUB5tCt7/BUuQxp0UJnNnpy2dYMoQe55UQf2Iutkc6RqoGVet5uSq6oX3ucCZSct8Y
	 01lJGcfHXsgs0S9jAm4aZBocsimEklx5J6pO/Bt3DDi59376NmJdYjdQbZKdJ1fvCkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3ZygqP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 781AE606A338;
	Wed, 18 Nov 2026 21:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3ZygqP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C571F000C7;
	Wed, 18 Nov 2026 21:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037231;
	bh=LrHK4mtWKNKFz9eJOnyXk5jdFd3kUZ45b7X6z76f0aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3ZygqP0sQ0+tlrvJnzPv3H/8s6ZPRUwSqbHPgRGNw4K1VUm5OF5XDe9vwuMcgn38
	 G4+c8rTl4KejwDYwMh+L0O7l8VXOnvTK/DQVSzO6JMd9bM8kLg/FybcRexqLIsDGzI
	 070Xrc2P0UlKCLlDMO8rQIm0CIdjHFDNf+K6iOdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Gauche <scott-dev@scottgauche.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1294/3318] ALSA: hda/realtek: Fix audio after Windows reboot on ASUS Q423SA
Date: Wed, 18 Nov 2026 15:31:56 +0100
Message-ID: <20261118150359.086455742@linuxfoundation.org>
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

From: Scott Gauche <scott-dev@scottgauche.com>

[ Upstream commit 8acd6469f42784f38872ad83b14c41152d986b63 ]

The ASUS Vivobook S 14 Q423SA-U5512 (DMI family S5406SA) with the
ALC294 codec has working analog audio when booted directly after a full
shutdown. After a warm reboot from Windows 11, audio works briefly during
Linux startup, then both the internal speakers and headphones become
silent. PCM playback continues without errors.

Coefficient 0x1b is 0x4e4b on a direct cold boot, but 0x4a4b after the
Windows warm reboot. Restoring bit 10 changes it back to 0x4e4b and
immediately enables both analog outputs. Speaker playback, headphone
playback, jack switching, cold boot, and suspend/resume were tested
successfully. The same 0x4a4b state and immediate recovery with 0x4e4b
were independently confirmed on another S5406SA with subsystem 1043:10c4.

The same coefficient write is already used by
ALC294_FIXUP_ASUS_COEF_1B for the ASUS UX431DA. That fixup cannot be
reused here because it chains to ALC289_FIXUP_ASUS_GA401 and applies
unrelated DAC routing and microphone pin configuration.

Add a model-specific fixup for subsystem 1043:10c4 and chain it to the
existing ALC2XX_FIXUP_HEADSET_MIC fixup instead.

Link: https://github.com/thesofproject/sof/issues/11051
Fixes: f2d08f3651fb ("ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA")
Signed-off-by: Scott Gauche <scott-dev@scottgauche.com>
Link: https://patch.msgid.link/20261005154017.1164657-1-scott-dev@scottgauche.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8ebbbc731f8ac..f13da29f4b90b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7521,6 +7521,7 @@ enum {
 	ALC294_FIXUP_ASUS_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_I2C_HEADSET_MIC,
 	ALC294_FIXUP_ASUS_SPK,
+	ALC294_FIXUP_ASUS_Q423SA,
 	ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE,
 	ALC285_FIXUP_LENOVO_PC_BEEP_IN_NOISE,
 	ALC255_FIXUP_ACER_HEADSET_MIC,
@@ -8863,6 +8864,17 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC294_FIXUP_ASUS_HEADSET_MIC
 	},
+	[ALC294_FIXUP_ASUS_Q423SA] = {
+		.type = HDA_FIXUP_VERBS,
+		.v.verbs = (const struct hda_verb[]) {
+			/* Restore bit 10 lost after reboot from Windows */
+			{ 0x20, AC_VERB_SET_COEF_INDEX, 0x1b },
+			{ 0x20, AC_VERB_SET_PROC_COEF, 0x4e4b },
+			{ }
+		},
+		.chained = true,
+		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
+	},
 	[ALC295_FIXUP_CHROME_BOOK] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_chromebook,
@@ -10343,7 +10355,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
-	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS Vivobook S14 S5406SA", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS S5406SA/Q423SA", ALC294_FIXUP_ASUS_Q423SA),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.53.0



