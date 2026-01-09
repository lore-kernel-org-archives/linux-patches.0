Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E1B35B149;
	Fri,  9 Jan 2026 12:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963012; cv=none; b=DLlU8vbgwqFpLYlJYpmrviqDzSOseSF73DB16o10o7KbarLSpvA/Iuf0Cfl96sxlmzaJeO0gGQtuBenY3o5AImTv6hxDsUvBMB5akFZfcnJJUSYNONkd2uz/HWGQmEUZsLkd1RTYeamCgc6roMa76Yby1eP1gSqDGZqF3LZ0+uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963012; c=relaxed/simple;
	bh=sEUPC6bfssgJQmTWoLIMsK4RMy60bvmMNsAeYNV6c7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/n8eNLlgqABXJenrx75+O+MUm/9C3WeSkFZK9wu03cg+GQwE4ji0co7gNc8ydjjRmxu+QEhhpHCjVmqKDDxcwO/F06bmTft2dK3UUDRSr421OoqCKn9/JV4qXjux1BJhVIqnTzrS+q8CQpG6/Cdz1TqWEaY0fBEOEe9mdjNTCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sZ+X9L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sZ+X9L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B1CDC4CEF1;
	Fri,  9 Jan 2026 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963012;
	bh=sEUPC6bfssgJQmTWoLIMsK4RMy60bvmMNsAeYNV6c7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0sZ+X9L1oLMKPxmXdoPPnzD6wnqljweKzuizObfhpZ17/Z+Ug4R3jK/ZdEJd+EbGK
	 vyhUC5yz3Hgpi/OP0J7ldwK10DF47j3amwYuDQhvVqj6joOVEilC8kmnutPy+806+v
	 aLJdATTheIcfKke/6Q4hPIjk75pWMk1EAJI8OLFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 567/634] iommu/mtk_iommu_v1: Convert to platform remove callback returning void
Date: Fri,  9 Jan 2026 12:44:05 +0100
Message-ID: <20260109112138.940152581@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 85e1049e50da9409678fc247ebad4c019d68041f ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230321084125.337021-9-u.kleine-koenig@pengutronix.de
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 46207625c9f3 ("iommu/mediatek-v1: fix device leaks on probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/mtk_iommu_v1.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iommu/mtk_iommu_v1.c
+++ b/drivers/iommu/mtk_iommu_v1.c
@@ -708,7 +708,7 @@ out_clk_unprepare:
 	return ret;
 }
 
-static int mtk_iommu_v1_remove(struct platform_device *pdev)
+static void mtk_iommu_v1_remove(struct platform_device *pdev)
 {
 	struct mtk_iommu_v1_data *data = platform_get_drvdata(pdev);
 
@@ -718,7 +718,6 @@ static int mtk_iommu_v1_remove(struct pl
 	clk_disable_unprepare(data->bclk);
 	devm_free_irq(&pdev->dev, data->irq, data);
 	component_master_del(&pdev->dev, &mtk_iommu_v1_com_ops);
-	return 0;
 }
 
 static int __maybe_unused mtk_iommu_v1_suspend(struct device *dev)
@@ -757,7 +756,7 @@ static const struct dev_pm_ops mtk_iommu
 
 static struct platform_driver mtk_iommu_v1_driver = {
 	.probe	= mtk_iommu_v1_probe,
-	.remove	= mtk_iommu_v1_remove,
+	.remove_new = mtk_iommu_v1_remove,
 	.driver	= {
 		.name = "mtk-iommu-v1",
 		.of_match_table = mtk_iommu_v1_of_ids,


