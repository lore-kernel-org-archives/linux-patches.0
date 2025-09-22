Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDF22F0C5F;
	Mon, 22 Sep 2025 19:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569760; cv=none; b=tRb77GfVz7Qv3tTuBtVTz3iytEBuHjGljvEihA4Oib1dRd4lACYJ6oR0S/8BlbLhLaonn7JS6Zjy5LsRwoOURSVGqiW4sdSD3Efni46gpZYtLsTAwjSIO20jCr3NIgoEfj+OhEOdz4QBaOo4U9efHgtjHmFS49RrFTfiL+wWE+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569760; c=relaxed/simple;
	bh=J206l71c2u5t0Z/cnvQ986tGEfkbbbreGJcBIvgbba8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0knuleG8sWPKjN3UZpT/Zwc/f3qLejLHztO55MLSurs5Zww+oC9Q2U4r+VVrYHz+Dtr39qOBSppg43jeC6C9vm0MKNgC2P3osgoEKk56mpf5k1AyXee/wugM1lxUdKlZFF+8jj2reLhpZhgpj3av4SNPAEuJ4BGrAoSktCSigY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK0A+HUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK0A+HUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5F7C4CEF0;
	Mon, 22 Sep 2025 19:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569760;
	bh=J206l71c2u5t0Z/cnvQ986tGEfkbbbreGJcBIvgbba8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fK0A+HURscwBDSnIWQGZVN5Uofgc1sWsW4gE8GvQTvBnfbrc64B7NOA0aTZMT/mBW
	 hGzfh9ASNZlDvE1dWC30+Cdv2wAXoqCVXBlIluNw3eABJuLlHVonzrTeqAH+2Jx5q7
	 3d7jbbL9aHYmZ6muome4XbRxOOwZzq1UrFglc/oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Praful Adiga <praful.adiga@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 46/70] ALSA: hda/realtek: Fix mute led for HP Laptop 15-dw4xx
Date: Mon, 22 Sep 2025 21:29:46 +0200
Message-ID: <20250922192405.850119668@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
References: <20250922192404.455120315@linuxfoundation.org>
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
@@ -10161,6 +10161,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8992, "HP EliteBook 845 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8994, "HP EliteBook 855 G9", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8995, "HP EliteBook 855 G9", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x89a0, "HP Laptop 15-dw4xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x89a4, "HP ProBook 440 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89a6, "HP ProBook 450 G9", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89aa, "HP EliteBook 630 G9", ALC236_FIXUP_HP_GPIO_LED),


