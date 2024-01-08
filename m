Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907D51E4A2;
	Mon,  8 Jan 2024 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AfqDSEii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C344C433CD;
	Mon,  8 Jan 2024 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728273;
	bh=0NA4CzTsXc0e84jqNcGj9n7umAdkBJR90UXPdjm0H24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AfqDSEiixzvgOxzlgdDl1c1Pk3I0FCEgBwGDh6IrAp/J4Xx/zJP2qqil8ugQhtnwq
	 CU7K+Aamn6keDwStLvEypPbgwXDmiUU5qt4dqKBdfJ5OZmec/RirQIviPdwhFVOvJ0
	 uqMHN96oZ57xp7GpFcBynM12MbNvZ1iXoXacZYR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chi <andy.chi@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 004/150] ALSA: hda/realtek: fix mute/micmute LEDs for a HP ZBook
Date: Mon,  8 Jan 2024 16:34:15 +0100
Message-ID: <20240108153511.427123399@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chi <andy.chi@canonical.com>

commit 18a434f32fa61b3fda8ddcd9a63d5274569c6a41 upstream.

There is a HP ZBook which using ALC236 codec and need the
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to make mute LED
and micmute LED work.

[ confirmed that the new entries are for new models that have no
  proper name, so the strings are left as "HP" which will be updated
  eventually later -- tiwai ]

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240102024916.19093-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9708,6 +9708,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c70, "HP EliteBook 835 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c71, "HP EliteBook 845 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c72, "HP EliteBook 865 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),


