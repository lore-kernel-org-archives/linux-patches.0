Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027002;
	b=kJUjmskDhy1rqiN8Y4MeKTrWctMzn8uBcSHG87hBho8gnH6FdfpbPN4gq6661cnhhHRT
	 jbsvbSe6Xri+m3jjwtiNjg87KBOXLrSi3lMJhgKeMQ+FGeztydXyDBe8sb9PYmdpK464E
	 FrmmmQYhQh+7Aupq8lUtUJiHW/CyGpG5PSbs7KFnwgw22IBRIu6kBKpxWLW2XoIdWhh20
	 l8WiL269vX4pU/EIEeOegdBY4xNoO82y/+iBcHO1/hnACXvGMwL0OorvlLQNsgxHXqBwm
	 PSWEdqXDQVd+c07UtzaU/QArq1J08QikHo+g8g2EklO+WLUZ6AhgON0jHU+Nh2elSCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WT/0qM4IY9P/xDviVjj3mT9anOVTiPm+coB7FYwPHBM=;
	b=RFLadIctG0BKuFIHZO4ut7zlTgdRkq6sQyBQfZF4vzxb2jypfvd9eBdIH+3Vk7eLJQB1
	 n2C9HspHyDOnLgpNyLuRawJV2haGiTMY8T6wo+bFAzmw1MEq8hCesDJz/0cnpaX+mXwdW
	 7+mxAGf/4LpdbHSHKMXJjRLGhn3xH11JlSuYYbb30cQd2FzKYaG2RVUgUeHVy++iivmAA
	 El0ACwzVu/RGCt+7zHwLLZqcosodDLo+DjNoEqz4adc/yYXSTeDRMCDtd0XrMnJJ2RdHD
	 Hbf6apH64KiFjd9b2ozsOO4GPG0Sey5qA1bgZXCKYTiQIOP3s6ZqT6HTn1OnMqy8Djg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uU8ZiCfl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9D7606A330;
	Wed, 18 Nov 2026 18:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uU8ZiCfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A54411F000C4;
	Wed, 18 Nov 2026 18:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027002;
	bh=WT/0qM4IY9P/xDviVjj3mT9anOVTiPm+coB7FYwPHBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uU8ZiCfl+I7y1KqL6hiEwL7FOyxqGH4+UQXw7+hATcP0k2P5YJbzzgsYqINcgeRBh
	 Ejwe/mnypsrTu07H4EGdMDmsAFMvHDMXDQuYF3eEa6WKjgFGGWmRdDpf//n6X4X3O9
	 treuEvCuA90nlJfBD21pzt78NcJDwnpR/Airp6iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1634/2151] ASoC: mediatek: mt8195: Fix main clock error handling
Date: Wed, 18 Nov 2026 15:56:09 +0100
Message-ID: <20261118150221.391947737@linuxfoundation.org>
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

[ Upstream commit 9f1b48c658ac38be81c04fbc29ed1522f89fb0c9 ]

Check the return values of clock enable functions and propagate
errors to the caller.

Disable previously enabled clocks on failure to match the
main clock disable sequence.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 23 +++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 57c72f8407720..2b944ff08621d 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -725,14 +725,31 @@ static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
 
 int mt8195_afe_enable_main_clock(struct mtk_base_afe *afe)
 {
-	mt8195_afe_enable_timing_sys(afe);
+	int ret;
+
+	ret = mt8195_afe_enable_timing_sys(afe);
+	if (ret)
+		return ret;
 
 	mt8195_afe_enable_afe_on(afe);
 
-	mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL1);
-	mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL2);
+	ret = mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL1);
+	if (ret)
+		goto err_disable_afe_on;
+
+	ret = mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL2);
+	if (ret)
+		goto err_disable_apll1_tuner;
 
 	return 0;
+
+err_disable_apll1_tuner:
+	mt8195_afe_disable_apll_tuner(afe, MT8195_AUD_PLL1);
+err_disable_afe_on:
+	mt8195_afe_disable_afe_on(afe);
+	mt8195_afe_disable_timing_sys(afe);
+
+	return ret;
 }
 
 int mt8195_afe_disable_main_clock(struct mtk_base_afe *afe)
-- 
2.53.0



