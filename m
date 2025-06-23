Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E419049B;
	Mon, 23 Jun 2025 22:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716301; cv=none; b=jY0FAWeOpGeqaFmlc5VRf5NS3Q9yys6sicSe9hScrbDJuoDYKlSLl6HmR5UedvPSnmX/+azOyILBurXWX4GiDj1vo12/+L159CWNoE5M/jcTR971ysU5ELqvVoWZyV16pulyRTOgF/DII/2fuIMCXeTDvhYGKhvp+Z9EOUK/tVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716301; c=relaxed/simple;
	bh=kLyADrxaoi5mTi0FgBOzdjO6bjRP6qQ6mEIYNEUDRLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E01Fv5XciNYG5CelQuq+jxDZUyv6rcQxUsurgu+iJIpaBHSe33h5pFnlYhBplnxTRh/UWnYob9L3jwz8d44ifAbzOicZyOL9PqtOO7GmKcJc0QuG9rNCmXS6dNN9JWRu82uBej7awBs2KmHQ53IIfuzaP5QE1hVvGdp1vHWF1zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sN79RNKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sN79RNKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53226C4CEEA;
	Mon, 23 Jun 2025 22:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716301;
	bh=kLyADrxaoi5mTi0FgBOzdjO6bjRP6qQ6mEIYNEUDRLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sN79RNKGlMyGQd5pGwnJRw5SsGan/2df/3kcQDz3OYRmQo5AREGQKm59Ew5BjEYca
	 iOzVZRYgNL25D0YGafOpUs+yBfpH/yxGvSg+BY9IidcQ4fqVfWhK7U2xovgI2Li2x7
	 h8BtzO4oZXD0zNZgBCtXCgzDzjHgB01rZPvaU6mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 320/411] pinctrl: armada-37xx: propagate error from armada_37xx_pmx_gpio_set_direction()
Date: Mon, 23 Jun 2025 15:07:44 +0200
Message-ID: <20250623130641.690458736@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit bfa0ff804ffa8b1246ade8be08de98c9eb19d16f ]

The armada_37xx_gpio_direction_{in,out}put() functions can fail, so
propagate their error values back to the stack instead of silently
ignoring those.

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-5-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 3a9a3a1d5d4be..9c8ed5a03a825 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -468,16 +468,17 @@ static int armada_37xx_pmx_gpio_set_direction(struct pinctrl_dev *pctldev,
 {
 	struct armada_37xx_pinctrl *info = pinctrl_dev_get_drvdata(pctldev);
 	struct gpio_chip *chip = range->gc;
+	int ret;
 
 	dev_dbg(info->dev, "gpio_direction for pin %u as %s-%d to %s\n",
 		offset, range->name, offset, input ? "input" : "output");
 
 	if (input)
-		armada_37xx_gpio_direction_input(chip, offset);
+		ret = armada_37xx_gpio_direction_input(chip, offset);
 	else
-		armada_37xx_gpio_direction_output(chip, offset, 0);
+		ret = armada_37xx_gpio_direction_output(chip, offset, 0);
 
-	return 0;
+	return ret;
 }
 
 static int armada_37xx_gpio_request_enable(struct pinctrl_dev *pctldev,
-- 
2.39.5



