Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2073AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48662C433D6;
	Thu, 27 Oct 2022 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890419;
	bh=usumVKRXMPZUsGMJcY0f1cVOhkLxyrcKJp9IFOALwIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CvsRarsu0fJFf136E4q0nph9Dm6qBvnLsTlQb8WKwl/be0++uEAdkGawzFpLQtdQ9
	 UylmXNzeE/uHJer68BAXEaCO7jXQt5RpkKjpfj0Df0aGOjBQZvPNmnbPYCO9kZz/1i
	 1HvoIXydh0IunFT9XV0kRVLR97Q+WHNMrwgzzBBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/79] dmaengine: mxs-dma: Remove the unused .id_table
Date: Thu, 27 Oct 2022 18:56:06 +0200
Message-Id: <20221027165056.208663428@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit cc2afb0d4c7cbba6743ed6d9564f0883cab6bae1 ]

The mxs-dma driver is only used by DT platforms and the .id_table
is unused.

Get rid of it to simplify the code.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20201123193051.17285-1-festevam@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 26696d465716 ("dmaengine: mxs: use platform_driver_register")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/mxs-dma.c |   37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -167,29 +167,11 @@ static struct mxs_dma_type mxs_dma_types
 	}
 };
 
-static const struct platform_device_id mxs_dma_ids[] = {
-	{
-		.name = "imx23-dma-apbh",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[0],
-	}, {
-		.name = "imx23-dma-apbx",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[1],
-	}, {
-		.name = "imx28-dma-apbh",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[2],
-	}, {
-		.name = "imx28-dma-apbx",
-		.driver_data = (kernel_ulong_t) &mxs_dma_types[3],
-	}, {
-		/* end of list */
-	}
-};
-
 static const struct of_device_id mxs_dma_dt_ids[] = {
-	{ .compatible = "fsl,imx23-dma-apbh", .data = &mxs_dma_ids[0], },
-	{ .compatible = "fsl,imx23-dma-apbx", .data = &mxs_dma_ids[1], },
-	{ .compatible = "fsl,imx28-dma-apbh", .data = &mxs_dma_ids[2], },
-	{ .compatible = "fsl,imx28-dma-apbx", .data = &mxs_dma_ids[3], },
+	{ .compatible = "fsl,imx23-dma-apbh", .data = &mxs_dma_types[0], },
+	{ .compatible = "fsl,imx23-dma-apbx", .data = &mxs_dma_types[1], },
+	{ .compatible = "fsl,imx28-dma-apbh", .data = &mxs_dma_types[2], },
+	{ .compatible = "fsl,imx28-dma-apbx", .data = &mxs_dma_types[3], },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mxs_dma_dt_ids);
@@ -762,8 +744,6 @@ static struct dma_chan *mxs_dma_xlate(st
 static int __init mxs_dma_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
-	const struct platform_device_id *id_entry;
-	const struct of_device_id *of_id;
 	const struct mxs_dma_type *dma_type;
 	struct mxs_dma_engine *mxs_dma;
 	struct resource *iores;
@@ -779,13 +759,7 @@ static int __init mxs_dma_probe(struct p
 		return ret;
 	}
 
-	of_id = of_match_device(mxs_dma_dt_ids, &pdev->dev);
-	if (of_id)
-		id_entry = of_id->data;
-	else
-		id_entry = platform_get_device_id(pdev);
-
-	dma_type = (struct mxs_dma_type *)id_entry->driver_data;
+	dma_type = (struct mxs_dma_type *)of_device_get_match_data(&pdev->dev);
 	mxs_dma->type = dma_type->type;
 	mxs_dma->dev_id = dma_type->id;
 
@@ -865,7 +839,6 @@ static struct platform_driver mxs_dma_dr
 		.name	= "mxs-dma",
 		.of_match_table = mxs_dma_dt_ids,
 	},
-	.id_table	= mxs_dma_ids,
 };
 
 static int __init mxs_dma_module_init(void)


