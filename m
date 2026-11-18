Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029198;
	b=qhth9TeHToKIYP/COaaa+7jZZc5hn2d1x4cIQmsTCretdo5/4vDqV2snEh5RMrN0rXoM
	 YhKGhJAh5I/BOpXORStRmqWWa0LwQAA0iqCpGyXoe4Ok2vtYyfPfnSFLpKFeqyacGnph+
	 WdovwKvr/qEBFQi4F0MhSs9L+o4fhCVJzrbPY6SbZ8oHivr1zQAxyLqGQaNKUOFwrGxw6
	 mHx3YsW69o4MYoRrBIiAK5K1VnNk2VWBUxjRcP+CdMI8V2L8wsagUPXFHYCHUofHZggA4
	 EDDjRpz5lzVvN/n/uJa39NbzX4ZWBhz5br60jSKYT1UFnpR22rx1H4xyjMxywPbvHnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ih9DlxAJ3MSTCda0HY9EnFXcAkOTFQ4kh9QT4r34usA=;
	b=TEqiKPDNeOb8m8LigEQRyQEBgtufuMF2MdjAzPkIrMxSk85EFYfQlkUmZqan/q1N0DF8
	 hQJ9ruoSAyEZ7FWR1e4X9fzedA5IFH+y7ssa3RIf+IZnQnGb0il5X5n30dOi1JAABVkSY
	 6siNn1FU+s4Es4g7CB/kCgVpVUG9rTpq+x4yiQ5YrFis322wD08fFB9R0JogVX15w2RP1
	 oEIIku8zy7PNRGs8wwIDsvvefzwItN1Qy5HS5U0CR9TfwpYw7hWwEpUAH1ymhWe8JwYkU
	 2lyA/h0T77fodhDqsmXSUGlV9i9I5oT12NXPCzUIV56DPqxcXeAI6gdwxeWtapyWrig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bXn2s/rK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D269606A31C;
	Wed, 18 Nov 2026 19:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bXn2s/rK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F731F000C4;
	Wed, 18 Nov 2026 19:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029198;
	bh=Ih9DlxAJ3MSTCda0HY9EnFXcAkOTFQ4kh9QT4r34usA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXn2s/rKGmCnse/F84gpxNbCEQOF21VHsO/jioyF3rl3YkcAU5U3zClEk3+NX1XJH
	 MKgD8V9Z+rb6kZbnj+n6CR2z4vQuXh3Bf0Y7ajolCtSGZ28MiLunjLWWuTZEY+P5t/
	 +Va8imYZtkgjUt94XRrCpGA2TPa5c1fNWCqHIFVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0262/1756] ASoC: mediatek: mt8186: Fix MCK error handling
Date: Wed, 18 Nov 2026 15:39:49 +0100
Message-ID: <20261118150018.788170963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 996469c1092e8fa81fac98d819174ce56baff821 ]

The mt8186_mck_enable() function returns immediately when a clock
operation fails, leaving previously enabled clocks active.

Add error paths to disable previously enabled clocks before returning
the error.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index a54fff16ffa4d..ead467d027c33 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -575,7 +575,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 		if (ret) {
 			dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[m_sel_id], ret);
-			return ret;
+			goto ERR_ENABLE_MCLK;
 		}
 		ret = clk_set_parent(afe_priv->clk[m_sel_id],
 				     afe_priv->clk[apll_clk_id]);
@@ -583,7 +583,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto ERR_SELECT_MCLK;
 		}
 	}
 
@@ -592,16 +592,25 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[div_clk_id], ret);
-		return ret;
+		goto ERR_ENABLE_MCLK_DIV;
 	}
 	ret = clk_set_rate(afe_priv->clk[div_clk_id], rate);
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_set_rate %s, rate %d, fail %d\n",
 			__func__, aud_clks[div_clk_id], rate, ret);
-		return ret;
+		goto ERR_SET_MCLK_RATE;
 	}
 
 	return 0;
+
+ERR_SET_MCLK_RATE:
+	clk_disable_unprepare(afe_priv->clk[div_clk_id]);
+ERR_ENABLE_MCLK_DIV:
+ERR_SELECT_MCLK:
+	if (m_sel_id >= 0)
+		clk_disable_unprepare(afe_priv->clk[m_sel_id]);
+ERR_ENABLE_MCLK:
+	return ret;
 }
 
 void mt8186_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



