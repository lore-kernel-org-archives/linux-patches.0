Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040343;
	b=ntRCRW58mjgWgeaQLvs8WyaJ5wvThfgaUA/cFpto/7K3aZDrU6vfGWIVAyCMSMv/IdaA
	 SbJ5FF7X/OEO7WNgxMn8P1E3rlQsW7qy3bMr8BK5jvNSXO0ecvopxVhcxVKi229LaDhYm
	 GXXWFQKwG0wc40gcavj7aBWv+/MeSIjxinsMl3caVJdaGqM5oGTRzjsg22pQigtiEnK3f
	 1iDmbN6yeGBruSskNKf7Nm/uy1Hn+Hkapi7XTYInicNqNU8jf73X37LsIy8R2MHABYYFb
	 VumiP3LMVRarkMyi8sgOuFB6ic6NPH/y6HXfc9cu2a71t5YsdOxd2lFda9O8Tb1BWgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V38TyJuGD545MyNSFZZT4EQJ+ijZD7v/t5AWwG+5zic=;
	b=iCmAuf9/XW1LCozXze1qn6nrvRdbr13cpXmdtbSOSefjudAHTZ0GlAaU+SLslcvmWbCq
	 mqdsS8j7yyQEQIHxyutAPppEdhzcPu30o7MkCxFP6VQRBheHDPobxsx3WxFDwot4gjHy9
	 Divd9FXN5mZa/tUG72sUnawA6UYtc4w29RLSGfyKVq+VlgclwpJcdqWS42O1xIG+s/l/9
	 No0BBdnSSmW+j9AuePVa8zB/m8Cyoc7zuHPYkaRulkDFLYrd+GTosMaKKaCyKS8+tx1hD
	 9zX66G3p0im9U3GuH+rFB7sUm5vKmzgdV/NQeibHU1DTLxQgtJ+kMw5StprZCybO6GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLGNWGsL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0C8606A320;
	Wed, 18 Nov 2026 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uLGNWGsL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CB61F000C5;
	Wed, 18 Nov 2026 22:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040343;
	bh=V38TyJuGD545MyNSFZZT4EQJ+ijZD7v/t5AWwG+5zic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uLGNWGsLM5IavchhYuSqzcWKoCnqAh6LVoFZn9GYgbuFnkIIPQYNKbXemcVUyZdhv
	 ldYrFGcSicdUYMckz+3Q2O0eOUlCDEs1CwqPITnEPU/laIRZCbkJtMVT0KgCEKE8NZ
	 Rfpe+YUfrqmEyCnvhsdZHIT+lAjhbjk1WYcEgmUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2423/3318] ASoC: mediatek: mt8192: fix MCK clock error handling
Date: Wed, 18 Nov 2026 15:50:45 +0100
Message-ID: <20261118150434.159666089@linuxfoundation.org>
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

[ Upstream commit 4a0ab266cb1594f8c6aef3c79726476ad99618c5 ]

If an error occurs after enabling 'm_sel_id' or 'div_clk_id' in
mt8192_mck_enable(), the function returns directly without disabling
the previously enabled clocks, leading to a resource leak.

Fix this by jumping to proper cleanup labels to unwind enabled clocks on
failure paths.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 118dd48196828..77f596cab92da 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -619,7 +619,7 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto err_disable_m_sel;
 		}
 	}
 
@@ -628,17 +628,25 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[div_clk_id], ret);
-		return ret;
+		goto err_disable_m_sel;
 	}
 	ret = clk_set_rate(afe_priv->clk[div_clk_id], rate);
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_set_rate %s, rate %d, fail %d\n",
 			__func__, aud_clks[div_clk_id],
 			rate, ret);
-		return ret;
+		goto err_disable_div_clk;
 	}
 
 	return 0;
+
+err_disable_div_clk:
+	clk_disable_unprepare(afe_priv->clk[div_clk_id]);
+err_disable_m_sel:
+	if (m_sel_id >= 0)
+		clk_disable_unprepare(afe_priv->clk[m_sel_id]);
+
+	return ret;
 }
 
 void mt8192_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



