Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023198;
	b=KCFFb6UXSEMba6VupWQTts7KvDb1nTf2tx0uUMbJokm0I3MiRZiKr+2V3d3scBNUMPi3
	 HX1XyhNeRW4yCBqQcCQpymbbyvMo65BoF6wXfdyd/oq2NdjPuhXWKhrjCUpXArF/Li9wn
	 Tfj7vT9qTPI26rnNWPlc4c/5QJOSbTvSzqzeCQOA/LbN6dNmHYFnxZ595bMEV1RRXSqGk
	 EPZabWxn8jiQpf/eHpdvmAE/8xJvnnpMQM/ui1fU5AWW0PhavGZf7kfWpYE/eQG4DykiD
	 vIg2nCd+ZTUoTh3CJcmjfsM2kB/mu/JAY0QP+uY5m3UfeNTUeUDswAROQiNUsGhPrng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3cwJVUJERY0bqS8fdFZISa621m6FuDizlzp32X/0Qxk=;
	b=CVGDMNK/BGOJHMEsEu2k357dFVdw4gR3ggwv/91L5uMSvBUYpwZviX9mSa1sTDnWSxqX
	 i207VMGuJHhcV3FPxPdWo1rK9QbAm3rXKFqXB0m/uju/LZCr9RLD5ECy9scWqiYUTx1XR
	 8Zhs16CzP+21YZWWtRmeqt6O8j6q8hSPAGQ0iLRv61zP/3o5dE1EB/2h2TsGuyCQD84ZC
	 tIZieQ/0GiD2hEcPwGdTXAr0fxi1j48B+zNSptZ6766c8gqm5TBufzb1Ndu2AMlkG5p+s
	 UeZeam99Vt1acVGVM2Og2d05l5YmoGzSVTx4cUMoXksv+uQkyyEP73sztGr2iuWxWdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jY9zQRgl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A55606A32C;
	Wed, 18 Nov 2026 17:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jY9zQRgl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44E81F000C7;
	Wed, 18 Nov 2026 17:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023198;
	bh=3cwJVUJERY0bqS8fdFZISa621m6FuDizlzp32X/0Qxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jY9zQRgln5HG2aMBLpeZXjkB6RZCONpxdtwZRdmAX834I0wCJIQot45uakc199wi7
	 TtVtrOgWxS6vytmq+QffuYxHvfjqCUhXkUaVP+8ftMphS4fXckr8M8BZDaLSZ+2Zul
	 dW+g8+E5+edE+F8fqVRhTADG97vtH4w9SpGdqRHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0282/2151] ASoC: mediatek: mt8186: Fix MCK error handling
Date: Wed, 18 Nov 2026 15:33:37 +0100
Message-ID: <20261118150132.166389625@linuxfoundation.org>
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
index 77a0cbc8ee241..62b008b7caca2 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -520,7 +520,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 		if (ret) {
 			dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[m_sel_id], ret);
-			return ret;
+			goto ERR_ENABLE_MCLK;
 		}
 		ret = clk_set_parent(afe_priv->clk[m_sel_id],
 				     afe_priv->clk[apll_clk_id]);
@@ -528,7 +528,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto ERR_SELECT_MCLK;
 		}
 	}
 
@@ -537,16 +537,25 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
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



