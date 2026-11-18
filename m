Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029389;
	b=JGQhlwe5oGx4qdZVoWUkms5UuuBjrIjGMdfmiNsqgJOxEONZeejSnTsYPoZ7N/rpSXyQ
	 SfDaU97Q6hJXDIQ40M2agzajdqigzijF3OIOjIm3YAIF4QkTQGjZH+CVNqsXZM6Xh+XrF
	 gbq26rJP1CHWCSn7AvyZsxb4gTXpqDueIOs8JMOaxnF6NvF7LF7ytcfR0mGxpF9aHAQPk
	 J2wgs7e/zhpL2eQCQua7tmoCGmhhjqzAPw9mi/fHz26lNlXVl7Mfr5/qgDD9B1UETiI2E
	 R/4JF1Uf/IPb+Ii1ISFNTMiW4oUx4f+Eo9/gKWs/FUHpB4rR2K1lvcA+oDecFHRQO/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029389;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BosRRFKsO1Y6UQ8Yp3Ihsn/aXoGEK3dEL2E0/AayU8Y=;
	b=g6xu7pEgd4e8yigDjR/rN+1T5ut7HOeMzX543APZgtq5WJ3TtvIHORMAs8GdVmhpd+Vn
	 G5mF1heI0JDFVvG0kG0SsG/vDngHNNuydxiNxTvsvOmI1Xr8p4z5enOKZZfu+dBMziNtE
	 I/SAmKMLclEW93Hta82F9/GA8fgUOqNZAdwFrRlD2rRkUYbu/WNqL+wh5jjfFk71sxCAq
	 6xdzI5GRhkjfsnj76xFhgFCGBow1HzWS4SqSe3uCAiI/lc2yOWtuTnxaGSTe/PMY7YE4Q
	 N10vj9UCyL6C542NaccW3pIU/HGWsjH1PHnV9siiyA//aofYd2xqTQWMDTRqE1UEmsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yqp2NDMy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8DF606A320;
	Wed, 18 Nov 2026 19:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yqp2NDMy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871641F000C4;
	Wed, 18 Nov 2026 19:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029389;
	bh=BosRRFKsO1Y6UQ8Yp3Ihsn/aXoGEK3dEL2E0/AayU8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yqp2NDMyAjMykVJIOqIhKZHvqo5LPIDm+bcYVE9de/OMcEAzx0axBNTh9ExQQzlHh
	 eJ+n9oPkFCWcY45jhZbv9tiv9hX1lAyjbC/QBNb3rBu6sBgg3hLLl/+eb9QcFLjDvJ
	 vwwjFXzGxRWpU4OeAiVX00NNDhUBEWjgqkcm36Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0333/1756] dmaengine: sprd: use clk_bulk API to fix clock imbalance
Date: Wed, 18 Nov 2026 15:41:00 +0100
Message-ID: <20261118150021.510124650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit d09cd5e8bbc98969b5333015b45c525078ac0f6f ]

sprd_dma_enable() enabled sdev->clk and then the optional ashb_clk. If
enabling ashb_clk failed, sdev->clk was left enabled: both callers
(probe and resume) treat a non-zero return as "nothing was enabled" and
bail out, leaking sdev->clk.

Convert the driver to the clk_bulk API. clk_bulk_prepare_enable()
enables all clocks and unwinds them on failure, and
clk_bulk_disable_unprepare() disables them, which fixes the imbalance
and simplifies the enable/disable paths. Both clocks are fetched with
devm_clk_bulk_get_optional(); the optional ashb_eb clock simply becomes
a NULL entry that the bulk helpers treat as a no-op, while the mandatory
enable clock is still checked explicitly.

Fixes: 9b3b8171f7f4 ("dmaengine: sprd: Add Spreadtrum DMA driver")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260819053518.2825514-1-nagachaithanya9911@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 45 ++++++++++++------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index f000d5a5add52..a18c4f1eb233e 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -208,8 +208,7 @@ struct sprd_dma_chn {
 struct sprd_dma_dev {
 	struct dma_device	dma_dev;
 	void __iomem		*glb_base;
-	struct clk		*clk;
-	struct clk		*ashb_clk;
+	struct clk_bulk_data	clks[2];
 	int			irq;
 	u32			total_chns;
 	struct sprd_dma_chn	channels[] __counted_by(total_chns);
@@ -260,31 +259,12 @@ static void sprd_dma_chn_update(struct sprd_dma_chn *schan, u32 reg,
 
 static int sprd_dma_enable(struct sprd_dma_dev *sdev)
 {
-	int ret;
-
-	ret = clk_prepare_enable(sdev->clk);
-	if (ret)
-		return ret;
-
-	/*
-	 * The ashb_clk is optional and only for AGCP DMA controller, so we
-	 * need add one condition to check if the ashb_clk need enable.
-	 */
-	if (!IS_ERR(sdev->ashb_clk))
-		ret = clk_prepare_enable(sdev->ashb_clk);
-
-	return ret;
+	return clk_bulk_prepare_enable(ARRAY_SIZE(sdev->clks), sdev->clks);
 }
 
 static void sprd_dma_disable(struct sprd_dma_dev *sdev)
 {
-	clk_disable_unprepare(sdev->clk);
-
-	/*
-	 * Need to check if we need disable the optional ashb_clk for AGCP DMA.
-	 */
-	if (!IS_ERR(sdev->ashb_clk))
-		clk_disable_unprepare(sdev->ashb_clk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(sdev->clks), sdev->clks);
 }
 
 static void sprd_dma_set_uid(struct sprd_dma_chn *schan)
@@ -1140,16 +1120,17 @@ static int sprd_dma_probe(struct platform_device *pdev)
 	if (!sdev)
 		return -ENOMEM;
 
-	sdev->clk = devm_clk_get(&pdev->dev, "enable");
-	if (IS_ERR(sdev->clk)) {
-		dev_err(&pdev->dev, "get enable clock failed\n");
-		return PTR_ERR(sdev->clk);
-	}
+	/* The ashb_eb clock is optional and only present for AGCP DMA */
+	sdev->clks[0].id = "enable";
+	sdev->clks[1].id = "ashb_eb";
+	ret = devm_clk_bulk_get_optional(&pdev->dev, ARRAY_SIZE(sdev->clks),
+					 sdev->clks);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "get clocks failed\n");
 
-	/* ashb clock is optional for AGCP DMA */
-	sdev->ashb_clk = devm_clk_get(&pdev->dev, "ashb_eb");
-	if (IS_ERR(sdev->ashb_clk))
-		dev_warn(&pdev->dev, "no optional ashb eb clock\n");
+	if (!sdev->clks[0].clk)
+		return dev_err_probe(&pdev->dev, -ENOENT,
+				     "get enable clock failed\n");
 
 	/*
 	 * We have three DMA controllers: AP DMA, AON DMA and AGCP DMA. For AGCP
-- 
2.53.0



