Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E70711C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960FAC433C8;
	Mon, 28 Aug 2023 10:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219007;
	bh=t5coIyvRERdy4u5dIqXBW7Q/fFjU6gi2ClRZp739daw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9/bOhJaUt9ks5IbjT1mviIxnlB/eNaefU73yDHDUa7BUAgqnTR24zXvfzdlmIjL6
	 WdPeNnrBcTpk5iOXQhxhuwFxUiSkeWmu4WgOBqqKmk3i2Jts7oYPAvsqibdvgDq6wv
	 7qrf6RFurw/yKL+B2vw4uVrAwZVTnFUD3MhHtDdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yangtao Li <tiny.windzz@gmail.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 001/158] mmc: sdhci_f_sdh30: convert to devm_platform_ioremap_resource
Date: Mon, 28 Aug 2023 12:11:38 +0200
Message-ID: <20230828101157.371325990@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
References: <20230828101157.322319621@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yangtao Li <tiny.windzz@gmail.com>

[ Upstream commit dbf90a178cdcfe255f6e67ecfcf720d1592efb60 ]

Use devm_platform_ioremap_resource() to simplify code.

Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
Link: https://lore.kernel.org/r/20191215175120.3290-7-tiny.windzz@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 5def5c1c15bf ("mmc: sdhci-f-sdh30: Replace with sdhci_pltfm")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_f_sdh30.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mmc/host/sdhci_f_sdh30.c b/drivers/mmc/host/sdhci_f_sdh30.c
index 9548d022d52ba..74757809fc90d 100644
--- a/drivers/mmc/host/sdhci_f_sdh30.c
+++ b/drivers/mmc/host/sdhci_f_sdh30.c
@@ -113,7 +113,6 @@ static int sdhci_f_sdh30_probe(struct platform_device *pdev)
 {
 	struct sdhci_host *host;
 	struct device *dev = &pdev->dev;
-	struct resource *res;
 	int irq, ctrl = 0, ret = 0;
 	struct f_sdhost_priv *priv;
 	u32 reg = 0;
@@ -147,8 +146,7 @@ static int sdhci_f_sdh30_probe(struct platform_device *pdev)
 	host->ops = &sdhci_f_sdh30_ops;
 	host->irq = irq;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	host->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	host->ioaddr = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(host->ioaddr)) {
 		ret = PTR_ERR(host->ioaddr);
 		goto err;
-- 
2.40.1



