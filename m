Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024389;
	b=uU2w16/yfo3SXP9MwYEU+CbEJNngEEdieXPiMGrH3gsUyFEicYXzSAWorUl0W39fnn2O
	 3eiYW0ae4DAxluzMtVAw53n/wXuHcnxdIC/+O2YSG9/2LKa/n9xycZw1Eg9DSoCwx/zie
	 0T/ExJIO++GSR9SEvMV35BeH2LfTpkFnYqtZAF7lVTLNIvcrfiAYFRppo6mOhUh0nG62h
	 2PhCkadA5WFuM8EywKRteC/3gs+PD3cylXJHbDwzCK4qrBbGa8kx18kpcmTl2C+GJiRP+
	 rwhvAVnWA74ngLFCFGd1nkmYnUf5eyU+SuzLUNHuZjhlb/60w7JSQyiA/tLiDXrGKSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=siSNmvLpECpNkZ7TGRwxC9JWN7hRPpvNWEw9GP3rlEo=;
	b=ZfqwjlFfW9ZXAxMLdFl2F3pGt90equcJXopvFeh0SBp3rK+2XPQ0fT7KLMPK+zCtm6Cc
	 N89IqWFodmPfWCUEvxDFF2/5Ja9xCZdoWen3CFH0UJ1mhzMevB9v/41tsX2kpRzsqxs5z
	 d+MCaHsvM8RXUQoaNvow+TA/xgOcvUK8BVkfsmHxUBPKPun+hZ4MOvK9qdX/BxcMrGV09
	 sU5Zwt2ZNwgq/NNjVhZZWxWVBwehryq82b45IZe9qwUbNna10j0NLOXaG+/NRqxk9dTyN
	 xQ9h2a9ES1VaAubyU1LalG/QraMoW08OFmarDy+RV85sygN9aci94WaQp3m742Jodzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pva3778a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69672606A325;
	Wed, 18 Nov 2026 17:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pva3778a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF001F000C5;
	Wed, 18 Nov 2026 17:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024389;
	bh=siSNmvLpECpNkZ7TGRwxC9JWN7hRPpvNWEw9GP3rlEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pva3778aHeMpl9+IWmnd8YWvQVZ987IVVtptUaVVN5hWjIqKvGbqwmNZ8kYNhOrdG
	 8RcoIYZtICEpCpX1tpONlSXQrrLW9DdowIfUFVOhNEJO+MtBwHGUDNQBRiL1URHJt4
	 cvmSyj3OVXVklotqW9HF3hUZgS2VjuL0YVRrHVGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0709/2151] ASoC: mediatek: mt8188: mt8188-afe-clk: Handle tuner clock enable errors
Date: Wed, 18 Nov 2026 15:40:44 +0100
Message-ID: <20261118150147.705297680@linuxfoundation.org>
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

[ Upstream commit a2c3ee3349a7da91e563b9a21a355a28fa754bc7 ]

Clock enable errors are currently ignored when enabling the APLL
and tuner clocks.
Check the return values and roll back the APLL clock if the tuner
clock fails to enable.

Fixes: f6b026479b13 ("ASoC: mediatek: mt8188: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
index 7f411b8577823..b41069b752a94 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -260,15 +260,28 @@ static int mt8188_afe_enable_tuner_clk(struct mtk_base_afe *afe,
 				       unsigned int id)
 {
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
+	int ret;
 
 	switch (id) {
 	case MT8188_AUD_PLL1:
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL1_TUNER]);
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
+		if (ret)
+			return ret;
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL1_TUNER]);
+		if (ret) {
+			mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL]);
+			return ret;
+		}
 		break;
 	case MT8188_AUD_PLL2:
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
-		mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2_TUNER]);
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
+		if (ret)
+			return ret;
+		ret = mt8188_afe_enable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2_TUNER]);
+		if (ret) {
+			mt8188_afe_disable_clk(afe, afe_priv->clk[MT8188_CLK_AUD_APLL2]);
+			return ret;
+		}
 		break;
 	default:
 		return -EINVAL;
-- 
2.53.0



