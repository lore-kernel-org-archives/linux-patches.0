Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061107;
	b=IrBlI8EHpCj462phsZk7J/2W9Phrbg6dAtWJgxRAY4XvnSksVfDz6CS2PJsGWjSmMBYK
	 oQNdQoOEhT74E7nfo8CoBt33jfWYmA0Jzx25CeWOFc6+lzRsYpPYI95+T9ciPuRWemyn8
	 bNSFAmF9hmSEdDBgrrYd66ovC/AWBRLfxyGfkpcTtA1e5nnq3fNbx+aDRnktUgjEPjQuJ
	 cN1qOoWiO6P0wjRXIKS0bal2sOOZ1lBZBtvYiOnvs/SwMlLaFa/p6yoFR41p7p4CLMmTq
	 a19+2AovtPS9BCAZl0U240KKsp4QQ3WF529LjC5Q7uAnbjls/4YUm1xDx2DqvN1sddw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8x21az0ireercYzfpATwsRktAgtAiMtmEgweaYfBnNI=;
	b=2dfdkfiWjQLpjoQ4G4bfgVDFXMExuH7+MS9l/J0U204W1xHSdD/A7+6cjMm6Ios7P99W
	 eeM1H2V80YXQIHEmaJNjLvzyBaFx/oXbkLw6WADpIwA9rNMGgk4PkTnzW5JDW6VURono8
	 AgOsdDI69daen2SxQ85AowRxmsd0eKsrFMsWq8eZBIOIjUAXskv57D5tKM26tPfEPN5DK
	 XdklLY90BSHwWJpXApnFGRrj11zmj+h1TLqQS/RAmZHmwiTdA5U+LGNvYSFEft/2K7l9K
	 Sg+GFI0vvlfxdEGf3q+drOQeysH7ER/CYVWzz2zHFmwyrxVgPGGRt/Gptym27Xe90Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHoE9gJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F1B606A32E;
	Sat,  7 Nov 2026 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHoE9gJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947F31F0089F;
	Sat,  7 Nov 2026 14:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061106;
	bh=8x21az0ireercYzfpATwsRktAgtAiMtmEgweaYfBnNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHoE9gJywHbUEvoIAuZxYDXd4gEMujO6tku4B6CDIsiHy2pf6yHwDlmpeKn+NJrvJ
	 yYxjNKtohI1ybo+S3X6XQoPkFCaLBH7hTgDkjCEhsdAu1L92Knazs0ln+ctG2g8Kbg
	 M9s6UPUOd1P+v3FsxIuHMCoTSpVsgqttjxp2ocmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaidheer Sirigineedi <jaidheer7@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0425/1536] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg3xxx (103c:8bfd)
Date: Sat,  7 Nov 2026 08:40:41 -0500
Message-ID: <20261107135009.506338698@linuxfoundation.org>
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

From: Jaidheer Sirigineedi <jaidheer7@gmail.com>

[ Upstream commit 13dffca9043500ed6033d770b491a043fb952bc5 ]

The mute LED on the HP Pavilion Laptop 15-eg3xxx (PCI SSID 103c:8bfd,
Realtek ALC287) does not work because the machine has no entry in the
quirk table. No fixup is applied, so the mute LED is never driven, even
though the mute function itself works.

The LED is controlled via GPIO pin 4 (mask 0x10), which is exactly what
ALC287_FIXUP_HP_GPIO_LED configures. This was verified on the hardware
with hda-verb: setting the GPIO data bit lights the mute LED, and
clearing it turns the LED off.

  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_MASK 0x10
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DIRECTION 0x10
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x10   # LED on
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x00   # LED off

Add a quirk entry for 103c:8bfd using ALC287_FIXUP_HP_GPIO_LED.

Signed-off-by: Jaidheer Sirigineedi <jaidheer7@gmail.com>
Link: https://patch.msgid.link/20261002185951.33855-1-jaidheer7@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4a471dd67662a..ca556753f0661 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11137,6 +11137,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8bfd, "HP Pavilion 15-eg3xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
-- 
2.53.0



