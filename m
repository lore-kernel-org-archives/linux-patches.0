Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A465102D;
	Mon,  8 Jan 2024 15:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCaKD/xw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61877C43395;
	Mon,  8 Jan 2024 15:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728269;
	bh=omZd7E8Lh6AGRSY4XpplDaGHD6b0S8k5r93E/cEnqxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCaKD/xwh/6IhvAbaRBxLVVUJ7xpU6RWwwBm7MuDsCd4NeHMG7O/75AjmEuDoNkx2
	 T+Hg/SMFeavQ9xGzBrB4yjnKT2/qM30ejZkMcewAOYW31V0SueDUO3NYglM90eT7ld
	 eG4N9nxViC+xZWQ6QMhj8m1nTbXekrvx33C/OG6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aabish Malik <aabishmalik3337@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 003/150] ALSA: hda/realtek: enable SND_PCI_QUIRK for hp pavilion 14-ec1xxx series
Date: Mon,  8 Jan 2024 16:34:14 +0100
Message-ID: <20240108153511.386606299@linuxfoundation.org>
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

From: Aabish Malik <aabishmalik3337@gmail.com>

commit 13a5b21197587a3d9cac9e1a00de9b91526a55e4 upstream.

The HP Pavilion 14 ec1xxx series uses the HP mainboard 8A0F with the
ALC287 codec.
The mute led can be enabled using the already existing
ALC287_FIXUP_HP_GPIO_LED quirk.
Tested on an HP Pavilion ec1003AU

Signed-off-by: Aabish Malik <aabishmalik3337@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231229170352.742261-3-aabishmalik3337@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9663,6 +9663,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x89c6, "Zbook Fury 17 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8a25, "HP Victus 16-d1xxx (MB 8A25)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),


