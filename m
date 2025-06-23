Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B284409;
	Mon, 23 Jun 2025 22:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716080; cv=none; b=trqUWsBiIMuUDsViUX/+knyC8V9+3JEJYACFd2FzgEbsryNNAesaEgU6v619sN5uRUedqEaP0893Edt6yQTmcPbNRBtEYhsx1S6iiLVi+i6mQXXPaff+jn0saq8bRG0y9SpKPgn6OUoiXRsjsYJRJpE7VeaUZm4of4pPkkhN3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716080; c=relaxed/simple;
	bh=oXkA9Zcg01BSCl9L4iYwnjq3AFsRX1b4IcDTL8dGME4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gb/fQKWH4aBWClOOx5O9lYprNtgvVIiH2lNgnmJTqUjI81SlCsAyKGBo4viSpi+19Q40mQg17kZ22FigqCwvD0+/UtS3IR8NKO2g+rGN9IUBx136x4h2KiaIRHH13NvLG14lwtIptJm4PvY1KTfT4Bnbki+opf9jy7Yl2BghY/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCGB01Si; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCGB01Si"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AAAC4CEEA;
	Mon, 23 Jun 2025 22:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716080;
	bh=oXkA9Zcg01BSCl9L4iYwnjq3AFsRX1b4IcDTL8dGME4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCGB01SizuLIF34QjtLWW5ZhIUrJnnXmb1UPp53VYrLNGoJuXaA6CGu3bnlN+9BLW
	 cWATrOJVCtO8aK7wZLKXvziBaoKRn5JyvPfl5J0HeP81pBHD+8jzT55bqQc/Kp8fqm
	 UKrFDAM/KAG34uF28yxMSG62f6zc34Cka+A2C9mI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/414] pinctrl: armada-37xx: propagate error from armada_37xx_pmx_set_by_name()
Date: Mon, 23 Jun 2025 15:06:03 +0200
Message-ID: <20250623130647.682588839@linuxfoundation.org>
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
index 4ce11c74fec1f..aa6bb1c0d9fa7 100644
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



