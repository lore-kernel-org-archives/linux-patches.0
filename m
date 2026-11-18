Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027172;
	b=yzKMswLwszXuMU5fX4+SNRIBSUrVrTcWK0MFGpNuKzLr36Nu9UTz/H5hmL7PbYPdn9KE
	 SOzVuKTYdCF/SbV2jhTqYjvG+pvWEOnVFqZuy2YgtzB97lsmW9n3jjjngANS2pXPdxxNw
	 RoPaOXq+MTBDvtn6XLLGSwc3+coW98uMipdC4e36iYLGeyEm3R2OBuS1hQBGadszSQmgj
	 etckvpQ+yknmEPlCmw85eKDsCNugUAinYYkMLCLpCvBZmWTvPfTPiVpLm1ut+944WsZjR
	 tkb2MJRDzaYpVjJ0CXfbx2Q2Ugdye85/3854KuqgVYKABayOGy+gqCt25erbiYCEIBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027172;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WRru9iMAF4IFkmxqFHM0eK8Tj0h9vVD1SgkQYjFi2k8=;
	b=aMuCFt6X1M9e+LxsI81+HFAidn/X03zxx7etEIoL4k3XerlC1zcItAcNw3Vp25UFVHz0
	 tNHx7mb9QIab7DfJ6TL+8YEKGp8bH35x71mqTqObvTIurfZ88zG5mdJyMRstQvUn+osI+
	 9bnY2ctQDzwB6NanrcLK3ePK19RPjh5ZjQUKEUIU881agQYCUSnkKiCEwe6HJhFkTcYKY
	 Q62P7dWs9p4rxE/Lff6wYTzIWqBiF67i6J+YBzwwxEtEq01JPaRFjQD11Nm3Nzd4qN9cR
	 OpHv2p9sxJTZbdfkiJGqAj7+Aaeb2eqiCOJYXBWHqfnJ0vIvKhr3JHWZSvAnjaknZRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXSAhmtR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0889606A330;
	Wed, 18 Nov 2026 18:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tXSAhmtR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B78A81F000C5;
	Wed, 18 Nov 2026 18:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027171;
	bh=WRru9iMAF4IFkmxqFHM0eK8Tj0h9vVD1SgkQYjFi2k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXSAhmtRYvkSg6Tl04yJ8SpcCVw3rnt7nUrZsajnUtaP/6ljh5D139QRxOZxz0GWt
	 S7imJFwrwzPlto1YQrQ//uPbUF4oXoHWMatypGi11tTMjpyF3l4QXHJPXJ6VByFI5x
	 pRBE+920Mz52YwSvUc9KaZeYUkmLmbtWAsyzr6X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1643/2151] ASoC: mediatek: mt8195: Fix ETDM probe error handling
Date: Wed, 18 Nov 2026 15:56:18 +0100
Message-ID: <20261118150221.708072189@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



