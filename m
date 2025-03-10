Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1F42309B6;
	Mon, 10 Mar 2025 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627546; cv=none; b=RFDmYpdBzG2sMi94B1QVCh632I5f/gjyQz65fJu5+mVq0FtiTP5yOfmBSSUDQJIiVZzHY+dPe1GWVJcySL0JHulR3/p36wvSFhG4tbDqPw1wXaBEqDNHqDH9DYuPVUVPYHpi/slKJ2MnIRbHNXgewQ5v113nPu2beeHPp4NywBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627546; c=relaxed/simple;
	bh=qBpjzcuRzyvFz2XK5RtbTmTemVMQ3EqiDQ4XVz9nxMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YOCC+Gzx/j5J0GU5FUxfub4DAca38vJESlUR8HQxuz54PHyc5BT3Rsg6k6fwBnvpZcgOOKv0XyQ3PwmxGTap0s72HuePjDIhhaShRJsA+Ut88ZrZCAuALMagVGQ7Qx4ybwadO2YjljzSD0goNBhSreQ6mveslnwIdLg75e3HFW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LK6za9hp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LK6za9hp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C06C4CEE5;
	Mon, 10 Mar 2025 17:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627546;
	bh=qBpjzcuRzyvFz2XK5RtbTmTemVMQ3EqiDQ4XVz9nxMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LK6za9hp9IHxw+LTSH810AxQKU0R7DDXY2cPBI+D8phjm/r5+Rk0H26IepuacyLmc
	 PGpHshF4kSvUzcYjHhzLefhaWYcmsq6oySdYNzNzu4nQIIa8SQ31G50wzZC54fra2w
	 3D6bicJ2nd/jUWj5pElGx/A8m9CY2CZDOcEkZ010=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/269] ALSA: hda/realtek: Remove (revert) duplicate Ally X config
Date: Mon, 10 Mar 2025 18:05:19 +0100
Message-ID: <20250310170504.333199237@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
index 9997bf0150576..d3a81d3638872 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7741,7 +7741,6 @@ enum {
 	ALC285_FIXUP_THINKPAD_X1_GEN7,
 	ALC285_FIXUP_THINKPAD_HEADSET_JACK,
 	ALC294_FIXUP_ASUS_ALLY,
-	ALC294_FIXUP_ASUS_ALLY_X,
 	ALC294_FIXUP_ASUS_ALLY_PINS,
 	ALC294_FIXUP_ASUS_ALLY_VERBS,
 	ALC294_FIXUP_ASUS_ALLY_SPEAKER,
@@ -9184,12 +9183,6 @@ static const struct hda_fixup alc269_fixups[] = {
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
@@ -10674,7 +10667,6 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),
 	SND_PCI_QUIRK(0x1043, 0x17d1, "ASUS UX431FL", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x17f3, "ROG Ally NR2301L/X", ALC294_FIXUP_ASUS_ALLY),
-	SND_PCI_QUIRK(0x1043, 0x1eb3, "ROG Ally X RC72LA", ALC294_FIXUP_ASUS_ALLY_X),
 	SND_PCI_QUIRK(0x1043, 0x1863, "ASUS UX6404VI/VV", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
-- 
2.39.5



