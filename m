Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032165;
	b=okR0Zkr16h5NEuN3vS2JvuqKzYJlr4/K7qLfKe9vYu20NUNOir6F96eHcV/myjfwwaJn
	 Drg9GUFhiP5FTwZ8u7b1wlUR/idyo1bchmZkXTXbfvlF48QlVXNczG1jeHwEehLGrMgVc
	 Y0E4E6Rs3U3AdzDLkYnkNi55S1gPsIjRxDorKOij5/0hHydcEljQ6spCpEPUftymmnLJ1
	 ePGZ+fu2owhucyWD/tjIM7l58VBa0Ih23XX3Y/V+aVFrqSHwBGrtmoQfbqTeJJva18uBy
	 D8FIhJLJyEdKw9eAQbhqVm4bRHqK/Mfb4+WMTecTHsc0+rAnj+T3nkYLB++FNe0IvBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FXcJv1xDEttWPJrHFUn54PT9/soKD7UOz5/mgzUcVf0=;
	b=LlVPzcqkMs0axuHG6tUwV2DLqb8EKCWVYo7bDb7gcwzBlsIhwCDb4sRSk5t+NzGwRyru
	 dwCsLo7cP3lp5hPku7msYPK5UA/1TsHiMROIyhv7Pdg+Y7o/lkaBhqgBJHZd/ZK26Bpgw
	 nvEckclSccwyW2ZMZo0iWI8zwXFyMe7Drv9mX+ONOxhatV4SmbCpUag4UiCq+NDRRDIw6
	 V5bjiZ3pPPk2jJFFpTgnHluY5loxi1HhLSdGGIJT2IBtYSz63hw9ZCOHJTVRY1BVVmalq
	 DB3ZcQhLLJ2lMkIc5JKD7rFEitvG2oCuz5jSIYlkWpRT1u2OfpC++tpkCBstv6UeJDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmgrP59P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93050606A31C;
	Wed, 18 Nov 2026 20:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KmgrP59P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BA91F000C4;
	Wed, 18 Nov 2026 20:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032165;
	bh=FXcJv1xDEttWPJrHFUn54PT9/soKD7UOz5/mgzUcVf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KmgrP59Pq1vfkSg5b8UVV917S0AJYukYpZ+nNZus/58EA8T3sFQ8/vZKpoEJo6MYw
	 Qqz3mzCZbOaDIDUUvB0x664NSgGxp0fynqifad/jmaY84Rz2WRE66xjaDrH0YtYvu2
	 9S9Oo3UGNnIzI7WDiHWkONwuLYQdvNK2YtG++jmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1314/1756] ASoC: mediatek: mt8195: Fix ETDM probe error handling
Date: Wed, 18 Nov 2026 15:57:21 +0100
Message-ID: <20261118150101.773593848@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



