Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057489;
	b=ecsg8pIbg1weUDGUK2vN5qDgcaA+JmmLzrDrGoSVFeSg21553IifgXXpBq3zvCGXuIQ5
	 NNtcO2KwXHs3SQNONKdAuYdsydYSku4Hwrmelp46C2+wUytzIzKolICpjxhuXIDCIr1p0
	 VMy1oNgfG+JzBDxGz0hTNcOZSvxDG1EMQ32HXceKb/1Y1oKqL7rQcmkSmAiJSOjRCsrZ3
	 E6zpxCW9ui3bWs+eA2N7cOdr16S+z1rtSSlhWaxxu3gWDIvWePIeWH6yz98amIJLzzCMB
	 Q2Z/XWKPRGBg8H+itlivMvPGSmbQlEk22TwKtbKiYmXIdYda1x4cNHs4YE5ytZgz//g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=01bU5Eot/3iFMCffMa3ZfeliblAdfxF9tfY9I/rphJE=;
	b=z+S2gnmMvOVq/K7NOk0HIZfh753OZ4LYcMn18CdJ0SOAN/+EiHHWJD+X2OGm8hoTVJgs
	 DbdLpXTpq3vzLEswEtYpBWWTCj/jhXud962hEo3Dc7b/gJcTdRskjqeXQBaxgIP0t+jmP
	 MXJ7nTxfF9nsCMqa49rY8jk6TvXp5UJUW1cK9SS4s8gDm1HMxVcgLgMU05KWkGMs8DzU6
	 vbNSbNjX/1KJM4b36PLVt5cCu3s8ctR93k13pZ2aPwbVoIHAZl4asevTpzv+KiWo3XHkO
	 2B09PrNsUHCk1j8nvGpg1W/Zcmuux5YcVIYxMXIFWLw+QqlZr87f8FeQ9iFmb9bNdqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJ8nIIOx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E523E60A261F;
	Thu, 19 Nov 2026 03:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DJ8nIIOx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271581F000C4;
	Thu, 19 Nov 2026 03:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057488;
	bh=01bU5Eot/3iFMCffMa3ZfeliblAdfxF9tfY9I/rphJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DJ8nIIOx+lGY5c+E3g9O2KKg6hRFB3DBsbQRrjQdaJ0UNuzjd8S0ngAUF2Ss051Im
	 3HhJ1nwKEDxoghckvpf2wZ6ET37Fv3eMXKCN0C7ODxSW3jcROFJtfCdS93uXSgcBhF
	 xSmAnLAOw+nxT7NLNxKs89Br/ndEqagtseXrAYYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Quist <equalizerjr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0149/1848] ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx
Date: Wed, 18 Nov 2026 15:36:27 +0100
Message-ID: <20261118145917.495792975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carl Quist <equalizerjr@gmail.com>

[ Upstream commit eb2b516900f2cff6c931a0d664a625ee93855779 ]

The mute LED on the HP Laptop 15-dy0xxx (PCI SSID 103c:864f, Realtek
ALC236) does not work, because the machine has no entry in the quirk
table. No fixup is applied, so no mute LED classdev is registered and
nothing ever drives the LED.

The LED is controlled by COEF index 0x07, bit 0. This was verified on
the hardware with hda-verb: setting the bit lights the mute LED and
clearing it turns the LED off.

  hda-verb /dev/snd/hwC0D0 0x20 SET_COEF_INDEX 0x07
  hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x1     # LED on
  hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x200   # LED off

That is exactly what ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 configures, and
the closely related HP Laptop 15-dw0xxx (103c:85f0) already uses it.
Bit 9 (0x200) is set by default on this board and is preserved by the
fixup's read-modify-write.

Tested on an HP Laptop 15-dy0xxx (SKU 7FU54UA#ABA, board 864F,
BIOS F.40).

Signed-off-by: Carl Quist <equalizerjr@gmail.com>
Link: https://lore.kernel.org/CAOtcGaxXndKxTK5MVSEcmF-LUy+V51K7fhE=qvLA+VvW5ZyCNA@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index acbe56e95f42d..f6a96dddee145 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9263,6 +9263,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
-- 
2.53.0



