Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056438;
	b=XUzKn8L7A+Av8KrAN4koiRqZm/tHL17l60GPHIc2xhmml5gKy39uXyo8Y+SgaQ52d8Do
	 k/N5prrKH7OhyVtW59kwtsh1HnE9qWxMSk/NivQJBvkAwKRmuckZKH3ILCjS8zoKCXz3k
	 NtIBP/Pzqsgb6GKwBG84qsm7AkZF+atwkVQvENelcp2D45rAMw5bq8YBFD4wGAvmwahvF
	 pVrEhigqyZeXhLKtWYblwHzrS2fVCyjagrlbbndIvDR8+VbJfvpc34vPGYJcAkl004gRW
	 YL4c8ZgfYLRKxUlmviGhy3pQb9gw/Sxf1I2Y0lM1viT2xkaEgUtROTCFjKns4ZsS/YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P1Uw6T1K567CbhlgYV2naWDw0E5OS8aweb+OR/BA6UI=;
	b=MlaKP93G8UIsQXEpS/jpnQxWGILKtiuL9VpYm/etIysm3Y3nrHgvf/BnTHvHVP/ZUzIV
	 EdqZFG1Gpcwqawq0dbqV46MGod2A5yYbl/vuCk9Hxzj6FwIAtJ7IJmiqkVQi5S/YiHvk6
	 s+/Pl2NFur72gYnAP95/rNc4OEzanMqQBVg+9oMoX89GGYUEQYewZeBLuQWt265ENzU8E
	 9v8B8vkRfZKqj9AaASSK50HQWwVYjJE6kVxkiI8jullvojqlYLDtBbncUGp8nbcpihO3O
	 dEiYdK73WmYmDz3mWY7ugsZOoazl6846vXpjebIVqgWTsIgM6pyDitjPnU7A0CL+5xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TUhVYX1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FE5606A31C;
	Thu, 19 Nov 2026 02:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TUhVYX1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B231F000C4;
	Thu, 19 Nov 2026 02:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056438;
	bh=P1Uw6T1K567CbhlgYV2naWDw0E5OS8aweb+OR/BA6UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUhVYX1yPmM4m2UAwzBCBqapv9IVZMo44+PmUAQ02WfDnttXpdgWwyfe0PkO41R4R
	 73CF7Zm9jd5DG18O42Y+267EKNn8FPvFJX5CWVUHGJygyAfnCa1IST0OorxNwlgxPr
	 z0Y7TsydlZVKoKFleO2VDNBnQDbpIwUt4kv3py9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1986/2214] ASoC: mediatek: mt8195: Fix main clock error handling
Date: Wed, 18 Nov 2026 16:01:02 +0100
Message-ID: <20261118150130.295043182@linuxfoundation.org>
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
index e7f0b61e0f7fd..ab638a995729e 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -711,14 +711,31 @@ static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
 
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



