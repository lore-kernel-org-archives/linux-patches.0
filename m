Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DB8470445;
	Tue, 21 Jul 2026 21:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668117; cv=none; b=SzmKuRjlaVIPPH2IUZ44C8zQOO+NORzeuDj0FFaNB1PV6Avnd3WgkOw36iw6XI5cwTFoToi/AQiWe82c8hI1/UrYWdag2YmZrmxGvAWcA0BR+9jj6ml+RKjAYCMbnZLoQkbPgq1HxCxrnRSLxgwu9lQTMNUmiHveOgojJtDJ034=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668117; c=relaxed/simple;
	bh=wzKQG1pVG1fZMryh0mL6Sj6wRJxOMSBQkfPTNgoOzzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bG+h19jth4S28VXA24IdZXi0nt5EQTjmzAFfzKAy+lfYTRRDDDXFyRK1Ka3QhRvKbVZxci+EVLDxqmMbirnUoMADYBxVhIinlJzTDe8qSCkrbggrlAVRC53BpWtUUbeLQPLjXEAJlXbkAC9m6jJG1tFzqrnVsdNnXpoOnSVxSxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uqh3Ydw7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uqh3Ydw7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F9C1F000E9;
	Tue, 21 Jul 2026 21:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668116;
	bh=33MW/9JM+shtXG/WS7dqrC5BEPwpsGynGEAvyhXNWyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uqh3Ydw76B/ybGr4v65FQ11hKEeM5P3QOYY6zeSXoX3mraQFHrVU9b58VtkdFr0c3
	 OOHqK4IfJLsJhNMz5pPPwX3nnPD6+/AGNqhP/Tsu7hIh/B0fuz/wKHjdGLZe8zQ6Z4
	 5WhKQ46f/J4q7IJdOAwZS0XGo3iYVj1WhXkG7Xms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0011/1067] slimbus: Convert to platform remove callback returning void
Date: Tue, 21 Jul 2026 17:10:12 +0200
Message-ID: <20260721152424.784921931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

[ Upstream commit 880b33b0580c8ac9d0202b6e592cb116c99d1b65 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.

To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new(), which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert the slimbus drivers from always returning zero in the
remove callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240430091657.35428-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 2a9d50e9ea40 ("slimbus: qcom-ngd-ctrl: Register callbacks after creating the ngd")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/qcom-ctrl.c     |  5 ++---
 drivers/slimbus/qcom-ngd-ctrl.c | 15 +++++----------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/slimbus/qcom-ctrl.c b/drivers/slimbus/qcom-ctrl.c
index c0c4f895d76e20..31f46000ca030f 100644
--- a/drivers/slimbus/qcom-ctrl.c
+++ b/drivers/slimbus/qcom-ctrl.c
@@ -628,7 +628,7 @@ static int qcom_slim_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int qcom_slim_remove(struct platform_device *pdev)
+static void qcom_slim_remove(struct platform_device *pdev)
 {
 	struct qcom_slim_ctrl *ctrl = platform_get_drvdata(pdev);
 
@@ -637,7 +637,6 @@ static int qcom_slim_remove(struct platform_device *pdev)
 	clk_disable_unprepare(ctrl->rclk);
 	clk_disable_unprepare(ctrl->hclk);
 	destroy_workqueue(ctrl->rxwq);
-	return 0;
 }
 
 /*
@@ -724,7 +723,7 @@ static const struct of_device_id qcom_slim_dt_match[] = {
 
 static struct platform_driver qcom_slim_driver = {
 	.probe = qcom_slim_probe,
-	.remove = qcom_slim_remove,
+	.remove_new = qcom_slim_remove,
 	.driver	= {
 		.name = "qcom_slim_ctrl",
 		.of_match_table = qcom_slim_dt_match,
diff --git a/drivers/slimbus/qcom-ngd-ctrl.c b/drivers/slimbus/qcom-ngd-ctrl.c
index 6003f6f99e1db3..bf2007dc3cd043 100644
--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1537,7 +1537,6 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct qcom_slim_ngd_ctrl *ctrl;
-	struct resource *res;
 	int ret;
 	struct pdr_service *pds;
 
@@ -1547,8 +1546,7 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, ctrl);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ctrl->base = devm_ioremap_resource(dev, res);
+	ctrl->base = devm_platform_get_and_ioremap_resource(pdev, 0, NULL);
 	if (IS_ERR(ctrl->base))
 		return PTR_ERR(ctrl->base);
 
@@ -1609,7 +1607,7 @@ static int qcom_slim_ngd_ctrl_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int qcom_slim_ngd_ctrl_remove(struct platform_device *pdev)
+static void qcom_slim_ngd_ctrl_remove(struct platform_device *pdev)
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
@@ -1617,11 +1615,9 @@ static int qcom_slim_ngd_ctrl_remove(struct platform_device *pdev)
 	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);
 
 	qcom_slim_ngd_unregister(ctrl);
-
-	return 0;
 }
 
-static int qcom_slim_ngd_remove(struct platform_device *pdev)
+static void qcom_slim_ngd_remove(struct platform_device *pdev)
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
@@ -1634,7 +1630,6 @@ static int qcom_slim_ngd_remove(struct platform_device *pdev)
 
 	kfree(ctrl->ngd);
 	ctrl->ngd = NULL;
-	return 0;
 }
 
 static int __maybe_unused qcom_slim_ngd_runtime_idle(struct device *dev)
@@ -1677,7 +1672,7 @@ static const struct dev_pm_ops qcom_slim_ngd_dev_pm_ops = {
 
 static struct platform_driver qcom_slim_ngd_ctrl_driver = {
 	.probe = qcom_slim_ngd_ctrl_probe,
-	.remove = qcom_slim_ngd_ctrl_remove,
+	.remove_new = qcom_slim_ngd_ctrl_remove,
 	.driver	= {
 		.name = "qcom,slim-ngd-ctrl",
 		.of_match_table = qcom_slim_ngd_dt_match,
@@ -1686,7 +1681,7 @@ static struct platform_driver qcom_slim_ngd_ctrl_driver = {
 
 static struct platform_driver qcom_slim_ngd_driver = {
 	.probe = qcom_slim_ngd_probe,
-	.remove = qcom_slim_ngd_remove,
+	.remove_new = qcom_slim_ngd_remove,
 	.driver	= {
 		.name = QCOM_SLIM_NGD_DRV_NAME,
 		.pm = &qcom_slim_ngd_dev_pm_ops,
-- 
2.53.0



