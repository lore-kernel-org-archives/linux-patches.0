Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF67070838;
	Mon, 23 Jun 2025 21:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713024; cv=none; b=HLh5yB12+bFinK/8a3pnVIeJkj36v3BeKjil4R7kwUtzeD0erCo06fFqVSHGxs/oe7u9B23mYIz+xW41Px+O3HVVvtl/ADAo1POm9n9G0zU4+PJ+NnMwhVm9Zn+PPIdt908Jvk0qgSiwyPyqPV+sLn5aZ28erEqSOHU7Py7sjBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713024; c=relaxed/simple;
	bh=x0d6YNegH1rxL2FZCRyIYTR+EA/totKp7ZXv8QbbilU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDLFUINaIZWeCwfzEktBJF0kyiQfSpUZovkYvypAqqti8D6rxQrrLH0TI0kWF6r2wvPLsR3bHXqZ3EbTKt1k0vIOSe0ExkKUf475V1hPPNrkbLKx3PIPB6Wvfzxq69yRxQgAqaVsLNGXAewC8LEeZc2MVMGw9i9K1Iiin/qF8bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AgkptfCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AgkptfCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A23C4CEEA;
	Mon, 23 Jun 2025 21:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713024;
	bh=x0d6YNegH1rxL2FZCRyIYTR+EA/totKp7ZXv8QbbilU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgkptfCqUsaLIF8BmLOjz42bfgBbjE+v/oNBi1pUGvl53/34vNZeSZP+tWvRCWPrT
	 ck/uhPnPsIXl7N24ZPrGFy8HBLUNOSdOLVNOD5Yf5KSq3DVa6alhErNjNUCLZzc1FM
	 exxHFSTR6YRvc95NFlWrMR8COChtwDHpoB/nG6JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/222] pinctrl: armada-37xx: propagate error from armada_37xx_pmx_set_by_name()
Date: Mon, 23 Jun 2025 15:08:22 +0200
Message-ID: <20250623130617.098391452@linuxfoundation.org>
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
index bee20c97aed41..5e0b04e593dc2 100644
--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -353,9 +353,7 @@ static int armada_37xx_pmx_set_by_name(struct pinctrl_dev *pctldev,
 
 	val = grp->val[func];
 
-	regmap_update_bits(info->regmap, reg, mask, val);
-
-	return 0;
+	return regmap_update_bits(info->regmap, reg, mask, val);
 }
 
 static int armada_37xx_pmx_set(struct pinctrl_dev *pctldev,
-- 
2.39.5



