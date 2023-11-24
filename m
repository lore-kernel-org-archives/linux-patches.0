Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68083A8F5;
	Fri, 24 Nov 2023 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLkW3vcM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EB1C433C8;
	Fri, 24 Nov 2023 18:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850681;
	bh=VrZNMQvffeFdcjLWRj86jEbHhsTid7cJPghyL/6/sVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLkW3vcM3M89RLzYT388VHTEuiyHjXh5uH1l8ucNDIVJu/X+xIUxyI4SRkrnGpA/7
	 a5PvJL7IfL/lyBgt/0F2RxLNlUyhHK2p8OAfEV+M3jJYGE5izNjcBxtAGdJAgjsn8h
	 xgHpiPs6vywFH7vilxc+oB+/oyAu+kU0Qao9nJUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Spataru <alex_spataru@outlook.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 147/491] ALSA: hda/realtek: Add quirk for ASUS UX7602ZM
Date: Fri, 24 Nov 2023 17:46:23 +0000
Message-ID: <20231124172028.900972551@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Spataru <alex_spataru@outlook.com>

[ Upstream commit 26fd31ef9c02a5e91cdb8eea127b056bd7cf0b3b ]

Enables the SPI-connected CSC35L41 audio amplifier for this
laptop model.

As of BIOS version 303 it's still necessary to
modify the ACPI table to add the related _DSD properties:
https://github.com/alex-spataru/asus_zenbook_ux7602zm_sound/

Signed-off-by: Alex Spataru <alex_spataru@outlook.com>
Link: https://lore.kernel.org/r/DS7PR07MB7621BB5BB14F5473D181624CE3A4A@DS7PR07MB7621.namprd07.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7f1d79f450a2a..fe9a29f358792 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9798,6 +9798,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1d4e, "ASUS TM420", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x16a3, "ASUS UX3402VA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
-- 
2.42.0



