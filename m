Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051561;
	b=vrSq9I8f7fMrtvWG5o6zdpRyc3P+4Cz1nXPB94yV0OrMw8nukgghfHRigYBe/Vmhc8Ui
	 RT6MrtxV9f5Q4TYlbHg6kes+kdqhyT5HkANsQfbRsaebvo8qUpcRh+rPETXJ47eKxAPNK
	 S7u8NgNc7HmuVVXNE8BYhq5H/iIfxDR7pL9rx1R0ygTERRPvKemaP/hBJNYF0VOubbvg4
	 oGEMTcMJv4pQXKksVvqP+2hwUApvnUuyPG4lOHpkmKKfuIXED6gkGj8l1Z6GRy6IybH+M
	 aQqch3d5z6OR55oNdLKZQvahqgcXYuUn3NQBDAlOe156MEDgBMMsYbmF32QYY+of3Yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051561;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GeYIlaIiteytlZf5K/ZsV8INgEWaN0ow/5zgPpsgGCA=;
	b=Pwt2UD870oWNV0awz1BT0ZKJkyHFUQlTGsJNqubHf2n+a3IOqFJAYulGR3g+uk4zzjdt
	 s4fTqd7GnwYAdt1DypFDs4Yo7RrcRBV//nQvz8l5zEJNGOZwKO4OpvoR8Qh3BzEtJms90
	 syrIdIOX97wsUGyl4oyBosWP4icNZbJeLqMM5YCTTOmKyVAwSXx/9ktgLahNX3Ov/sr+M
	 o+zyc+tPs8iZa+RN7ifmq5eyr728SEdmsmeifBcTjN/tN8MbAPVOFfSFEjlcUZaVig1nE
	 VRjkeD8uTx60h7fhNqXdKbe65V9WqocqHpMcdoTlhR47nHjRc0nKPFetoapFpOwN4Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxCMWjJL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D085606A31C;
	Thu, 19 Nov 2026 01:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxCMWjJL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30791F000C4;
	Thu, 19 Nov 2026 01:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051561;
	bh=GeYIlaIiteytlZf5K/ZsV8INgEWaN0ow/5zgPpsgGCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxCMWjJL4YEO55YfRDJ89y4NYG7/IaJLlhuM8/bZcvbVPFp6FE2z5ytHWq0HJqwHD
	 dCQQEaiBD8LLkGOa2zdihcPyA38TnEa9+dsU/FbV2Qez0iCj7LktPKgY2D4/UBgF6H
	 kAmIcvAZrL0BDpgcfnUX6sGX9zxXLbEBrkIM8xJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0250/2214] ALSA: hda/realtek: Add quirk for ASRock NUC BOX-358H
Date: Wed, 18 Nov 2026 15:32:06 +0100
Message-ID: <20261118150020.155459768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

[ Upstream commit 9a44b828dd7c0be1d0d6d6cf178d9727ceb6da6e ]

Fix headphone jack detection for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20261001183403.103990-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4e403d3696f3d..68c1db02894b4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9688,6 +9688,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
+	SND_PCI_QUIRK(0x1849, 0x6256, "ASRock NUC Box 358H", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



