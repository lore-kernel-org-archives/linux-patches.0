Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9251F33CCA;
	Fri, 24 Nov 2023 18:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BJbIDc42"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CB7C433C9;
	Fri, 24 Nov 2023 18:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850142;
	bh=ubOpd01rTh4YyHaWGsglmelOpN6CmUpe6MJuY7wYmME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJbIDc42i08UE/2OgpvHyyxgLk4FLdD84wewJwxdu9ijpIDgeZC1mE60ZmsFJT/eA
	 +hrzghd5NRMBGVYHuxQB4+OGpO/yu/SpLOmb6yRWleTjzSIWZaMViuGgV7ecxl0UnY
	 mWCGceE0twr4itKfTk4x3tK8xajuVzeHdM43tsXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matus Malych <matus@malych.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 436/530] ALSA: hda/realtek: Enable Mute LED on HP 255 G10
Date: Fri, 24 Nov 2023 17:50:02 +0000
Message-ID: <20231124172041.360588372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Matus Malych <matus@malych.org>

commit b944aa9d86d5f782bfe5e51336434c960304839c upstream.

HP 255 G10 has a mute LED that can be made to work using quirk
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2.
Enable already existing quirk - at correct line to keep order

Signed-off-by: Matus Malych <matus@malych.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231114133524.11340-1-matus@malych.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9782,6 +9782,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b2f, "HP 255 15.6 inch G10 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8b42, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b43, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b44, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


