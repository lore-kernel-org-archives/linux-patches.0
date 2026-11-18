Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030387;
	b=vlW9dr67aLVouMnCqQ/P/3HnPtF4Y3JmwiBIMRs7RNjE6GwXpYWJ/dc1Q47Gw8LAOGzF
	 ywnCfI7tyxMLeWhjrc8tEvT+gMiwWn6lUPPsDvLV0cavHCrrdFYWWvhDBL2L5E54iLZQV
	 Z8/lFAf/9GgNizPpheMlMH82jgAg6gWCL/TEbEe/0d5FjlsLXb5x+rzmr8eJtVAl4RSow
	 TYkq/gH1v0goNgvDoDWoqJGdJla4k+Ky3ZQiNf6ZyOxJxTLHvQrwTC6oYZzbVCinWUo5R
	 qdZb87DsDdIZAJwpEgi9NmVrPgYrLKJtwAQP/Y3XAbbrPizgzEaf7a4qvDh22gA0gKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BcYZ3K1DaKpEhcg2/DkaPdPDV6tXQ4qxbwXO+06/SzU=;
	b=sV0KnLICJg87WxVWicnOKV+fAJfuDRNmWvAjpDRnwxu4GxIzo21y/KeBACpU39u5j3ri
	 rXdoiuYsb4EfEbTfa+vV10px+j2Cqo6HAkfVbO40+9MW3Ob2ICskfk3TahhhcMmagMuCE
	 of/bn0xffVgk694L9/GC0AtZZs96laMCgcjpvn+wzKi64e0KjyUTH2TF/EiCNYOrmWFfU
	 nNJQyTpzM1A51/FJvlh2UpJt7GmRB6OQVP3TUuEme50f6gh4dno7xOaXq6Je7Zuql+HBI
	 MnCha5lFVurFADYaBaLfa0GVBgED9xDJmYsuLrxvbE/ZK8a0jf7sf6TzAqYS/xWUDfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+WyPykx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C628606A7F1;
	Wed, 18 Nov 2026 19:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0+WyPykx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 645131F000C4;
	Wed, 18 Nov 2026 19:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030386;
	bh=BcYZ3K1DaKpEhcg2/DkaPdPDV6tXQ4qxbwXO+06/SzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0+WyPykxI26rOURCPSv1EmagENSdb6zsgNlP7Tl8kFs+1EBIqlgo7+HqblDKzOnPT
	 1RyJqUFo50WCqOav1Ju/kLHQ7ZorQlq573r1AkWdLA9+Y5lLVx4Ir5kGThHOaKwBuC
	 4/Umvq/Lb5vU3vX3NNbgGcibKB8ZhA2sDbBtNglY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0649/1756] ASoC: mediatek: mt8192: switch to devm_clk_get_optional()
Date: Wed, 18 Nov 2026 15:46:16 +0100
Message-ID: <20261118150034.693223424@linuxfoundation.org>
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

[ Upstream commit 6f4edfdce0099dc0c346c78c85f58a23d4ee646e ]

Switch from devm_clk_get() to devm_clk_get_optional() when requesting
clocks, as optional clocks automatically return NULL when not present
instead of requiring manual check and NULL assignment.

Additionally, handle clock errors properly using dev_err_probe() to
propagate error codes (such as -EPROBE_DEFER) on failure instead of
just printing a warning and continuing with NULL pointers.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 77f596cab92da..9b9a3465ddb52 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -672,13 +672,10 @@ int mt8192_init_clock(struct mtk_base_afe *afe)
 		return -ENOMEM;
 
 	for (i = 0; i < CLK_NUM; i++) {
-		afe_priv->clk[i] = devm_clk_get(afe->dev, aud_clks[i]);
-		if (IS_ERR(afe_priv->clk[i])) {
-			dev_warn(afe->dev, "%s devm_clk_get %s fail, ret %ld\n",
-				 __func__,
-				 aud_clks[i], PTR_ERR(afe_priv->clk[i]));
-			afe_priv->clk[i] = NULL;
-		}
+		afe_priv->clk[i] = devm_clk_get_optional(afe->dev, aud_clks[i]);
+		if (IS_ERR(afe_priv->clk[i]))
+			return dev_err_probe(afe->dev, PTR_ERR(afe_priv->clk[i]),
+					     "failed to get clock %s\n", aud_clks[i]);
 	}
 
 	afe_priv->apmixedsys = syscon_regmap_lookup_by_phandle(of_node,
-- 
2.53.0



