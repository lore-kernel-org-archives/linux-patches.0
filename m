Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C95168C8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0196C433D2;
	Mon,  8 May 2023 10:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543486;
	bh=/CirPnlQip9K72+yzl27FDVqJP27yaQTcovgu1nBL04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rca8y0xC6EoS7wRbtXNfwTdX+bJRQgWh6BdDZ+u4puR8+Bxn094v2CPiKrsPqbUNb
	 0AOpWJ+f5Bm5+QUxOms9CktuA7p9VOXTKXbZTCZBrXV4ay9dCWg33/7JMb25Destbw
	 GJqaS7SfUNdhSNokmGx/Krw+tlJk9qo5cz9+Lm1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Harper <calebharp2005@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.3 105/694] ALSA: hda/realtek: support HP Pavilion Aero 13-be0xxx Mute LED
Date: Mon,  8 May 2023 11:39:00 +0200
Message-Id: <20230508094435.889588913@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Caleb Harper <calebharp2005@gmail.com>

commit e7477cb97607b373d175a759c8c0270a640ab3f2 upstream.

This patch adds support for the mute LED on the HP Pavilion Aero Laptop
13-be0xxx. The current behavior is that the LED does not turn on at any
time and does not indicate to the user whether the sound is muted.

The solution is to add a PCI quirk to properly recognize and support the
LED on this device.

This change has been tested on the device in question using modified
versions of kernels 6.0.7-6.2.12 on Arch Linux.

Signed-off-by: Caleb Harper <calebharp2005@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230503175026.6796-1-calebharp2005@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9428,6 +9428,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x896d, "HP ZBook Firefly 16 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x896e, "HP EliteBook x360 830 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8971, "HP EliteBook 830 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


