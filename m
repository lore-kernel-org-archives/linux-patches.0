Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061150;
	b=OVGk2sKpoxo+z9Cn0W0OTLIt3xKBRb9nyu04HeE8oOIaFDij5+im8GXX1+BAKjLftMMf
	 yTZU7RgD2OIuwLd+4GiQ6c4rVprzANeU2I1Ri7v96I+ZWGp3suzENgOtQtwueQ7BzDNIZ
	 zcDZbr+gGVK+0t5nmCdFg/TalFRDNAOBXu0CX5Wxi7JhVa8WzgeszaTm6m38HTizt3kyn
	 scAAB+LLeUrSDqp3lSLcLjB+L7T8zlmKiTXXWLriWT5+85hyyZ+gWxfSCpCSblCYhcr7O
	 PLU91j6G0x3l6T4BkxYma+Mv6TjMqduw9PlyfR7GIxgpYjO5gcNDwzf2YqLGQ4lt5DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CS0FHZ6xIIe52PGWwMlsDeC8Z+DDPBnDeguFc+/Fo6A=;
	b=b2WAGXQ+oA8JD7Zs/rbmFMhd4KGj5M3+r3ef6kbtFurGXpQCW2lnlXQulZvCNuuAgJYC
	 rGnva2Yvl0DbuI9yO533hQWEjgUke11+5K0gy5Jm59ds8xBJBtVJQ86RZi4JLvOeZDii1
	 QR37FqER6Z7Rn+fxOcnmcPrPTiPNXfN0QEM4d/BwCwEXGAsu5UyenHRh6TbpXpHJ0Ksj8
	 EDTE3ni8C8YPudVYBqMXtDRC8ErRa5WatI4pgjdZe/ztlnWLyruua2bfjUm0bm4Hvum2f
	 5cvt2pL9ksXT1xIt4cHyaDlncdfGwFiE/vkFBHf5RRpzPU59lwzqhu4vS0TwDlW1JfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FAtvs6o2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF830606A33E;
	Sat,  7 Nov 2026 14:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FAtvs6o2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEFC1F0089F;
	Sat,  7 Nov 2026 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061149;
	bh=CS0FHZ6xIIe52PGWwMlsDeC8Z+DDPBnDeguFc+/Fo6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAtvs6o2+cvTGpmYmEIopdZPMxyF5V3eCK2yQzxS/rjRE+WvbVo4fwOI1Xuj3C9lf
	 qrMT0zmcWKqdg8xxaMIRak2mwhto/Z3dDy+zDwGbmjI+K4HOS4Ww0q60Zsw7gG2XMW
	 Q/gmo/Qmm4t4owFeeJSHqGe0oRud5uwTNrtOvfIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0418/1536] ALSA: hda/realtek: Add quirk for Acer Nitro AN515-45
Date: Sat,  7 Nov 2026 08:40:34 -0500
Message-ID: <20261107135009.316630006@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 0d90a929836344f1d3b39f22f08ccecc62378a59 ]

The Acer Nitro AN515-45 requires ALC2XX_FIXUP_HEADSET_MIC to make the
headset microphone work properly.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221925
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260921124450.639601-2-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7d89c5c90d2d1..d26f76f4de2b7 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10757,6 +10757,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x151e, "Acer Nitro AN515-45", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1539, "Acer Nitro 5 AN515-57", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.53.0



