Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047158;
	b=nrtvR2sZ6W0DujjaTkSiylZfoVJjDMMXWrDT3c1COnCfDDDR8A8oOfYAzkNKNoS8eFm1
	 IX2po7efv8I0kmDthbMNUntdZZc5sSQYYICQ05eyvbGypuERo1Nj9Hpod/QXObBzPrqv0
	 I0d6cRB8OaiaGzF7JvEZMLobyxCROxlM3ASBfEmyLHP8Hqnw1glUSVsQSFQwd1mNcLy2M
	 U8MSkrK8PgUfeuzwK9z1rKW2qr8qFqdsTK2bQ0WruoXUa2p9ccXDgk6aIaCNznhON7SPP
	 Uh1XvnFR8MLJJgoYQGDvJ7e7IEevsqSXD6aRB0xXQq+RY+sg/8629gdPybIXpJ/orEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047158;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vd9wwfi5saEVkfK/VTTZZpzMXu2A3pZJ2MsfxdFYEbw=;
	b=Kb0YhY/8jPyZOLVJDbn7mh0jrwD/cKGUTj7JOWYLTPl97xocmXUABJKrMO7rb8HkHaxE
	 bhWTRAuezjco7kIPATe7QGCpWWT/voy5HUMoH2MIAG40U9ZGGW3xtReQ5J4xGVauhRN5+
	 zsxqAaJu2SH58D9nho6+2zuLmRth/6n9wJPXzfKaqSGNvioUw5uzxUA6jCBMvnYjZgnbM
	 He04c/XD7vRqUkad0inNIV9/8GSWKsGDKIYKKIFJhYS6MkYLEZnr2eD4DzCIW6R6MMERD
	 Uqb506JpVtR4jDnQSHiSargFC6HWdrkEKoovBob1Tl8eV5ZQttUt9FAh3rWiQpzqX0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYJ+Qy6x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36E2606A31C;
	Thu, 19 Nov 2026 00:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYJ+Qy6x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2275B1F000C4;
	Thu, 19 Nov 2026 00:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047158;
	bh=vd9wwfi5saEVkfK/VTTZZpzMXu2A3pZJ2MsfxdFYEbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYJ+Qy6xA/RdhUIPaGYkoV2NKFdOb2SxZLAPm7+zHkaDtdCtErQOut3G8MGgIKBuN
	 H2Ax0l+WGQYUjkKTa51F9ZoH6VP0MELNfcAPK6ws7kJBq7b4n6OAQM14z704FxMY66
	 hMWEtKiqrLh2wrLw/vPG3QOTN+rqFWdy03RoN86k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guiting Shen <aarongt.shen@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1538/2857] ASoC: tlv320aic32x4: Fix the divide by zero
Date: Wed, 18 Nov 2026 15:42:52 +0100
Message-ID: <20261118150256.694796821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4de5bd9e8cc5f..d6101ce73f80d 100644
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



