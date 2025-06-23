Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5D1B676;
	Mon, 23 Jun 2025 21:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715125; cv=none; b=icsGEKLpiVcABLYkPMU5F1DAVsJWI2YYOZYnPDqNO+ACiMgVqojqlf4T+oeNkKBiUCA5mwq+po9bNnXGyaxqF03CvZczPIFp0VVPkQ5QVgEoaVbdkQGIXJfap2aDQxlVKK8tgthHUJBOmg6B3nWqnQBKwlC8aaS+R0QP5CY4q+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715125; c=relaxed/simple;
	bh=0q6dnBUwHhJHehJepHCmL2YFXF6X/SOoCSSCfjIAP/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMRyaXtc/i0eL/KDtoSmFOCiUod30qDEyNNpWlvC0k5vxpvfRCRBMKxTwiAQjhFZDUNAjJVDUNppkNKxMQqByl2xBTxsav4TWKThY6McOytFSzOKvNPyBqlC/dby1Qfpn5phEjDzq0G4XMyl9mNugoyhxFH1RBLg0JoDr9PcBco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=omggJ1jL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="omggJ1jL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5EA7C4CEEA;
	Mon, 23 Jun 2025 21:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715125;
	bh=0q6dnBUwHhJHehJepHCmL2YFXF6X/SOoCSSCfjIAP/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omggJ1jLZiXXpnjmdvcFRM5TweI9z2xUPB+vED3TN0upLtxXNAnUKTcPn+8XCu6HD
	 s1whNfk18rwbtUzR/g+zXx5tFEttE5uWY/TN17illpnSrztmzTb2fj9QvElUULmOLN
	 BaXEdgwyPVkorMAbJEILWdCJ6fVIkpUERL4xAPz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 261/355] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get_direction()
Date: Mon, 23 Jun 2025 15:07:42 +0200
Message-ID: <20250623130634.601026829@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 6481c0a83367b0672951ccc876fbae7ee37b594b ]

The regmap_read() function can fail, so propagate its error up to
the stack instead of silently ignoring that.

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-6-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index b17d0e80f25af..1cb3bcb41684e 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -396,10 +396,13 @@ static int armada_37xx_gpio_get_direction(struct gpio_chip *chip,
 	struct armada_37xx_pinctrl *info = gpiochip_get_data(chip);
 	unsigned int reg = OUTPUT_EN;
 	unsigned int val, mask;
+	int ret;
 
 	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
-	regmap_read(info->regmap, reg, &val);
+	ret = regmap_read(info->regmap, reg, &val);
+	if (ret)
+		return ret;
 
 	if (val & mask)
 		return GPIO_LINE_DIRECTION_OUT;
-- 
2.39.5



