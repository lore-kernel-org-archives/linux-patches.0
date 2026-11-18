Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049985;
	b=0Whal14rqhB7X5k3ls3Ag9KG4TQtoPeusFqklB1B/Op5P6Eftx4+t9/1z8t9IxesuG7F
	 xlLzAKoeR/lMrfUrifcXgzzuI5Q77XIQHjdy5b+JL8lTtwFTRBwPy3OCJLHVZQ2wI5k7+
	 s+g4+0tSGbIT8jYUkXdmqF30ybkOGaxyMm+CwfaG0M6thHlB56LUWm+Cc58ur3E3DBEPS
	 EHeCsS3v8eoG7O7ZTorTZreQbqdyi3MXvs2xixCAmMm5lMTmzfvsq7b5x4UteF5FYKfdM
	 bK1DHJQA05VFL6KjXyRG77zItYMjlU0Fri6gXTmmE9gjb3IPOFrnuHmDqoEM5rPYUkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MTfO08XlKfrFg+wJoBizEtCT4Hia3U0HchTDG96vsDs=;
	b=MH0Aujh1FyEkBCYk/gJ/LmTZBdyDmJ/oxJF2OO79orYgcMJRV+4mlcIkO0WUM22FOqkj
	 Zu88FEBPUhEwRDOJViv+ZrAFpAknmDvgkOU5HsNsUT3B+zAYGk1TF9OTdtS31UJsiLhoH
	 vrka/G8FvsOzITxR6heNYGX/uRN+EyqY8Kt5t6IPpaeXxJ21n9G1gq34na9JyEIJOJ+5x
	 YQDYoV6Z4eXM2kwb3buU20N9Actq9WHIV0Y9b/c5mnQK8Ye4O+NS4PJ4E/dcezQyZGmuj
	 udyjmzYwYEa58RSeBDclTCAp3idyddaH6jrTdNKFyPEbHJ9jxOP3/SFtvR7Oriq3xtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rw1VPtun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8217606A320;
	Thu, 19 Nov 2026 00:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rw1VPtun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F7E1F000C4;
	Thu, 19 Nov 2026 00:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049985;
	bh=MTfO08XlKfrFg+wJoBizEtCT4Hia3U0HchTDG96vsDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rw1VPtunPaocpPc0L+xZXxUayVZ7XZaesPnZ1q+Ve29rAy51R+npUCnyTkvlFGUIl
	 PmbBTtMAqm5UsfNoUTyUxR+yf5vAq3W5Vb2KKOWAuWeh+wn0APOzSAYqMmFC+dc2Wl
	 8CWeHoRLJS5LUzYdnEMktnNuDWvufmuxK9ka5IvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2548/2857] ASoC: mediatek: mt8195: Fix main clock error handling
Date: Wed, 18 Nov 2026 15:59:42 +0100
Message-ID: <20261118150333.262312604@linuxfoundation.org>
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



