Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354A1168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA55C4339B;
	Mon,  8 May 2023 10:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540956;
	bh=W9NoJiVh+l92EWH2uvdP7TDt5ze0DbnrYZ9sc7V56Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nKBEbPV0zudXs0RaxexByhNV5FltdNl57pDIeFxH9rIyLtbpW6zQji+H2E3rxMKXI
	 2WCTLTzf4eGUgbeu2POujfeKHnPZP8RDB76BtvnEvgkNO/qOhmFTAQBtQemvZVLahH
	 misaD9DQjOpvuBNEcQY6mUXZ2nzFgvmJjDoLfJ9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 562/611] ALSA: hda/realtek: Add quirk for ThinkPad P1 Gen 6
Date: Mon,  8 May 2023 11:46:44 +0200
Message-Id: <20230508094440.242083768@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

commit 067eb084592819ad59d07afcb5de3e61cee2757c upstream.

Lenovo ThinkPad P1 Gen 6 laptop has 2 CS35L41 amplifies
on I2C bus connected to Realtek codec.

Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230427110452.13787-1-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9689,6 +9689,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x22f1, "Thinkpad", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x22f2, "Thinkpad", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x22f3, "Thinkpad", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x2316, "Thinkpad P1 Gen 6", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x2317, "Thinkpad P1 Gen 6", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x2318, "Thinkpad Z13 Gen2", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x2319, "Thinkpad Z16 Gen2", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x231a, "Thinkpad Z16 Gen2", ALC287_FIXUP_CS35L41_I2C_2),


