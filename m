Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CEC28DA1;
	Fri, 24 Nov 2023 18:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaZy0G5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B1E4C433C8;
	Fri, 24 Nov 2023 18:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849378;
	bh=XeMBvAfFbS5Ou4jmvO17SDJZpg/QElGEZ+9i5YrjOBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JaZy0G5vwPi1Qz5bIQkc3ZkUEShIwzw1OoCBlFojAHsTgBaYUYt/fsxwoHzllLf3n
	 lw+K3FDOIpDIX06C97SDr/7WsvZjmJQvXEbl/XSZpDLtjUZgkig4Mra+gFT7T1+s6p
	 Mp0eUCVKKzJsqd8WHLn0oRKj9NjmcKUVdFO/ujqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/530] mtd: rawnand: tegra: add missing check for platform_get_irq()
Date: Fri, 24 Nov 2023 17:45:23 +0000
Message-ID: <20231124172032.865883565@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 0a1166c27d4e53186e6bf9147ea6db9cd1d65847 ]

Add the missing check for platform_get_irq() and return error code
if it fails.

Fixes: d7d9f8ec77fe ("mtd: rawnand: add NVIDIA Tegra NAND Flash controller driver")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230821084046.217025-1-yiyang13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/tegra_nand.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mtd/nand/raw/tegra_nand.c b/drivers/mtd/nand/raw/tegra_nand.c
index eb0b9d16e8dae..a553e3ac8ff41 100644
--- a/drivers/mtd/nand/raw/tegra_nand.c
+++ b/drivers/mtd/nand/raw/tegra_nand.c
@@ -1197,6 +1197,10 @@ static int tegra_nand_probe(struct platform_device *pdev)
 	init_completion(&ctrl->dma_complete);
 
 	ctrl->irq = platform_get_irq(pdev, 0);
+	if (ctrl->irq < 0) {
+		err = ctrl->irq;
+		goto err_put_pm;
+	}
 	err = devm_request_irq(&pdev->dev, ctrl->irq, tegra_nand_irq, 0,
 			       dev_name(&pdev->dev), ctrl);
 	if (err) {
-- 
2.42.0



