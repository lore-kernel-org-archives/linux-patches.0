Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E73426E161;
	Tue,  8 Apr 2025 12:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115866; cv=none; b=dqhizBtVCQoBUn+SMkWl/0xlj1SjyQIWcurLU1apSz4PKW/1Bg4tFg9ANLF8MduZONg4BQTUeBcWVs9/1xTtrodsvNTG/Q2XiqbcYn41z5N3olSnu2b+qyCR4CaBys9QiJZnV5qBoQdQh7weJP06JJSeyWCLpD5o7BQM8/JIH1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115866; c=relaxed/simple;
	bh=GIlZzc6TCJ538nq/eCB+TW5wFEbC3tzrJq3CdyYNyNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWudzjOe0KVVImjszLyQEOexgij4c6a5EheiCGodtDxH29WCB+rnmKbe5evLyJepfcfqUGj+ncRI0h9PrpawcF8LW/czc/2+wXaHvC2J8U48+HYp7wJn3Vt1DCiW7nm+w9JyHrxTWVNFPBbebE7lVOJX53hVY7+nXZaiPLlcpIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1SqAd/7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1SqAd/7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A76DC4CEE7;
	Tue,  8 Apr 2025 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115865;
	bh=GIlZzc6TCJ538nq/eCB+TW5wFEbC3tzrJq3CdyYNyNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1SqAd/7kWUaEALS/YsWvcryF9E/iqquaXPCooIF/FqYBgpAA+YblpNCoIn91NrEyM
	 YFI6LhQeKq8XhMOr1iCMpKsTK9cBWDft2n4adT8oW/wIsqsEu9j6HvEBJ4FrAzxGNR
	 ncWFzUsgEk7DSGbDt7tNUlp4/0Czpx/TP75ws4FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Gospodnetich <me@kylegospodneti.ch>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 134/204] ALSA: hda/realtek: Fix Asus Z13 2025 audio
Date: Tue,  8 Apr 2025 12:51:04 +0200
Message-ID: <20250408104824.229871684@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 86a4e8c7d3f91..2df163625ccff 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10066,6 +10066,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f12, "ASUS UM5302", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.39.5



