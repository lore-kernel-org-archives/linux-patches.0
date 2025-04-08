Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EAC224234;
	Tue,  8 Apr 2025 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113486; cv=none; b=U/GcZyEaeE/+jEtDYNk1MLrIDZDInwBJMuEtEdtYXdt9eMY5bii7/WVb6qESMc3hYX1BPLwhM2h1tsqrBToIwb2vTvYwqZ1RF4gy0fXyU+Xxi44IcBB1RPJcK+erFrigsv7hEw6fKPml8ynwc0ceoS9CJCZUHCZNMosI9OabW8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113486; c=relaxed/simple;
	bh=XTeZ7Vp3mv8BS7qPxp54d1N6zcZ76bQV5l3HyXOjrvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YyiVp6bLLD3SOZoyKHdiBLzt/5eDeBRE4LaLhYS25SiFntjYxJ8iQPtBmx5RjOotvK/nxMBIgH0CSoiVcTsi7A6C2ugSIi+PB+rmmu7TfuObNikcHxvp9u5rnQVbUKWV3SDlig/ZfefAKZGaS6MjK9OT4GEGWPg/W+IhIUviMcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsG2zcOp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsG2zcOp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52396C4CEE5;
	Tue,  8 Apr 2025 11:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113486;
	bh=XTeZ7Vp3mv8BS7qPxp54d1N6zcZ76bQV5l3HyXOjrvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsG2zcOptZt6d6EUEHYMmh6xrz5evqIcMpSmDiKtDHoMgfVwNPOIsAuZ9xX5Z+kFv
	 G8aNSUJzzEPmnoaAArFEFhUcgVcG9A86gN9BhJccOY5Vp9qV7XfVMhpQWYlNRRirNw
	 tE3AJUerKJFkHQ52OC+EOVbBtxm9U3miziBudFiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/268] ALSA: hda/realtek: Add support for ASUS ROG Strix G614 Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:49:48 +0200
Message-ID: <20250408104833.318314550@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 9120b2b4ad0dad2f6bbb6bcacd0456f806fda62d ]

Add support for ASUS G614PH/PM/PP and G614FH/FM/FP.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-4-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 77fa07f0a8455..9f6ee6489d943 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10152,7 +10152,9 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
+	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1074, "ASUS G614PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x10a1, "ASUS UX391UA", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x10c0, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.39.5



