Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA651991B4;
	Thu,  6 Jun 2024 14:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683152; cv=none; b=uDlD8USaMRLcdDUbjgfvGeLUnT0w17LU3jv36gUm2+zH4dB5IMNCxz7npwrob6OGxd4NiSYgSWiWExiFTm8Gjh+mzf789sxngZFCBbGr2G2PdUEpzxxTRHzR3/QrZwUe7lXmZJJcQRxTAjbZ3N1ItEEAkaWxiZzAWOzr7KpFzGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683152; c=relaxed/simple;
	bh=Dtjpv2KiGYdwgEkY3WXwnXiuxzR0J+QwAPgjunfilHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOMIzsVF72vmGjhTU+EExOrM3dcT4lsiE+qZA48RMmCtek+vwUP0cL6Yg5ocUtwtqZIZwsDWcXrVIeK05ymskJdy8klGquM7V8M5+qcYHrFZ+kChFDrlHw2qa9Avmqfl+CAZnN2pqsn6ljADK+43JP4YD28LZzvenxSK/LOB8fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZFJuuvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZFJuuvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34AF4C2BD10;
	Thu,  6 Jun 2024 14:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683152;
	bh=Dtjpv2KiGYdwgEkY3WXwnXiuxzR0J+QwAPgjunfilHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZFJuuvPxGfdUzw1/Q4VW/etqs2J+4+PZEQI2LShhmH3ReZMFQFUggydHwV7D7xJS
	 4BWWUc/3a1jbXegPJFO0LhtxUjUAvSHj7FjBBWxYNBIdDKk3361deNsY+yy4FksmK8
	 POy95mnymZEwcuU9KCcDyyHWC/wr1Ab3iF5mhIjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chi <andy.chi@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 023/473] ALSA: hda/realtek: fix mute/micmute LEDs dont work for ProBook 440/460 G11.
Date: Thu,  6 Jun 2024 15:59:12 +0200
Message-ID: <20240606131700.622859503@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

commit b3b6f125da2773cbc681316842afba63ca9869aa upstream.

HP ProBook 440/460 G11 needs ALC236_FIXUP_HP_GPIO_LED quirk to
make mic-mute/audio-mute working.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240523061832.607500-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9793,8 +9793,11 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c70, "HP EliteBook 835 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c71, "HP EliteBook 845 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c72, "HP EliteBook 865 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c89, "HP ProBook 460 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8a, "HP EliteBook 630", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8c, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c8d, "HP ProBook 440 G11", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8c8e, "HP ProBook 460 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c90, "HP EliteBook 640", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c91, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),


