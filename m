Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04442222576;
	Mon, 23 Jun 2025 21:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714765; cv=none; b=NZrowRXqS6HUt3odYA6dN7t2S2xJ6KRRcYWN8cR7n+UW96um14BH0gSwqrLETYv16IC+MSPr2x3f88wBlFY2nn2C4jNq4j0nOpCfou4gPydrtzju5ciZ2UzAfgr+quAS9LpAOED00vojvxlrFJsR73fN41Jwk2FkCT6p4G2HHBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714765; c=relaxed/simple;
	bh=yniziJcUbMzCO/m7mcPKZHxiYJQ0Mj5uamB4DqzzPwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thw9xoWFQitvtF5QlFKv0IkfFTH0VGNLAgZ801zP0sKFNuXrLX32A3Rk7dp3kEzg/5vvIdUFW7qEZSjrMt8bh1IpYcLGUp3/cLphswqi5iI4J8I8QEevUjphT7uAbJJAUXolPvODmoxDq0fm1eUakQFHByrqh7+Bx5NMM8ymfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LOo+B9dr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LOo+B9dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90882C4CEED;
	Mon, 23 Jun 2025 21:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714764;
	bh=yniziJcUbMzCO/m7mcPKZHxiYJQ0Mj5uamB4DqzzPwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LOo+B9drBQAK5rp6MD+WqozdWSfQs16OCk6ZHo+HvkkG4juxAt/z4pju45aw7Rhfh
	 28/G1Q7B1YFZPy5NmiMaTQ2GcOolZLrMzjgt56FwQpX1yA+eqgAXkA0O73u8HxYs0w
	 bTBuC8wjdf895cXKjTLwKlJHs9CJwHgcobiGAa4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/290] pinctrl: armada-37xx: propagate error from armada_37xx_pmx_set_by_name()
Date: Mon, 23 Jun 2025 15:06:58 +0200
Message-ID: <20250623130631.615631211@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a39fd97a9005..1d9aa4e76a23b 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -358,9 +358,7 @@ static int armada_37xx_pmx_set_by_name(struct pinctrl_dev *pctldev,
 
 	val = grp->val[func];
 
-	regmap_update_bits(info->regmap, reg, mask, val);
-
-	return 0;
+	return regmap_update_bits(info->regmap, reg, mask, val);
 }
 
 static int armada_37xx_pmx_set(struct pinctrl_dev *pctldev,
-- 
2.39.5



