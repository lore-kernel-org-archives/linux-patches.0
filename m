Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E94356748;
	Wed, 20 May 2026 17:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297334; cv=none; b=tLFnPL+6JXMg1NkNZvY9WVyvUsKBBxkZcMnAp+Q8134sYMCsA1MQ/eTEAqvL5XmGlKdefcr69A6+Y7AXoge9JFOspNZ296r7imw+ahSXgEXpdLJY0uk/VJOEJ70UmhA48zrTb0TXzihrJJE4RnQnlW1iMcuBwy+Pu0+v4UPsuVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297334; c=relaxed/simple;
	bh=kJW4sIe7+VU7AzbTv4zSSUJbnBHP6xruPswCAFLGu3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OtoPIjgMv4KSteN8XzP6yDnh1jb9gELZNBjC8zkqGasCNzF5YwJJykyZ9n42IQuXh2dD/BIJ344alb9sqBnSf/mJXlgZJPQC/rdke24iuefpk4y9nOf10WV+dtC0BbhlKoEK33zd4tXX7iT9S+ddlurgayHz5VBIqY9Yzg+WucQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDuiuiri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDuiuiri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C721F000E9;
	Wed, 20 May 2026 17:15:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297333;
	bh=OiVE337kF7WYb7LweRadhXasAMLeQRBL+RZ9Vw4GhiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rDuiuirikUVdwEL9C0imdpm/FcSEcdn4b/k+NKMXz/sUES9/0G1h5yoEqzyCvzV/j
	 Qp9KkAW4WRb52HJrmNRqToO985u8XEPUBZUT4PHxAWcN8/e+VXPwGPTGVeWe3w0TjQ
	 A0qqkkym7p7mMIrTnQpAAuRXmS6PLUPUmouKQEWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Burnett <an.arctic.pigeon@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 1088/1146] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion Laptop 16-ag0xxx
Date: Wed, 20 May 2026 18:22:18 +0200
Message-ID: <20260520162212.859052906@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7146,6 +7146,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8caf, "HP Elite mt645 G8 Mobile Thin Client", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8cbc, "HP Pavilion Laptop 16-ag0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8cbd, "HP Pavilion Aero Laptop 13-bg0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8cdd, "HP Spectre", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8cde, "HP OmniBook Ultra Flip Laptop 14t", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),


