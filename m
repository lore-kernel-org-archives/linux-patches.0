Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9A2F302141;
	Wed, 10 Dec 2025 07:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352032; cv=none; b=JJjuOcmkFqMr9wSP4ujaeiB5/CX5ZQm1Wykz5R/4PYvayUlvrxxwH1sGnvgQS/U1W4856hFpR0v2r6/LCVbZ22ubScCuu6ZxHF0D6H8Zq5x3NZeaFPFnSZtYZ79SjDcZSlu/3PeaVSKoKy5AWsW295Mlqjkg87gKURcjCSf6NA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352032; c=relaxed/simple;
	bh=iC5lIlYHYHV/QRKsslny/vBotFZugJAqPe8RytEuNcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu0r2g7sMUEw/PcrmLTNZ/xNuZwXkTlQCAdZpm5QD+q5ZI2WdL+7tOC1d5hx+sn3/Advg1rTEtrEnh9lMdyEIkbb+CY+5QnANYfYDs/EfqZZI4trlR5qoNo09yyG4l2cxvGBOTgS4afYlqy4Jit3t1mNfS0dKsVj2lTR2Iwk0ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dASFNOQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dASFNOQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF2BC4CEF1;
	Wed, 10 Dec 2025 07:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352032;
	bh=iC5lIlYHYHV/QRKsslny/vBotFZugJAqPe8RytEuNcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dASFNOQL8hYyu+QMOIcH2du1A+FxgCGH+vI5+Eb59lttWlnP75pkds47cuiDcgXWU
	 xWDvCAq3cY0ypx5WUSt4nKygBznkOPEjfl4e2tS30sIukCERRpvTnbC8PZCQ0mERfR
	 sPlglV27hgPowqbwtu+UAt8+qomkIUTwlvzVGwB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 25/60] ALSA: hda/tas2781: Add new quirk for HP new projects
Date: Wed, 10 Dec 2025 16:29:55 +0900
Message-ID: <20251210072948.456533829@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baojun Xu <baojun.xu@ti.com>

[ Upstream commit 7a39c723b7472b8aaa2e0a67d2b6c7cf1c45cafb ]

Add new vendor_id and subsystem_id in quirk for HP new projects.

Signed-off-by: Baojun Xu <baojun.xu@ti.com>
Link: https://patch.msgid.link/20251108142325.2563-1-baojun.xu@ti.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 796f555dd381d..5e0c0f1e231b8 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6685,6 +6685,15 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8e60, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8ed5, "HP Merino13X", ALC245_FIXUP_TAS2781_SPI_2),
+	SND_PCI_QUIRK(0x103c, 0x8ed6, "HP Merino13", ALC245_FIXUP_TAS2781_SPI_2),
+	SND_PCI_QUIRK(0x103c, 0x8ed7, "HP Merino14", ALC245_FIXUP_TAS2781_SPI_2),
+	SND_PCI_QUIRK(0x103c, 0x8ed8, "HP Merino16", ALC245_FIXUP_TAS2781_SPI_2),
+	SND_PCI_QUIRK(0x103c, 0x8ed9, "HP Merino14W", ALC245_FIXUP_TAS2781_SPI_2),
+	SND_PCI_QUIRK(0x103c, 0x8eda, "HP Merino16W", ALC245_FIXUP_TAS2781_SPI_2),
+	SND_PCI_QUIRK(0x103c, 0x8f40, "HP Lampas14", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x103c, 0x8f41, "HP Lampas16", ALC287_FIXUP_TAS2781_I2C),
+	SND_PCI_QUIRK(0x103c, 0x8f42, "HP LampasW14", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1032, "ASUS VivoBook X513EA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1034, "ASUS GU605C", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
-- 
2.51.0



