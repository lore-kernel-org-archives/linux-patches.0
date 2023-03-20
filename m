Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A361C32
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB695C433D2;
	Mon, 20 Mar 2023 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679326096;
	bh=TIQXJjlpa6+QktvqASVdGyu4c9KPKmpcQ1nIF2II6wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4LYMoh5dA2Fn8vGPcUKImMt3w01d/QDFqfNnq77Z5IRx65XQroxTEgjexWjR3v38
	 WCHd9v5yh0bDYa/IAz5Ue3YwHC7Bnl4aVocRYG0ryNtEbUE0w1rF2OmhT5MP7/lDf4
	 VdqxNh+nsmkGJmSCSWcTPtJL/OyYqAVwF0PbPgJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Szu <jeremy.szu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.2 158/211] ALSA: hda/realtek: fix speaker, mute/micmute LEDs not work on a HP platform
Date: Mon, 20 Mar 2023 15:54:53 +0100
Message-Id: <20230320145520.047867239@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Szu <jeremy.szu@canonical.com>

commit 7bb62340951a9af20235a3bde8c98e2e292915df upstream.

There is a HP platform needs ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED quirk to
make mic-mute/audio-mute/speaker working.

Signed-off-by: Jeremy Szu <jeremy.szu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230307135317.37621-1-jeremy.szu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9446,6 +9446,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8b8a, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8b, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8d, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b8f, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b92, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),


