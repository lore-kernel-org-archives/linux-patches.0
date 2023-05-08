Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72D2171A8
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:42:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09822C43443;
	Mon,  8 May 2023 11:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683546169;
	bh=IOZYk8KpdKtsbW9Br6tBpxV20ZwRAxeWYvI6+1F/B7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mR0YoP5X+VBN9noYyEipe/KBv+g1MKwO/IyHFyHQMV27uISRN5LGizIG+XaX8HcSx
	 Tb3vp3yWB244bTEVsCWvDlQN2zwQxt3l98CZTb3PL94bwXtI2EXiV6Ut2h2h1+AKSh
	 Qmpt8ehpQL274aiKcn2yJd2adh5zKVqhnv/WLGug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhruva Gole <d-gole@ti.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 279/371] spi: bcm63xx: remove PM_SLEEP based conditional compilation
Date: Mon,  8 May 2023 11:48:00 +0200
Message-Id: <20230508094823.072451257@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dhruva Gole <d-gole@ti.com>

[ Upstream commit 25f0617109496e1aff49594fbae5644286447a0f ]

Get rid of conditional compilation based on CONFIG_PM_SLEEP because
it may introduce build issues with certain configs where it maybe disabled
This is because if above config is not enabled the suspend-resume
functions are never part of the code but the bcm63xx_spi_pm_ops struct
still inits them to non-existent suspend-resume functions.

Fixes: b42dfed83d95 ("spi: add Broadcom BCM63xx SPI controller driver")

Signed-off-by: Dhruva Gole <d-gole@ti.com>
Link: https://lore.kernel.org/r/20230420121615.967487-1-d-gole@ti.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 80fa0ef8909ca..0324ab3ce1c84 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -630,7 +630,6 @@ static int bcm63xx_spi_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM_SLEEP
 static int bcm63xx_spi_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
@@ -657,7 +656,6 @@ static int bcm63xx_spi_resume(struct device *dev)
 
 	return 0;
 }
-#endif
 
 static const struct dev_pm_ops bcm63xx_spi_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(bcm63xx_spi_suspend, bcm63xx_spi_resume)
-- 
2.39.2



