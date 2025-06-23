Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCB4226CF1;
	Mon, 23 Jun 2025 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716275; cv=none; b=pgxTJHQk3zg5ROBeESJF/tel7XS1oSU+IsfQmT81cEd5WsXrRGbQowG+waOGYm9ktWeb+RFLA/RycZvOhLEFS2y7f8DqQiQWQF55G1JuuaSB3RtjLdggD6Lh45oC953J+kKaUraoMZCfaH+8fh+zPqM9Lzq2ZbNLHf3unRHz4MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716275; c=relaxed/simple;
	bh=6It1Y4ZbOrWxTxDt4DpgNssZc5SzAydhRI9wMmH2k18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqmDz+kdIkLtnR0DP3+4raUPicCfg8uW7SnwVwJiz3KwkE8rDZbAcRE/XbrzIpb1mZruMCFcq32Ms+FFE10KzN+qPlHrP5eKKUv8coU733NNCU3kg2NkzJMtXHWXGNAzGYpIZ+Qy/RArxwd85bvg9ZqbY1wD/oiyVsTNY9lVBSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngONWlf5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngONWlf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9DFC4CEEA;
	Mon, 23 Jun 2025 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716274;
	bh=6It1Y4ZbOrWxTxDt4DpgNssZc5SzAydhRI9wMmH2k18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngONWlf526LyX1tcYf+uTQHkGVqhWpdKsCML51pm5YWGg9TphWr0/4nsE4OXLDQ0x
	 4D1M5SnfwWDulVZnt6IoeYQkKfkonuX1RJQGZRb8HhfkUaiPiC/WyajX7ep5dPMfIi
	 IMBXo1XdExU+Pv8+MLut23LKPXWd+IUHL0wEbaUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/411] pinctrl: armada-37xx: propagate error from armada_37xx_pmx_set_by_name()
Date: Mon, 23 Jun 2025 15:07:42 +0200
Message-ID: <20250623130641.641211127@linuxfoundation.org>
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

[ Upstream commit 4229c28323db141eda69cb99427be75d3edba071 ]

The regmap_update_bits() function can fail, so propagate its error
up to the stack instead of silently ignoring that.

Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-7-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
index 7ed7b6484d704..e95d30ef5711b 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -354,9 +354,7 @@ static int armada_37xx_pmx_set_by_name(struct pinctrl_dev *pctldev,
 
 	val = grp->val[func];
 
-	regmap_update_bits(info->regmap, reg, mask, val);
-
-	return 0;
+	return regmap_update_bits(info->regmap, reg, mask, val);
 }
 
 static int armada_37xx_pmx_set(struct pinctrl_dev *pctldev,
-- 
2.39.5



