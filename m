Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041855;
	b=c7oM2QXWcMkq6czoZDctq+lq5XU7XrvNovjODhNRNhdnIsia4tOci0nfi+/2tq1QylKL
	 nwMkPOP9FAoUGfOsnbjGR4eoOTKU1+IKE19kmTCm+y58aHBQC1BsXXiHrFqJ7INsA/1Dg
	 ANvR9USKZPNJp/fZpWWIV6KRZRNBcLgKZjTwmC24y7OdRRqG7Vly+A3IL83hNqPZr2yun
	 k5I963SGdV1Eavp/0XL8/Luo7C6kE8jOSqcKm/VAPomVvBKNI3W5s2jBuESG82Gp1a+Rc
	 oHSCngsG+fdVjov1kHEUFnwTUvXbJsKKVzJ8WLUJy6VVDdad5f75J1AwIpSyPGY/x8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a30uelIRJ+k3qD8W+PtqCf0w6+viP1FzuS+wB/s+DUQ=;
	b=5svS+IdJhRTERQzLyGRiRwdGafOvtjAXQc2L1CejYmaTmJx/sezjN0spOfd+u9rf4+w0
	 mQD4P7+Y5ENw9e5rLWul9ZYq7mqaRJNAhd3UKB51ddtsISchuqjTiV6aKKmfycujCbgAV
	 oxCK329LV4KOjgxppV12nEMNAAsfEIGJkaFxHr2beAzFvyYggewsnwCEApBTr3BLgYswi
	 SUwSzMZO3sPKbrdLZAF0mrxRadqQ0K8AdPp1113jaEUsOkQaRgS1UEpK91XNs0s5Axwyo
	 REAw9jZWGwPdnjcAK4t7+7BKk5kHTl3zIXJ49+rLeT6mBm07pj2l4vDVZVjHtxIyJdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnTHD7tD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021FC606A320;
	Wed, 18 Nov 2026 22:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WnTHD7tD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574801F000C4;
	Wed, 18 Nov 2026 22:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041854;
	bh=a30uelIRJ+k3qD8W+PtqCf0w6+viP1FzuS+wB/s+DUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WnTHD7tDNXb29wSRNi0s2NZihibS5T4ChAxBMQitVH+SSy11X3UflSHZo+oLbjgv+
	 Coy3uHGSx7epybUDCq/xRMWcvNBVfmIeMbPYmFMCgs0PCrei3yDVaxJBJQqBtZeeWs
	 IVb9PE7TEzrDM0wSi66rtQsu1EFx4qNKp9VJtK00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2962/3318] ASoC: mediatek: mt8195: Fix ETDM probe error handling
Date: Wed, 18 Nov 2026 15:59:44 +0100
Message-ID: <20261118150449.156205145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit ca3ac9a7eec1884bfff2d2dd92caf30f86a9eea7 ]

Use pm_runtime_resume_and_get() to properly handle runtime PM errors
during ETDM probe.

Propagate errors from MCLK configuration and enabling instead of
ignoring them.

Fixes: 1de9a54acafb ("ASoC: mediatek: mt8195: support etdm in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-16-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-dai-etdm.c | 27 ++++++++++++++-------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
index 66f8468e534a8..b796c1de70379 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2508,6 +2508,7 @@ static int mtk_dai_etdm_probe(struct snd_soc_dai *dai)
 	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	struct mtk_dai_etdm_priv *etdm_data;
+	int ret;
 
 	dev_dbg(dai->dev, "%s id %d\n", __func__, dai->id);
 
@@ -2515,15 +2516,23 @@ static int mtk_dai_etdm_probe(struct snd_soc_dai *dai)
 		return -EINVAL;
 
 	etdm_data = afe_priv->dai_priv[dai->id];
-	if (etdm_data->mclk_freq) {
-		dev_dbg(afe->dev, "MCLK always on, rate %d\n",
-			etdm_data->mclk_freq);
-		pm_runtime_get_sync(afe->dev);
-		mtk_dai_etdm_mclk_configure(afe, dai->id);
-		mtk_dai_etdm_enable_mclk(afe, dai->id);
-		pm_runtime_put_sync(afe->dev);
-	}
-	return 0;
+	if (!etdm_data->mclk_freq)
+		return 0;
+
+	dev_dbg(afe->dev, "MCLK always on, rate %d\n",
+		etdm_data->mclk_freq);
+	ret = pm_runtime_resume_and_get(afe->dev);
+	if (ret)
+		return ret;
+	ret = mtk_dai_etdm_mclk_configure(afe, dai->id);
+	if (ret)
+		goto err_put_pm;
+	ret = mtk_dai_etdm_enable_mclk(afe, dai->id);
+
+err_put_pm:
+	pm_runtime_put_sync(afe->dev);
+
+	return ret;
 }
 
 static const struct snd_soc_dai_ops mtk_dai_hdmitx_dptx_ops = {
-- 
2.53.0



