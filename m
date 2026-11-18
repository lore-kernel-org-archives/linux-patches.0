Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034601;
	b=imx+OzI0y72L5FMo77QdFTMZ9QSrIrTXMtYMwHx+9D85C+eVR21Es7GzMjIx+xam3f5/
	 xC0loSq/uXYqPk36XscWThLNgKvJPmU7E+5TiL/Vo1wdaJYxetro2o8D8FIC9RhGs/LSg
	 4inUmk6G1dRwxailizfeU1sLimFM3fxK6XXULA20+vV0xZxNqdqZnBzNrxDeryCPECIK5
	 xjfrGtyDSrBZ+2wqmFSOcR3sRePhusqLV3X1BHID/w7EoGxs0XoUpuyJ3VGTGNk7sBWME
	 uvZr/AQJyDHQmSB9i14j+gFNL4JXAc0osbign5Ohbv7EP7czeB/tbOaGfMphMlAvK1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xiFncNtNxlDJDa+xCPE3UiWxcWUNsODiRo0eK7euOf0=;
	b=aSld7nlprj737M7FVaMf2ezbFsPBB43KPdtmcJxgHNlg8s806WF9W4/JR52Vjc9WJcO/
	 JyRWHYAjx6AQRZ5qkZEu999Rz02qvsr4u+GAGkV3ZtkG8DE2ouqtn/Sftf4y/jdXO3tiY
	 piuHwaXNip8OUD9H/BJPhbk2CSg/tmZZ44vn1k+fVUBVqP9LhtyekG5b1F9wqQzKGz3vb
	 o4wuNahrlwA5WebPZAxbwG2y48Lo3iRSFr1VACRBWCtXDvghCuq8SFYonM8d1yaPMFgsR
	 1+Nke3KVp/IrLg2IFUUuC1UC4yFviHAyzdjc/5SCgSyULtyoI4jnrkyY3l0Yt3jqFrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2J8355j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CE60A2628;
	Wed, 18 Nov 2026 20:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2J8355j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466861F000D3;
	Wed, 18 Nov 2026 20:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034600;
	bh=xiFncNtNxlDJDa+xCPE3UiWxcWUNsODiRo0eK7euOf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2J8355jTqfl6zfYDyplsW0vlBuayVxUVtAQazNj1tLPkCWgjigNFPzbyz7PuOq0r
	 DmLrX7GsfokB/Ga5z6lJTTT4ll+HFHhsYxcpLtszXL6Wsa5QOEwhRtgIrzaXZ+NM6M
	 zTYioIXEI/XYyplOhVA/i+u6Sqblx61cZtvfGjyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0425/3318] ALSA: hda/realtek: Add quirk for TongFang X6SP45xU
Date: Wed, 18 Nov 2026 15:17:27 +0100
Message-ID: <20261118150329.339035246@linuxfoundation.org>
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

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 26a94400ffa4fcbeff32e23abebb83a1a20eb401 ]

TongFang X6KK45xU and X6SP45xU have actually different PCI IDs. This patch
Adds the missing PCI ID to fix headphone detection and clarifies the
naming.

Fixes: d595255241e5 ("ALSA: hda/realtek: Add quirk for TongFang X6xx45xU")
Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260724190109.169889-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e72d5659a260 ("ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c92ae6d2ee81e..58c057027d97d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10737,7 +10737,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
-	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



