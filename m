Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2561FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A923C433C9;
	Tue,  1 Aug 2023 09:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882721;
	bh=vlGvqWQnWAWRszo4XsFHnz3ksroGiPELptbBvNzKR0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mo1BfRGG7ZjtRxQCxCyVU5y5kCvybpKYfsvw1f5zpvtSeNbJQqJscTOu6pGk2HD6E
	 ksx85DvzgI6jBnuCrCKtKqNgTnyU72CAtL+8t0SNpFkmj2QMr8tUz4txwSHB84N5gP
	 Qn/Akx4qTHI65WwpaB3Ou/NlNxIFP4+wdEox2+Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Asyutchenko <svenpavel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 179/228] ALSA: hda/realtek: Support ASUS G713PV laptop
Date: Tue,  1 Aug 2023 11:20:37 +0200
Message-ID: <20230801091929.332235968@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pavel Asyutchenko <svenpavel@gmail.com>

commit 8019a4ab3d80c7af391a646cccff953753fc025f upstream.

This laptop has CS35L41 amp connected via I2C.

With this patch speakers begin to work if the
missing _DSD properties are added to ACPI tables.

Signed-off-by: Pavel Asyutchenko <svenpavel@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230726223732.20775-1-svenpavel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9580,6 +9580,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1c62, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1ccd, "ASUS X555UB", ALC256_FIXUP_ASUS_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1d1f, "ASUS ROG Strix G17 2023 (G713PV)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402", ALC245_FIXUP_CS35L41_SPI_2),


