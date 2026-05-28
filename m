Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A9A1C3318;
	Thu, 28 May 2026 20:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000119; cv=none; b=oPrGiqClN6IeI62q0TPCT9yo3vdRLLDaEi4hkabrqF2i2m3pS5wslSwRy784O2UucOKcUU7M3ZUQURPFkcZNSnwzk6y8lUhmakOb69J4hiOE0WbSt60O0K/he+RXhYxh1+QASyLaSp94bvEwkBAVvo2AJhjaWVyqw1mozz+fz64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000119; c=relaxed/simple;
	bh=ruAr4k9evQm4LCzSAZYh0a401KI9u/I5PpKscPEAcro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9HDudG2I7mRM3M3NtmZXbLdMtzShZbnmBUJk5qg2pXp+6v/XYO4JDANqdNi5oRP6OtvJvUY4IsdeUkTH6cWzYN3mGHouvtsGEy430gTwlayXlEyf4/R4Kc2hqEm29YmEd8wv3fEFOqhQwwgZE56ZEyc6k3wlnq+UqUyTKmqk0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jntlaljn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jntlaljn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022DB1F000E9;
	Thu, 28 May 2026 20:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000118;
	bh=MFUlFSYwEUgyGtukHfAwJy7dKSGARVJQgwm1qepaf0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JntlaljniSjs0O+ULKwBeBHlRH/U0QuU3K0U+TXhe7LPbq9raFTbQfuWJljcxPl6a
	 1CYL5xg9kU8llVEGd3nWgqRPrxjlSckL31q+Zbwfwv6u7ShFO9MjEL8fHSqNEER2Cn
	 zz8HP7MKZggB6I2wyYtgiDxd1hMR2d5rNPSPyM3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Naim <dnaim@cachyos.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/377] ALSA: hda/realtek: Use ALC287_FIXUP_TXNW2781_I2C for ASUS Strix Gxx5
Date: Thu, 28 May 2026 21:49:06 +0200
Message-ID: <20260528194647.292879557@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Naim <dnaim@cachyos.org>

[ Upstream commit 4372286ac774536e8e68bc6dfa0f0b0152b31fce ]

These devices were incorrectly using the ALC287_FIXUP_TAS2781_I2C quirk
leading to errors:

[ 18.765990] Serial bus multi instantiate pseudo device driver TXNW2781:00: error -ENXIO: IRQ index 0 not found
[ 18.768153] Serial bus multi instantiate pseudo device driver TXNW2781:00: error -ENXIO: IRQ index 0 not found
[ 18.768476] Serial bus multi instantiate pseudo device driver TXNW2781:00: error -ENXIO: IRQ index 0 not found
[ 18.768899] Serial bus multi instantiate pseudo device driver TXNW2781:00: Instantiated 3 I2C devices.

Use the ALC287_FIXUP_TXNW2781_I2C quirk instead to fix this and restore
speaker audio on affected devices.

Fixes: 1e9c708dc3ae ("ALSA: hda/tas2781: Add new quirk for Lenovo, ASUS, Dell projects")
Link: https://lore.kernel.org/59fd4aa4-76b9-4984-8db9-a60e55ec6e80@losource.net/
Closes: https://lore.kernel.org/CACB9z7kjs8rhLstEc8fV29BCTb5dd881JwGozoKdO5cwCb=YwQ@mail.gmail.com
Signed-off-by: Eric Naim <dnaim@cachyos.org>
Link: https://patch.msgid.link/20260516111532.111463-1-dnaim@cachyos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index ea98cbc4310df..4cd5b719556ec 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7182,12 +7182,12 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x3e00, "ASUS G814FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e20, "ASUS G814PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e30, "ASUS TP3607SA", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3ee0, "ASUS Strix G815_JHR_JMR_JPR", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3ef0, "ASUS Strix G635LR_LW_LX", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3f00, "ASUS Strix G815LH_LM_LP", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3f10, "ASUS Strix G835LR_LW_LX", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3f20, "ASUS Strix G615LR_LW", ALC287_FIXUP_TAS2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3f30, "ASUS Strix G815LR_LW", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3ee0, "ASUS Strix G815_JHR_JMR_JPR", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3ef0, "ASUS Strix G635LR_LW_LX", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3f00, "ASUS Strix G815LH_LM_LP", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3f10, "ASUS Strix G835LR_LW_LX", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3f20, "ASUS Strix G615LR_LW", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3f30, "ASUS Strix G815LR_LW", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3fd0, "ASUS B3605CVA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3ff0, "ASUS B5405CVA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
-- 
2.53.0



