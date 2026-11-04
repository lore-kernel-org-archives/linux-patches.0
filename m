Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830841;
	b=eBpbaRiaNUBQ/sL4+329odGXikEMK1BUGKwtqWhVIX/zK+G6y8K4lR1fqZvBlJQimG0k
	 oRDRf/OxaDsF+MgkiMa2HSjhtwIU96pV+78jzDgfjvK1V5XWDyF8nPJrtqoaWN9krxltH
	 9iTyp73Ob0ZxX5/W6vUgwFXJOkv5gRz1Az1WfEzJ3VPSuiexVsUzXDgI2UXKqdRUEZPD3
	 UBoJ9FMdguWFPLL+7v3T/ZsYyh0WE8oldGx8i60l4Ii0irzBHBXlEcUXod8zXc+x9RQ7V
	 zqag02G+WowFeYMluEQDPnamn896mzxk9ATiIQPfea9iYBKTf6zVXiUmNctDpazurGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y9j+lXRpM86pHynfNn79gAbqg1PqQLoQz5f3pjuh4zM=;
	b=ekiwcPXM5zsJfqiZ+5qaUsswdwxUC82Hkz3Xoznrj3M45+jwJDw2bHzYpulpfZH/cC0Q
	 +9+gTmiCB/bmKR2X3FBwID4Ma1SjF02lSkw/FwbvM9+lolktoJH6AHBaur/z8Pjx+jcCN
	 kzsHnS9fLKNxreG7x/23KJK+5+5DSoAY+VRekvgt1PQu53uUpCcMz5QRWcGhoMGqLiwmi
	 wLm8hF0c47O5SA3FY32WJfrJYyGVe5kkWfjMTIB6C18+j2bBneGieIBzR6HN4nUX8L2Ca
	 62DME4e6F37vsxfKZ7XUzi6mb2bvIAsKf1j7Xa906OCHgUi6TciaDTW/DIn8gl58dxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpzlVgoC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EC1606B2D8;
	Wed,  4 Nov 2026 22:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qpzlVgoC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A144B1F000C1;
	Wed,  4 Nov 2026 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830840;
	bh=Y9j+lXRpM86pHynfNn79gAbqg1PqQLoQz5f3pjuh4zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qpzlVgoCUGwf1wIhFzlTfeF7vmICgCv6YqLPEoDePznMLhoMEvFMDSL7yOi5Sqj0C
	 9Hs6p7gk6ExkIxPT9BksVTnZwhVBoQ8ab+ffuKjSB9sf2SVEs1FrLC+iaIcHRcG/pl
	 QI2vuR4RFb0ZcHeT0/d3+nXQHCJEcPPSGvc23AXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Garrett Blackmon <garrett@blackmon.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0354/1005] ALSA: hda/realtek: Fix speakers on ASUS ROG Zephyrus G14 GA403UM
Date: Wed,  4 Nov 2026 16:01:27 -0500
Message-ID: <20261104211053.987633708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Garrett Blackmon <garrett@blackmon.dev>

[ Upstream commit 140fe610af607fd70da95c447943fc2690855519 ]

The GA403UM (SSID 1043:1044) uses the same ALC285 codec + dual CS35L56
I2C amplifier topology as the GA403U and GA403W variants, which already
have quirk entries (1043:1b13, 1043:1024). Without the quirk, the
woofers sit on a separate DAC from the tweeters, so the hardware volume
control only scales part of the speaker system and the headset
microphone pins are not configured.

Apply the existing ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC fixup to the
GA403UM as well.

Signed-off-by: Garrett Blackmon <garrett@blackmon.dev>
Link: https://patch.msgid.link/20260807150708.33785-1-garrett@blackmon.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8fdfe1bbe7aff..05e7fcc2f67e6 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7094,6 +7094,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1034, "ASUS GU605C", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
+	SND_PCI_QUIRK(0x1043, 0x1044, "ASUS GA403UM", ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x106f, "ASUS VivoBook X515UA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



