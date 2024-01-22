Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CD26EB68;
	Tue, 23 Jan 2024 02:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975421; cv=none; b=uik4TWpx8l9bhlbSrrg/PYMD94GaGZMnpDvjSc4LKC3o0EUJHwj7+NhwwB89hy7T1yUQ1mBGbyK9d1E+r7PC6LMs6y8tFBwYxE/UOvQB85XWF6V2ftrPqFPdR/ih0omKQg0ScDBg6eznqtZ9ICV8d5HGzjMQVwb94Nbg9nbKGuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975421; c=relaxed/simple;
	bh=1T4SPQjZWjfSvE8LUvM1gtsF2l2mh41IvUMbVh3NEnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BDs+5vdSmytAVPJW2Rvtpr4x/R70vwTHdZbG2lxwcat5uZxGFBnZZifDfJ5NVIkBx7w3b4sJdC4LpXl2FZxwYoAQ2FEalv2fxhyIe2qC9RQB7ynhHlaaIHyqdOVajlPWr69wm+ACc7YNTrmhIoxP+GY9q/KkT1TsHfsHjFr8hiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTXk4XZ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTXk4XZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E0EC433C7;
	Tue, 23 Jan 2024 02:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975421;
	bh=1T4SPQjZWjfSvE8LUvM1gtsF2l2mh41IvUMbVh3NEnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTXk4XZ/Bx78d5BUMlGuD6bIxEih/FbjoTYMFCd88J2bYLKHihabpD1wnaYXcGVFI
	 wNhSHSRDYVQlgtzPvgyJdvDyWLDxetYrDDwriwjmu0Ob2m9+LgF2ZDBjRVm8FmtJDA
	 ZxEPeALWGE2qXRRGx+S/5XDHEBda2sn4tafrJqUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=87a=C4=9Fhan=20Demir?= <caghandemir@marun.edu.tr>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 380/583] ALSA: hda/relatek: Enable Mute LED on HP Laptop 15s-fq2xxx
Date: Mon, 22 Jan 2024 15:57:11 -0800
Message-ID: <20240122235823.629074350@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Çağhan Demir <caghandemir@marun.edu.tr>

commit bc7863d18677df66b2c7a0e172c91296ff380f11 upstream.

This HP Laptop uses ALC236 codec with COEF 0x07 idx 1 controlling
the mute LED. This patch enables the already existing quirk for
this device.

Signed-off-by: Çağhan Demir <caghandemir@marun.edu.tr>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240115172303.4718-1-caghandemir@marun.edu.tr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9754,6 +9754,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x87fe, "HP Laptop 15s-fq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8811, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),


