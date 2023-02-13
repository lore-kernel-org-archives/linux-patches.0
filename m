Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0648F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:52:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39B3C433EF;
	Mon, 13 Feb 2023 14:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676299953;
	bh=5Oiq0hDAR+C5h0bmRkKfuJpORIZjna8SRW67T9R//o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=doJqjSbKjhatUlxHevpw+i6Uvv+K/fvL/AE/sweZZyHXwFGZ8U0nNeEZsd43HySUb
	 BxLobUYuVFtq2bW8DAGqv4uHxm1kbzAn+/S3H4FROVAXzhuRJ17quIUQLctVTVIwyW
	 9Qe8vrUkQH0U4dAzEgOxFr+PLIVQXVCirY9eId/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elvis Angelaccio <elvis.angelaccio@kde.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 007/114] ALSA: hda/realtek: Enable mute/micmute LEDs on HP Elitebook, 645 G9
Date: Mon, 13 Feb 2023 15:47:22 +0100
Message-Id: <20230213144742.573079414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Elvis Angelaccio <elvis.angelaccio@kde.org>

commit 9a6804aa1c92cd28e89e746ace44d5ba101db76c upstream.

The HP Elitebook 645 G9 laptop (with motherboard model 89D2) uses the
ALC236 codec and requires the alc236_fixup_hp_mute_led_micmute_vref
fixup in order to enable mute/micmute LEDs.

Note: the alc236_fixup_hp_gpio_led fixup, which is used by the Elitebook
640 G9, does not work with the 645 G9.

[ rearranged the entry in SSID order -- tiwai ]

Signed-off-by: Elvis Angelaccio <elvis.angelaccio@kde.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/4055cb48-e228-8a13-524d-afbb7aaafebe@kde.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9423,6 +9423,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x89c3, "Zbook Studio G9", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c6, "Zbook Fury 17 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x8aa0, "HP ProBook 440 G9 (MB 8A9E)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),


