Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB00481643;
	Thu, 20 Aug 2026 17:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248048; cv=none; b=XnWZz5h9EcLYbk0e6KIdfFencaVGUFhxkajS3JnMhP/orZ1SmXN9gb+0b/qEXyUg1+70jIThN7pun+2tu/Ph7MRHDYBnQ9RKSF3Q43ISwj4yx6U1eQ+zwUn/urVxNtQrkKUQMwSklOmsyXbIIL1jm6pLMGdNRwHzJPBiBReGTDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248048; c=relaxed/simple;
	bh=yW2NYWpmY0ntDD/E84SwQenygsipZHngRG58dzdUYpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diNOzlEXWmAwIisg03W/TdJdvy0JimNpCmXzy3hQA5i00jg6eqt+QiCLcnISGnMP7Hrc96YfvOZ9gRy1Wx5SbpOwU56dVIxDBbf7iOGSEdPWJmGb3uKwHiyU0u3A+0S7Dni4Q0BQyb4HmK3smrAjlEHkcvq6Heq5ZHp6X1joSnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vt6DwN4e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vt6DwN4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25D81F000E9;
	Thu, 20 Aug 2026 17:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248047;
	bh=Qf9MWCw+1Xeyfz7yOSHClAjGmT7+khJLewwYyDMskQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vt6DwN4enKd196tX6if1psWdn86TU0EVU4fHW2jYKq8Uyrdu3WVQxDRR5n6l+jOU2
	 jBXxYiKi9bNzqPEoXzd/iMrP/E86UCroA+l4mOGKvrtmd7P7i54gojMQNud7Fos55E
	 plhkr32xr9XA8ltM63wuA1TkYyCDAoS0wz6gIVuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/303] ASoC: mediatek: Use common mtk_afe_pcm_platform with common probe cb
Date: Thu, 20 Aug 2026 16:53:47 +0200
Message-ID: <20260820145256.033135322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 1d2a6b3b5189b6c3e51f29e050aa9b2337b774e8 ]

Since the mtk-afe-platform-driver generic mtk_afe_pcm_platform now has
a common .probe() callback, there is no reason to keep duplicating this
function over and over in the SoC specific AFE-PCM drivers: switch over
to register with the common bits instead.

Note that MT8186 was left out of this because it is registering some
extra sinegen controls in the AFE-PCM probe callback and needs extra
cleanups to be able to use the common bits.

Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240416071410.75620-13-angelogioacchino.delregno@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: e24d5dde56a5 ("ASoC: mediatek: mt8192: Check runtime resume during probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2232,13 +2232,13 @@ static int mt8192_afe_pcm_dev_probe(stru
 
 	/* enable clock for regcache get default value from hw */
 	afe_priv->pm_runtime_bypass_reg_ctl = true;
-	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_get_sync(dev);
 
 	ret = regmap_reinit_cache(afe->regmap, &mt8192_afe_regmap_config);
 	if (ret)
 		return dev_err_probe(dev, ret, "regmap_reinit_cache fail\n");
 
-	pm_runtime_put_sync(&pdev->dev);
+	pm_runtime_put_sync(dev);
 	afe_priv->pm_runtime_bypass_reg_ctl = false;
 
 	regcache_cache_only(afe->regmap, true);


