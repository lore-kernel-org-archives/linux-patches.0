Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9971A4F12;
	Mon, 23 Jun 2025 22:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716316; cv=none; b=kgXkvm4g/ZHbmbg6OkJcit6c2fCOWIvfv9mhOiPUi9ItdtmHoWrpbJN9Px1Sdiu0E+KxoNRnjG4it/ew8cKEi9+hFz2VtpPYD3i1pvPOFLvfebpJ/ftA73ZeVzxmVKljuECfkOgpuPKcTJ9tsl3A+Xw3ytFBREvQXWnJ5qC4NiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716316; c=relaxed/simple;
	bh=uvHpC2pDmVMqpcAZWA2MUUBSEqnkLnr0YPoZsQceyDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVjbdgSqcCie0rkW6frvdvMBVaZKqL0FDHz/L+xUc5YBiCz+Rfq9u8zf3A2p/jwn0EJNfSsFGmjPamB4m7+r6u8LeFlJkdM5cia8Hm1gpO6ozSBBymlEAjEXEMY+K6XRgvFxjRXNxeSBTj81IaKzF4YgEvKJBSxuQL3iFxXr6ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NI5Vlizn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NI5Vlizn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B30C4CEEA;
	Mon, 23 Jun 2025 22:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716316;
	bh=uvHpC2pDmVMqpcAZWA2MUUBSEqnkLnr0YPoZsQceyDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NI5VliznNcZq2mgAHI44gjiWg+a/HTy+Od/BIayDUIzbNSYJTHzId4hzFlscvwYYW
	 dPEe4WAKD5wL3CEPqVbclS5cjVPZ6ZNj16ycjuMQOcrVGmirbAaCsa8UCxgmKGjI/g
	 MrmaF0WaH6/00wYdnXUZlG8SqoARlYmr7m2T0sYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/411] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get()
Date: Mon, 23 Jun 2025 15:07:45 +0200
Message-ID: <20250623130641.714964287@linuxfoundation.org>
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
index 9c8ed5a03a825..e0dbac0c9227a 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -439,11 +439,14 @@ static int armada_37xx_gpio_get(struct gpio_chip *chip, unsigned int offset)
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



