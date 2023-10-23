Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5DF14282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXviKO3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C20C433C7;
	Mon, 23 Oct 2023 11:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060044;
	bh=wpZYbJi1d0V+4lLmD/hbnkHCeM2r9EQN0Yf1xCy9QaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mXviKO3ZA2NhjyE5ncnOfI++WHXTt3FlgqlTo9NqBIvH2YGBkeGY6zjoNURR2W9BW
	 Yi4T0qzc64n552sl4MCC9MF4cf0E8RltGb3IFqM/4roJM0QcqVw/Ugc5Lu7tRmCjrq
	 MEJOZp4EIMe0in9z9LDcawKs2ml0nvFNsSz3qdvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Borisov <dedsa2002@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 039/196] ALSA: hda/realtek: Add quirk for ASUS ROG GU603ZV
Date: Mon, 23 Oct 2023 12:55:04 +0200
Message-ID: <20231023104829.598316684@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

From: Artem Borisov <dedsa2002@gmail.com>

commit 5dedc9f53eef7ec07b23686381100d03fb259f50 upstream.

Enables the SPI-connected Cirrus amp and the required pins
for headset mic detection.

As of BIOS version 313 it is still necessary to modify the
ACPI table to add the related _DSD properties:
  https://gist.github.com/Flex1911/1bce378645fc95a5743671bd5deabfc8

Signed-off-by: Artem Borisov <dedsa2002@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231014075044.17474-1-dedsa2002@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9717,6 +9717,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301V", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),


