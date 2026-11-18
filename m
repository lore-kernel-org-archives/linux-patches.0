Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034597;
	b=gD9GkIG0GEQD+hC9J3xwizRNDTAhZDkSJCBu+sef5HitnyqMOcnlnOPvHd5OTk3oHH89
	 OjXDnACrXtu5kQYDSuLaGLCdYOq7aMqyT7OmW0K4s8FGxvykZOn8QvINdS1t78cnSZAvx
	 37zhvaqvfvSODsGzFSO2OYbZtlMd2tRblimlHKaojAohAY1fzwp9Nq25+uPD4UwS0Rzv5
	 EtStvHDX36x+FQGnRqfesSdthbAQEtFqDMlAH1jh5rlFDLJpbkNCs9vrBOuiVFriX+sgx
	 o7mnVESKoIGKsI2UFRucTHzCtmahHK5ju9x0t+4Ew6cEoIJQ6b/CP5Un7bWJCCsLJkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034597;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qRW/iFUVP6gSSnjkLV4BNNIc4NECw2BEfqHzGt1VsMY=;
	b=erIC+/dNeIs8a9c7xyE2yaNTpbOcIOfuOb+q790o5cwK/5KVzeIMBn27Qq+LeoEIpILx
	 dqfAymlf9cPtgzyWCOHoikCWG/Cga/6MMGjJ3iVjgiFa9k/Kk/yUF3pNaCoGTMijiUetm
	 EH/zrQwyh/g2jS1RscUBk4BELyuKty2YFCMD/yXirsVSXbEGt4GggQL/KZTX3y1X+EskZ
	 TXu06lhK43U3Q8QM9XX3BgO28MOlfZRDWxd+RWQqesaPOQWb4yA8b7nXInecL1qzA6REF
	 XsZjEFe1WlSMfp8L4EILnwE3MuH8m6MKhtCcAdFUmDRYwxc5s01eKo+NnzaYeKY9jHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWKBl1jT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A7F606A335;
	Wed, 18 Nov 2026 20:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BWKBl1jT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC81F000C7;
	Wed, 18 Nov 2026 20:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034597;
	bh=qRW/iFUVP6gSSnjkLV4BNNIc4NECw2BEfqHzGt1VsMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWKBl1jTNdcaLyQE0ct7lh8YpPDRq8ZnmpLHGH/4Yjp3yxbxNK/VumgVGv7ur/7Kp
	 Nf6Cl3Iz+wHcxS4bs1THD/06DMrHW4rvj7OyodzQbUaCkhKsRoDTPTRxG8GWvXzyvi
	 a/ddqexiLnYnuE8tKPm/59Nznz39Mx3MdiWMmd84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0424/3318] ALSA: hda/realtek: Add quirk for TongFang X6xx45xU
Date: Wed, 18 Nov 2026 15:17:26 +0100
Message-ID: <20261118150329.304745279@linuxfoundation.org>
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

[ Upstream commit d595255241e5fec0c94adeebf2565524398e37c5 ]

Fix microphone detection on built in headphone jack for some devices.

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260708132135.102680-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: e72d5659a260 ("ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d375f0729e652..c92ae6d2ee81e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10737,6 +10737,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.53.0



