Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706ED269826;
	Tue,  8 Apr 2025 12:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116819; cv=none; b=TkbLOr84afvEGPNQ2K0s57S6GAgPak1dDCSD8IwRwgvJVQytTJjPVyILLGUiHU3b3tqb4TAtALMA960HWlwseBF2vAo7BbAhvodg1SK6/3FqHx7TzopMON+2NiN4Pm36aqJFurijOZhMHakWbKQZtZ/IAfUU174aL/U1t+waAlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116819; c=relaxed/simple;
	bh=Lq6or8HYm6vGrWGyT+xywnUaVqTaErr4kcpkeqnYDlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lS50xme3YuIWKfl3KtNoSKkllBYViMOmFRgeDStiZq9fu1RD2VhMmeuL7P27MErq7n+nCf8LfRUg8g3beH0MTWpOyb3kCckVs+cmfH0hMc77oXF448Jp3dRNfmQR21gm+D9t2OQKrJZgrDeCtFw3DBkthnuKgpong2t6U+++od8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQJKxo0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQJKxo0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00713C4CEE5;
	Tue,  8 Apr 2025 12:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116819;
	bh=Lq6or8HYm6vGrWGyT+xywnUaVqTaErr4kcpkeqnYDlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQJKxo0bUUGEoh3a6z5MrpbbfeHh8RaAqDMXQM4zsd3k6k4MbZ1s4H7N+rZDcsNfK
	 9NvuDHH48O4BrBOVSWhVle0m8ql4p0a1IGsWWVtWjT05UtxJ0599QffuGtrgxYeE5Z
	 og9R13H6gESpHtfxK6r7TKT5VTTgN4jbokL8TGWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 280/423] ALSA: hda/realtek: Add support for ASUS B3405 and B3605 Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:50:06 +0200
Message-ID: <20250408104852.296101687@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 7ab61d0a9a35e32497bcf2233310fec79ee3338f ]

Add support for ASUS B3405CCA / P3405CCA, B3605CCA / P3605CCA,
B3405CCA, B3605CCA.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with SPI

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-6-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7a9d996ac1a45..5c43f9d2ead1a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10640,6 +10640,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x12a0, "ASUS X441UV", ALC233_FIXUP_EAPD_COEF_AND_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x12a3, "Asus N7691ZM", ALC269_FIXUP_ASUS_N7601ZM),
 	SND_PCI_QUIRK(0x1043, 0x12af, "ASUS UX582ZS", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x12b4, "ASUS B3405CCA / P3405CCA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x12e0, "ASUS X541SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x12f0, "ASUS X541UV", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1313, "Asus K42JZ", ALC269VB_FIXUP_ASUS_MIC_NO_PRESENCE),
@@ -10725,7 +10726,10 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3011, "ASUS B5605CVA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
+	SND_PCI_QUIRK(0x1043, 0x3061, "ASUS B3405CCA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x30c1, "ASUS B3605CCA / P3605CCA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x31d0, "ASUS Zen AIO 27 Z272SD_A272SD", ALC274_FIXUP_ASUS_ZEN_AIO_27),
+	SND_PCI_QUIRK(0x1043, 0x31f1, "ASUS B3605CCA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.39.5



