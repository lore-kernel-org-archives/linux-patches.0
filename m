Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E55324EF7A;
	Thu,  3 Apr 2025 15:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693987; cv=none; b=fpAmT7H9LbehmwmiSiua1TV/dplZP/iBX/Ka1908LW/HHhdcabNqiuQRDKcvwfqBr/cDVZLwvYkcrah/X1B5aTJrWAJcTxKqJquFUBfLV/QH3kDKPFi4t83UC/ht7wgkziUR9bJBCZ8RshY9O1ZbB03Lz63gLmxDEr1m2O1pBaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693987; c=relaxed/simple;
	bh=+AKySAybjKTKnULvz+kRnN1F4+I4w5VQFvxJnG0bnmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7bkeWwiUG+7GrPXb2DPPpUydOGhe1AhAUvLYAgz04KiS9kwQYKkOmZOkJIm+TkEoYsg4L/ypN6hVrEyoxV9/gRgCif1VeefeL6VqweyHHQtRs388JnN3NSC1G3EZkgl/ae6Mxw0bZmic+SwthB4PqxeB4hupWRUMUc+DpXFDCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niW15FU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niW15FU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BACC4CEE3;
	Thu,  3 Apr 2025 15:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693987;
	bh=+AKySAybjKTKnULvz+kRnN1F4+I4w5VQFvxJnG0bnmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niW15FU9dB0zDqH5BxsUZ5Nn0zRnOs32FPjBTFIzbSKIUpZW21IFzVZhyMUPpzV6F
	 A+1UKv9qVPXNguiO2QG6cV6eQrMTCiLi2dWqsE8UQE5HGyvc80ezgmNJysr1IykQLf
	 c2nx1nANiYLxnuEsHcT/c5rT/+YyEH9Lx0x5iVO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruv Deshpande <dhrv.d@proton.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 15/26] ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx
Date: Thu,  3 Apr 2025 16:20:36 +0100
Message-ID: <20250403151622.856571192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
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

From: Dhruv Deshpande <dhrv.d@proton.me>

commit 35ef1c79d2e09e9e5a66e28a66fe0df4368b0f3d upstream.

The mute LED on this HP laptop uses ALC236 and requires a quirk to function.
This patch enables the existing quirk for the device.

Tested on my laptop and the LED behaviour works as intended.

Cc: stable@vger.kernel.org
Signed-off-by: Dhruv Deshpande <dhrv.d@proton.me>
Link: https://patch.msgid.link/20250317085621.45056-1-dhrv.d@proton.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10023,6 +10023,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8811, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x8812, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x881d, "HP 250 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x881e, "HP Laptop 15s-du3xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


