Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB3A524B8;
	Mon, 11 Dec 2023 18:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PP7ObWdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A52C433CC;
	Mon, 11 Dec 2023 18:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319613;
	bh=/8BbZvHZiewqeIVT0qkPwpCtS7ftnP7KQ1G9Y0gzMus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PP7ObWdTQi7/UMBy7Gju83xMPU+8viieNYVxVKWwRXK0/LvBLEZvJaQT+/coQYTLk
	 ed8z1PV4OZZkflUZJMXPvZePCrBJCPftPkj7M4pgesuZdJg/6T1//McATYZ72TO5+S
	 pnSXrs7KB1iL+CbMP/lWIvGmJ7NmN7O3J8F59b10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrs Vinarskis <alex.vinarskis@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 140/244] ALSA: hda/realtek: fix speakers on XPS 9530 (2023)
Date: Mon, 11 Dec 2023 19:20:33 +0100
Message-ID: <20231211182052.059907729@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>

commit cd14dedf15be432066e63783c63d650f2800cd48 upstream.

XPS 9530 has 2 tweeters and 2 subwoofers powered by CS35L41 amplifier, SPI
connected. For subwoofers to work, it requires both to enable amplifier
support, and to enable output to subwoofers via 0x17 quirk (similalry to
XPS 9510/9520).

Signed-off-by: Aleksandrs Vinarskis <alex.vinarskis@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231203233006.100558-1-alex.vinarskis@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9615,6 +9615,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0b1a, "Dell Precision 5570", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0b37, "Dell Inspiron 16 Plus 7620 2-in-1", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0beb, "Dell XPS 15 9530 (2023)", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0c03, "Dell Precision 5340", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),


