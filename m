Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E711448EF;
	Thu, 11 Apr 2024 10:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830302; cv=none; b=o+3x9znNAMogMRf0X0ylfx3rajimVbE0VrkDvYR66et/nhmx5p7gRQiSQF6vj0HZvsvroPXdrxejpTYLIQ7zIWtU1atfPmt5LmWkfOA3CcNGkkrvn1fNRbsK/ep/Vam8r6sXiRsHQCXcgSVW+O/s0aK30agr132t/5HrPEdXOgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830302; c=relaxed/simple;
	bh=uToPu1CaNLjdFQwur6ZmwtGwraZIS35IZdCZ7giID8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVQ0OE3/6z7c2/jGXEJBgrATF7k9stIQC/VYh/Qy3DO0QPBMxq4XJMhAOlkvqlO8GHe/XXD3dBD9PpN74d1eDjPWg/gP54mNhduYxVoR7b1wdWkqU2PJzkkY94MnGEaL1UagG5vzZpDrQfAiUnY2+G/n6RYBdXhVdracZlhhiQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zq/a2+GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zq/a2+GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EA5C433C7;
	Thu, 11 Apr 2024 10:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830302;
	bh=uToPu1CaNLjdFQwur6ZmwtGwraZIS35IZdCZ7giID8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zq/a2+GBxsSAWI/rro9XWicG+hBQhSUgkmUgQRKLsJLxaB5Sx62HYSaPQmIruH9F1
	 7cCbpjHtT+O9H+g3gepCbnYLvVa2fpDBIXeMO2WnFhmDIHgVsW86+1MnSDhwk2rxuk
	 9OkEZqIo6FB+y0zWgBLak2tdNafT6CesO5GxwvVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jichi Zhang <i@jichi.ca>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 104/143] ALSA: hda/realtek: Add quirk for Lenovo Yoga 9 14IMH9
Date: Thu, 11 Apr 2024 11:56:12 +0200
Message-ID: <20240411095424.038131186@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jichi Zhang <i@jichi.ca>

[ Upstream commit 9b714a59b719b1ba9382c092f0f7aa4bbe94eba1 ]

The speakers on the Lenovo Yoga 9 14IMH9 are similar to previous generations
such as the 14IAP7, and the bass speakers can be fixed using similar methods
with one caveat: 14IMH9 uses CS35L41 amplifiers which need to be activated
separately.

Signed-off-by: Jichi Zhang <i@jichi.ca>
Message-ID: <20240315081954.45470-3-i@jichi.ca>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f4a02bf1abb11..39d8931fb7b21 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -7521,6 +7521,7 @@ enum {
 	ALC287_FIXUP_LEGION_16ITHG6,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
+	ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN,
 	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
 	ALC236_FIXUP_DELL_DUAL_CODECS,
 	ALC287_FIXUP_CS35L41_I2C_2_THINKPAD_ACPI,
@@ -9650,6 +9651,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	},
+	[ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc287_fixup_yoga9_14iap7_bass_spk_pin,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_CS35L41_I2C_2,
+	},
 	[ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_dell_inspiron_top_speakers,
@@ -10384,6 +10391,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x38c3, "Y980 DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38cb, "Y790 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38cd, "Y790 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x38d2, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x38d7, "Lenovo Yoga 9 14IMH9", ALC287_FIXUP_YOGA9_14IMH9_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3902, "Lenovo E50-80", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
 	SND_PCI_QUIRK(0x17aa, 0x3977, "IdeaPad S210", ALC283_FIXUP_INT_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo B50-70", ALC269_FIXUP_DMIC_THINKPAD_ACPI),
-- 
2.43.0



