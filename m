Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040304;
	b=eJo+eaCdiH3cwN5+7vDzHm4Y9Zvw/pw/nn87RJM7cn4c4CErPM89Fl0d9SHjlSaO5v5j
	 f+N12jnS0g+Zn6Kmm05gjz+zp4UipM2Efv6qGGlNHCFFQpwwkEjfD7TxG0MwKhMH+x9k8
	 PJqXVtfx7BcWjiHtEuL4C2sJ+0ySiThUo7OFX+N7eWhm87A8gLZPo0pwSoDj4wcUX7xk3
	 uPMGwe7qufRwXObDJ4L2bK+g6xeDU9tH9hUQ/rt+Hs+aof3kMjZ6NDfgDIBewJT2x+n5H
	 eNFXnkZJ8qI+eK8c4QHratDvb47lfhMlOJSjXvqX2uJfJcB74U+6aAjoeb6TyXQJKCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QACLyZTPpr6TZFDuWIgxq9q0n0M6XlYcNFZm/QdycFs=;
	b=gNMvmdddaFS7xFdlUluo4y4Pu+EJ66q5uGf2cvqTNmPR6g6S5z2H/8et0IkXl1uPPbbM
	 Tc87R8/obNkJDTupofoFw7CUjqTH+zADmYSpi5R17V4u8XOvW2mZRmvCVJPx/fsfLb+hC
	 ppX7M9B2Mbmj+GCAByb4mmgTEC2rdGvyY5MHkjXLqDG/xFfVZh82d3WmDJX2bzLZXOc23
	 w0cwyBSWDC13UsRD4jl1qWYKu9JJQgJ+AgFLxh3dQp7IsPEKUR7nDhU+xPr3EI6kog1Q5
	 2+WfHKHfdezSI1QkrlrBcCuSeXptyZyCJTnayZ8sdn08ZHocHz/bopzwlsTSXf6oChQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTbMRYoW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C2C606A31C;
	Wed, 18 Nov 2026 22:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nTbMRYoW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B703C1F000C5;
	Wed, 18 Nov 2026 22:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040304;
	bh=QACLyZTPpr6TZFDuWIgxq9q0n0M6XlYcNFZm/QdycFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTbMRYoWhsAHyNwe+ZbtcY2mPhLYK6ZE/wuHPkpcMYONr4FBi2h/eQAnP6MiI4So9
	 7DsKppMa9QDBecpksl+1MPFNsBNakxfIfRiyh+uqkRXWeLQQO0ElQ75z//9iKYutG4
	 8z2Ftz8OFtx8lAXnFV1DwImQmjkgp97QPx4SRASY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2359/3318] ASoC: mediatek: mt8188: mt8188-afe-clk: Propagate regmap update errors
Date: Wed, 18 Nov 2026 15:49:41 +0100
Message-ID: <20261118150432.359355947@linuxfoundation.org>
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

[ Upstream commit 60a8112a088aee38d728457a14fa8bfb50f4c87e ]

The return values from regmap_update_bits() are currently ignored
by the clock and AFE control functions.
Propagate the errors to allow callers to handle regmap update
failures.

Fixes: f6b026479b13 ("ASoC: mediatek: mt8188: support audio clock control")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-afe-clk.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
index b41069b752a94..516b9b4ee0339 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -574,9 +574,7 @@ static int mt8188_afe_enable_top_cg(struct mtk_base_afe *afe, unsigned int cg_ty
 	unsigned int mask = get_top_cg_mask(cg_type);
 	unsigned int val = get_top_cg_on_val(cg_type);
 
-	regmap_update_bits(afe->regmap, reg, mask, val);
-
-	return 0;
+	return regmap_update_bits(afe->regmap, reg, mask, val);
 }
 
 static int mt8188_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_type)
@@ -585,9 +583,7 @@ static int mt8188_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
 	unsigned int mask = get_top_cg_mask(cg_type);
 	unsigned int val = get_top_cg_off_val(cg_type);
 
-	regmap_update_bits(afe->regmap, reg, mask, val);
-
-	return 0;
+	return regmap_update_bits(afe->regmap, reg, mask, val);
 }
 
 int mt8188_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
@@ -627,14 +623,12 @@ int mt8188_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
 
 static int mt8188_afe_enable_afe_on(struct mtk_base_afe *afe)
 {
-	regmap_update_bits(afe->regmap, AFE_DAC_CON0, 0x1, 0x1);
-	return 0;
+	return regmap_update_bits(afe->regmap, AFE_DAC_CON0, 0x1, 0x1);
 }
 
 static int mt8188_afe_disable_afe_on(struct mtk_base_afe *afe)
 {
-	regmap_update_bits(afe->regmap, AFE_DAC_CON0, 0x1, 0x0);
-	return 0;
+	return regmap_update_bits(afe->regmap, AFE_DAC_CON0, 0x1, 0x0);
 }
 
 static int mt8188_afe_enable_a1sys(struct mtk_base_afe *afe)
-- 
2.53.0



