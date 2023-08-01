Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D5351FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861B8C433C8;
	Tue,  1 Aug 2023 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883276;
	bh=zLymHTM2wiGm8Z9dCwfy0KoGiIVXPYTdBZUZJFOqGCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3mpxXRboOspwhmItKkz/bjLRNcNaKU/zBn3ztJjFXPEab+RBdx9TJQrrHPOhWUP2
	 +SfnPRCPCEzLFPa7xjZQCbAj1mbSH0AnX1XIHeWkwxh9Hr+KZGn4JPaLd15/nSrsQX
	 n9t/F5HiQfRuBWH/TcXsy5wGIjJttef8Kq/px6o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Guzenko <l.guzenko@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.4 178/239] ALSA: hda/relatek: Enable Mute LED on HP 250 G8
Date: Tue,  1 Aug 2023 11:20:42 +0200
Message-ID: <20230801091932.066241009@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luka Guzenko <l.guzenko@web.de>

commit d510acb610e6aa07a04b688236868b2a5fd60deb upstream.

This HP Notebook used ALC236 codec with COEF 0x07 idx 1 controlling
the mute LED. Enable already existing quirk for this device.

Signed-off-by: Luka Guzenko <l.guzenko@web.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230725111509.623773-1-l.guzenko@web.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9502,6 +9502,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8811, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x8812, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
+	SND_PCI_QUIRK(0x103c, 0x881d, "HP 250 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


