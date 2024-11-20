Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECC91B5821;
	Wed, 20 Nov 2024 13:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107624; cv=none; b=E//GNm9H8hnYfMNJiPIcNX/7FERi6y58vipOJMh+02mocx4zzXLebIj0jT5EO5e/nEB6OyfFmcgL6x/1U3uQ9so68fBpHkDRqds5WuLcDKB1GQ/PC3SrHPzsGwtDRHM9fbnxOENsOGPg0My60DPBPVaIWxk86ZPq/NzFvSYWzvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107624; c=relaxed/simple;
	bh=uBctpCBxbv73vOzSz3BSu7n4b5JhAkkba+v6N/P2toc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGneerAFKNUxjas8SI16RxsOsV9alovBmujPy7LSdKH79AEByCLIk44OzJZgmXHfY4Vcjv0s4mqy/6TGA35qK4Tt7lOtOqRlPo6UYcbc0ilD76KalBeRPY7JLJZs3tYahyPBPGFv54nrzHRVVYuvEOQQrSV6JBBOP9zqFmgMGcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NIk0FsjH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NIk0FsjH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC57C4CECD;
	Wed, 20 Nov 2024 13:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107624;
	bh=uBctpCBxbv73vOzSz3BSu7n4b5JhAkkba+v6N/P2toc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NIk0FsjHEybroazY1fF6HLNukc8qMykTRSY5wsDH+tmEyY4fv8G9XG3SX2I3GFbcd
	 bG4G+Dl9Zos+RTEYF51PBLTyhfGMbfZBrSNoWnMrCgpm8yHX6ULzihB2kCWv2vtyCe
	 RZwoS1RlODE3xoleMO3U/uoV207O2jwo7ZQkLcTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksym Glubokiy <maxgl.kernel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 42/82] ALSA: hda/realtek: fix mute/micmute LEDs for a HP EliteBook 645 G10
Date: Wed, 20 Nov 2024 13:56:52 +0100
Message-ID: <20241120125630.560266787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maksym Glubokiy <maxgl.kernel@gmail.com>

commit 96409eeab8cdd394e03ec494ea9547edc27f7ab4 upstream.

HP EliteBook 645 G10 uses ALC236 codec and need the
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to make mute LED and
micmute LED work.

Signed-off-by: Maksym Glubokiy <maxgl.kernel@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241112154815.10888-1-maxgl.kernel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9996,6 +9996,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8b59, "HP Elite mt645 G7 Mobile Thin Client U89", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b5f, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b63, "HP Elite Dragonfly 13.5 inch G4", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b65, "HP ProBook 455 15.6 inch G10 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b66, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),


