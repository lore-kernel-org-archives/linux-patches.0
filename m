Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00B41D54A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B05C433C8;
	Wed,  4 Oct 2023 18:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443115;
	bh=iaUPUaZsePUyIgs6QN8h2txMVQsnrD3uaYCdipkRRxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0aWchiInMRTv4l+9FCv5a7TepXeReab1Ifmg9eshfP2i6ryjSd9WVvD/vVU08g/j
	 +zFh9wGtQLFbJAAm2HHyaPf2MrCpgXd0lIqFhUr/xiRcR2VSiwsBUfc+TgawG+76Ep
	 rel5F5nFfA0gbzvd610CwN1pHBhiU5y6dPRH9+i8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Knyazev Arseniy <poseaydone@ya.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 042/259] ALSA: hda/realtek: Splitting the UX3402 into two separate models
Date: Wed,  4 Oct 2023 19:53:35 +0200
Message-ID: <20231004175219.376120649@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Knyazev Arseniy <poseaydone@ya.ru>

[ Upstream commit 07058dceb038a4b0dd49af07118b6b2a685bb4a6 ]

UX3402VA and UX3402ZA models require different hex values, so comibining
them into one model is incorrect.

Fixes: 491a4ccd8a02 ("ALSA: hda/realtek: Add quirk for ASUS Zenbook using CS35L41")
Signed-off-by: Knyazev Arseniy <poseaydone@ya.ru>
Link: https://lore.kernel.org/r/20230913053343.119798-1-poseaydone@ya.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f70e0ad81607e..57e07aa4e136c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9657,7 +9657,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1d1f, "ASUS ROG Strix G17 2023 (G713PV)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1d42, "ASUS Zephyrus G14 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
-	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
-- 
2.40.1



