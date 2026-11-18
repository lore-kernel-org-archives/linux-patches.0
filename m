Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034141;
	b=kTiTeRLQgq81MTFCm5OTtbZ3bewgsD9+EE9cGs/C0VMBqcBf0hu46AIJGgjn5tL4/NkM
	 jYjPWN9Ty2ErV3RplWo2oGqtkRJscWvmBK5IPSojqXbHpn1zbM6X8JuPNGU/koh0jYlPF
	 bf4RazCi7sRitLEhOpprvXzohq2eRNqYLWI/qE0Wr75ywBdPllN6f2KH8mHvwS5izvBXT
	 BsrsSzGKzbZ6JEGbtSJrY4aFOpi/u39Yd8LWkNSaoDYJGE6xA93kU94yIYnOXByGKHbez
	 eTD0ddQ07WnSRTdCrbltFZPBSX19zJt529vHf+o2Yfzt7U5qX6sTvCJgOcYUMx27RDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TzxFUy5ifq3AzB2KjiKxbWke9RZGBd9+mePDcD+7pE4=;
	b=tC7jqUOKOD+9idQL5YYoUajhF7A9qf0Kyf1zxITS2N1BlCbnsbseC40Z7PtWcD0GpsFJ
	 J5oTBEnjiwqpqDcXoE4S+Q+YbOAW84pWSH126YczKZdRg5xfP3kc/9/EBHbPxrwtNKM92
	 c/tzCInAkIkyUavVWVeupzqdZjkEq/iaoTF5jsh8QBIM+e21wMBEARb+YaE1hqf5BBcZT
	 UdjsGck4w7BTsOIZ5IBpwh0MFMkYgiTa/KA2QAcdtj4wRVfBO8XseK2G/mbjzZlSKFK1P
	 /NcyrEnJNM5GXYl4XURLim7M1BlHmT01YMuEhttpLDRJ62wZL1SWG31Vzr8sdE/EqnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kl9aMDDC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E717F606A32C;
	Wed, 18 Nov 2026 20:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kl9aMDDC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4917C1F000C4;
	Wed, 18 Nov 2026 20:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034140;
	bh=TzxFUy5ifq3AzB2KjiKxbWke9RZGBd9+mePDcD+7pE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kl9aMDDCSozUqglCB4vDG45prvZquxayNZZsVX2UIX5WuZN0RRN7daKzSiVHEOHEq
	 ErWeS5aIXfGHFq7Cfl92HqDmHAQ+GpozytRC6m95gQ0oxWX220ABs6q0Rj7gnNYv2r
	 eB+J8akBouS4JFDA3fdgE0OimkTNY/wbRWPRIi5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0247/3318] ALSA: hda/realtek: Fix headset mic on ASUS Vivobook S14 S5406SA
Date: Wed, 18 Nov 2026 15:14:29 +0100
Message-ID: <20261118150322.685767515@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit f2d08f3651fb12634347fef2c41687a807a7dcba ]

On the ASUS Vivobook S14 S5406SA (subsystem 0x104310c4, Lunar Lake
platform) with an ALC294 codec, the headset microphone (3.5mm jack)
fails to capture any audio. Adding the ALC2XX_FIXUP_HEADSET_MIC
quirk resolves the issue and restores proper headset mic recording.

Link: https://github.com/thesofproject/linux/issues/5729
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-3-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 77ef197d6ae48..27356a33a93b2 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10318,6 +10318,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x10c4, "ASUS Vivobook S14 S5406SA", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.53.0



