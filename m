Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041827;
	b=jIvvONR9OpWw9sUIoT6sgf+iy3ED+9BkyaengB40LYJOlLfQQHtJ+Esce/bOBJafMHmD
	 PtwOC9YR51d2mQ+Csb/DJ0BS88YODgUqSjctv30fWtCB6WRJt1Ltrn5ZgcT5WCA9qAe//
	 k1oqt4ApStidNXl5ZRTsj0dYVQh/xxfMbjmdZ0uYgzpRSG1bkM7xnXv5toLW+Hi+I8zaY
	 Owa70PRrvP1lKnutN0fXkgi4krGKJI7yocHyq+hp4Yo3KgbXbNIyeUJo7g/FxteLMOGDZ
	 AS6RO15RtCV1dRhE/oZeB7y4jQWc6AbLwUo4pdv+utF04ke8zYdl2epy0FuFwqrpVpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QoKO33kxRmBrH0Fd3fHoRID9E+GOwxv1Ve/+LOR/Yo4=;
	b=ABTWgAyE2a+0V69Ly9Hm1cjqoajZScY2GR/SCGf98Uj5TTWdHlsnev53I5+d6p1ZuWyk
	 Ty7zVAP6TPb+35jTTNHuxKMDoz54L3JRajn7F1sUj10TwOwf3h51q+81o0H249WYa9FjU
	 JnNEuGLilQd7Elnmn6I9Fe9nC8Vzsp89a6QmhEvnjk7S3eq1spEfUm5LmsAha5YmkWSDD
	 ksDQUEGxCU4Znbld0nqv29oOqbjMo1vLKpmozElEaafzgnG9XAZQFLLly75SPafnSfL1Y
	 7XIdwVM0ADC6/aPcUFiq6ulmVib2CPwaSSRYNhVB74Aaufqcnqz7BiRxaZwMMvxAzvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y9gv5mhH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13E7606A32F;
	Wed, 18 Nov 2026 22:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y9gv5mhH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE921F000C4;
	Wed, 18 Nov 2026 22:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041826;
	bh=QoKO33kxRmBrH0Fd3fHoRID9E+GOwxv1Ve/+LOR/Yo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9gv5mhH9FFpw4XlvyDWgiW3C9Oj6Vc8ztDmHiTqN+qjinifgNwZcvUKWkPBVUnCg
	 lE9iXWCCoyxJNXxte9derGSUQKVKV025XLTa+6THxFociu6pjYUL7DKUpPB1Q5WQFO
	 C82qVAOiiDghH45OZ6OrDoaH9iUXvjIhutcQylKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2953/3318] ASoC: mediatek: mt8195: Fix main clock error handling
Date: Wed, 18 Nov 2026 15:59:35 +0100
Message-ID: <20261118150448.903337768@linuxfoundation.org>
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



