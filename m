Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4073BE64B;
	Wed, 20 May 2026 17:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299853; cv=none; b=beQ3YXOYwvV2e+hympWplTTQ4QHULh4OV5iNV4vBSTLS2SjmaDpkpn0dOF00Cwd/Z4IP7+XDBhCfuNxzwvz2JYoeH4iYFBKKlesEwkP1ERXnSEH4T1N0I+o+1forXVsl4/iDzp9RpI03fakfh1WHHq0PhD0SUHxAWtIxZkofkzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299853; c=relaxed/simple;
	bh=2KseTn3SbY426e69M2IGrW/QfqgJaMnHxPBzK0XLpf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VG8et71kRTeXaFv+VlfLvfn8dp4eappR7F1++xP4bY65nZvZe3Y1uE0o45i7rfSlKOUuBkdstrEMsIS7bWs7x9dtQmbjYlrugUnPhcNQTwkQhFQMHBLD6RzvvDPFOQnYhgqXpm5MYdraa1tqokR3kAZkiLReRf47HfFQZSau/1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1SId+33; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1SId+33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29C31F000E9;
	Wed, 20 May 2026 17:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299852;
	bh=lN0bu2yJQydjTcfa4Bk4QLXswL2/5Z9K5XfdArNl3a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1SId+332sRsEc9VogK4gvJxu37DsNVFmwxUvhWnsm4p8Td4R7ejTILHDShW+x0+N
	 7SGKE67FB2lARbLNd+wv5n6fFBiJe0WLvFdxaFe6JqoCPtZXOeyJ7SwS5Yqik1Ayk6
	 2pxobYIEXLgBZaXIFOC21IopXvnJUuS7dXua/rhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Burnett <an.arctic.pigeon@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 911/957] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion Laptop 16-ag0xxx
Date: Wed, 20 May 2026 18:23:14 +0200
Message-ID: <20260520162154.332633728@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrien Burnett <an.arctic.pigeon@gmail.com>

commit 7d1051ad68df3d584b5f24bfa1fb19f3a24db278 upstream.

Add a SND_PCI_QUIRK entry for the HP Pavilion Laptop 16-ag0xxx
(subsystem 0x103c:0x8cbc, Realtek ALC245). The
ALC245_FIXUP_HP_X360_MUTE_LEDS fixup is already used by the
neighbouring HP Pavilion Aero Laptop 13-bg0xxx (0x103c:0x8cbd);
it chains the master-mute COEF handler with the GPIO mic-mute
LED handler, which is what this machine needs.

Tested on the affected hardware: both the mute and mic-mute key
LEDs respond correctly to the keyboard hotkeys after this change.

Cc: <stable@vger.kernel.org>
Signed-off-by: Adrien Burnett <an.arctic.pigeon@gmail.com>
Link: https://patch.msgid.link/20260514165905.21175-1-an.arctic.pigeon@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6960,6 +6960,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8caf, "HP Elite mt645 G8 Mobile Thin Client", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8cbc, "HP Pavilion Laptop 16-ag0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8cbd, "HP Pavilion Aero Laptop 13-bg0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8cde, "HP OmniBook Ultra Flip Laptop 14t", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),


