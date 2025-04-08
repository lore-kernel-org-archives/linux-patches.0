Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8626026A1BC;
	Tue,  8 Apr 2025 12:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115035; cv=none; b=gERKDPhROkoF4o0ZqlghQiumCSQDKs3aCLZsdcLlpePg1fQf+oojiEFM58GQm1CwpeOn5mKd8MxmE6cxhKEbXb4m2A9ZRMSpnW+8jyPdJeIF5+l/uY5oNwOCkET20w3k+lph0dK+WC9ADvUokdFJsp6jOytzm29mrwXM3/rWBYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115035; c=relaxed/simple;
	bh=1bZdioDyvSC4Fs10KcKcRuDWKzW3XpiD+PwuNhJJnMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoPgxT8nf+JTYIoNtIzi46fuEMgkq7eIDUqsbgTX9Jt65tzIfT9QwHB+OjYjI7/Vp1fE7DTxbISy1pnzNefiAIaFrhJECFvY/ms14X5kK8bCvmQJjaJRBv62DUwuShDZ9wy8QmpqbKPXb6CJ7SSRsBpv2e1gOml11UmxRAXrG8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k0VaJMRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k0VaJMRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1727BC4CEE5;
	Tue,  8 Apr 2025 12:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115035;
	bh=1bZdioDyvSC4Fs10KcKcRuDWKzW3XpiD+PwuNhJJnMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0VaJMRpinyF6p1BEnxhMfF9pZvOpX4clzYiIqSFs9srehu2eIJe/Q7Ago4Hx0dEh
	 gMoCm1sdRuU3eBtdcKMV8SuJF/d3rCXzkepoqtirWUwPDudcT0Juh9J0WUHFVJtcOF
	 t/U5Fku8UGyL27q4tgID9UNZUN4Nuaq6hoL6EmH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 324/499] ALSA: hda/realtek: Add support for ASUS ROG Strix GA603 Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:48:56 +0200
Message-ID: <20250408104859.304469375@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 16dc157346dd4404b02b42e73b88604be3652039 ]

Add support for ASUS GA603KP, GA603KM and GA603KH.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-3-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ebacbd996bceb..c4e01becdb625 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10760,6 +10760,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a50, "ASUS G834JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a60, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
+	SND_PCI_QUIRK(0x1043, 0x3d78, "ASUS GA603KH", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x3d88, "ASUS GA603KM", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e00, "ASUS G814FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e20, "ASUS G814PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e30, "ASUS TP3607SA", ALC287_FIXUP_TAS2781_I2C),
-- 
2.39.5



