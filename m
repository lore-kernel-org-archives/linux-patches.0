Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B0E21B183;
	Tue,  6 May 2025 21:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567376; cv=none; b=pzWbA8V7LdBrEmg97dMyccd7EZgLOpOdMj6EhbacXp31IN6wmkqXCszyeU+ZeaFpdxTjnxh7B7u3zgH24TtzT95ZBRdNjN1ULtUhQ4Fc99KjspRUzJ7Pmnl9AQNU2a9meWhgtdC/vXcjoPAul2Y+rkrunAUewAgy8TOTQrsDtMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567376; c=relaxed/simple;
	bh=yBu1az8/OZoi8PDKYPnp/10aiX5KHCwBplGq28w4TsA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=t7mLJrIdQcsigY8SS4Sm6tn25ZBSBOUYQ+0/DJV9gFtgWtabtplThHvUIXhy7pzPcIe6VbUY8bJu3QwBzRuGe7Xw+qAveYrL1hx94z9AiffgcFrb5WHrxH/EOBBlTQpZvZ5q7TuGGrv1j/NJrW0Q9X+gBCyh07VHCcwOn8hdSmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKl6VUYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKl6VUYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20E3C4CEE4;
	Tue,  6 May 2025 21:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567375;
	bh=yBu1az8/OZoi8PDKYPnp/10aiX5KHCwBplGq28w4TsA=;
	h=From:To:Cc:Subject:Date:From;
	b=dKl6VUYJMX/9CDIRIxh4vgqSY6j7YnuwWCtY00dsO63ca5MXGUmNHEi+pIBV8Ed6v
	 Xx0nX0J1fXsa32qQa7du82v/3d+mR4Jfw+7nB9igMxxgzIZrKcXgWNYs/66tLZlzN5
	 o6/mw0NtkejhOGrMQims4ChvY4JoDgkFmyDddnNsBkr+pzdtg9D4CQvTiCng4RzPMU
	 H8VcYre60/8HIcTI+a9Xhe3r0Lub4LItq8Bj1YVELSAR84fCGCF7SaCmZF1fgF69VB
	 Vgs8zeaB7g0FU3uvPfTkvUS5x3j3+ZKr5jqIJdYQc3q0nhh+DGpr+gKs7Ejlu7FMKH
	 S3SoVOm/sKk8g==
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
Subject: [PATCH AUTOSEL 6.12 01/18] ASoC: imx-card: Adjust over allocation of memory in imx_card_parse_of()
Date: Tue,  6 May 2025 17:35:53 -0400
Message-Id: <20250506213610.2983098-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.27
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
index 93dbe40008c00..e5ae435171d68 100644
--- a/sound/soc/fsl/imx-card.c
+++ b/sound/soc/fsl/imx-card.c
@@ -516,7 +516,7 @@ static int imx_card_parse_of(struct imx_card_data *data)
 	if (!card->dai_link)
 		return -ENOMEM;
 
-	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link), GFP_KERNEL);
+	data->link_data = devm_kcalloc(dev, num_links, sizeof(*link_data), GFP_KERNEL);
 	if (!data->link_data)
 		return -ENOMEM;
 
-- 
2.39.5

