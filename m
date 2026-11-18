Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049977;
	b=FWLNBkS6I+v06Us7dyqiPCP1nRo0XoZbJIpCqXXsZdVlX84i01hMaGNi3+x2ui5TAzES
	 H/2mjz1dE+D9QPueRvOM6DiwuMFW+2Fzwi9HMRold/ok5mBtFPvnD/+uRwPI4CE/ikgvw
	 AXHv72DOa51f18oTDvSZmHp+ZyU3gmpgK0iYkdFRjlqzEUstjyWTRjfMcHk8LP5x3tr0Q
	 PA88VVbtQN5cf3s+m/sCjbZF6S07PUfqAn5ze/HujzjQG+iNbZAY0kbITUDw+Y7PPsMAD
	 tvlbMSrx7tug58qHlzw2IhSUtqG5FOUCdldCY71zbJ5wVORX7bx7oOUaPtHQWTXFbZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CVBegO4CY9iKPcfwpWw6h83uIc+hOj0jNefzP9XCfnE=;
	b=MXpZqxViV07lGi8lTgTAC95Pj9dfqZHga/ArMRUS6Sh5crOy1UpPxjHh1+yAYluJwCz9
	 FC9BMh/NQotxkRybiYBbadPvjwcDHmxHOAoOA/dBb/xkCvh77FEHViGnYCShVkorp2tUS
	 EEbXysySp4lpCzyVQq63ZJqHNQRJ2pjcn59E8juwjDacztX/G1Hrtza3XwwGfj/tQQKO+
	 gfn+gs51do5UD7l/RDookKhI1+DSXq5JRzXT2SV28xgJEoaxo8ZQiQnE9qnYxo4Cx5aBa
	 aMtvYdx0oV6OE5WBPoCR7nzS1ViCM0RHLQAvrUrCDwOnyU1fHxeQ+a9I/cXXSWflfIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5yRp8Ov;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC96606A320;
	Thu, 19 Nov 2026 00:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v5yRp8Ov
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074C01F000C4;
	Thu, 19 Nov 2026 00:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049977;
	bh=CVBegO4CY9iKPcfwpWw6h83uIc+hOj0jNefzP9XCfnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5yRp8OvngdR6LtVyxPnFgrrqeYJj0ORvbQ6DbMZRWTbKeTcsXhY1t77PXVnYJbJn
	 j0ViF+TEk+SWNMLx3JJaq0itATwITeoCmLf9Bp1YaDU7frlXyb33IUYvI8xyYPhK97
	 6SjPxsEabckGFPDZfSi+Ab+JOHtpvcXjml14TbCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2545/2857] ASoC: mediatek: mt8195: Fix tuner clock error handling
Date: Wed, 18 Nov 2026 15:59:39 +0100
Message-ID: <20261118150333.149402444@linuxfoundation.org>
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

[ Upstream commit 8e5a2eabb0d7cbd6db0b94f7f30e1ca2c0a8994f ]

Check and propagate errors from mt8195_afe_enable_clk(). If enabling
the tuner clock fails, disable the previously enabled APLL clock.

Fixes: ff5a90173d98 ("ASoC: mediatek: mt8195: enable apll tuner")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 24 +++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index f35318ae07392..5d4ba88ceaef1 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -241,21 +241,35 @@ static int mt8195_afe_enable_tuner_clk(struct mtk_base_afe *afe,
 				       unsigned int id)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	switch (id) {
 	case MT8195_AUD_PLL1:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL1_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL]);
+			return ret;
+		}
 		break;
 	case MT8195_AUD_PLL2:
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
-		mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+		if (ret)
+			return ret;
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2_TUNER]);
+		if (ret) {
+			mt8195_afe_disable_clk(afe, afe_priv->clk[MT8195_CLK_AUD_APLL2]);
+			return ret;
+		}
 		break;
 	default:
+		ret = 0;
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mt8195_afe_disable_tuner_clk(struct mtk_base_afe *afe,
-- 
2.53.0



