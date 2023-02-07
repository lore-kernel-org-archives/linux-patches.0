Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E774A3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646D8C433EF;
	Tue,  7 Feb 2023 13:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775534;
	bh=rjSOyDAWED1Q+f8NQRKFB68hLygELEUWTEIWR7OhzfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dL85Az7Fq/Q8wTOtLUzJj0eS1oYUEEX5yOIh9tMAYmfZWLlSjNbVSqDqHUWRKJEp0
	 47ITnoBBX7NoI/+blDyFPsAxu5yjLXTWwmKPb64R+ed5Cvpj+2YYJ8gxAAu0VvYI+G
	 dYKp5BZBaHbE7dBBpD3zIrE+UUYJIVaf6qvGUu/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shyba <victor1984@riseup.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 071/120] ALSA: hda/realtek: Add Acer Predator PH315-54
Date: Tue,  7 Feb 2023 13:57:22 +0100
Message-Id: <20230207125621.782117339@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Victor Shyba <victor1984@riseup.net>

commit 6a28a25d358079b7d0d144689f850aecacf63cba upstream.

Same issue as SP513-54N: Headset microphone does not work without
ALC255_FIXUP_ACER_MIC_NO_PRESENCE fixup.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=211853
Cc: <stable@vger.kernel.org>
Signed-off-by: Victor Shyba <victor1984@riseup.net>
Link: https://lore.kernel.org/r/20230123222129.17589-1-victor1984@riseup.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8873,6 +8873,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x142b, "Acer Swift SF314-42", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1430, "Acer TravelMate B311R-31", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),


