Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B78219A70;
	Tue,  6 May 2025 21:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567461; cv=none; b=eBupeiivrHMdzjOs1N9WB/QmM9v2azzlhOlWbSlXeDQVUPiG/7o7pdHbgtsi6u9mel4hleDLG4DOmrL5w69/z+wQ8VR/8cC57FIg28NQseNJ+f3BBeWe8tUvm2OBEc+OxZ7ScGzz8I5q70+sZBntbVaMLpFlLmQC7hw3WwEeMPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567461; c=relaxed/simple;
	bh=L6Tt2ffMkg9EVgZa42tozx0zcdnP3UBkZcqvblRNdv4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cCK0Ivmp4kyryDK/SFR//fr/qx6TyxuP5XBkQVpCjHRv0ACCn/n6/ChcBlxQQY8Npj2vzFyrRcNVFnqIls1l4W009iEy7qNB18ZgVtSHY06W/TrJLRLl6I3B24k56OSGWtrFIOHtAbzCFY1WJ68bkl64Gwvszh9r8NQiRNtrbPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsWNs7U7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsWNs7U7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF3F6C4CEE4;
	Tue,  6 May 2025 21:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567460;
	bh=L6Tt2ffMkg9EVgZa42tozx0zcdnP3UBkZcqvblRNdv4=;
	h=From:To:Cc:Subject:Date:From;
	b=hsWNs7U7gMY5LY7oLi3jBIWTu03Lv4lLsUfyUU3Z3tucFubQgZIj8ZKg+2ZCiEEFr
	 czKi/tTmSeQIDa1PJwUz/H83sHV2yPeu0jqmyNhT2Lq2zl4KT5lWCrLbKMncaahM2O
	 Lwz01Q7PX2TV/tx31W1ECr0ZhsXncI1ebgSppGLPRBzX1nZh1Iok3+2NNcSvtUY4Hj
	 atKyBez0SG0m2GbJjfAqyaXmFvs4P6REkoojh+Hvlrqt3WG0AoWvWOXCBIj6M9kfTB
	 YUobReJ/93Jg9MFnZM4XyYJl0S0Fdk2gN/bjyztcLeOaW5abUtbiWwURpufeDy08A3
	 eSxGUtxBlzW8A==
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
Subject: [PATCH AUTOSEL 5.15 1/5] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Tue,  6 May 2025 17:37:30 -0400
Message-Id: <20250506213734.2983663-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.181
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
index 2b64c0384b6bb..9b14cda56b068 100644
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

