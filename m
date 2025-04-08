Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE33206F18;
	Tue,  8 Apr 2025 12:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114993; cv=none; b=LorEq8MBElhwNRZjiyzkd7yCf+XhvhzCSmfbMdkyuWTyU8YN3w8yivKGlTU1cIU+/w6yh9/n4pztto1XYosnE6Emtv/AfyBzv2x4BwxMz4t22yGe5A/i+JfOASPswyxxEN6fleVmZdjUurrUvDpTxXY/Mg9PA+n3FMQqjTUoK6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114993; c=relaxed/simple;
	bh=hYWkxJSTFIi/0YNdsJxB/V6q6enENPh1tLppj0hqdNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjUviGr7jScgJUB6X1+O4udLqibOrwy+GOdHW2x6MHJ9RsgIKG9emw3D30YaZg38ONdxClm2JqHz4Yd9ePC8d717UuhS8pYbVJRHZvgsJa4nulcIXNqjXv+Rp4oKFI4jkdu1wyEy4TzlHk7KxipOHx8GL3nNF/Xc1bxEs9ysZ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsc3NSMG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsc3NSMG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA866C4CEE5;
	Tue,  8 Apr 2025 12:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114993;
	bh=hYWkxJSTFIi/0YNdsJxB/V6q6enENPh1tLppj0hqdNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsc3NSMGBTbz3lJRjCkDR2vmCt3itsP/GtBMx9hNZud5G8M2W9t30r/qw4ZqlWyUi
	 GB7ZZSh20gyr2AlEXBN/3n0AdmwI/WE3KU52jdfL926w7L83IYHdda/tNk/i2aclRO
	 J/CNi2pxVqBdfrApL/oAjuukh9GcfMZo/h+akiuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Gospodnetich <me@kylegospodneti.ch>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 311/499] ALSA: hda/realtek: Fix Asus Z13 2025 audio
Date: Tue,  8 Apr 2025 12:48:43 +0200
Message-ID: <20250408104858.973622048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 12784ca33b62fd327631749e6a0cd2a10110a56c ]

Use the basic quirk for this type of amplifier. Sound works in speakers,
headphones, and microphone. Whereas none worked before.

Tested-by: Kyle Gospodnetich <me@kylegospodneti.ch>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20250227175107.33432-3-lkml@antheas.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 4c7f578726e26..575e76590a106 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10751,6 +10751,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f1f, "ASUS H7604JI/JV/J3D", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x31d0, "ASUS Zen AIO 27 Z272SD_A272SD", ALC274_FIXUP_ASUS_ZEN_AIO_27),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.39.5



