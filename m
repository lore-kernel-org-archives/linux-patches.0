Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A537B3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 293ABC433D2;
	Tue,  7 Feb 2023 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775061;
	bh=GXj/1WGP/5qdlx2md4bAj4G0DPjbf9mfshzObgjlNDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIJjlGNtO9IA8h5gRo/awNIWdSeWkebzhkollEptqGJXrE45nhZVwNvEPqNoWwh2E
	 BdkKCjkhaXcI2AuBsK73rouFKCohQ/taj9OatP7eBWN08IEBx+7WDWt2H307dgXRR+
	 GvvhPXhHwZjo6/2hBGoT0MlcxsgKjIoCoFTdzy3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Szu <jeremy.szu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 125/208] ALSA: hda/realtek: fix mute/micmute LEDs, speaker dont work for a HP platform
Date: Tue,  7 Feb 2023 13:56:19 +0100
Message-Id: <20230207125640.065172068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Szu <jeremy.szu@canonical.com>

commit 858c54152658ccd4e305c1e12d3cc6825bc90504 upstream.

There is a HP platform needs ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED quirk to
make mic-mute/audio-mute/speaker working.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230118115446.14902-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9433,6 +9433,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b92, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),


