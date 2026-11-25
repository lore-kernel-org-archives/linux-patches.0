Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625291;
	b=phR5xirLT5g/ytaORnN6gV0UGWqGrXgI6KtnQev6pA5O3QWxUf3lIWPJwOqqA8gkJq0r
	 qv3r/rrNWj+piN/TJ9ISgA3P55Hgo2bgPZr/pjwoL4Gi+lhMyUHqs+RxhbjNf2kdlrxqF
	 ITY+3Y9bikwMWudxYKUyJ1uc722ulmMsXYi5OwkS+V8s/LABVPRmGmBV/QHtBfmg6i1dO
	 Z2M6neCdRj7sA86IFiOad/+vOZYpKE4jLTBtSZtR17ja40ghBwpdKPez8+smUMZgIXrpz
	 CeAQsDwB7Ilq352b80gBI/C0DyPPTFlDu+ifmNBWMXgNtUrv6h9iw2+dDBS8HpNpV7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Et9a6RkSU1jfCdGfGOR0pskEbbThakh9BTiWjGnC8Fg=;
	b=QaQH33Bt6Q9mscInnhC/6BXhqJSbnkOYHyM+sKv0VvDs7ZFAQcI/7YvBGUxODSwGaoz5
	 8hPimh7DYkNF71kD302qeUpoWzxJrKxRz9nzwcaGLLOAmAFtFGU9eXTxKIcIQs8y/esf7
	 ybCYqUaq9wjhnOtasvTyBtwzkjwhyrpytuB6TzxcZNeLaF5y8aPyMfktMNKCtLmUyOZsk
	 WDHWj/yzcce/mHr5sRkB6Nzw2DH5lFqeCnZk9wQ40YCz+0jPjrgv+5xtij4ggC+KKJAr1
	 vTenSsbozprcvxZF8BXzJJA5ORsEaseRthpuW1WhWFW1JstgceBUzO5F/ZQAgBaz9Bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVPe+vDw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37717606A329;
	Wed, 25 Nov 2026 16:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVPe+vDw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600461F01564;
	Wed, 25 Nov 2026 16:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625290;
	bh=Et9a6RkSU1jfCdGfGOR0pskEbbThakh9BTiWjGnC8Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVPe+vDw0eb0Boq7lwolARg/IemXxa6zqmCSTfI+bU7h7Gqq5UZr+hJsIlFmgLI0A
	 XqJmpu4KpLfqjWU8VmMkfihhRD309NHr6dj4GW5c5hKUMmp0VPjVNZTAii634fQqzg
	 30Z3/GIaekQo6UAdzKesn1fUCLFw9Z1RsPxUXwuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 423/816] ASoC: mediatek: mt8188: fix clk leak on error in audsys_clk_register
Date: Wed, 25 Nov 2026 15:32:51 +0100
Message-ID: <20261125143858.988950722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

[ Upstream commit 6cddf6e56d2539fd13c0ee9dd817c4e06a967173 ]

devm_add_action_or_reset() is called after the loop that registers gate
clocks. If kzalloc() fails mid-loop, the function returns -ENOMEM before
that call, so cleanup is never registered and all previously registered
clocks leak permanently.

Move devm_add_action_or_reset() before the loop so cleanup is always
scheduled. The clock from the current (failing) iteration is not yet
stored in afe_priv->lookup[i], so it still needs an explicit
clk_unregister_gate() call.

Fixes: fd67a7a1a22c ("ASoC: mediatek: mt8188: fix use-after-free in driver remove path")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Replaced kzalloc_obj(*cl) with kzalloc(sizeof(*cl), GFP_KERNEL) because the older base lacks the newer allocator helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
index c796ad8b62eea..fd73f9d9f41a1 100644
--- a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
@@ -166,7 +166,7 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
 	struct clk *clk;
 	struct clk_lookup *cl;
-	int i;
+	int i, ret;
 
 	afe_priv->lookup = devm_kcalloc(afe->dev, CLK_AUD_NR_CLK,
 					sizeof(*afe_priv->lookup),
@@ -175,6 +175,10 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 	if (!afe_priv->lookup)
 		return -ENOMEM;
 
+	ret = devm_add_action_or_reset(afe->dev, mt8188_audsys_clk_unregister, afe);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < ARRAY_SIZE(aud_clks); i++) {
 		const struct afe_gate *gate = &aud_clks[i];
 
@@ -190,8 +194,10 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 
 		/* add clk_lookup for devm_clk_get(SND_SOC_DAPM_CLOCK_SUPPLY) */
 		cl = kzalloc(sizeof(*cl), GFP_KERNEL);
-		if (!cl)
+		if (!cl) {
+			clk_unregister_gate(clk);
 			return -ENOMEM;
+		}
 
 		cl->clk = clk;
 		cl->con_id = gate->name;
@@ -202,5 +208,5 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 		afe_priv->lookup[i] = cl;
 	}
 
-	return devm_add_action_or_reset(afe->dev, mt8188_audsys_clk_unregister, afe);
+	return 0;
 }
-- 
2.53.0



