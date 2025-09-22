Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF28D27B320;
	Mon, 22 Sep 2025 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569576; cv=none; b=gLtMduoMlUejsILHTcz8fDdlIoHXKm586WUCHgeW2KxQ9g8lx2Ynplr+bpmwXmX8f1tw4hkx83LqrhuJ5snVichZXg1ZSSD10MWtX8A8MRmPnWREFci2Y2ycvN7tuSJRyswsACx7dYrjNTainFRIoxdBF/xvyVNMBHO2oOOKGNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569576; c=relaxed/simple;
	bh=JzdEhYd134Vq1Aw25z6wiGuZPEAVTvHwiLY8RhsfvEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hx6s74QEMtONTx8w8kiQ111O2k7dt2LDmjC9DZ+cJgsSi2u+6b9iR/iVROhdVFXLABOwwdgzDdAuWvzWgsTKNrK9jAuSKSGpyQoKFMVnRYjannX/OxG4EmBUzYUiY13CiC8IQi0WWyz1JyYtkX+eybqM1jJAYquU6ixIruiMhYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNHF6e4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNHF6e4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEC9C4CEF0;
	Mon, 22 Sep 2025 19:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569576;
	bh=JzdEhYd134Vq1Aw25z6wiGuZPEAVTvHwiLY8RhsfvEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNHF6e4se9sBvc0LHfE2h4a1IKoiJWjvElhP2zwO10x+d5qx+/9oyLvIxMQAqlCBH
	 Afx7jVvRpPDdlrcgMgxavJrht8K+peu9UWo9/wwvIM/difbwaA0Mw4cT5pOxearg2k
	 /pHtFdKCyTYSP9CbLT4+xtkLchNGBVwahZqFTgM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praful Adiga <praful.adiga@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 35/61] ALSA: hda/realtek: Fix mute led for HP Laptop 15-dw4xx
Date: Mon, 22 Sep 2025 21:29:28 +0200
Message-ID: <20250922192404.529906956@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Praful Adiga <praful.adiga@gmail.com>

commit d33c3471047fc54966621d19329e6a23ebc8ec50 upstream.

This laptop uses the ALC236 codec with COEF 0x7 and idx 1 to
control the mute LED. Enable the existing quirk for this device.

Signed-off-by: Praful Adiga <praful.adiga@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10005,6 +10005,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8992, "HP EliteBook 845 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8994, "HP EliteBook 855 G9", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8995, "HP EliteBook 855 G9", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x89a0, "HP Laptop 15-dw4xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x89a4, "HP ProBook 440 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89a6, "HP ProBook 450 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),


