Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C777A1EB5A;
	Mon,  4 Mar 2024 21:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587758; cv=none; b=lkl2uKFpMnT5b7SbXbYr+M4cmpiwPKmHnFaW6tfPqhChpVOtUodQCiW2e4VClUtN0d33BhIhCdrlUGRKIuMYm420o6aKLC71EYXEjOOMbMvcOYFPlYS9VMdrAofuMwpzZJ2+vjaIjhPyCTUbyoLzCO+EkfTvNSSaqCZxVR5NFUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587758; c=relaxed/simple;
	bh=eKT316BK8tRgAT6gTla6vnz2jX4OMj9jWUJa88ohqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3o0nlMZf7zOsJvZnKAGOjuRHAagMqQpviRbTdUK3gXx/sY3JEESTU6ALuvMaY1caHmo3/8rqBOPIU0vg/0YS0E9DrEa4N+Uoo0ZRjt7sVGvSF4l27L1AG9HYq8yQF/YJu4/kSDRB69jy6hIrRGU1Khf0JEg+l7WrUicuxhutDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRcAs5rg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRcAs5rg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C28DC433B1;
	Mon,  4 Mar 2024 21:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587758;
	bh=eKT316BK8tRgAT6gTla6vnz2jX4OMj9jWUJa88ohqzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRcAs5rgz8GW3F7aUp5/6/6++JJjCo71dft1IG/lC46EOZOVDY4agXIjEbJDJ9FG2
	 Yb/B8G8YYXKVwYojfhgzNKvDHIinWolIvEHNbW3+gqinlX+5gAQCxebSQ/X2kBdvVU
	 ccmSXGInlmEk9wWJtS1PYY80H3nm4L/2SnG/cYHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eniac Zhang <eniac-xw.zhang@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 079/162] ALSA: hda/realtek: fix mute/micmute LED For HP mt440
Date: Mon,  4 Mar 2024 21:22:24 +0000
Message-ID: <20240304211554.376157891@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eniac Zhang <eniac-xw.zhang@hp.com>

commit 67c3d7717efbd46092f217b1f811df1b205cce06 upstream.

The HP mt440 Thin Client uses an ALC236 codec and needs the
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to make the mute and
micmute LEDs work.

There are two variants of the USB-C PD chip on this device. Each uses
a different BIOS and board ID, hence the two entries.

Signed-off-by: Eniac Zhang <eniac-xw.zhang@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240220175812.782687-1-alexandru.gagniuc@hp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9890,6 +9890,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8973, "HP EliteBook 860 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8974, "HP EliteBook 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
@@ -9921,6 +9922,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b0f, "HP Elite mt645 G7 Mobile Thin Client U81", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b2f, "HP 255 15.6 inch G10 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x8b3f, "HP mt440 Mobile Thin Client U91", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b42, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b43, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b44, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


