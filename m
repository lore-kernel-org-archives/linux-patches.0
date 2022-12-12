Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEB628ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D04CC433D2;
	Mon, 12 Dec 2022 13:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851052;
	bh=Ifsob09A2HnLkQYwGfDz21JX4bOqjQMUir02pR9HhGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZOGMGsgoE2/sFUyc/Zw/SBZnwzrwAbRajf+jWr1K3GvFqNqAZdjdCSGJsWW7IdAY
	 ygUmgwTuipwVYSgie0AW47EPUlj2O05VMpg7x4OYhSaRyUsY5aI+x9HlbJaW9mgPyI
	 y3XcWMRWyS6IHnVAgB9oYzTCrJucouBauyA3bKOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentina Goncharenko <goncharenko.vp@ispras.ru>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/106] net: encx24j600: Add parentheses to fix precedence
Date: Mon, 12 Dec 2022 14:10:24 +0100
Message-Id: <20221212130928.411650255@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Valentina Goncharenko <goncharenko.vp@ispras.ru>

[ Upstream commit 167b3f2dcc62c271f3555b33df17e361bb1fa0ee ]

In functions regmap_encx24j600_phy_reg_read() and
regmap_encx24j600_phy_reg_write() in the conditions of the waiting
cycles for filling the variable 'ret' it is necessary to add parentheses
to prevent wrong assignment due to logical operations precedence.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d70e53262f5c ("net: Microchip encx24j600 driver")
Signed-off-by: Valentina Goncharenko <goncharenko.vp@ispras.ru>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/encx24j600-regmap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/encx24j600-regmap.c b/drivers/net/ethernet/microchip/encx24j600-regmap.c
index 81a8ccca7e5e..2e337c7a5773 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -359,7 +359,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -397,7 +397,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
-- 
2.35.1



