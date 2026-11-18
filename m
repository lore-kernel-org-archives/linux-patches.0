Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017216;
	b=hLuIHzCHlJ2dwlJbh9dZLKAGqMb2LBjmaX/wSPrTCejqbfep0OUKJ+QT86SeI9+FH660
	 p9sl1Nf686JhY4tGF9RpGMWzhrSF7fp4TraUVgVmUW1xzTBK5YfRcaa0JAZmGH9YPJ2oW
	 gcWUjEWOADPX8KuofBekCbvQDjTV+o2rZkbyApKGbh9SUq2A3c+d2k4XOe2sb6NsiX1MN
	 jTmKNy+GcYuIGZbKiD5BID8WIuPtZD2bKyS7+4r35O6v+VS7LC+0v/NQ2ptbbpH3lsilG
	 H0Sz8nvwtCsRAQ0l0wNF6R9CNEbKznvgfzY6Oewd7kHQnxFUF+324XCOo3tClb5iYtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8e37rMyeHZHKNhN6TahKg8+yR7S8nyhj1rt3+ugEmF4=;
	b=TneEL1Skusy0mSwhuLl+ffJoRjHy1rTNIslCtw8z6QHufhI/FKf0CbZruIYmgPNq+x9x
	 BiaNUN4vQKZpWVgrI5OeM/xyg5NISjX8v/CwjCRMCdCUAYXixMK0sXb6ALIYnpBvjH2eF
	 wEOa8NZ1mEjjLnrVgYWYff7P8pZqFOJBsazBIBaMG2AXf19UNEjXb4N8iBhx1O+9x4Lay
	 Le4+kiitsvrKY3cyfomZZEnYRXq/fuUHJ8z1wf0+N/kS9b3af88ul6lyftIo+N8isGaed
	 fFqdBO96FjruPdNMPPDUsGEJASvW0ny6PNTiU3byN/Pfsii3MZqaqjmp2FWW0uZRaqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrXMa1l8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2244A606A320;
	Wed, 18 Nov 2026 15:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DrXMa1l8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769881F000C4;
	Wed, 18 Nov 2026 15:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017216;
	bh=8e37rMyeHZHKNhN6TahKg8+yR7S8nyhj1rt3+ugEmF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrXMa1l88VSHdJHMfJHqQAVJjoiU9AsOX3NlGnO7YK6sGCA++nxBmwPBG+3H8RQWx
	 GDcEvAQOhtgUwT/TVjMCw+XKMco+gUcdp5P0bwfP+wsph2tg7RZwSkZX/IYNhG7fXW
	 G8mpfQ79wSKEpKtBuVmW41Mfv/ka58WGEZvoZaXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0805/2651] ASoC: mediatek: mt8188: mt8188-afe-clk: Propagate regmap update errors
Date: Wed, 18 Nov 2026 15:34:05 +0100
Message-ID: <20261118150316.857761220@linuxfoundation.org>
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
index 586fe0a521b80..7360cbf6671b4 100644
--- a/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-afe-clk.c
@@ -567,9 +567,7 @@ static int mt8188_afe_enable_top_cg(struct mtk_base_afe *afe, unsigned int cg_ty
 	unsigned int mask = get_top_cg_mask(cg_type);
 	unsigned int val = get_top_cg_on_val(cg_type);
 
-	regmap_update_bits(afe->regmap, reg, mask, val);
-
-	return 0;
+	return regmap_update_bits(afe->regmap, reg, mask, val);
 }
 
 static int mt8188_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_type)
@@ -578,9 +576,7 @@ static int mt8188_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
 	unsigned int mask = get_top_cg_mask(cg_type);
 	unsigned int val = get_top_cg_off_val(cg_type);
 
-	regmap_update_bits(afe->regmap, reg, mask, val);
-
-	return 0;
+	return regmap_update_bits(afe->regmap, reg, mask, val);
 }
 
 int mt8188_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
@@ -620,14 +616,12 @@ int mt8188_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
 
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



