Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CC114F9C8;
	Tue, 20 Feb 2024 21:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463213; cv=none; b=EVF3jrJKBX0lSeUyffEdiZ8eiVEwX/2gw0SDYtWhoJgusaRSTQkA5NzdrBPeVqTvrGyIqCeMwpX6A3SKJl1qLPR/FZ1pm1R5RpbW6xTJMCB92GWvxCjU1ASD7RiWQgSOvFDnoqj4Wee6yIoNVNGo9ggbgpB6+/bJtRk1pMiME7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463213; c=relaxed/simple;
	bh=KTSJLZ+6V5YTFUZg8to+pJTwliWA7Hx5mRPtiRx+H08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/zgfzQqNjIR1J/L3MN/iW3aUPcVQpY2TBo5/qHFBetZNapeooHGhT7QCNMRuHlD2qM37ZgJ0By85A4Zzt/iSeekDfOaZ32mmlERgpZKuGeqnBM/iIrVgMGIpO5t7xFdjMgkumciz/5ASleuGy6yaBtGxXxlsC2Ki7K55vGv93A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRpxduk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRpxduk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27188C433F1;
	Tue, 20 Feb 2024 21:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463213;
	bh=KTSJLZ+6V5YTFUZg8to+pJTwliWA7Hx5mRPtiRx+H08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRpxduk5criNXrxJxV19i+Wtva/jkRWAX/gN+Qp52RcTV/csgSnNHTpc5mrxqTqX4
	 sG9OLxzVoOMeFnhCTkqBJgQpzmE+J4mGP3B4zvuAfuiq3OW302KOJeOfkB7ORIBqsM
	 Wm30nMQ9VJwGXXk6lnjCkqBTaEeqeBj9WSlH9AvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eniac Zhang <eniac-xw.zhang@hp.com>,
	Alexandru Gagniuc <alexandru.gagniuc@hp.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 133/197] ALSA: hda/realtek: fix mute/micmute LED For HP mt645
Date: Tue, 20 Feb 2024 21:51:32 +0100
Message-ID: <20240220204845.053678699@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

From: Eniac Zhang <eniac-xw.zhang@hp.com>

commit 32f03f4002c5df837fb920eb23fcd2f4af9b0b23 upstream.

The HP mt645 G7 Thin Client uses an ALC236 codec and needs the
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to make the mute and
micmute LEDs work.

There are two variants of the USB-C PD chip on this device. Each uses
a different BIOS and board ID, hence the two entries.

Signed-off-by: Eniac Zhang <eniac-xw.zhang@hp.com>
Signed-off-by: Alexandru Gagniuc <alexandru.gagniuc@hp.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240215154922.778394-1-alexandru.gagniuc@hp.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9690,6 +9690,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b0f, "HP Elite mt645 G7 Mobile Thin Client U81", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b2f, "HP 255 15.6 inch G10 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8b42, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b43, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
@@ -9697,6 +9698,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8b45, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b46, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b47, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b59, "HP Elite mt645 G7 Mobile Thin Client U89", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b63, "HP Elite Dragonfly 13.5 inch G4", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),


