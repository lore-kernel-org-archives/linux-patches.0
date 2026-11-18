Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050017;
	b=eNaQip5mKBucKcSghLCZd8x4Co4h869COCvQmhRh8wZvqczq2CFpEcXPX97AQAuKqTJA
	 fdAdyeLfStVINeE5iAdO6oSqK8t2tB+e297il6xjCMuj++ejjRSmegH5YnjYDj74GL5gH
	 cNzDl+pH3HOhQzO1XEMsamESwsyDuqo3/3Wwa/Vyqr6y/HJ3AhTrCeAVioxEgolbPkRmF
	 nJSn3VjehW8Hwju0ae5BtE3DEPViqFr7x0KR9Ije76lLj7UBIj7wv9ARljKlELK5ldl4H
	 BqbAvaVedVTsapwNaPYf/iDwJrq5J5GzK/29Lj22/hjA3A9OkQ014iLal7WP5S/W0Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sgd18WYLX2Zjj315jxalpFQY3vRa4iQw9VEm389GcYw=;
	b=V5bONlf40WlEepMbVf2NnDBgEA9vIivnl3HKFrpG2UKzwngBu7iLd1Al+pcigIREJCv1
	 VzrmR22sal8HZt2DtHmCEhoub/wg9V6dfIL3KqPuOlvbfifg2lk9+7Y7FGca7FIEsqL9q
	 qBh22aQHhNyZA8SfZ9vXwcEW8d3Qsuop1fp0ZpsbBi/EZQgJjhZBu9NM5EFaAVtUt0GYP
	 7wf9SKULamdRL52ibTEJio7KnNsP9nZ05+S/hDsCscZ1zEp6KDXwOMdZLkmzCrr9fAypG
	 bb7dae0rRtBp12WakTCw+DTlsoPZbfK+187a6aBjh4DqJzwKYTjtTqTu/4x8xbWpKnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQEeqfOm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4038E606A31C;
	Thu, 19 Nov 2026 01:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQEeqfOm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F3B1F000C4;
	Thu, 19 Nov 2026 01:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050017;
	bh=sgd18WYLX2Zjj315jxalpFQY3vRa4iQw9VEm389GcYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQEeqfOmA8HywXUvn2NlFlh4mIay0joKG+X4xQzBS3lVnuC6bKojLPrxgx/CGJ7EA
	 FGhq6MSUncXTOP7absVFhcUMxiQps7A5ltsMykLUK4VqtH9OvfY3sylQW3RbfdmDPB
	 rb95gRjMKiLaG6fDcYKYVlqen/MjKTkaLXfGzkjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2558/2857] ASoC: mediatek: mt8195: Fix ETDM probe error handling
Date: Wed, 18 Nov 2026 15:59:52 +0100
Message-ID: <20261118150333.607334605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a5e5d8a684d50..1090132233ca7 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2527,6 +2527,7 @@ static int mtk_dai_etdm_probe(struct snd_soc_dai *dai)
 	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	struct mtk_dai_etdm_priv *etdm_data;
+	int ret;
 
 	dev_dbg(dai->dev, "%s id %d\n", __func__, dai->id);
 
@@ -2534,15 +2535,23 @@ static int mtk_dai_etdm_probe(struct snd_soc_dai *dai)
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
 
 static struct snd_soc_dai_driver mtk_dai_etdm_driver[] = {
-- 
2.53.0



