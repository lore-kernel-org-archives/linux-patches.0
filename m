Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030406;
	b=z6tuhZatJxShWO46gdsWhXI4UINcHjb62HZ29Aq4FLBQpVGM2S+QQcfywIeTJ4TooWm8
	 +Vqmqv++1vD/7tY+VTM/9Jml22Vclsl99DMOOYLoto44it0e1RwN9DMYB4qUQvtFdNuCq
	 l/0V2np9/ktG30FgA7Op8OIkfPtoNskZxRCeveaM013m3nsDgS2kl6mtzMqBqyzldlX6O
	 aD7QD9SU5z2LkpeXelXcp3UnxCw3qFlRc6u1FRC6Y7aaWrneANjtnVY1eR+VoCBZZEqR6
	 WoRABON6VSaVGoBTIhUQlB+8OaFKRdQRikKGziopKeK7kUtUFz6h86bTL6db6Iy6cMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9IMmCKnERXIB4+a7GEh13JVvIBXBHlUUdDoICtj+7s=;
	b=0MtJmqaZPPmx16WNLyJdhEoU0Y3qyz6qwKrJ+TmxqLR5L4t31vUcxRHKUKRv1qCcpr5W
	 hIjc0kRZu7MmJCFybt5pArahq5yAEVOzctgI+dwGVwXwThY0KX8DqyZcdXmEy289N4qBr
	 xJ6F/hvxDjMW1/koj8Q2RQeKC0HD0yVqBEgbk7LzjTcQsyGUospjamttgE3Nh6iRxm1JZ
	 w9GTkgzsb2K//o8Dr/QsYifJ88u2lBEvDkyoW4LA6dmbQ6DfnKQbKWHcpOBCcQ5OhIO1A
	 6qh1Yp/KRTiRXJ8rzC0/3o1sUO56eaJiN6iHCjUpqLh1xyzPfGoFm6fKoxSf5ASd2xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VYquwK4O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E8F606A336;
	Wed, 18 Nov 2026 19:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VYquwK4O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEFE1F000C4;
	Wed, 18 Nov 2026 19:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030406;
	bh=V9IMmCKnERXIB4+a7GEh13JVvIBXBHlUUdDoICtj+7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYquwK4OxIXo1lpWxK8wvZBNUkQPRpeEx8kugaet/9TfIy7i2nAfTGb60Ao5yV6Nw
	 RSM12cMBAeXHmG899LCxI9yBG9W1AfZVA6ipdUpn7F4yqdyJKaUb0i+xMGuTx9cZeV
	 1XYsAauLkkInC5bG6dhWeoChPvdcZxBCw40+ZzqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0652/1756] ASoC: mediatek: mt8192: check return values in mt8192_afe_gpio_init()
Date: Wed, 18 Nov 2026 15:46:19 +0100
Message-ID: <20261118150034.825055545@linuxfoundation.org>
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
index ed6dfdf2589bb..f2d5e61fbb639 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -151,13 +151,17 @@ int mt8192_afe_gpio_init(struct device *dev)
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



