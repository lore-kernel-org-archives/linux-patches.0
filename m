Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42946230BF6;
	Mon, 10 Mar 2025 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626874; cv=none; b=ECK5uK0feuewMBgesfRXJJ08ZfkiECcMt+OpX5NT3kzAWV8kd24YYqbQ76ajvs+XcCwgaLFkAwevpUMB/jxkXQ9o67or/NwKRSnKVJpz2No4T2SdgQ05+Q3sYLUh7hGgAMkSB8x+TGHSaBFHDURV48Co6JI5txElnON1xvFdh6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626874; c=relaxed/simple;
	bh=GyGavryKUjHq22byAEmoywGMpp3F8S1EQtdWrgQ7Hgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zql0OsUkCBVA1MqV4yP5kvVyOC/t/WZWCk3yABnJw4PJJ0aWEaoWA4CZR1Ea8fnFEFtKb+KnTdMJ+mdRavkr8WgimJDUxIfuSbbqEgjlPhZzzEd2MqFXRX/RZqX128mZpe424VQCMghShs1m228CZ5HQBglY6Fn7fmJBA3a0/oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzGVLwC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzGVLwC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62331C4CEE5;
	Mon, 10 Mar 2025 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626873;
	bh=GyGavryKUjHq22byAEmoywGMpp3F8S1EQtdWrgQ7Hgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzGVLwC5KUnxe3/aL5PDK5rCDE+s9NoCEzL2pZylh5zq1tvJv5rsed9uLiU5wDI5z
	 MyU2pAqGTOWvFwaxLm708zBf4di9js0nY5MnuX46RPIXvxp5vlRp4aeM6jvN280y7G
	 3fWyOGX1SFnIIY6UjXjgzRIMnc/hvrk0NBPmuyfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 110/207] ALSA: hda/realtek: Remove (revert) duplicate Ally X config
Date: Mon, 10 Mar 2025 18:05:03 +0100
Message-ID: <20250310170452.129058302@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 3414cda9d41f41703832d0abd01063dd8de82b89 ]

In commit 1e9c708dc3ae ("ALSA: hda/tas2781: Add new quirk for Lenovo,
ASUS, Dell projects") Baojun adds a bunch of projects to the file,
including for the Ally X. Turns out the initial Ally X was not sorted
properly, so the kernel had 2 quirks for it.

The previous quirk overrode the new one due to being earlier and they
are different. When AB testing, the normal pin fixup seems to work ok
but causes a bit of a minor popping. Given the other config is more
complicated and may cause undefined behavior, revert it.

Fixes: 1e9c708dc3ae ("ALSA: hda/tas2781: Add new quirk for Lenovo, ASUS, Dell projects")
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20250227175107.33432-2-lkml@antheas.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2cd606900b8b0..e86c4d894ea30 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7761,7 +7761,6 @@ enum {
 	ALC285_FIXUP_THINKPAD_X1_GEN7,
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	ALC294_FIXUP_ASUS_ALLY,
-	ALC294_FIXUP_ASUS_ALLY_X,
 	ALC294_FIXUP_ASUS_ALLY_PINS,
 	ALC294_FIXUP_ASUS_ALLY_VERBS,
 	ALC294_FIXUP_ASUS_ALLY_SPEAKER,
@@ -9206,12 +9205,6 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC294_FIXUP_ASUS_ALLY_PINS
 	},
-	[ALC294_FIXUP_ASUS_ALLY_X] = {
-		.type = HDA_FIXUP_FUNC,
-		.v.func = tas2781_fixup_i2c,
-		.chained = true,
-		.chain_id = ALC294_FIXUP_ASUS_ALLY_PINS
-	},
 	[ALC294_FIXUP_ASUS_ALLY_PINS] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -10705,7 +10698,6 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x17f3, "ROG Ally NR2301L/X", ALC294_FIXUP_ASUS_ALLY),
-	SND_PCI_QUIRK(0x1043, 0x1eb3, "ROG Ally X RC72LA", ALC294_FIXUP_ASUS_ALLY_X),
 	SND_PCI_QUIRK(0x1043, 0x1863, "ASUS UX6404VI/VV", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
-- 
2.39.5



