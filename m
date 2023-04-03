Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4BF6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2396FC433D2;
	Mon,  3 Apr 2023 14:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532967;
	bh=ix5BDHpUYHprcIRWFhavDx2lp+6OQGCI50MBP6BojA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RJ5vgjr5EryEQQbDqIx+j/JSbzptsn3WA/vy7i8jL7+PthnFxHmQOb7c3OXuLEfwU
	 1lAle5AVku0e7wKn4jqW1iRrhCdbXWvOgrdzynbHvjnV2SC2BqZce+oUYFHMGeR5HM
	 4cBqgpeC2SajaCZTziOJ2QXqi4DJWragPMQ2Czms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	huangwenhui <huangwenhuia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 155/181] ALSA: hda/realtek: Add quirk for Lenovo ZhaoYang CF4620Z
Date: Mon,  3 Apr 2023 16:09:50 +0200
Message-Id: <20230403140420.113627523@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: huangwenhui <huangwenhuia@uniontech.com>

commit 52aad39385e1bfdb34a1b405f699a8ef302c58b0 upstream.

Fix headset microphone detection on Lenovo ZhaoYang CF4620Z.

[ adjusted to be applicable to the latest tree -- tiwai ]

Signed-off-by: huangwenhui <huangwenhuia@uniontech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230328074644.30142-1-huangwenhuia@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9712,6 +9712,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x511e, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
+	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),


