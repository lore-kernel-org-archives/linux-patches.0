Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B25171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:34:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FA0C433EF;
	Mon, 22 May 2023 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784040;
	bh=xH+H4TV5ebWLxDovU1pG8EOJaNbnm8nsJUKC9Du6tw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUnArnhIWX279STBazLMt3NNCPKbjcb95yoSVciZbDYrveAC8DwtXC1yAEi+5mBq9
	 EsUVlivhHUTXmIDxHwlLoYXoPEuzJuC/AnVWhRkuzLpLR7/I47p87eRXZBvuXE2I/Y
	 wN5FVKItDVaHYTIlsyJpeSLEyIXNtxJ74C0t131E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 244/292] ALSA: hda/realtek: Fix mute and micmute LEDs for yet another HP laptop
Date: Mon, 22 May 2023 20:10:01 +0100
Message-Id: <20230522190412.049838475@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 9dc68a4fe70893b000fb3c92c68b9f72369cf448 upstream.

There's yet another laptop that needs the fixup to enable mute and
micmute LEDs. So do it accordingly.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230512083417.157127-1-kai.heng.feng@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9485,6 +9485,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8b8f, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b92, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c26, "HP HP EliteBook 800G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),


