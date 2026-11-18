Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041841;
	b=wR/ziHCUKqUXsd86Du52KI3bKIfxMsS09VRsCtVRRD2q+Q4Q5kZWxPSIwl6ywikLKOa2
	 3LRjkwwBwEzw4tZ/T3dp74bsBCXLffckfZK6P7UiVJzKMBGVLE24bdsYzsCi0PRC6fRYE
	 zPGHzbJ96B7HaZJgG5TvTnBdSbxWLH1wgFN8RHnEwihDW5z9LjzT2CRD8MlbuG0kZjmVw
	 P7G5d3dnInM/2a7jUfYoBrHXvB95CdVVig5crdZ4qZz8kJIEVouosoTpbxezWBqng+xc8
	 M4x2ISsTErWKD9pbZ5ctPTYRK5kq8Z6PHbTfImN2Gwsbnn84Dd6QJZQRK7RsjnIr5Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cSG8Db4+wrr9ygV3JxQi5XrUPAuZgJOzoR2t3qY/b5A=;
	b=q5ard7zqjLfsxnyNzRe2m2rxpwP/2U0nPdj9FqUzlQy9sfXusl02CICZiMf78kY5D772
	 lkkpG6yVRf7RAn321AUg2y5Gpx+HcL0pwnk/+R/mOsHC8IfuKU+uG+NgiEkvURyYRgB7o
	 c5UHXlLL4ukfo/HeT04GOKJrz7JsYkBdpUyn5pnLJEMYAyMy6mc6qsNH9nj6tC9eSC7Ug
	 6UopgXYLLEcALEWYLv/rztV0MZKCWzEE/KoYmO48Xsb2OfIKvtA4MTLYbIhLB0Uh+JU9f
	 qwFDuJxXsgdzmCCs1xlbO0JTqyexwpZHT/0KzC2MbJkibkNEAvWW6ocI16dlvhrkEGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTFOyo5x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEACD606A320;
	Wed, 18 Nov 2026 22:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OTFOyo5x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494F31F000C4;
	Wed, 18 Nov 2026 22:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041840;
	bh=cSG8Db4+wrr9ygV3JxQi5XrUPAuZgJOzoR2t3qY/b5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTFOyo5x+//Z6VhW64O8R4SOIdIg/19ZilZ+GcadSbQDEKkwF7zTb6m1dvDjqTe5/
	 kM64hzd7cq6bgZAjHFQR7is0wtiLDYaJd7zOsm/TAyGL94RMsp82n2TfnpEl+1P9BF
	 QT/dGZUF0uaKt8fO/sR3elxTfbEVnnOXapmyHF6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2957/3318] ASoC: mediatek: mt8195: Fix runtime resume error handling
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118150449.011790175@linuxfoundation.org>
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
index ae8727d27e696..4a866bd3801e2 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-pcm.c
@@ -2967,18 +2967,31 @@ static int mt8195_afe_runtime_resume(struct device *dev)
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
 
 static int init_memif_priv_data(struct mtk_base_afe *afe)
-- 
2.53.0



