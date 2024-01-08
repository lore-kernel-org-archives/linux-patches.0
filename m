Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9910524AC;
	Mon,  8 Jan 2024 15:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WDVkKnao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55717C433CC;
	Mon,  8 Jan 2024 15:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728547;
	bh=/UXc6pCjcp023mX2caT1uzHJbg2x6ycqF3wNRa23W/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WDVkKnaocvFonHK6oIvWgTyIPL/4BYksUPHf6B4UAotdWnWAST5SrXMGchzfnmwOK
	 0SnBjooz/rxCHVvvHo2UiZa9qdmDyll5cEARKv5F9STK/ZOgWBKfL2JL+8OKMrBjZo
	 le4j5lhkLtJSa8ml4IahNPgJvbTZVh91H2i2OLoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 111/150] ALSA: hda/realtek: Add quirk for Lenovo Yoga Pro 7
Date: Mon,  8 Jan 2024 16:36:02 +0100
Message-ID: <20240108153516.303055994@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 634e5e1e06f5cdd614a1bc429ecb243a51cc009d ]

Lenovo Yoga Pro 7 14APH8 (PCI SSID 17aa:3882) seems requiring the
similar workaround like Yoga 9 model for the bass speaker.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/CAGGk=CRRQ1L9p771HsXTN_ebZP41Qj+3gw35Gezurn+nokRewg@mail.gmail.com
Link: https://lore.kernel.org/r/20231207182035.30248-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9907,6 +9907,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0xc019, "Clevo NH77D[BE]Q", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xc022, "Clevo NH77[DC][QW]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x17aa, 0x1036, "Lenovo P520", ALC233_FIXUP_LENOVO_MULTI_CODECS),
+	SND_PCI_QUIRK(0x17aa, 0x3882, "Lenovo Yoga Pro 7 14APH8", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x1048, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
 	SND_PCI_QUIRK(0x17aa, 0x20f2, "Thinkpad SL410/510", ALC269_FIXUP_SKU_IGNORE),
 	SND_PCI_QUIRK(0x17aa, 0x215e, "Thinkpad L512", ALC269_FIXUP_SKU_IGNORE),


