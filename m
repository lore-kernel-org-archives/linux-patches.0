Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36DA1E51FA;
	Mon, 23 Jun 2025 21:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713932; cv=none; b=nfMV+XdBRDcHmy/jKqUl8tOoyWn/cB6BtC3Zi5PDuuR2h3dl348gjqUkw77SChIU61xSa29PeHbm2hhjuwxzI/VpokfymLMGPQ/XUX64++8EmODqYQMWeemWFsfXwYCK8XVy434RtdUm90rOfgByq0qpkuET5SGnJ1a9Z0+39fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713932; c=relaxed/simple;
	bh=GVBk0gmIVweuYEnQxWbmnex+9zqnl7RXNLFoPtEgEHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWRRbeTh05mdEfeDpBBVjZJmjCdFBv6rbcQbWnM0lngv698DUFmIppilZRfHR8pKc+NNV1vJayAhfpb5DzcG9JmaA4nbBp7worH6nn3Npm/BWrT+S2AMCL8fopAhsXHGu2GdcNAFusWTGsTz/Ne4MYodZZ08dGmOFj6a21KSbgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/I/Tt96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/I/Tt96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C118C4CEEA;
	Mon, 23 Jun 2025 21:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713932;
	bh=GVBk0gmIVweuYEnQxWbmnex+9zqnl7RXNLFoPtEgEHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/I/Tt96agdf47kjW6OQLrre4SR/8pONKdN++luXBkHmzQ2T4qXqC+5AF0ANByG78
	 hvSXukJGFydD+kCwyf6yvap93WsifllwaUTnkMEoUO3+sMrVH7z9ThNwdXbMbNrgAe
	 z4dw+7wGrqbpxiTan9/m/igVNXAeN0i6kv24vox4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 354/592] pinctrl: armada-37xx: propagate error from armada_37xx_pmx_set_by_name()
Date: Mon, 23 Jun 2025 15:05:12 +0200
Message-ID: <20250623130708.862994001@linuxfoundation.org>
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
index 79f9c08e5039c..072bdd0d153ed 100644
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



