Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EB81951F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B34CC433EF;
	Mon, 12 Jun 2023 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565870;
	bh=HjuVzgB3wtgjTFjsxzHXV69RKt32ehF2LaZSm4Am3Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ie8PhO46r16OaCDZeOJe/WiUWELZeYGM2TggsUXcGshjhbO04b6QN95NvNJi8NMxT
	 il0TYKqUukZcB2OltrfZsUlipBwz91nDDL2zlzblppozFSir/sybEDlRnwzmBrgeYN
	 TxNkkj1/PLUlBjXRjwAnKDAEpKyEUu1VuDmuEibM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	RenHai <kean0048@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 23/45] ALSA: hda/realtek: Add Lenovo P3 Tower platform
Date: Mon, 12 Jun 2023 12:26:17 +0200
Message-ID: <20230612101655.612748806@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
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
@@ -10367,6 +10367,7 @@ static const struct snd_pci_quirk alc662
 	SND_PCI_QUIRK(0x14cd, 0x5003, "USI", ALC662_FIXUP_USI_HEADSET_MODE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC662_FIXUP_LENOVO_MULTI_CODECS),
 	SND_PCI_QUIRK(0x17aa, 0x1057, "Lenovo P360", ALC897_FIXUP_HEADSET_MIC_PIN),
+	SND_PCI_QUIRK(0x17aa, 0x1064, "Lenovo P3 Tower", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32ca, "Lenovo ThinkCentre M80", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cb, "Lenovo ThinkCentre M70", ALC897_FIXUP_HEADSET_MIC_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x32cf, "Lenovo ThinkCentre M950", ALC897_FIXUP_HEADSET_MIC_PIN),


