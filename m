Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44F20218EBA;
	Tue,  6 May 2025 21:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567441; cv=none; b=SG3oUZUIWcl2W7PmgbbzTv5YEfzpE3pgRYyi/72uQHkIGAJHnslQ+nc4RCsRY3YW2fUYyf18vhlAS03w4G4OAFPBm2gqRSrpUkHwJWyXMLL6TULy5Rw8XrsbBg6He3HOfHCOucgLArn27YyJvrvky95QV5QYhYf3vKqMy52Bg0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567441; c=relaxed/simple;
	bh=sDdNilLczBKLaYqH/j1+dAzPrmbkU/4O96N81w9WPAU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NgtAuk1s7NvsjcB91dNWchdWdk27/d/dAHoVtIrN7+JHDOQ4H8CnEDreo+aRO6dHT1rCd8tRmFy0OhERHveWNxRCehuZ/gIaHNQP6ZwDRvy8ChmtxQaIS4e5bAEPYk9SFm1hVqQRUoU5qa0NqHo+9wvMghJDVB+25lsFP/YpfeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GFll7MAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GFll7MAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B88C4CEEE;
	Tue,  6 May 2025 21:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567439;
	bh=sDdNilLczBKLaYqH/j1+dAzPrmbkU/4O96N81w9WPAU=;
	h=From:To:Cc:Subject:Date:From;
	b=GFll7MACCfR30CYypbhc3YU4zQrW+sGnDisfzoH00p5OQqfXhoLJNyDslyTWzTgLm
	 zPgsGJ8anCr08Gku7f6TkhgldVWZFs/OqbJMJ9NzCayW+cecVJqcZkVAp10KdCt3tY
	 to1mgfK7BcuY4u8XX5Vyx4TEw2c5tL60UJhUQxYBC+zR4pDJQ5sdWmGu2202dlqvfB
	 tytHH0PNHiHzbrV6g2Czm9q7Dr8N5QpLpzkYlOPhidBAHaJVezxvCLoRorE3w4rFlI
	 WZUJHDEGrPV64ZTAamKTn12mtChhEmcejDop5wIoap5tTv6AoduUTcDWifmSZ20WIN
	 4wtYG8frBy+/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	shengjiu.wang@gmail.com,
	Xiubo.Lee@gmail.com,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	shawnguo@kernel.org,
	linux-sound@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 1/6] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Tue,  6 May 2025 17:37:09 -0400
Message-Id: <20250506213714.2983569-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.137
Content-Transfer-Encoding: 8bit

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit a9a69c3b38c89d7992fb53db4abb19104b531d32 ]

Incorrect types are used as sizeof() arguments in devm_kcalloc().
It should be sizeof(dai_link_data) for link_data instead of
sizeof(snd_soc_dai_link).

This is found by our static analysis tool.

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://patch.msgid.link/20250406210854.149316-1-chenyuan0y@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-card.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/imx-card.c b/sound/soc/fsl/imx-card.c
index c6d55b21f9496..11430f9f49968 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -517,7 +517,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5

