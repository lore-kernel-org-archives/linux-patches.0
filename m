Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087B12377B;
	Thu, 18 Jan 2024 10:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575505; cv=none; b=LqL/aOi4X0/BZTG9Bjhfm8HBy3MRX/HYGb3+wPw3I2hHXAKKsXrIkN/l7PI9JubolUVvKwCcpzBm2XCCvSzLAvlanveF5LayxhzUpSV6EO8H8vUnYUg+TS2I/0LnRAbz1MPzBLVKzb45bMnl/MGh253vLTZJlxJI1MnWtEHk1Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575505; c=relaxed/simple;
	bh=6++ZeRTK3f2yfFxNQj3GEn3PMN7i3s9lWcZYBhrf2nA=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=K00Y8Q4XO6LdweVbLu+ULJcOZSMuDf3SoeLguDSxy5yMDKah2Jh3sESp5B03F1LMNzG03+PYdAqmX08Pv4yfpzJHsTpxyPmk75mRdKm1pGr4EeqRiaIbaH6chjxWCLLHOJmQqU02YLRjiNI2Kl4mJdcu9nZnUFvvgcirFfxgsBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qu8fp+yB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qu8fp+yB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812C8C433F1;
	Thu, 18 Jan 2024 10:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575504;
	bh=6++ZeRTK3f2yfFxNQj3GEn3PMN7i3s9lWcZYBhrf2nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu8fp+yBjYVia9SUgo6EfIrhSwcn9xzSp2uo/dwEJAYN2pJ/G6t75O1c6eN0T9DF+
	 0nYaedThnsq9rxueReuDKncJpvSldJ/L10N7IyRoQOlg6s2ZseE3Uhr0IZrzQtFMNy
	 50WGhng6HsQmDO6Dbc3wOZyb/QfNlE9lA+OUI9zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Jason Schwanke <tom@catboys.cloud>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 130/150] ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP Envy X360 13-ay0xxx
Date: Thu, 18 Jan 2024 11:49:12 +0100
Message-ID: <20240118104326.063785364@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Tom Jason Schwanke <tom@catboys.cloud>

commit 6b3d14b7f9b1acaf7303d8499836bf78ee9c470c upstream.

This enables the mute and mic-mute LEDs on the HP Envy X360 13-ay0xxx
convertibles.
The quirk 'ALC245_FIXUP_HP_X360_MUTE_LEDS' already exists and is now
enabled for this device.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216197
Signed-off-by: Tom Jason Schwanke <tom@catboys.cloud>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/651b26e9-e86b-45dd-aa90-3e43d6b99823@catboys.cloud
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9735,6 +9735,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x876e, "HP ENVY x360 Convertible 13-ay0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8780, "HP ZBook Fury 17 G7 Mobile Workstation",


