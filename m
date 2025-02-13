Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB5D14658D;
	Thu, 13 Feb 2025 15:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460338; cv=none; b=jPiW3KaNm1jNW1N6I7I62U9EpiED7R9H9ebFB137WackpfD3fvLoA4r8SLy/4cjbR3PN8ARBHwr3/WJVRFv0eCsKOLdjignMvFhUAihxfYlX4bLqGmTzXXLsH4vyaD2JMQOXbzNEXGysvpWXOZWA8gFRdrsZwbmzkuYxI8QIBLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460338; c=relaxed/simple;
	bh=nWh96KCrD3PEcpHFmwEOMbPPkCUTQE5vUb/3gr4Yu00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V9ktYH7oy9ZmTYBHwfuSYpqe7XQXDP+3KO16kXk+yvL2puEdt80s4Zz1OMdS4ypcefCEZ/L2MHYHGWzuxHv7DVENvLucp1MXDc/sZomWTI0oiGmdjZE823LOQTYho1WlndANUnHC6aKLHtrBZAoXijV+aHTzBHRNPBKfKtW6ucc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUWSwyKH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUWSwyKH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AC4C4CEE5;
	Thu, 13 Feb 2025 15:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460338;
	bh=nWh96KCrD3PEcpHFmwEOMbPPkCUTQE5vUb/3gr4Yu00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUWSwyKHhtMzUFTUQWTVDxNLKF4pIi1K+fz/rGX+3do/w6RiMHFAuNHArxcuGeLrJ
	 B+szt0BxBAncWVKr0lRuCStSuOEk15394FH7pxmbZLuf8jlHX/JpSlEVvcFytENWxN
	 3CLUv3/ArcbzaHptcZD/oo5eAA6I//WmPmf8MXyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Wiese-Wagner <seb@fastmail.to>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 083/273] ALSA: hda/realtek: Enable Mute LED on HP Laptop 14s-fq1xxx
Date: Thu, 13 Feb 2025 15:27:35 +0100
Message-ID: <20250213142410.625454193@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Wiese-Wagner <seb@fastmail.to>

commit 711aad3c43a9853657e00225466d204e46ae528b upstream.

This HP Laptop uses ALC236 codec with COEF 0x07 controlling the mute
LED. Enable existing quirk for this device.

Signed-off-by: Sebastian Wiese-Wagner <seb@fastmail.to>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250120181240.13106-1-seb@fastmail.to
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9949,6 +9949,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x887a, "HP Laptop 15s-eq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x887c, "HP Laptop 14s-fq1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x888a, "HP ENVY x360 Convertible 15-eu0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),


