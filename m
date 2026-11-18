Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059741;
	b=srxiZNaMWQx1Btc1Cg9D4k8RZE1u5GTcab82rDIiKo+toWiQIzetfMRPT94vMOZlGIiP
	 Tt4m4GAJsEaIVseRmWYLHp7Th2rEsZC6p8Nq/a8qWCaJI0obEnBgDuTk0SGDd2ev/173b
	 zaPIjwM5tq8SlsWzfe9q774ou+AondK1AKkELcastGpMAabyYrxVSbezVmpQwsHZXt5qf
	 QFc5DsIMR0FHZzBNUC1x3HfgiXaHFaCE1U7JU+41gpvSazEP7eAXvI3pY72yuAgA6Y/zY
	 A2/kIdp52/nfmyhTZxTzlhqC+O/6GyzNUkSBTk0fO7YNJe8BxQ43aV4SuEKW4R8MR6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o9SK3nc84FJua2mWZ/XF8b+n9Qh3k3I6MmpbgV3RO1c=;
	b=oemRySEIn1tmCJSQrLJzYCRQuoORDAc1ESAzt0CBPW0h56aS4s2HPDh9NDO2Kpiy3k3X
	 AZapEFuCx8dcUY1rrv7536YA7dapEoipbaj65nV+NWR8ntQFM47u4kDTw28Q0FVCXjrDz
	 7NbvTXsxOHwscNSkWHXJqv1m3T2f1BNFJTXeoSZrytkexNiodvBaNQFceQMie70TC2js3
	 4avwJQMfDrAtZawEeLCqvcYVDNE6L2864MiPDqREOxOSyDCKuLeTZAV9KpamDvp42nDry
	 7Dihil6S261H93pIyk9z/IxK8PVesGDYkIqKyGJCRef8KR/M3Tw6HqtFTBhfpoZbqbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1EKDTTu+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23E2606A32F;
	Thu, 19 Nov 2026 03:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1EKDTTu+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91B21F000C4;
	Thu, 19 Nov 2026 03:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059741;
	bh=o9SK3nc84FJua2mWZ/XF8b+n9Qh3k3I6MmpbgV3RO1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EKDTTu+OsJp/kEnx5RDkatqxbyHJ5sVxDjytlJ5Iu2sgRnVGncaiblun51OwHRV1
	 jRk5cZM9qh1HyzJzwac/TRlRm1k3voSAJwUkbX+QmSL/JPiWUg+aKnc1MPQAvDIHJC
	 B/QyJULlKl27MFxBecRB6yTtjXRbqW7d3XPmdpCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guiting Shen <aarongt.shen@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0950/1848] ASoC: tlv320aic32x4: Fix the divide by zero
Date: Wed, 18 Nov 2026 15:49:48 +0100
Message-ID: <20261118145956.798870384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7550122e9f8a9..8e7e4aec3ef31 100644
--- a/sound/soc/codecs/tlv320aic32x4.h
+++ b/sound/soc/codecs/tlv320aic32x4.h
@@ -213,8 +213,9 @@ int aic32x4_register_clocks(struct device *dev, const char *mclk_name);
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



