Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA601AD3FA;
	Mon, 23 Jun 2025 21:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715841; cv=none; b=BOpGTIuxC36GinQ6vK/WkkOrqCVe32hVoMBxY958OBbQ1OvI53rUzKgzIStIAXD/t/zZL7j1+DQ+c5vpvBQORzveS63tGAMhiW1hDxvqqpwLD/axXGPtboWoU4ma/wXx/Let2sTCgsmNwXAiXzxXS/lo58d8rf1JWx5JzNAQ/LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715841; c=relaxed/simple;
	bh=Dhq7pW8Qogj1kf3R6Hi+DytN6Ux7v8z46EPc/MDXrEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqqxUDJYej+9InKLTJpqOqcZzoZcBmxgc9CI4VQrmU3Lhdu/N6+F6tfqMW06oWf3PxDtFih5BXX4PIr3LHkn3DjF0HsjeGwD3ESZ3TWw47j0/u04fMQuTUp9HusCabqNmXkJaanafJaLi6fN87s/TWUBTBzjHARZg0vIwSw8Rr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BzLrxQ8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BzLrxQ8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361E1C4CEEA;
	Mon, 23 Jun 2025 21:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715841;
	bh=Dhq7pW8Qogj1kf3R6Hi+DytN6Ux7v8z46EPc/MDXrEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzLrxQ8lZ9ZQ2D4gu0GGljR5FmYyom/F2ROXzD6gFMHz9KyDLgUm7J8MhLan4Khmd
	 wIF+x1hBDljbZu2mzqZXOkPN7Ene2zqG3AyO0g3v9aasG9sjtYd0hFfiKbZpeO05bx
	 rY2hP5tpcJ0pbLXIlAAEIj0pnBfMsTK5si81z3as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 232/414] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get()
Date: Mon, 23 Jun 2025 15:06:09 +0200
Message-ID: <20250623130647.838345810@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 57273ff8bb16f3842c2597b5bbcd49e7fa12edf7 ]

The regmap_read() function can fail, so propagate its error up to
the stack instead of silently ignoring that.

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-4-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index f242d24d72b8d..53b6eb7486593 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -443,11 +443,14 @@ static int armada_37xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
 	struct armada_37xx_pinctrl *info = gpiochip_get_data(chip);
 	unsigned int reg = INPUT_VAL;
 	unsigned int val, mask;
+	int ret;
 
 	armada_37xx_update_reg(&reg, &offset);
 	mask = BIT(offset);
 
-	regmap_read(info->regmap, reg, &val);
+	ret = regmap_read(info->regmap, reg, &val);
+	if (ret)
+		return ret;
 
 	return (val & mask) != 0;
 }
-- 
2.39.5



