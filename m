Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055490;
	b=EDYnFbDPoyOKrCUFewog97FOpCyl7sRMhcIZbZn7Sz99RZUvLM1/BXy7XZ4P631uE6cV
	 tak7NaRpFtisTcr//RwvPNyxdnsEibFWRevuXa7iPB4trADIjWR+CjD4lsJw8PQBdsAqS
	 kVMvxpUcoynw9cqrfT0XPTuUD7AzmIRvC+lmaekZ49BaPUzE87foQ+HER0oFxj+eewdkG
	 vWVr8u8sNW2L1YfPClWVHvJlKg509+mv0Cro7k5ulXyh1MvZrVhNPP9TyfLLrdZCye78T
	 iqQO5fFjSHP5elW7uzuSdpVss0L1HWjXCcj6S/P0PIXkPYudE6j8bkZy+PW19G3jNWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1lX+Q0l1eaFczg7w8Tx+GVz5Mf5QYMWBOfY2Gg5xgcY=;
	b=Au6221lmgfIa+Sp7qeMLRqg3tE3EmWv+EeEeFG3hYSlYQx9eHXehw9mW0C6aZWoGwcxH
	 HQsKhsgeaPKx9TuMK+wHKGy+oIhBmyEZCs1boD27afj0/NjusRQVELCBwSr9pIfWeseQW
	 K039QQl8ay5eVee+lNQWUonH7WWoWUiisJyBmjHNuovSkNeLHYAtql5uF/n7wcyulVbCD
	 BxV8GK2JXJTOL4Tp4HbGYfITgY6o8kUc12QhXPdTv6HcNFrIYmFBunCdx2wkPQUuc03pJ
	 ocvfj6RtvKFev4HyUFserULGCriLnhxSpx2aL262cyfLAaaOzMMmthSn3tHaVoDhHNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxTex4vf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB67606A32A;
	Thu, 19 Nov 2026 02:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxTex4vf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2300F1F000C4;
	Thu, 19 Nov 2026 02:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055490;
	bh=1lX+Q0l1eaFczg7w8Tx+GVz5Mf5QYMWBOfY2Gg5xgcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxTex4vf/HgzwytKgbaIr8ohPQKspu49FLnOYQZxeknEb7gFRmhgLmhcHJ6rwye+L
	 R9ruj30D8Rac3RgvaLbaCZ6vaeEHOdQvLqSAIMNmGN/Lbakj56D2rQGe8+4UiemsrV
	 iqignOWA/B792/Sd1TZnafcD8+c8ycSzginEshIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1651/2214] ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()
Date: Wed, 18 Nov 2026 15:55:27 +0100
Message-ID: <20261118150117.950163972@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 7cca184ad434436e8f4648f71756bab0c3593ed9 ]

Currently, mt8192_afe_gpio_init() ignores the return values of
mt8192_afe_gpio_select() and mt8192_afe_gpio_request(). If configuring
GPIO states or requesting GPIOs fails during initialization, the function
still proceeds and returns 0, masking the initialization failure.

Fix this by checking and propagating the return values properly.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
index 8e4013a18d8a2..3737583e347e3 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -152,13 +152,17 @@ int mt8192_afe_gpio_init(struct device *dev)
 		}
 	}
 
-	mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_CLK_MOSI_ON);
+	ret = mt8192_afe_gpio_select(dev, MT8192_AFE_GPIO_CLK_MOSI_ON);
+	if (ret)
+		return ret;
 
 	/* gpio status init */
-	mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 0);
-	mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 1);
+	ret = mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 0);
+	if (ret)
+		return ret;
+	ret = mt8192_afe_gpio_request(dev, false, MT8192_DAI_ADDA, 1);
 
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(mt8192_afe_gpio_init);
 
-- 
2.53.0



