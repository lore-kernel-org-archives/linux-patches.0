Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3981171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E149C433C8;
	Mon, 21 Aug 2023 20:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648570;
	bh=jbvMzFmjSYHmiosVTmRSDrtGUWjWhB7mVg5YNS/JP6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LRw0R86/OZU6n++yCvv5CaVt/Q1m/VJp5rXzf3WjYagS0YMKZB38LkCcxIffgsV4R
	 a/vFs2oVLHzZ7MObabyzk2sX0RoALsBVaAR/3L8gp7x+tf919VoV8yrBzz4qWjkEpD
	 APoo15dMaTctAhpfqtXOXA2xnsBtQHAQHnI/9ZFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 193/234] ALSA: hda/realtek: Add quirks for HP G11 Laptops
Date: Mon, 21 Aug 2023 21:42:36 +0200
Message-ID: <20230821194137.357053488@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit fb8cce69e5e56eedb35fc4d77b2f099860965859 ]

These HP G11 laptops use Realtek HDA codec combined with
2xCS35L41 Amplifiers using SPI or I2C with External Boost.

Laptop 103c8c26 has been removed as this has been replaced
by this new series of laptops.

Fixes: 3e10f6ca76c4 ("ALSA: hda/realtek: Add quirk for HP EliteBook G10 laptops")
Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230809142957.675933-2-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 853d1ed21facd..0289d9109bf32 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9606,7 +9606,13 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8b96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
-	SND_PCI_QUIRK(0x103c, 0x8c26, "HP HP EliteBook 800G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c48, "HP EliteBook 860 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c49, "HP Elite x360 830 2-in-1 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c70, "HP EliteBook 835 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c71, "HP EliteBook 845 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c72, "HP EliteBook 865 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.40.1



