Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 113574EDCA9;
	Thu, 17 Sep 2026 18:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668500; cv=none; b=oLOSe7/Y7urTJt8pMnwlTJYOL1VcDvm7yLmrDESXxPh+5XWnKkz1i9llIzGtoCUCUfZkVS5RsaPhlK7MWBb3x5VNzMdNKvNMT60DOAnauwuMvooCY31ZDftjsjEFF92iVHGXvJEbHSZgoWAlK5nKCYvWkKwBtRT4JjKbUyyfhVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668500; c=relaxed/simple;
	bh=vuesMibT5FPh+qHN06rbeyumjT/BJTV1f5iTy7VoFtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1pbz/SbgARUBo0672iDQ1y7RXJ0t3k1yU6R/aoNB7ntPh7XsmAYYAPBUk4kfScScW5qF7JHrlTuaI8j/ONYgSG94/OS/KN/uPM015BNqFT0CkqGwpgzov+yDHfFFT8JMjNO58+NWV3N8USyiwzNEiRG4Ziq3arynyQh9zu/Kzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDKIfbG2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDKIfbG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D091F000FF;
	Thu, 17 Sep 2026 18:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668499;
	bh=iXhuVLCbYjYacaKCeQvjD0XIN7qDy0bwahjGMjlCg90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDKIfbG2ylOVXnPgk4ZMfFnaqAdP+tALf7g3wnxaTL2bUvex7QWHyVM4+IoQsag6Y
	 RUfKpMz8JrgGAQ38kdnH1hsmK7KEsEgsF3u4BPXCRmS+7TGZWJ/Cpe4d8SK0j3GL1b
	 vE+Mj8G1zb6DlYaaCH8JnhiQfdbgl/ihs/7tuQc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavender Singh <madhav@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0444/1102] ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx
Date: Thu, 17 Sep 2026 16:06:27 +0100
Message-ID: <20260917151550.826358919@linuxfoundation.org>
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

From: Madhavender Singh <madhav@disroot.org>

[ Upstream commit bf4fc9f33ec21595143132a3e7fb8b5d2c2261cd ]

This laptop with an ALC236 codec requires the
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2
fixup for its mute LED to function correctly.

Add the subsystem ID 0x103c:0x86c8 to the quirk table to apply this
fixup.

Signed-off-by: Madhavender Singh <madhav@disroot.org>
Link: https://patch.msgid.link/20260723104736.23386-1-madhav@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 70cac100b2064..58729c8430273 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10899,6 +10899,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
-- 
2.53.0



