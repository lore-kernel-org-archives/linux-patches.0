Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017224;
	b=DaGcDf2WGGGSj1my7X7VxWRxl5cAtjRnSsj9pPaRzcfryIZBczujO8+7syTGIkv4iUML
	 q67L2Aafr37KWeGvBWia6XGVfDhXyCnNL98P/M4ZDQ4LsJNkI3MUHteNyIDGFWvWvCkn8
	 pcu5FMjIKfR5o3B3ZIasMUswNIG/coQzL8Eil3UAtEef6lfNUj1ZfVJCJloBeZwMu3Xfv
	 zWTRe9FitwgQ38U+KqkdxDI1tLsG3APLQbCsYCtWihc6HzP+chPgU6eTQeWGzJeLmiAgp
	 Iv4z765uoghlBB12XKJlFt6vlZ8IlJJGch/8E+36VivvnTWp/PrsTc62CPWUqV0xkbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+4aVCoRarPxLOl3UIHpmDfq7b6KMu/6kghb6bvLTLjw=;
	b=1hEb6zEBHPOfmFu7AVNG2Ht8yI3ZkCL46pdAx8iflGjVNwAzyjt7ZSoHDePDSvpaMcA4
	 wI8D3AhxlNkDUI8VPi8U8tDxmjNq0GujqIfzv9DHM/SNpjHxAbeAIDdwaT0WBf51s09Uj
	 Mtxji4CHzo9KAS4vSa3kX9iJlCFLaTrsKcyRWo0Ai4gVERZPJNKWULNQjT6Q8LoqcPWTi
	 QXSb4QWMIErXhzKZ6H6kqQ312mGYDFJIMkKDbgjaJimvmXC9Pz+lTWjLsgF4S6q6TBsG7
	 GpRWOxtBACw0LXUUGZ5DhwdOrVraBrar30XRUfa5EJmBfMW0We2VxQhDyrf7oxNAAcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nE3dRzfF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CEB606A33B;
	Wed, 18 Nov 2026 15:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nE3dRzfF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66D11F000C4;
	Wed, 18 Nov 2026 15:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017224;
	bh=+4aVCoRarPxLOl3UIHpmDfq7b6KMu/6kghb6bvLTLjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nE3dRzfF0xDlPC5f6UM1IyPn00ynmtQ5t9zaR9W336JGa7q+sl6s17pHVk7TDhjxJ
	 bsbzH5lzEdUBgGPBhs7toOP01YiEEiC0gMpjkj2BcT6c5FtbvcYo5UyTpftnKWtdr9
	 io9qUryVkZ5Q2lYkT4SHQXq//iIZvGj+PEY9Memk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0808/2651] ASoC: mediatek: mt8188: fix clk leak on error in audsys_clk_register
Date: Wed, 18 Nov 2026 15:34:08 +0100
Message-ID: <20261118150316.981298435@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
index 972f097a13ca9..9f3b3a777577c 100644
--- a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
@@ -170,7 +170,7 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
 	struct clk *clk;
 	struct clk_lookup *cl;
-	int i;
+	int i, ret;
 
 	afe_priv->lookup = devm_kcalloc(afe->dev, CLK_AUD_NR_CLK,
 					sizeof(*afe_priv->lookup),
@@ -179,6 +179,10 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 	if (!afe_priv->lookup)
 		return -ENOMEM;
 
+	ret = devm_add_action_or_reset(afe->dev, mt8188_audsys_clk_unregister, afe);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < ARRAY_SIZE(aud_clks); i++) {
 		const struct afe_gate *gate = &aud_clks[i];
 
@@ -194,8 +198,10 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 
 		/* add clk_lookup for devm_clk_get(SND_SOC_DAPM_CLOCK_SUPPLY) */
 		cl = kzalloc_obj(*cl);
-		if (!cl)
+		if (!cl) {
+			clk_unregister_gate(clk);
 			return -ENOMEM;
+		}
 
 		cl->clk = clk;
 		cl->con_id = gate->name;
@@ -206,5 +212,5 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 		afe_priv->lookup[i] = cl;
 	}
 
-	return devm_add_action_or_reset(afe->dev, mt8188_audsys_clk_unregister, afe);
+	return 0;
 }
-- 
2.53.0



