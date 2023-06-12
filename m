Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9C319523
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEEEC433D2;
	Mon, 12 Jun 2023 10:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566036;
	bh=zihgKEjlNQPc7g0CdWKisTAY6Iicd31Ld807N2n6qyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmR18yIO3BUOIibLWj2GrvPpsjFuCznMndKcv/0XCg1roN0hA/PxHUZH0TgY+Uh+E
	 rVBjvfG8hyhiTzy5SOyFO8Lg5K0m+l1OPFS8NyEZpmj7j5amsetl32DTo7+5OUj8L6
	 SHY/x3xYrpwa0p0xoEoedyLd3QX1aMz4BPdtbg3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RenHai <kean0048@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 39/68] ALSA: hda/realtek: Add Lenovo P3 Tower platform
Date: Mon, 12 Jun 2023 12:26:31 +0200
Message-ID: <20230612101700.032248532@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: RenHai <kean0048@gmail.com>

commit 7ca4c8d4d3f41c2cd9b4cf22bb829bf03dac0956 upstream.

Headset microphone on this platform does not work without
ALC897_FIXUP_HEADSET_MIC_PIN fixup.

Signed-off-by: RenHai <kean0048@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230602003604.975892-1-kean0048@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11184,6 +11184,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x1064, "Lenovo P3 Tower", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32ca, "Lenovo ThinkCentre M80", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),


