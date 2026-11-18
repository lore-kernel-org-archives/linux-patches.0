Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041821;
	b=Yuyce3qXgSpwmv5D27jLe2AV2yoSKmOJnagOzSxlQllYh6ZjKHr9g8G2kjzaRC/B+OgR
	 oJzr18WtFwYaHyZ3ETPLzxDV5XjgkwFh24Kbl4iC7cnqHWLtwvry8KTLDMUvUZfOXOwF7
	 RbwZpo9NXuMxMPVg2yQrmqD8Z5TuCEpp+0Zz3XuekXGnslRE7Jxkahts2VUivTAbQTz49
	 cQ77kVh9O/NxVM5+ixH4grMvr73QOFjVzSUuhD1ivvEJz8ooJPjvqyGFV9nBeuUUJVd9k
	 aa2eD+HfRGpRiMr4HJoA1JLRaWEq9l8SiKMqs8/ej0xYWYl3rMh5vS3k192yyhaUNZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041821;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JiV9fM3wNcbSTeJAcfMyMGgJUFwKXCi/CNz+cRrGoF8=;
	b=E59rQYNeXfvC2UeZWU4SnfBHnm8izuX6Xk5TA6mvlxSmgxqJE4+jrebZ2ZEeF9SGbuTQ
	 R78zUKxVYH0FaB4aVtGl7sEu8cLYPSAid55ICmCWyrhzBWMjfXB7a0vEBjwmstC7e51is
	 IElMDiGJ4WxZMtwvbvnkaYq5bKJa1tB7aFZp1vjAChEb8lPAfqMrBDZOpf4MFF3rmkC6V
	 rwaMYtHpvGNHF8jLs8kd1zacvO/T5hzcPaRb3+Vr+ZOMxCkePSy7a+hKuctGGUtPPMO2W
	 zlWTPoTpGzA2JiU7o9G5BgjhDj5usWHvAmbq19y2yfz2h2d14qFB+KKtKDjBUZbmKRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6zZ2Ypk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB63606A31C;
	Wed, 18 Nov 2026 22:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N6zZ2Ypk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF481F000C6;
	Wed, 18 Nov 2026 22:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041821;
	bh=JiV9fM3wNcbSTeJAcfMyMGgJUFwKXCi/CNz+cRrGoF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N6zZ2YpkBvw4Oii2swuqJv7iTNxobXwFr7g+TG8euJSwyI2XAAocm+4baLTN/3nL0
	 5wHw8WsXu4ncRYxLY7LBuvlyVhlo5QRM8xLZFIp3czao8IXZmlmv526ex9fpxP0kOm
	 lM0Rc2mMR3zA/9ND+Yl4NER3DLbXj6GgNj1j4HKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2951/3318] ASoC: mediatek: mt8195: Fix register access clock error handling
Date: Wed, 18 Nov 2026 15:59:33 +0100
Message-ID: <20261118150448.850997072@linuxfoundation.org>
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

[ Upstream commit c23390ecf5c068976f25d9c8bfa8e298fa12ea3d ]

Check the return value of mt8195_afe_enable_clk() when enabling the
register access clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 5d4ba88ceaef1..9940e95b1dcd3 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -608,7 +608,7 @@ static int mt8195_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
 int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_SCP_ADSP_AUDIODSP, /* bus clock for infra */
 		MT8195_CLK_TOP_AUDIO_H_SEL, /* clock for ADSP bus */
@@ -620,10 +620,19 @@ int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 		MT8195_CLK_AUD_A1SYS, /* AFE HW clock */
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 int mt8195_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
-- 
2.53.0



