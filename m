Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057092;
	b=cQmxzZuocpwEXErIm/qnW9DmlYA+EZ5/L/piklORfuMC7q+7dWWebBchty7+5FeUuItP
	 kFdRFh+bkTQCxpicc5k7WTS7jG0H2C59bpR8+CCJRIuLSWB+JdgQN5hXvsjKR+zapLlSz
	 F8X2B4rAZnyxkJq/9i29gXPw+Iahzk/JoS6ZoNjdnVapvLAKjs0VcZF5FKZln20pEy8o8
	 KwTJdQ+H3CvvP4rUjWf0mMjx5LIcmlgf+tJmIneDQY3rSFrWHVPyrkosTdu2f2wRbZNLI
	 E4Td/1RWQ1tKjcc+rMepLz2rl04pNNn2S4qlKNJAq9oQCcpQZRRuJ5Xt8S7+M8MjGyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=usBY6LUtLnuhRMWjkua2Tozorjwhryzpn98wEiWEpvU=;
	b=wy1tJ1kxQmE4xj61pnpjgGEHZTyEUGU9t8LMw993ugCQSW1GXVC44+bskLjtZhC840i9
	 bzaM2ZnwDBFxJ/NwKEUMGfy7XkFuhdmLMpCqLLji7AeUWSHdN36/Epji0agAMWLzcJc5c
	 JJdksGvKHtI7XWlfsAscYZDtL/jK1vakO6Zr9/HCY2ZX2u+zA3OOGrB/nQuA3E6ewl8xY
	 vmN4otFfiX7VI6kyKnpSQzp3xCIIcp0neW3GsVjM5baMKUtwER/+SWuuZN9uojoIh/M+k
	 z/1ws0ubKYxtgnWr/mR3VhL/naYxdgvLasxA0cMGGaKR16nRrr7M3KaaJYH5y5DNEXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gY83XpQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2631606A325;
	Thu, 19 Nov 2026 02:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gY83XpQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017751F000C4;
	Thu, 19 Nov 2026 02:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057092;
	bh=usBY6LUtLnuhRMWjkua2Tozorjwhryzpn98wEiWEpvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gY83XpQSCRPfLCPsjga05uOxCkMsqf7ASBzLxNrUxRTikZVsGF24olfRzkgzm4M9
	 /X46MHMuFPvvXMBYcDhZYcB7goIUG3Q3Us/JGL/TQ9Fgp6+KqdW5nvVD1bN16GLaYT
	 N3rKbKiVj7sZK5mXj/JL+nKWsP0tt++y+Q3iHht8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 2214/2214] ASoC: mediatek: mt8195: Fix tuner clock error handling
Date: Wed, 18 Nov 2026 16:04:50 +0100
Message-ID: <20261118150138.800763550@linuxfoundation.org>
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

commit 8e5a2eabb0d7cbd6db0b94f7f30e1ca2c0a8994f upstream.

Check and propagate errors from mt8195_afe_enable_clk(). If enabling
the tuner clock fails, disable the previously enabled APLL clock.

Fixes: ff5a90173d98 ("ASoC: mediatek: mt8195: enable apll tuner")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -241,21 +241,35 @@ static int mt8195_afe_enable_tuner_clk(s
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


