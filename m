Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6E51DF98B;
	Mon, 23 Jun 2025 21:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713204; cv=none; b=uPhGp8CeIyh9pjUlxE6yI9exZGew4y/3G9oZw24I+l2id/sq6dOnhsVaYWw69P6Gqthd6ZfVKTLf9AdexctYv7etlmEAz7inE8yJhNOFA6MlxnjmJQXgzcEz441xOoZb+FOCECHH8Gmx8bgnE4O65f+UBcAAVapFXfpA9FmtWP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713204; c=relaxed/simple;
	bh=DA5PKorBnw8NiM2JXr6C+WHKP+FGdTO7txPgBsuDPew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5lz3NkK3VzKDdrQ48mAGnUHI0bwvOJlEk82k2Wuta15Iep1s6/M1Y9QaxLLXIn1j0XmL5keywvHnMCM4xp9yvKrYbNNImquCjRXk9YcyZj0G8k30Vz2NeZx8qT0B1/K4J4u0riWFCUq4FwbdkVJHTA9Er/W49nM1kPJD2B8Jxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qe5hrIIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qe5hrIIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E57C4CEEA;
	Mon, 23 Jun 2025 21:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713204;
	bh=DA5PKorBnw8NiM2JXr6C+WHKP+FGdTO7txPgBsuDPew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qe5hrIIRKjWbWxNEOT/5k3ndGJ0jQB1yk7zQP8dvIg2v5UzNWJQ3Hlo7f+BPk396p
	 1OcITwWgg+WQo+yzqcS0SGbXYW3R/FSaBizNtS7KeVs2Ob1AULyygp/dnFbg8FYpPB
	 ikjY7EAPqRN/+ZFJE9Xv5pPgZ0YmxX3O621C0IRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/222] pinctrl: armada-37xx: propagate error from armada_37xx_gpio_get_direction()
Date: Mon, 23 Jun 2025 15:08:23 +0200
Message-ID: <20250623130617.128403761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 5e0b04e593dc2..d3d156b25e96d 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -395,10 +395,13 @@ static int armada_37xx_gpio_get_direction(struct gpio_chip *chip,
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
 
 	return !(val & mask);
 }
-- 
2.39.5



