Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C767952CCF2;
	Thu, 17 Sep 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664460; cv=none; b=ledCJtcnoqJHmY7bMwWu8/1OSHlG2LaCn1DIMUnV8glxswJO12m9wbco8LcRfj0qfr9ZPPwm2Ccp8bzofLP+2CTnEUoaZ1Gy2tZluDRficJh+0vpBok6Z09WmGCDJM6xyNNk37VeBPcXzHOBciDvQWgrLCs+aNI4M/+kLOOpBIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664460; c=relaxed/simple;
	bh=OhN9iMNEw3xhWdFfg91YkaCRacsQ/qYXNp/dmoproOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI7lTO29fiab2AL42kHDsBfI9t2tccLp3V0riWlkkn4oT0q2KdEBKdmGYjdwgF2tElcb6bUUh4+IdcG3A0E6QeSvQ7eMbeN4SdPtWaX+T28TgMFIOv4Q3G+jj8X/EB6dAxvzMgP+KKUEpr9VuLd4IgHXBMb9BoaTabiZAFXnPFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJHDPHAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJHDPHAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2A91F000FF;
	Thu, 17 Sep 2026 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664458;
	bh=wdQa4EzyOWkLqVWUUBa3FkHtlJ25fALBy6OJV8SVreQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJHDPHAJbks+fa86srKq8RosOtcyRsZaxrqCkQvfkrh997N/AOAdxaC9kGKRpraHT
	 em5RPSO46McdbgQfW13pKkMVT7qiZQBr44dd65NMiIFGhgl1RxB+9GBE/eOb65AOxk
	 bdIhiY/3zOwwyZRt7hrouXjATWfrncZ7/Us1FPZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furst Blumier <seal@furst.blue>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0379/1250] ALSA: hda/realtek: Add quirk for HP 255 15.6 inch G9 Notebook PC
Date: Thu, 17 Sep 2026 16:02:54 +0100
Message-ID: <20260917151602.322836575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index fde9fdcd96d14..3321d8d3571da 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6842,6 +6842,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a05, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a06, "HP Dragonfly Folio G3 2-in-1", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8a1b, "HP 255 15.6 inch G9 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a1f, "HP Laptop 14s-dr5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0



