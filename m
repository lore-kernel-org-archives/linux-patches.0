Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D351ACEAC;
	Tue,  6 May 2025 21:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567330; cv=none; b=UsZbGMaF7okIi12q9tiZEUmee2paaVsOhl9k4FNCgVweAP7hySCVmv26+JUSqMNjfUASd1RR7gdBpnOZvxTVLuk2wme7gOjzGnJICt5FwxCZs28rEUQDr+eieGrl3BWbQudVqi+MvySX4mpwpw26VC6hh5lIAWGRgQz2PAkm4Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567330; c=relaxed/simple;
	bh=TKtp1XPzEnz0nV/IHJfa7zuMDZxO8VXjrfb3mToz8VE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZCZP1DRnFfoAA4mSSowZOjXA0WW99hQoGqv0cQ4qFuPPjFPTKzG6RkAgj+rJDK6yfljDtNpQk1JXgA0mYSat6xnvdaEqlSx1FYSYmg5noUrxeBeNtgagFnfKaSv6kLPjUDGoYcqm5Jx0yBZ4IfQyVR755zKUTLI90xgsw/wDTKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CV0IYFxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CV0IYFxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512D8C4CEE4;
	Tue,  6 May 2025 21:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567329;
	bh=TKtp1XPzEnz0nV/IHJfa7zuMDZxO8VXjrfb3mToz8VE=;
	h=From:To:Cc:Subject:Date:From;
	b=CV0IYFxEGG3ggtbFUnwPZLVjTKIO7or7fTpnCNZtuLVBAoENhSCQ+NeDR95PU4s53
	 JYd5MDy5T8UqM7Cdl65/pNb28ZEZd4wNyYmP9uky9ecK8uXp2U5eG/dNTvUVwbcUXs
	 gF4gnwPQE5imHi1UT1L5m6Lv8Bs3vdzHqxLOs8EKa3wkBTJ7436sLdf3oFOVVB/Spf
	 SOeqr73xkw8iSUULpqYI7hRsnsrusx9G9yrarLU09r36tSVGcm8F+id/jrr8axyKRk
	 PHFA7SxUW5Mge0tKAagVbXNDtQlj68O+UBVnmeXYw/DrsbuVlbluQt0LbHj44EGkAx
	 gqlRRnkk3Dufg==
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
Subject: [PATCH AUTOSEL 6.14 01/20] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Tue,  6 May 2025 17:35:04 -0400
Message-Id: <20250506213523.2982756-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 21f617f6f9fa8..566214cb3d60c 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -543,7 +543,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5

