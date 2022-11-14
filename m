Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538234C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:57:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABFEBC43147;
	Mon, 14 Nov 2022 12:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430649;
	bh=pCKTQoQYLsFvW24E5yWiYxm1wQ2U38HMXjzC77/cvDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTsOpEDC3exY99PNkwIVDKYh1MoV93txCUF6hUUIB3FTSzaakWgT+vgRX4ojVhJ1/
	 M2dFNf3dllpJ1TJZVQPltKUP5F53PLsGv+nqHZBFpi+8z2uQir/uqHn9bUbigtA0xL
	 IakcZ4jnDmF9k8tT0CuAvds8IqTgIFAbX59WxcIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xian Wang <dev@xianwang.io>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 090/131] ALSA: hda/ca0132: add quirk for EVGA Z390 DARK
Date: Mon, 14 Nov 2022 13:45:59 +0100
Message-Id: <20221114124452.530621906@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xian Wang <dev@xianwang.io>

commit 0c423e2ffa7edd3f8f9bcf17ce73fa9c7509b99e upstream.

The Z390 DARK mainboard uses a CA0132 audio controller. The quirk is
needed to enable surround sound and 3.5mm headphone jack handling in
the front audio connector as well as in the rear of the board when in
stereo mode.

Page 97 of the linked manual contains instructions to setup the
controller.

Signed-off-by: Xian Wang <dev@xianwang.io>
Cc: stable@vger.kernel.org
Link: https://www.evga.com/support/manuals/files/131-CS-E399.pdf
Link: https://lore.kernel.org/r/20221104202913.13904-1-dev@xianwang.io
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
+	SND_PCI_QUIRK(0x3842, 0x1055, "EVGA Z390 DARK", QUIRK_R3DI),
 	SND_PCI_QUIRK(0x1102, 0x0013, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0018, "Recon3D", QUIRK_R3D),
 	SND_PCI_QUIRK(0x1102, 0x0051, "Sound Blaster AE-5", QUIRK_AE5),


