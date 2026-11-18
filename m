Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030081;
	b=pqxoYdXn38MLZIjp0ObHH84c6ttIJ5jiEGDZHXr/ByMq5svd6qHHGfjMKxaNaqJJ3E0H
	 ViCQw8RFkP9s5v+ZxirV8wyjcsXLm/A0YBg6DIH3vfO49+cPxGeOHuRX73Za3bRafDyJq
	 BBI4sng1JcTBAaAyhVZ6g3rLFAY2yoWnaXp2F+4ZvN9JWv4LbxpNXfVOe34Ok/UUcuCbC
	 RwoR0puHG8J8pA2004RPIaxXgwr1wjGQLpCpX9QMOBk9T205+3Upq6S4KSNSXYC+lUis3
	 tHdI+QfB3MZsrXyGwlj+c0vvi7Kh+qx7QQvi1vzMPcc5b6siTsPBa7P13jEcj8+Sb1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ezIsKeIWHYcXhuD8kJ1vLC4pktOn+UojioiEisVIms0=;
	b=TP5yPpPnd70JLhY+Y6EvF78X///HnHVVSEMKWr4QMbtCGmo8jznwmoYjAIjv6NQ+An6T
	 pdip52wij56hRIp6Hd9VYwp0TjBGVOzPCsptc5xA/NvAidWTRX3XSBcHmQTCc8YwnlIWY
	 62ENbv9diMo9wPsNHlCHdN2VLIXfG5a41NrTJF9DMLRbpzhHoLvwEcWB9SAKPZYMbVRkm
	 qhjVY6CoXS/JlITz5e50AnJsXeP9mJmTLmkRoOD0iSjFnSIajlf8svoTZiwJ1tywJYVeM
	 GlENuMFipjPJTUZ0k8XHAFDde9uFywx6q4D+gX3Cz2Ebnk03K8kzXOnRFGvgL+VY40A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJs0LCLO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0878606C73C;
	Wed, 18 Nov 2026 19:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wJs0LCLO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2A71F000C4;
	Wed, 18 Nov 2026 19:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030081;
	bh=ezIsKeIWHYcXhuD8kJ1vLC4pktOn+UojioiEisVIms0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJs0LCLOAiqvJeDPVO20MBV32ia2JYf0iPi5j2TYNiVlgs9w3p3BnRS5z2Y1v/26r
	 2Iu4VxhAsx4fgsrgYfCP8/LGM01l85vKHrvmQwL4LQjQSwBARQxIYwMrvqvK/1nI1+
	 pEdiXDZjY3tiuc7bID6K8Wjd2h2lXh3/65OP4RKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0578/1756] ASoC: mediatek: mt8188: mt8188-afe-clk: Propagate regmap update errors
Date: Wed, 18 Nov 2026 15:45:05 +0100
Message-ID: <20261118150032.051584254@linuxfoundation.org>
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



