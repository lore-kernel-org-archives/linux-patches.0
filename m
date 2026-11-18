Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049997;
	b=V4SHdLqgvcfVUfZqY4+x3TlojPsqP1ujMQL38d0oA9rnE/PxC7zHsUBcGiywEG2Ksa5F
	 2LCxjE6wRGg5ST7/zgGntX5lu5M5cEmsQc9ZxaW9KSn7o/TebxCByLfvTNklSmDAQ2Aa9
	 F1inZfe92nMMqs4MTRZeqf6KwrF8O/Dd9RfiPFfsphFwQ/li8AbWcdsNatKoHjoW3c3x+
	 ll4bv/t4t3uzYsAe9UMRnAyTt2aCRvEDslwrCSU3MKxiCWwDZY/Q+7HXyRcDR6OYAbJqC
	 9y9Ccb5VJBblc8Q3xaoMKXYlRPtmJ7DdrawRrH1zHPmBvRtF3J0Lh9hYPM1/GDIA6fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ABKi8135uv0Pv+nFqW4AvRZQ/DZt7xp57bwFCBbWUdU=;
	b=sw8DYBGeOmHXxF60PTOh7AFWCgJ8zhlViExWJx1Zi7YdKqb316k4gk/ZXOULtlaP0odc
	 O/7sK21vUwNmRH6Czn6UCGHeMWRbjegXXcp26lBa5AnGtZ4CW0FDtFVwb//8VY1aLy5sM
	 ff/fNVEiM7Jio4XQZNKNtqlgwHFgZO0w95CqU9RdcjEyxWBlKeRvO4FeKu8rs723oO288
	 RDcz89hU0MAG7mvHp51/83pESf/vBefGRoewI1l9cB5yoFEABYmL2f8hrCl2eeplPfzPZ
	 bNwMgrL3sXBPjXDCIsGTHkENcj4Hch4iKkmGsFtFP1ZVA52RfdhlsTLy9dCWcAbuE4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIhLhpU9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB7D606A320;
	Thu, 19 Nov 2026 00:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eIhLhpU9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBD41F000C7;
	Thu, 19 Nov 2026 00:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049996;
	bh=ABKi8135uv0Pv+nFqW4AvRZQ/DZt7xp57bwFCBbWUdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIhLhpU9F0PFt8XPa8mECA8sI+XKIh2bNSD+j0MdCYvMyT63lWAJWxgnb1X+F5ofj
	 0s6lY/PZhIJtig0TVMLRFHCTqMabimBJOd/ZSpzLFqXVCZmJvtBCw0ih435hIa7SwE
	 +XpmVqrX0mHO39Td1bisX2bsUBh5ibxxi1zgnymw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2552/2857] ASoC: mediatek: mt8195: Fix runtime resume error handling
Date: Wed, 18 Nov 2026 15:59:46 +0100
Message-ID: <20261118150333.395630603@linuxfoundation.org>
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

[ Upstream commit 933fbfb6648850e003a1fc47b7bcc08fe3687961 ]

Check and propagate errors when enabling the register access and main
clocks during runtime resume.

If regcache_sync() or main clock enable fails, restore regmap cache-only
mode and disable the register access clocks before returning the error.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-pcm.c | 23 +++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
index 34b05a4871eef..ab2930669568c 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -2971,18 +2971,31 @@ static int mt8195_afe_runtime_resume(struct device *dev)
 {
 	struct mtk_base_afe *afe = dev_get_drvdata(dev);
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
-	mt8195_afe_enable_reg_rw_clk(afe);
+	ret = mt8195_afe_enable_reg_rw_clk(afe);
+	if (ret)
+		return ret;
 
 	if (!afe->regmap || afe_priv->pm_runtime_bypass_reg_ctl)
-		goto skip_regmap;
+		return 0;
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret)
+		goto err_restore_cache;
+
+	ret = mt8195_afe_enable_main_clock(afe);
+	if (ret)
+		goto err_restore_cache;
 
-	mt8195_afe_enable_main_clock(afe);
-skip_regmap:
 	return 0;
+
+err_restore_cache:
+	regcache_cache_only(afe->regmap, true);
+	mt8195_afe_disable_reg_rw_clk(afe);
+
+	return ret;
 }
 
 static int mt8195_afe_component_probe(struct snd_soc_component *component)
-- 
2.53.0



