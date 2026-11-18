Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027016;
	b=qrewqeCwtetPKa6F0tKI01fBojrxSC/zSxLrh3hvGmD5uCS+2fKHM7lDeyL96p/oEBrw
	 4dp+knwcs700CqrfWOTOCyJkSLEaAQ4TOJ8mEmXb5R8CW8fAlDokzTD5elX7PgobH0Yv3
	 VZ+KAuWvPgEJCWxQQ83eWjVu/SWYiJuUGWCrHeHMgJu66TozLPWe4rkRkZmm3OduY/NkI
	 DrROAYLSMDMTwUnD7hFEpUDvLvaO58AHOG4W58rq1dDaoO+r1toA+sZYMcHR/JFRs9SN4
	 Wbfb3HV5W6SvapuTJiGWFvZH+MU+8med7O+kWBv8PJjNj3UG327JqHuGV/hDN2AbfvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sAWgFdvQsCwAbVijneNV7shc4/QbSVZ9CIU0ukdKEKY=;
	b=ESpYVMgcOlun5r8VuHh9TvfNH2ASOw1krMDYi3i+cD5uGIF79DNqWMQ4U7KrVTm3rAjf
	 EXGvLMEafXIJfUBPvTJYcFI505odagXHBjGarWZ9ZS15dfLD0/vdFHh+Gka8rb2ELQXWZ
	 69Y5xlhpDamPwRbHkPFKmREwoQtchVfT0XHbScQZOuKaoHSXVuitlLhlCVwCGoXtZtzGr
	 sAPyNbaOkFtL7cEB01M4Sy5pRpljG854NA77elHmHSSOaZk9ndTYzoi34F5L5qoAJizOv
	 veqWiIebunwNIQbzm5avPKFKQ+psSLEKRtz1VQRu7WZkIQUJoBEh8tcrgn0xbC9J20w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSq+gJuX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7A5606A320;
	Wed, 18 Nov 2026 18:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RSq+gJuX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28851F000C4;
	Wed, 18 Nov 2026 18:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027016;
	bh=sAWgFdvQsCwAbVijneNV7shc4/QbSVZ9CIU0ukdKEKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RSq+gJuX+YsQlfYGKCNWw8ctOPMrB65UUHEDu1CcU1ikWOrl3a3HKc+xI/l6oKpZc
	 4PAap7erSLZ4Q9oNVlIfm4WZnzqWl0TeIqdixLLc+W7ogsDLX8EZoOyMDBzb9XQxaq
	 QNLlBQYbrVEilUG2JDI3F+UCxLfjbxc6b4p1M/nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1638/2151] ASoC: mediatek: mt8195: Fix runtime resume error handling
Date: Wed, 18 Nov 2026 15:56:13 +0100
Message-ID: <20261118150221.535405658@linuxfoundation.org>
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
index 0d66e1b6dd3c9..6de510ea33cd3 100644
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



