Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C521E51FA;
	Mon, 23 Jun 2025 21:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713952; cv=none; b=l3+g9PJKjxFGAdHG/zYf3yj5Zd6NRutPXkKWpUbp1k5/B9daVenDiuenX5E49CUmcaf76qPbQ+ueo38m8HZ1iu4emWlfCx0K0auR5jNogFOpaITxav+vT7YUvQ9jdVbnGw/eX+rQZ5BvvGnIYXY3uff58JqxAriG9WRb/EsukfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713952; c=relaxed/simple;
	bh=TtG+AvkbL8DZ+J38Wj2YoVCC3NaNUzXvmo6CTwZh9c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mowyLeV+2G+ukbfBc4oflBmPjNNGBeQHCWS4HMHOJ0encoKJqUXubc5YNS+1qtQzvrS2yliisgylvNbc5eoFE5fqAEL+2CyunVhssYRUBj/b6GV/Z1EeSFyjvGvkzkEDfDLUMkJdtOmZAM59fmkGQPzs0S/4RC3/SojlTbDfH6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvS2J9ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvS2J9ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF93C4CEEA;
	Mon, 23 Jun 2025 21:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713952;
	bh=TtG+AvkbL8DZ+J38Wj2YoVCC3NaNUzXvmo6CTwZh9c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvS2J9ib1Hph7Zh/+WWuBZ7YQWvNUBwb2/w6Ej/Vrx9LaF8ywAbvIc2U3ALykGPi5
	 G0iz8NMbvtF9OSkGu7wAWkxlBp2FEIJLFs/V04UFXusF0TwzVguVCsGiZa9pRqblSW
	 xVgCL2hb+E3GymIqQcQqTgx/bRkQMy6njmlrC86Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 355/592] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get_direction()
Date: Mon, 23 Jun 2025 15:05:13 +0200
Message-ID: <20250623130708.886240783@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 072bdd0d153ed..4ac514cfd8884 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -400,10 +400,13 @@ static int armada_37xx_gpio_get_direction(struct gpio_chip *chip,
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



