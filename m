Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F293A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSxEn5te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A87C433C7;
	Wed, 15 Nov 2023 19:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077894;
	bh=c0UzMj+zSHxgiyxhgc16PX2qwyRlPKKbGwW+AhFAfUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSxEn5te6GNIEwR0IYx17YVFieZfRCpmOP3uk0Rt8GjUMek7IXxfUgDnbu6/7wCu6
	 49UdVvlh8PdxJxk+X0RfhFirWqaPj23krhP25HVSNWs59YyxPEof62YNEJRSNqEeit
	 wfBshMHgWkJg3nwYEa/hmU8Bu1nV2nXdFqYAwOW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 585/603] ASoC: mediatek: mt8186_mt6366_rt1019_rt5682s: trivial: fix error messages
Date: Wed, 15 Nov 2023 14:18:50 -0500
Message-ID: <20231115191651.804295225@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eugen Hristev <eugen.hristev@collabora.com>

[ Upstream commit 004fc58edea6f00db9ad07b40b882e8d976f7a54 ]

Property 'playback-codecs' is referenced as 'speaker-codec' in the error
message, and this can lead to confusion.
Correct the error message such that the correct property name is
referenced.

Fixes: 0da16e370dd7 ("ASoC: mediatek: mt8186: add machine driver with mt6366, rt1019 and rt5682s")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20231031103139.77395-1-eugen.hristev@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c b/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
index 9c11016f032c2..9777ba89e956c 100644
--- a/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
+++ b/sound/soc/mediatek/mt8186/mt8186-mt6366-rt1019-rt5682s.c
@@ -1179,7 +1179,7 @@ static int mt8186_mt6366_rt1019_rt5682s_dev_probe(struct platform_device *pdev)
 	playback_codec = of_get_child_by_name(pdev->dev.of_node, "playback-codecs");
 	if (!playback_codec) {
 		ret = -EINVAL;
-		dev_err_probe(&pdev->dev, ret, "Property 'speaker-codecs' missing or invalid\n");
+		dev_err_probe(&pdev->dev, ret, "Property 'playback-codecs' missing or invalid\n");
 		goto err_playback_codec;
 	}
 
@@ -1193,7 +1193,7 @@ static int mt8186_mt6366_rt1019_rt5682s_dev_probe(struct platform_device *pdev)
 	for_each_card_prelinks(card, i, dai_link) {
 		ret = mt8186_mt6366_card_set_be_link(card, dai_link, playback_codec, "I2S3");
 		if (ret) {
-			dev_err_probe(&pdev->dev, ret, "%s set speaker_codec fail\n",
+			dev_err_probe(&pdev->dev, ret, "%s set playback_codec fail\n",
 				      dai_link->name);
 			goto err_probe;
 		}
-- 
2.42.0



