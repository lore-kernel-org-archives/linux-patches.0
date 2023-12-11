Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A04FC06;
	Mon, 11 Dec 2023 18:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfJbAWpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEECC433CB;
	Mon, 11 Dec 2023 18:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319624;
	bh=J4yYknXgMhWretGDzHaSTiFSI/rTp0i8AmLUiwStKyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfJbAWpX++5ZYbGGzvgEWai/lSK2spPvdFkrVz58dP5SiT1z49gBh/XMoNBVsxdrL
	 ZfPOfh/Lsw6xVUItEYrVWJr0LbI2VEPaFMMOenVdwMkqVwXg/9b6WRQab7TZ3qSeN5
	 G5Dtb1nGj/ERQf3Jg+/SfSOR2sY2kon+G6RY876E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 144/244] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7
Date: Mon, 11 Dec 2023 19:20:37 +0100
Message-ID: <20231211182052.248071184@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 634e5e1e06f5cdd614a1bc429ecb243a51cc009d upstream.

Lenovo Yoga Pro 7 14APH8 (PCI SSID 17aa:3882) seems requiring the
similar workaround like Yoga 9 model for the bass speaker.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAGGk=CRRQ1L9p771HsXTN_ebZP41Qj+3gw35Gezurn+nokRewg@mail.gmail.com
Link: https://lore.kernel.org/r/20231207182035.30248-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10116,6 +10116,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x387d, "Yoga S780-16 pro Quad AAC", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x387e, "Yoga S780-16 pro Quad YC", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3881, "YB9 dual power mode2 YC", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x17aa, 0x3882, "Lenovo Yoga Pro 7 14APH8", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3884, "Y780 YG DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x3886, "Y780 VECO DUAL", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x38a7, "Y780P AMD YG dual", ALC287_FIXUP_TAS2781_I2C),


