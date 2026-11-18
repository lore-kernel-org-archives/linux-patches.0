Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020594;
	b=siLuLaf4ZHwcPNKjxT9584KUAXfOT51cnyYh4zmuLomKCo+/OgPkTPz1hpX/c0UVKxWP
	 SSpy6+sbpOQD1Uj+iQthFuiEtETs8PGm6AbchC6W0yzJ+4Qk8FenQACmeujobexX4EUP4
	 oLRq8lXFl1Yx0ZKC77NyabmLbMAYeoNWBV3NeOVhBW50LCOMPk7n3Hpb76FL5wBxfUbD0
	 AMZZt4mFnoErZ4m+YEaG7Yym8fQNDzowSs3gQCIl9yjItY7+qyVWiUeaBVdmpUds5alrY
	 TY6iLswR7hudZ9e3XW0xtDUxDKYGhDa8ByLcARZp11nTukKhBNkcfGqfRoMs3jvJGdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eh+XDzx6xpsCvOySQ1hVz1kuVV+1bgslU2Mt0IfpQ48=;
	b=qkD/8Fn3v0t0XHFHC4d9zQoslz3jP1y7oRVJlrR4KH/UzshmPA/qLp/SUKFQ3WdCYUa2
	 tVyfjYNqjAb45UFIKs3o//IPxXV9QL3b25/gRB0B/dt434XLQKabcRRGCIOjHc8zPfkWS
	 mMTaqthsc7nwNgzjSAsvvDDcjSf3QyccC5TLv5OCjqX2AQv9xkKOdQoFOb8QkZHZfgx/y
	 eUXGGUQE9W8OAGoxhmASVbvQaMwvsr9jyZbHrm2mGhPRmUpVf+7JvAPOKLtotuGf/35G/
	 o0QTChTXx7yUHgAWxFfV61wEk61XIPP60DnBWTVXPNu9cyrAhJcv/JdVrfHQnIpIB4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SozofyR5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8960C606A31C;
	Wed, 18 Nov 2026 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SozofyR5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77641F000C4;
	Wed, 18 Nov 2026 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020594;
	bh=Eh+XDzx6xpsCvOySQ1hVz1kuVV+1bgslU2Mt0IfpQ48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SozofyR5wb+8nZalAdOKLuqa4rLtmGmEG0c3uTo1xRblypyaam667jLPphc/MTHZZ
	 62FrUaRbTYVCh5XxswX8YZ9aSb3jxL223o9c9tbC9iruOhj7xdVM8i+mM4f5oiEsCM
	 syKrKWn7LMJEgT+IvkxkDyYR6Q//irHRonA++LVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2005/2651] ASoC: mediatek: mt8195: Fix ETDM probe error handling
Date: Wed, 18 Nov 2026 15:54:05 +0100
Message-ID: <20261118150358.472445844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 11317cdd14abc..8fa830a575029 100644
--- a/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-dai-etdm.c
@@ -2503,6 +2503,7 @@ static int mtk_dai_etdm_probe(struct snd_soc_dai *dai)
 	struct mtk_base_afe *afe = snd_soc_dai_get_drvdata(dai);
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
 	struct mtk_dai_etdm_priv *etdm_data;
+	int ret;
 
 	dev_dbg(dai->dev, "%s id %d\n", __func__, dai->id);
 
@@ -2510,15 +2511,23 @@ static int mtk_dai_etdm_probe(struct snd_soc_dai *dai)
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



