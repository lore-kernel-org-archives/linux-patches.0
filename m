Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDB71A29F
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYN1twPP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6601C433C8;
	Mon, 16 Oct 2023 08:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446373;
	bh=0USOAm+fI31Wwzw069R2ST//+Pm2JHuqIog7dMp7mvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYN1twPPkA7JKyH/clXrHwIZi6ZWs9SxupvbLYxbafcXELaFrOItaqV7XBYnwbWAj
	 BLxojX0HNu2J4C4V+jQI4Qrtt6N7vQZNwpRqLMxyRBRdhRASRDFlEI7Ujot9tDCGlI
	 XIwvC390CBdahxK5akAMMq7rCMUIkxYF7hnp6DEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 020/131] ALSA: hda/realtek: Change model for Intel RVP board
Date: Mon, 16 Oct 2023 10:40:03 +0200
Message-ID: <20231016084000.568692565@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit ccbd88be057a38531f835e8a04948ebf80cb0c5d upstream.

Intel RVP board (0x12cc) has Headset Mic issue for reboot.
If system plugged headset when system reboot the headset Mic was gone.

Fixes: 1a93f10c5b12 ("ALSA: hda/realtek: Add "Intel Reference board" and "NUC 13" SSID in the ALC256")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/r/28112f54c0c6496f97ac845645bc0256@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9697,7 +9697,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
-	SND_PCI_QUIRK(0x10ec, 0x12cc, "Intel Reference board", ALC225_FIXUP_HEADSET_JACK),
+	SND_PCI_QUIRK(0x10ec, 0x12cc, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
@@ -9920,7 +9920,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", ALC256_FIXUP_INTEL_NUC10),
-	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC225_FIXUP_HEADSET_JACK),
+	SND_PCI_QUIRK(0x8086, 0x3038, "Intel NUC 13", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0


