Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F01B33CE8A;
	Thu, 28 May 2026 20:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999069; cv=none; b=nGm6MijrLnCSspATpYubfbrysLgKxgTl956CQAQSGjlQ9wTCdURgFiioVc/C/je60oYn5KidYgl/c58zsmYUNi0hlMtlYgjmDPT/25QOvNylHy0S45wBRY39mU4ZU5G4mfQJ8u22PU0KoObZ20tX9SgQ2KOXlEboEUM54O8XwCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999069; c=relaxed/simple;
	bh=seCGoeq7wGTRUVnKbUHl6JlJ1o++wz2KL8vwhFl1F7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDd+hIZQWOUhRYDO5qHKOjsmZBRjvShZ/Ta2/QqagUs8y59exKpASCrGHmtw0SnvzSaXRC4BHpGP/zMupb4GtHw8E1WsOUvdPA9M0GewtUYXZUGlbS+4fy88I0fy8RZmoJ+XK80mnfx/FBGdhSXgf0q05tz1o05QbaU7TKzwHB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jyRe1e//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jyRe1e//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD83F1F000E9;
	Thu, 28 May 2026 20:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999068;
	bh=1q1ukYRxmid3845YpivWCuaUKcA4Yy88mbMvBn4/v+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyRe1e//n5UR4HKV8XmVSXvNQOtFlU8qD3a9Y3wWo7AGm/LEPSq24cBASt18te4QF
	 n36DWAiQen63kGy5jIvQNo5+cJ+vCBqnkUCUdV7VDfH6jzn9Ovz9LaBGyeaxR6u7GW
	 LIueV6+lHIr4Vb5A7f9kM5UVbl12T0dYZKamAH9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Naim <dnaim@cachyos.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 351/461] ALSA: hda/realtek: Use ALC287_FIXUP_TXNW2781_I2C for ASUS Strix Gxx5
Date: Thu, 28 May 2026 21:48:00 +0200
Message-ID: <20260528194657.560408369@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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
index 8f7d8337b4bc6..c59021c15d66c 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7389,12 +7389,12 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
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



