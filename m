Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056580;
	b=y15NtwP219ztjfgg8mOc41WWHqEFoBEFnKPAQQLOWUigYhzb3rt8Xaap9pPQgoVRr5fv
	 xqkRpZGgoIYOtR7/aGAs4uw84Ol0JiL+S3fIZIJYcKOUBFBfmZ9lZnlsUnDL12tJRLJnM
	 2vExOPvFZntb3wovhGNdym7vl1Y1fDCMRHC/dFurWoIwNlf/B04t7jC00Mde7VK4DWhrp
	 9clHeMWsdswoqNHpWwlyc9WNwsbdprRsE83UlmwQzaOW/slWn93yrRnO0jli/QHzWjilR
	 MZu4hQ2e+b97VbDs4jSlGG+PMnvOW59yaYe26FkMg3Awg6JEYaCVORpGsS4gAZGu7yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gFuKxPgJE9IZYLZ3j9EVC+LbfDLd4Dd7mJaacT8cMLQ=;
	b=bVQXnH/5/indHn0RmgG4De4SN8g6r69fNMFZg7SFMynF3+t9u4R+J0ULDQjqYUaZD6SM
	 X0Gy6VbCzpkt+z2ClYWcOTK8MbJCDMWf7T4i6CpQ3Ny517LebJ7YDmO34O8X07/3XvIe2
	 m+v1JgJeQrQGE2MAYBUFom2txixm0dKNKHyflFfMJSfD+BFtP9rdIrGWaJoFchjzxfZqM
	 ILN7zcl/X420hJedcZ2EjtjqHVmZJGEmdY9SKBoIPW4p7IHjvYpbXKsLDGaIRkQm1xL2x
	 1VLS3E+7/qvhDsXA6PMAcBUQNC6JdMd1fWO7vrQBJ4cVDIgfB//94p+FLU+RNWQqnyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4JR1KfF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90424606A31C;
	Thu, 19 Nov 2026 02:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w4JR1KfF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A161F000C4;
	Thu, 19 Nov 2026 02:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056580;
	bh=gFuKxPgJE9IZYLZ3j9EVC+LbfDLd4Dd7mJaacT8cMLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4JR1KfF1hYTC3mKz5NG5qDWkkTeoV4F8DgG8AJw9EPkEt6/LDfEcw3FvjkZ2orQ4
	 m3PsJlGExMHovq56c24lbwwNdJSWdAzgT8orJflmrzM8baDUT4EGT4RDkWmzIgFgk6
	 yFJFr18P8JeOdZltqSUARsgdMwNozAfoJFGk+Nhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1997/2214] ASoC: mediatek: mt8195: Fix ETDM probe error handling
Date: Wed, 18 Nov 2026 16:01:13 +0100
Message-ID: <20261118150130.684922796@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 30244775a4433..d524b450a9a41 100644
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



