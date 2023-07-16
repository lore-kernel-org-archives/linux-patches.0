Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C4A8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403CBC433C7;
	Sun, 16 Jul 2023 20:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538864;
	bh=E0LdzPPJDWGtCnA+R6OrlSvFmioLcTLQe52YTwJ+kuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8CnhdJAoivJraoZB3pVlo7CT+SCrwXHHpgUIUcJTvy4L1hyMX2E0DXwptJX6a9FY
	 vCGqTINh7Vp6hWzWQjixq/ohyh/NqfBKYdZUeQXAkjZ969fhxjT6g3vB1/zDAYyC67
	 h4U6Vpxvt4kPlI+GKzOjgR/7vCm+JVBdIjJrwme8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 604/800] power: supply: rt9467: Make charger-enable control as logic level
Date: Sun, 16 Jul 2023 21:47:37 +0200
Message-ID: <20230716195003.134456813@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 5d80a86a99d524b0d89ff3906c6200b9f57b66f8 ]

The current coding make 'charger-enable-gpio' control as real hardware
level. This conflicts with the default binding example. For driver
behavior, no need to use real hardware level, just logic level is
enough. This change can make this flexibility keep in dts gpio active
level about this pin.

Fixes: 6f7f70e3a8dd ("power: supply: rt9467: Add Richtek RT9467 charger driver")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/rt9467-charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/rt9467-charger.c b/drivers/power/supply/rt9467-charger.c
index ea33693b69779..b0b9ff8667459 100644
--- a/drivers/power/supply/rt9467-charger.c
+++ b/drivers/power/supply/rt9467-charger.c
@@ -1192,7 +1192,7 @@ static int rt9467_charger_probe(struct i2c_client *i2c)
 	i2c_set_clientdata(i2c, data);
 
 	/* Default pull charge enable gpio to make 'CHG_EN' by SW control only */
-	ceb_gpio = devm_gpiod_get_optional(dev, "charge-enable", GPIOD_OUT_LOW);
+	ceb_gpio = devm_gpiod_get_optional(dev, "charge-enable", GPIOD_OUT_HIGH);
 	if (IS_ERR(ceb_gpio))
 		return dev_err_probe(dev, PTR_ERR(ceb_gpio),
 				     "Failed to config charge enable gpio\n");
-- 
2.39.2



