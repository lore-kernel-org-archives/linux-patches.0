Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048764;
	b=VZx8jr2BQVDjXhWNzRyvKiFhp5Wjy19B4zCC5tGJ+3458/WuYRmT/l5M4Hime7D1AErv
	 1cVCNwoYlLBAipdosRt/7WSlbyf4ziHuVp1ZhWgt1ge3iSJSvtbrvEDsh75PoA+Cu7tz6
	 hk2mTA1vlamXMK+BoGqJbAujT5CE0EiFmF1GXLLXs6eJwy9tRkSDnHu3qu7f2lck1h6QX
	 rMTdTEM6FCrAi5s54s4ChGG0pLNDcksl6kHVCDeTrRuCyY0EIarn12n2JrrTb36i3Y7zH
	 YBdBfOGWGee6I/Ca+XmA3CqplwF9+R6p4yPXlC2y5CIfgk6ecSbl0fzA2+RlyCqR/bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZpiwFResJbzE1jRQtWvUZHE/AAtD7B7FofXzdtK7Fvc=;
	b=vJyy6D69c9meUT3KVRbwQgGCeFQeOY3s+sB8xpkshTIF5DAD+U5rtMCw1OzB2+EHB6+c
	 zoKU78WbYcN470jyHx7zswCCZn1AqUtidkovIbZwcH04jVk3w5JnBLrfLcaRjGABXmBNL
	 iWYAjZIqe2f/LBYbvNFpaJe8FJplUugmjigHbfAEZW9fKOpZLZnNcbAbEizVyktsPX9P2
	 Om3oP9akwhGy9PRpVLaLc5sMIHSEVBSHRtOflnhWfjxC5ObOnwF6asOGAJBVhfpbWQR/c
	 ZhmNjZhic3LVTCW8aa6glV/KoK3gUa76eVXW3l0rBCrV3xmukVrpOiUeOmOWzESs6iA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Aw/RjI9s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D89D606A320;
	Thu, 19 Nov 2026 00:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aw/RjI9s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738A11F000C4;
	Thu, 19 Nov 2026 00:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048764;
	bh=ZpiwFResJbzE1jRQtWvUZHE/AAtD7B7FofXzdtK7Fvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aw/RjI9smUecPL+7QzgvM9nclkkAzU26BkSKNDNg+01DWXBJmbcLtCQxS/keu8I4C
	 3TDI0xSe1hWPqd0Yl4EmvY0MMDADkz4Scv7T8KQ7cjwbdXCKTQhREv+zZMn5fqr/om
	 +LfKak2W5nDBwnUite8oAb+qEJrb7ML3QiWg9S7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2110/2857] ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()
Date: Wed, 18 Nov 2026 15:52:24 +0100
Message-ID: <20261118150317.383168287@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 411be3902fa8f879db6f2f55d0c15507efe09c92 ]

Currently, mt8192_afe_gpio_request() ignores the return values from
mt8192_afe_gpio_select() and other helper functions. If configuring
a GPIO state fails, the function still returns 0, hiding the failure
from callers.

Fix this by capturing and returning the error codes properly.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c | 74 +++++++++++----------
 1 file changed, 40 insertions(+), 34 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
index 88dca80cd69c7..8e4013a18d8a2 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -209,98 +209,104 @@ static int mt8192_afe_gpio_adda_ch34_ul(struct device *dev, bool enable)
 int mt8192_afe_gpio_request(struct device *dev, bool enable,
 			    int dai, int uplink)
 {
+	int ret;
+
 	guard(mutex)(&gpio_request_mutex);
 	switch (dai) {
 	case MT8192_DAI_ADDA:
 		if (uplink)
-			mt8192_afe_gpio_adda_ul(dev, enable);
+			ret = mt8192_afe_gpio_adda_ul(dev, enable);
 		else
-			mt8192_afe_gpio_adda_dl(dev, enable);
+			ret = mt8192_afe_gpio_adda_dl(dev, enable);
 		break;
 	case MT8192_DAI_ADDA_CH34:
 		if (uplink)
-			mt8192_afe_gpio_adda_ch34_ul(dev, enable);
+			ret = mt8192_afe_gpio_adda_ch34_ul(dev, enable);
 		else
-			mt8192_afe_gpio_adda_ch34_dl(dev, enable);
+			ret = mt8192_afe_gpio_adda_ch34_dl(dev, enable);
 		break;
 	case MT8192_DAI_I2S_0:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S0_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S0_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S0_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S0_OFF);
 		break;
 	case MT8192_DAI_I2S_1:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S1_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S1_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S1_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S1_OFF);
 		break;
 	case MT8192_DAI_I2S_2:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S2_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S2_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S2_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S2_OFF);
 		break;
 	case MT8192_DAI_I2S_3:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S3_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S3_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S3_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S3_OFF);
 		break;
 	case MT8192_DAI_I2S_5:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S5_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S5_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S5_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S5_OFF);
 		break;
 	case MT8192_DAI_I2S_6:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S6_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S6_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S6_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S6_OFF);
 		break;
 	case MT8192_DAI_I2S_7:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S7_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S7_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S7_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S7_OFF);
 		break;
 	case MT8192_DAI_I2S_8:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S8_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S8_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S8_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S8_OFF);
 		break;
 	case MT8192_DAI_I2S_9:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S9_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S9_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S9_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_I2S9_OFF);
 		break;
 	case MT8192_DAI_TDM:
 		if (enable)
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_TDM_ON);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_TDM_ON);
 		else
-			mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_TDM_OFF);
+			ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_TDM_OFF);
 		break;
 	case MT8192_DAI_VOW:
 		if (enable) {
-			mt8192_afe_gpio_select(dev,
-					       MT8192_AFE_GPIO_VOW_CLK_ON);
-			mt8192_afe_gpio_select(dev,
-					       MT8192_AFE_GPIO_VOW_DAT_ON);
+			ret = mt8192_afe_gpio_select(dev,
+						     MT8192_AFE_GPIO_VOW_CLK_ON);
+			if (ret)
+				break;
+			ret = mt8192_afe_gpio_select(dev,
+						     MT8192_AFE_GPIO_VOW_DAT_ON);
 		} else {
-			mt8192_afe_gpio_select(dev,
-					       MT8192_AFE_GPIO_VOW_CLK_OFF);
-			mt8192_afe_gpio_select(dev,
-					       MT8192_AFE_GPIO_VOW_DAT_OFF);
+			ret = mt8192_afe_gpio_select(dev,
+						     MT8192_AFE_GPIO_VOW_CLK_OFF);
+			if (ret)
+				break;
+			ret = mt8192_afe_gpio_select(dev,
+						     MT8192_AFE_GPIO_VOW_DAT_OFF);
 		}
 		break;
 	default:
 		dev_warn(dev, "%s(), invalid dai %d\n", __func__, dai);
-		return -EINVAL;
+		ret = -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(mt8192_afe_gpio_request);
-- 
2.53.0



