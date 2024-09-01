Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4BA537FF;
	Sun,  1 Sep 2024 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208244; cv=none; b=DVegnpgOmj7zPIPOPbXNUM5x1PWJjM4ZIVFNW5E9p6puE+oudTvSGIWS+Y6GVkF16vatDHgowVXMAqWf97KNAI3QfTU1LCPkTQ9ST4hYJMLhx0Boc2pWC9S5dak75vImLdP2bb3Q8VBS4R+QJkTgrMkmKGzGJqyxM74lGry+M34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208244; c=relaxed/simple;
	bh=7i5AIydh/fGlbuuE1runtAWyKv9Qe044sTbBOYf64Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObrAOnI/t42lvPMxjcoGmdt+QJm2FfIdfAenKmx7YUHQowN+HK376tIpzcq8QqDp0q1wrts5X03wt9Byj5i3fhw6xcN3mDlo35TwRbY4SKXRfRL29r6A9WmVnZzBRfYXqlBqJLlsPt04m/OwjPGdN4TZQPPZPSjtXeTOUyZRxMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkwD771f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkwD771f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30967C4CEC3;
	Sun,  1 Sep 2024 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208244;
	bh=7i5AIydh/fGlbuuE1runtAWyKv9Qe044sTbBOYf64Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkwD771fSlsy9Vvy9RXZfPv6/67Gg9Ho17kpUyPIf5iucGEVAlhGIoztRX7wrqf2A
	 jeLIctHiKM471Kvdvr4/gqy2hGsmsBfO5z4hSzh42+SxFdW9r6tg3WBKzpGPAstw6P
	 ruB372aODQi285JQdHipc9U991Cs/hcqrz2Zlibw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hendrik Borghorst <hendrikborghorst@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 005/149] ALSA: hda/realtek: support HP Pavilion Aero 13-bg0xxx Mute LED
Date: Sun,  1 Sep 2024 18:15:16 +0200
Message-ID: <20240901160817.668792390@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hendrik Borghorst <hendrikborghorst@gmail.com>

commit 2dc43c5e212036458ed7c5586fb82ee183fee504 upstream.

This patch adds the HP Pavilion Aero 13 (13-bg0xxx) (year 2024) to list of
quirks for keyboard LED mute indication.

The laptop has two LEDs (one for speaker and one for mic mute). The
pre-existing quirk ALC245_FIXUP_HP_X360_MUTE_LEDS chains both the quirk for
mic and speaker mute.

Tested on 6.11.0-rc4 with the aforementioned laptop.

Signed-off-by: Hendrik Borghorst <hendrikborghorst@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240825174351.5687-1-hendrikborghorst@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10260,6 +10260,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8cbd, "HP Pavilion Aero Laptop 13-bg0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8cde, "HP Spectre", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8cdf, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),


