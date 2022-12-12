Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A92928ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E39C433F0;
	Mon, 12 Dec 2022 13:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852964;
	bh=yC9GFXn/MWfoAyTdcSdcdiuiQJoUBVaPqUb3tQmBfU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLEN30Y3Y75tPapMzoWycVFhZ6FCUNaX/nXqwlBNb49ec0z56Rg89NDMfo2diQ65j
	 kYZb8Bnq40/3uge8UVg8+vF38wjiYTheDpYcU98ATSv47LFxY+GoMgppCF5ZpOo4Dl
	 GwJ31qpy7cF6Ar6AlSK2726YKuOXZrMYRubAS0O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentina Goncharenko <goncharenko.vp@ispras.ru>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/49] net: encx24j600: Add parentheses to fix precedence
Date: Mon, 12 Dec 2022 14:19:09 +0100
Message-Id: <20221212130915.213100203@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
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
index 46181559d1f1..4a3c0870c8e4 100644
--- a/drivers/net/ethernet/microchip/encx24j600-regmap.c
+++ b/drivers/net/ethernet/microchip/encx24j600-regmap.c
@@ -367,7 +367,7 @@ static int regmap_encx24j600_phy_reg_read(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
@@ -405,7 +405,7 @@ static int regmap_encx24j600_phy_reg_write(void *context, unsigned int reg,
 		goto err_out;
 
 	usleep_range(26, 100);
-	while ((ret = regmap_read(ctx->regmap, MISTAT, &mistat) != 0) &&
+	while (((ret = regmap_read(ctx->regmap, MISTAT, &mistat)) != 0) &&
 	       (mistat & BUSY))
 		cpu_relax();
 
-- 
2.35.1



