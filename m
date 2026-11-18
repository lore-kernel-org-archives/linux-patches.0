Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049983;
	b=4ppMBQ0+KyQ12Ahyu4JkGJL/655WVWPldCqME6lJyW57zO9b15ptM6ojEeVLUiy8fQ4Y
	 YQMWxmiekcRi50SZHtwJ4HlnQF3m9mppEfORvlu6ERVfv+uLD8bvD4MfkkR8WN5WoizcA
	 h6fQK70F9FD5M4ReZmtYv1x16sVViEb1BZThuvdeODm9jEcc6kCB0fo6oztmePpyIsWnE
	 d3T4fI1/oI4hJVy0QAiONS4b5f+3VIgLGvbCFA2eTD9A2RDyrvLDnyji+P+6Ktuj+V9yr
	 Yg26D/xsN/56tNNCweFK3R1UpPnC5uqTwtXcw0mI4gt1pNLWlGo4e89BiCOxwHmVc6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DXWHv9dm3AS2KHKncP1I4zCKgRHtgmqCSl3GPM0PNUQ=;
	b=XZOQ2EbBa3HDHjN1vLttqNl2o0IEeVJ1bVq3HMi3d9VgbjLY3hIMNBP1Xb3RdhSwI4XA
	 XvUeJsFPNlu/b+6FYwOh4NqjapAlyHSbC2aT+Y8uc6a2kdPU5AN6mmDBnzW8AP6/hp1G5
	 CWDzfa0630n+yCEFgOMGu15Ew02FKk34lFhlxfu4ZYTV0JZ/IdznAxdV3GBApXHKTk51L
	 9LDtXTpcxXhlX4uwMGAINZ9uYc4FQTLL4D7+rlqL7+0MeuOQv6X6HvUBsBPwXL9toV+pX
	 UNFFcO8sYeR+eIcWiS35kwDc4XGz3PfR3iyzdWWy1iJx5M3HnCNv4c5fjlrplwBX+7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwmG5jir;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2243F606A320;
	Thu, 19 Nov 2026 00:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PwmG5jir
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7B01F000C4;
	Thu, 19 Nov 2026 00:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049983;
	bh=DXWHv9dm3AS2KHKncP1I4zCKgRHtgmqCSl3GPM0PNUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PwmG5jiruo9FWsoHEM/46P8kkRX1VTshqzOxjDMAqphuGxYD5tJLdGuhuqFG2BCdQ
	 Hnlltfnt6AcQWUfBPkTaWa6mqp0OYFwoo4SX3PZWMbVpbA3QJlPmRkowUCQ4Du+wID
	 2ilYEhaT35jZRCN3zBUnmMtvz3JOvFpndIYrMNT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2547/2857] ASoC: mediatek: mt8195: Fix timing system clock error handling
Date: Wed, 18 Nov 2026 15:59:41 +0100
Message-ID: <20261118150333.224494162@linuxfoundation.org>
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

[ Upstream commit f18c0a8e528eb8844ee362324220ab8df3664afe ]

Check the return value of mt8195_afe_enable_clk() when enabling the
timing system clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller. In
mt8195_afe_enable_main_clock(), return the error instead of continuing
with AFE clock enable.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 9940e95b1dcd3..57c72f8407720 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -671,7 +671,7 @@ static int mt8195_afe_disable_afe_on(struct mtk_base_afe *afe)
 static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A2SYS,
@@ -682,13 +682,22 @@ static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 		MT8195_TOP_CG_26M_TIMING,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(cg_array); i++)
 		mt8195_afe_enable_top_cg(afe, cg_array[i]);
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
-- 
2.53.0



