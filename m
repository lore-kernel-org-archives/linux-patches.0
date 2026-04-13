Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6C424DCF6;
	Mon, 13 Apr 2026 16:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097115; cv=none; b=CFA8BvxcZ0XYYy73sgNRrhdr0qrLuetzKQ/pyMMeANgKsV7v9lHoB2eC3m7SVqXW0zB2utYd3raqNZxrawN1SoSmhESZMDJcFktXtCpr3dXN/TkQaTgFOZtKkrRpQLBCKmNnzKBuSUyqiF7WtxsQAuOWoIqXDFYiE68EAv9hC5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097115; c=relaxed/simple;
	bh=Uq5dJ1ABAHEEk4K9eswGp34KNGBlsjEYuzBCLrBHeMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BoYmVj0lLrQ/L7dRx/UB/leyfHEpJd+d33TbEFofqVFp38krSYKi7xPp5UOWRDg1ohe4t9A9bllRddvQMzsEicbe0ktSYurOYBjNLZPtxqXz6ssZPSPnAhcYnXTSNsn0nIcG/nhOSiyPxp7RlI1gQItFnZIemUCOW8osWohFc0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLN9ytUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLN9ytUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71DCC2BCAF;
	Mon, 13 Apr 2026 16:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097115;
	bh=Uq5dJ1ABAHEEk4K9eswGp34KNGBlsjEYuzBCLrBHeMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLN9ytUV5dSu64GgqSWSDQznYXp70Svf7GePD3WLO7BJawj/44lvbglwr45zBPgtN
	 CIVZRo12XvXbiULy8ni07+9tsvDZBL+bvCw7pLdLK157cgPOHkfkAvZysMNmNccn0h
	 f2TpOODuH3+R8jYR7tAnQGfr0Jq0t//zG2wmMSVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/570] memory: mtk-smi: Convert to platform remove callback returning void
Date: Mon, 13 Apr 2026 17:52:23 +0200
Message-ID: <20260413155830.859998297@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 08c1aeaa45ce0fd18912e92c6705586c8aa5240f ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/5c35a33cfdc359842e034ddd2e9358f10e91fa1f.1702822744.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 9dae65913b32 ("memory: mtk-smi: fix device leak on larb probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mtk-smi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index c5fb51f73b341..c317bcf49ebcd 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -375,14 +375,13 @@ static int mtk_smi_larb_probe(struct platform_device *pdev)
 	return component_add(dev, &mtk_smi_larb_component_ops);
 }
 
-static int mtk_smi_larb_remove(struct platform_device *pdev)
+static void mtk_smi_larb_remove(struct platform_device *pdev)
 {
 	struct mtk_smi_larb *larb = platform_get_drvdata(pdev);
 
 	device_link_remove(&pdev->dev, larb->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
 	component_del(&pdev->dev, &mtk_smi_larb_component_ops);
-	return 0;
 }
 
 static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
@@ -419,7 +418,7 @@ static const struct dev_pm_ops smi_larb_pm_ops = {
 
 static struct platform_driver mtk_smi_larb_driver = {
 	.probe	= mtk_smi_larb_probe,
-	.remove	= mtk_smi_larb_remove,
+	.remove_new = mtk_smi_larb_remove,
 	.driver	= {
 		.name = "mtk-smi-larb",
 		.of_match_table = mtk_smi_larb_of_ids,
@@ -549,10 +548,9 @@ static int mtk_smi_common_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int mtk_smi_common_remove(struct platform_device *pdev)
+static void mtk_smi_common_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
-	return 0;
 }
 
 static int __maybe_unused mtk_smi_common_resume(struct device *dev)
@@ -588,7 +586,7 @@ static const struct dev_pm_ops smi_common_pm_ops = {
 
 static struct platform_driver mtk_smi_common_driver = {
 	.probe	= mtk_smi_common_probe,
-	.remove = mtk_smi_common_remove,
+	.remove_new = mtk_smi_common_remove,
 	.driver	= {
 		.name = "mtk-smi-common",
 		.of_match_table = mtk_smi_common_of_ids,
-- 
2.51.0



