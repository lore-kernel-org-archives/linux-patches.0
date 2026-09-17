Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691194D17AC;
	Thu, 17 Sep 2026 17:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667980; cv=none; b=AUDJluyTAZ/fpcyi8GCGtdMTVfHp8LKeKx1GfjYC+MryYDDoeezO96AyCQT6W8Z1/J31X5cL0YWQSRwO0SHpNCpdid7NZ8BH9QI/LqkNbsBICS28bYm7z5xl1JT9wdZUKQayvadj1hg1FTfu455xspPG+dtcQOGMgwa8HF1QIY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667980; c=relaxed/simple;
	bh=tKuTbb4ZQh3Kk7FAFFA/VFfrbvDGBseNDt4wTLmkGdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDePpuImrCc6OUTSh0So8J3yHu1bgppjxhljWFzmeynelgF5UeTkiyO9HtlBVIKktwwDx52WrlexhH+sdLD/DRcNm+oTM5AFcaDSQj+dsDGdsx1/CurLR3xnSzI81PSmNeuDrBnp04WIEaw9UGXxtO9R2ZWRybzANc4ld2KCxHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPXWmyn0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPXWmyn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48C61F000FF;
	Thu, 17 Sep 2026 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667979;
	bh=fOcrq63vyWgbk0xsvBRMnVu++uqpxw+5K+UAy46Qr0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XPXWmyn0VW4OxjYTDIrai5HaLS2USgvwASFeUpdyhlN/5b0YiV5S5JSbP4X/oxnQj
	 73+SHNZ9VqF8YvgGuzcWT1V/pkCCWSXD1XHBx6bQUZzH4Af5KnYLa3jp0hmioL8gJ2
	 diXFHN6HvRbxVzoyx9v6/8i5nH7CwY2K+Hp7jOJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furst Blumier <seal@furst.blue>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0273/1102] ALSA: hda/realtek: Add quirk for HP 255 15.6 inch G9 Notebook PC
Date: Thu, 17 Sep 2026 16:03:36 +0100
Message-ID: <20260917151546.462736081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Furst Blumier <seal@furst.blue>

[ Upstream commit 98e157916f83c26a41448267180944048d2f1460 ]

The HP 255 15.6 inch G9 Notebook PC (PCI SSID 103c:8a1b) uses the
ALC236 codec but lacks an entry in the quirk table, causing the kernel
to fall back to a null SSID match (103c:0000) and skip the necessary
fixup. Add a quirk entry using ALC236_FIXUP_HP_MUTE_LED_COEFBIT2,
matching the HP 255 G8 which uses the same codec and fixup. This fixes
the mute-button LED and fixes an issue with unplugging and replugging a
headset jack not being recognized as an audio sink.

Signed-off-by: Furst Blumier <seal@furst.blue>
Link: https://patch.msgid.link/20260609201706.502075-1-seal@furst.blue
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9ab7f0c090682..9a56c60601c82 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10975,6 +10975,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a1b, "HP 255 15.6 inch G9 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0



