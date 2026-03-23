Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FD43AB295;
	Mon, 23 Mar 2026 14:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277618; cv=none; b=PjKsukSmzFl+RsaFYbWwaECDNArJRSE17+5Aypsyq7fzZQ1p8kiM0yYwNHwtljjOYSQqn2erTxcyUbEyNgHNOcjlYViJzi/0X90r91bsdbHV+toHhqOU9axl4CVi5dOzKTwwIlmxD+jH9ql5W+hExX7s7teAnD60ybpVJmpVHwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277618; c=relaxed/simple;
	bh=XbjOLcqtP30lVa/It6CUL7Os0hjrdq7GEyj/brI67Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imhxSDLc/lE7tH1p6eMGJW5E7TFgIJtxWzbpHKjW96dFKMOob9kuyVuX1rKG7XhznvSco8+j5a/zEPAVIn6o7HqQQ3hYy8SG6FUzQpOFe7jaqzjnqvAPYBDJkITpQcS+0wJGSxJsKDVR0vxhpFpd1nfap2kVPBNJkL5jzIZtozU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sja4mFzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sja4mFzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31E2C2BCB9;
	Mon, 23 Mar 2026 14:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277617;
	bh=XbjOLcqtP30lVa/It6CUL7Os0hjrdq7GEyj/brI67Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sja4mFzAexjIdHwfojcC4i7glPP3OJjlItCTmzqIIKV+MujtcxtTv5mR2TJx54Qzd
	 ECYMVIfhAVSlArnsBqNKNuPsYXLrYT7nu+WJGJFwGw9ZhKa2+i6EaeKQ+J7knhRNaW
	 pMOOC6F+hLMRBHBDhbDJVoR6mWGH4J/H9o72G8Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/567] memory: mtk-smi: Convert to platform remove callback returning void
Date: Mon, 23 Mar 2026 14:39:07 +0100
Message-ID: <20260323134534.445279401@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 6cfa038bddd7 ("memory: mtk-smi: fix device leaks on common probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mtk-smi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index 6523cb5105182..572c7fbdcfd3a 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -566,14 +566,13 @@ static int mtk_smi_larb_probe(struct platform_device *pdev)
 	return ret;
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
@@ -616,7 +615,7 @@ static const struct dev_pm_ops smi_larb_pm_ops = {
 
 static struct platform_driver mtk_smi_larb_driver = {
 	.probe	= mtk_smi_larb_probe,
-	.remove	= mtk_smi_larb_remove,
+	.remove_new = mtk_smi_larb_remove,
 	.driver	= {
 		.name = "mtk-smi-larb",
 		.of_match_table = mtk_smi_larb_of_ids,
@@ -795,14 +794,13 @@ static int mtk_smi_common_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int mtk_smi_common_remove(struct platform_device *pdev)
+static void mtk_smi_common_remove(struct platform_device *pdev)
 {
 	struct mtk_smi *common = dev_get_drvdata(&pdev->dev);
 
 	if (common->plat->type == MTK_SMI_GEN2_SUB_COMM)
 		device_link_remove(&pdev->dev, common->smi_common_dev);
 	pm_runtime_disable(&pdev->dev);
-	return 0;
 }
 
 static int __maybe_unused mtk_smi_common_resume(struct device *dev)
@@ -842,7 +840,7 @@ static const struct dev_pm_ops smi_common_pm_ops = {
 
 static struct platform_driver mtk_smi_common_driver = {
 	.probe	= mtk_smi_common_probe,
-	.remove = mtk_smi_common_remove,
+	.remove_new = mtk_smi_common_remove,
 	.driver	= {
 		.name = "mtk-smi-common",
 		.of_match_table = mtk_smi_common_of_ids,
-- 
2.51.0



