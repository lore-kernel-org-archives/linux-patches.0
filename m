Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A97252903;
	Mon, 23 Jun 2025 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685255; cv=none; b=VE3z0OwXaiwEaoZD0kSjdnkyZ1uTu0wHr2a86MnTSF1mgpR1NRyw4+DzM9M1kFlzlpz/LorgrdT1M5ntiF+X+7TdwT+dqpvGE1Wz1ZuZ2HxZCZGKgg3RHwah1lUj2D3K/yqCFeQhCQaxWl63d5cGi7XfAAnfOk8TIn3xCCe+pR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685255; c=relaxed/simple;
	bh=WHgoEh2Q1oZrWzhOfSYBsG0Yjfq8s3i9KVkvGRKJ4oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWm8OjM+hBiozDyGYE9vT0UwBq0iURitlP+B4ohPFAgDar3oIXayBlITaxC2008So0356SsFR9rvGBidFV94PGiZ0P4rdYOep3F7UtT1tc28TzqdkNFk5ZVcSJNJETUOdnVOrCsg/1uosWGn4XcoeZQuZiHTOx680hPbWZ3WNSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z84C5XLl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z84C5XLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74601C4CEF0;
	Mon, 23 Jun 2025 13:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685254;
	bh=WHgoEh2Q1oZrWzhOfSYBsG0Yjfq8s3i9KVkvGRKJ4oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z84C5XLlBKgoTBSH4YXAsodItdn+fz4EnPXkGC/dBy60DS+8i+0RPAhdzY1eEqVih
	 FAr8dKvyjEzZdhDAZV9U11gBPpGjtFiMjMAGeksaaqgMhixjgNLxQWPOnOm/C7NUu/
	 0QaFxts44ZPzM+Rv3nufH02XFwbnh06Zwtl/XiWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 218/592] ALSA: hda/realtek: Add support for Acer Helios Laptops using CS35L41 HDA
Date: Mon, 23 Jun 2025 15:02:56 +0200
Message-ID: <20250623130705.472272002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit d64cbb5ed9227566c068ac9300a85912234d10aa ]

Laptops use 2 CS35L41 Amps with HDA, using External boost with I2C.
Similar to previous Acer laptops, these laptops also need the
ALC255_FIXUP_PREDATOR_SUBWOOFER quirk to function properly.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20250515162848.405055-2-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 20ab1fb2195ff..cd0d7ba7320ef 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -8029,6 +8029,7 @@ enum {
 	ALC283_FIXUP_DELL_HP_RESUME,
 	ALC294_FIXUP_ASUS_CS35L41_SPI_2,
 	ALC274_FIXUP_HP_AIO_BIND_DACS,
+	ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9301,6 +9302,12 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ }
 		}
 	},
+	[ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = cs35l41_fixup_i2c_two,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_PREDATOR_SUBWOOFER
+	},
 	[ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -10456,6 +10463,9 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
 	SND_PCI_QUIRK(0x1028, 0x054b, "Dell XPS one 2710", ALC275_FIXUP_DELL_XPS),
-- 
2.39.5



