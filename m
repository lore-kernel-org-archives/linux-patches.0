Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74F5611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF64C4339B;
	Sun, 28 May 2023 19:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303339;
	bh=3Uf595Jknc3eLB79ThMn9PGVeA3zUR2SdQBQF6VlH5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SX3m13guKz8bsQL6F7GZOnNDC6FNUjtq9dtX35WVqEpPLCkDluaNsX5vHdqyMb+j8
	 RS4CiWf3HTLrCtT/3LO6onDnOmGo6YcYIvpAuSFdoxmzEssxI6yxBuY5iib0w6KZXw
	 hOETZYi3Dt79CUBzcyBA7RnqOSzT3rfDHJTQBT4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Stylinski <kungfujesus06@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 11/69] ALSA: hda/ca0132: add quirk for EVGA X299 DARK
Date: Sun, 28 May 2023 20:11:31 +0100
Message-Id: <20230528190828.768791814@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adam Stylinski <kungfujesus06@gmail.com>

commit 7843380d07bbeffd3ce6504e73cf61f840ae76ca upstream.

This quirk is necessary for surround and other DSP effects to work
with the onboard ca0132 based audio chipset for the EVGA X299 dark
mainboard.

Signed-off-by: Adam Stylinski <kungfujesus06@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=67071
Link: https://lore.kernel.org/r/ZGopOe19T1QOwizS@eggsbenedict.adamsnet
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_ca0132.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1306,6 +1306,7 @@ static const struct snd_pci_quirk ca0132
 	SND_PCI_QUIRK(0x1458, 0xA026, "Gigabyte G1.Sniper Z97", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1458, 0xA036, "Gigabyte GA-Z170X-Gaming 7", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1038, "EVGA X99 Classified", QUIRK_R3DI),
+	SND_PCI_QUIRK(0x3842, 0x104b, "EVGA X299 Dark", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),


