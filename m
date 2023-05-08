Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C616168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622C8C433EF;
	Mon,  8 May 2023 10:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542994;
	bh=5rgFYt5rQfHMzQmBNPOJUTeaF/OHTedFDXZoJjCXzJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/RRkIRzQ++lUn6QzH+aG2vfFF1DKn2cMjDCM95e3VusNDOlMaP+SnqiAe/sbSLqz
	 IJ3hB8pmtEFQT3Vzb0hO+BqPsguATOeshA0UlWPUqcQIUmEwIwvKKY9w7R2WzJ7+9y
	 AeSsijcnA0M+Q/mVaIfcudzRveOhVBZoLII4NjqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Asselstine <asselsm@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 615/663] ALSA: hda/realtek: Add quirk for ASUS UM3402YAR using CS35L41
Date: Mon,  8 May 2023 11:47:21 +0200
Message-Id: <20230508094449.666087979@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Asselstine <asselsm@gmail.com>

commit 7e2d06628aab6324e1ac885910a52f4c038d4043 upstream.

This Asus Zenbook laptop uses Realtek HDA codec combined with
2xCS35L41 Amplifiers using I2C with External Boost.

Signed-off-by: Mark Asselstine <asselsm@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230501231346.54979-1-asselsm@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9500,6 +9500,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
+	SND_PCI_QUIRK(0x1043, 0x1683, "ASUS UM3402YAR", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x16b2, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x16e3, "ASUS UX50", ALC269_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x1043, 0x1740, "ASUS UX430UA", ALC295_FIXUP_ASUS_DACS),


