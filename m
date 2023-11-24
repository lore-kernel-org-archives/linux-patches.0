Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D6439FF7;
	Fri, 24 Nov 2023 18:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUBq/nuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A615FC433C8;
	Fri, 24 Nov 2023 18:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850135;
	bh=tEZRWzNzys3RzkOD35xm5yWwWoOBnyXvOhtQ5V7iAtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUBq/nuVyJjE3Lkq4VhQZV4CmCbx7OzPiMCnL2T/M4+blzBpBCxB01YhoLCAGCOX6
	 QZhd+6rXWHFwuSZrKuQJfQwHPwtC+HkOB7cCFWtGJ22f9Rq18u86Q4rwqlkGbW3kWX
	 1ciFjBNi0ywt7qkxv2B7qcRoUfpUTdiHsuXsX3pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eymen Yigit <eymenyg01@gmail.com>,
	Luka Guzenko <l.guzenko@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 433/530] ALSA: hda/realtek: Enable Mute LED on HP 255 G8
Date: Fri, 24 Nov 2023 17:49:59 +0000
Message-ID: <20231124172041.258799982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eymen Yigit <eymenyg01@gmail.com>

commit 8384c0baf223e1c3bc7b1c711d80a4c6106d210e upstream.

This HP Notebook uses ALC236 codec with COEF 0x07 idx 1 controlling
the mute LED. Enable already existing quirk for this device.

Signed-off-by: Eymen Yigit <eymenyg01@gmail.com>
Cc: Luka Guzenko <l.guzenko@web.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231110150715.5141-1-eymenyg01@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9746,6 +9746,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x896d, "HP ZBook Firefly 16 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x896e, "HP EliteBook x360 830 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


