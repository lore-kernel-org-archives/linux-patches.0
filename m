Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C9A2505DD;
	Thu,  3 Apr 2025 15:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693897; cv=none; b=eSKJH+TNGX1VUMlJBMA8IGYjcKRAm0dJI4gXCOshwEMckRwftzC1rh32ljEgKzQ7EzTe6cqhUWneFT84XjZ1KuT8uysf5fMy6LJqTBIm9jt6Uk974Awbn65G1W+dCodo9XBuLCyZaZCrZl2awVWqSc2vqguTwIn1B2sE/8+GINY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693897; c=relaxed/simple;
	bh=hwrTPshLl0KZY7ckvUMoEz8A2I86+B9A/Dt1iGgb2DM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIvsM3a9Y95nhxZY2seS7akM38hUzJ7CIiR+D+Y7H0c9t84+hcyIy1h6tq5XZ1kHtNoq4GRBiTmg/1hylwZkqbvT2MNPpLPBn3S7w93q3YVpW14fU1XuN5nlxAw8sTN/JLL0saoPcn6aJE+kayiDVSCjKb570uMOIXGc1lSDvTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTTZoNSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTTZoNSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F180BC4CEE3;
	Thu,  3 Apr 2025 15:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693897;
	bh=hwrTPshLl0KZY7ckvUMoEz8A2I86+B9A/Dt1iGgb2DM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTTZoNSlN+1YgDTrGbzz8fYH9mnCB9xbpkCA7PSXqdfqltkNrA31EwC3ovSSaEMU5
	 81An1rdd2ZIP2DCJHETdQVVzQ84f/hl1JlRxFc4jWOSXHEK5kXvTZJPaUNNtrU8/g5
	 y7QPks+46bs6vBtk+pYYWCYS0xX26IRV7MTV5NqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruv Deshpande <dhrv.d@proton.me>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 07/22] ALSA: hda/realtek: Support mute LED on HP Laptop 15s-du3xxx
Date: Thu,  3 Apr 2025 16:20:17 +0100
Message-ID: <20250403151622.253072114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
References: <20250403151622.055059925@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10441,6 +10441,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8811, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x8812, "HP Spectre x360 15-eb1xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x881d, "HP 250 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x881e, "HP Laptop 15s-du3xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8846, "HP EliteBook 850 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8847, "HP EliteBook x360 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x884b, "HP EliteBook 840 Aero G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


