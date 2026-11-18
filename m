Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054044;
	b=FKNGNdW8rdpcv+Ijav98LuYsGgJpQyVa0pnK+prEtccAZUzYNZDpJjU28HTHop3cQHpU
	 JSnxaEUCW57rbH+7rRbrgb2oZH0j2yABCrQog0x1i8sqOd7Fpvn4DKhBLVGRtBd9HUY6y
	 tPTSFEmLgM1aZL4LUZtPptk7d80jyipC/zllZEpwfOWZ5y0kWxLjD7Tc0FyZT05BeMXDz
	 9b5Hhdq7p9/sXrgUAtnmwabxNIuwXfr50rWeKBBZypTYVPEouho/RZfGXamL9PLjREgJM
	 JdrQVaBgRvykhdWmlGhCIKzp034RvZ1lCNsBBrSOu57/KAERpPF+CS+8QGx3q4Osl5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QprQGKLD6z/0BImqb3IVxodaT8SwYcmSH6GnMiOHlAQ=;
	b=2oaX1T5ccQwQRwynerHcdy0UPUQmR9EkX4it04UB/Vwp/pMxjrAtMflACCZDLfSYb5c0
	 rclMkEkHdrta2yeW9ULf9SzFp97fmYBCKK4geseYayztl0bn+tvJZgfcu8FYR9rAIAaFY
	 9XE10OrYt2l0xg6mnOJBVlNHEQ2bfPrLL6ftXC7ogoqRr/dOksFRJRuboQiz1vLCdRxz9
	 zoZMzteDydchkvv4CeQb4J7Lv90TkGrQjp73UU/YdKku8wWKFBwybpp1ECURUDW6broZO
	 00TX27gE+RB1Al8w8wycpedi7BK/owk7Ip7T6LfmFqkAdr7+PX0AP/oHpthn/OIqkqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkLbK2v5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A79606A325;
	Thu, 19 Nov 2026 02:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkLbK2v5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B68B1F000C4;
	Thu, 19 Nov 2026 02:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054043;
	bh=QprQGKLD6z/0BImqb3IVxodaT8SwYcmSH6GnMiOHlAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkLbK2v5COtxTN/Xu8rnzrlnGfZSzBVq+2RDVxTzu302pCmgUpF/7OZ+qi0EWHKwG
	 ElUMphRaNZFV5gxy4gIcJNiEMewSf3X5mnjz0wbt2UMx8rzALdUlKEbz0rc1Wk3rYm
	 /oL2lcKZh+epL594C2/CvKn+ilcz2FoS7jKuM/Zw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guiting Shen <aarongt.shen@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1135/2214] ASoC: tlv320aic32x4: Fix the divide by zero
Date: Wed, 18 Nov 2026 15:46:51 +0100
Message-ID: <20261118150057.451798192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guiting Shen <aarongt.shen@gmail.com>

[ Upstream commit 11e756cc85fac43e2025306ad6aea80114cc7e98 ]

The value of register(NDAC,MDAC,NADC,MADC,BCLKN) maybe zero lead to
divide by zero in clk_aic32x4_div_recalc_rate().And the rate should be
divide by 128 if the value was zero in this function according to the
datasheet.

Add the macro AIC32X4_DIV_MAX to present the 128 and return 0 if failing
to read the value of register.

Signed-off-by: Guiting Shen <aarongt.shen@gmail.com>
Link: https://lore.kernel.org/r/20230813125520.11067-1-aarongt.shen@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 8cf9607d2d85 ("ASoC: tlv320aic32x4: Prevent division by zero in divider callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-clk.c | 16 +++++++++++-----
 sound/soc/codecs/tlv320aic32x4.h     |  5 +++--
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-clk.c b/sound/soc/codecs/tlv320aic32x4-clk.c
index 96979243d3a6a..4ade06e5f5cd3 100644
--- a/sound/soc/codecs/tlv320aic32x4-clk.c
+++ b/sound/soc/codecs/tlv320aic32x4-clk.c
@@ -319,7 +319,7 @@ static int clk_aic32x4_div_set_rate(struct clk_hw *hw, unsigned long rate,
 	u8 divisor;
 
 	divisor = DIV_ROUND_UP(parent_rate, rate);
-	if (divisor > 128)
+	if (divisor > AIC32X4_DIV_MAX)
 		return -EINVAL;
 
 	return regmap_update_bits(div->regmap, div->reg,
@@ -332,7 +332,7 @@ static int clk_aic32x4_div_determine_rate(struct clk_hw *hw,
 	unsigned long divisor;
 
 	divisor = DIV_ROUND_UP(req->best_parent_rate, req->rate);
-	if (divisor > 128)
+	if (divisor > AIC32X4_DIV_MAX)
 		return -EINVAL;
 
 	req->rate = DIV_ROUND_UP(req->best_parent_rate, divisor);
@@ -343,12 +343,18 @@ static unsigned long clk_aic32x4_div_recalc_rate(struct clk_hw *hw,
 						unsigned long parent_rate)
 {
 	struct clk_aic32x4 *div = to_clk_aic32x4(hw);
-
 	unsigned int val;
+	int err;
+
+	err = regmap_read(div->regmap, div->reg, &val);
+	if (err)
+		return 0;
 
-	regmap_read(div->regmap, div->reg, &val);
+	val &= AIC32X4_DIV_MASK;
+	if (!val)
+		val = AIC32X4_DIV_MAX;
 
-	return DIV_ROUND_UP(parent_rate, val & AIC32X4_DIV_MASK);
+	return DIV_ROUND_UP(parent_rate, val);
 }
 
 static const struct clk_ops aic32x4_div_ops = {
diff --git a/sound/soc/codecs/tlv320aic32x4.h b/sound/soc/codecs/tlv320aic32x4.h
index e9fd2e55d6c3b..7a89ac4d5f574 100644
--- a/sound/soc/codecs/tlv320aic32x4.h
+++ b/sound/soc/codecs/tlv320aic32x4.h
@@ -223,8 +223,9 @@ int aic32x4_register_clocks(struct device *dev, const char *mclk_name);
 #define AIC32X4_REFPOWERUP_120MS	0x07
 
 /* Common mask and enable for all of the dividers */
-#define AIC32X4_DIVEN           BIT(7)
-#define AIC32X4_DIV_MASK        GENMASK(6, 0)
+#define AIC32X4_DIVEN			BIT(7)
+#define AIC32X4_DIV_MASK		GENMASK(6, 0)
+#define AIC32X4_DIV_MAX			128
 
 /* Clock Limits */
 #define AIC32X4_MAX_DOSR_FREQ		6200000
-- 
2.53.0



