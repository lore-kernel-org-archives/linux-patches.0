Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A335E17CA12;
	Mon, 10 Mar 2025 17:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629241; cv=none; b=JkNhiAAyNNBfOsqWokfevYuIpSLfPZ6NB0LiD0YX8xplWN56p5T02bkEMr0oHMEZkNcJsTqaWuYLT85GEu976KIRGszPAf19jOPxOHRb2CdwBLJy9gwuRh/EbcmY01WwE0L+FixVb2v7Oxt8LkRbAymMt5Ijv8VDQMU6+raAZrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629241; c=relaxed/simple;
	bh=bCDo5ZvDUoNWlcgcOPG6A/ebDZHpVw4CZvJzuQvDPFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVGowwIlLhyAYUCWkANgUqIiC3ymIsJ/5EwR8Uabf4EA2z9nxjYcaUjgkiBB00blKvGNf/jrWdsi5QTcOcc2spP5zgnlYVHuYa1rCVlRxHK4Oi3WaedRurljqGtAb1JOw34SJ8p+nWe9ysGzSHq/NVEg5RjR1Y1aDyRiPFZjttk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqHOwNzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqHOwNzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC80C4CEE5;
	Mon, 10 Mar 2025 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629241;
	bh=bCDo5ZvDUoNWlcgcOPG6A/ebDZHpVw4CZvJzuQvDPFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqHOwNzvlmU60Qgr4IVrVeE+M0nWlutVPBeIi5ks9clxI5rPo5r/JoNkxFf7THW79
	 iSSUinzIeJpRH7fAnFW4V/8LdWzmFjse73u6/WDsBSFdYsHBeFgiaqbIKTomsOLkCe
	 mVm+rSC/6ye6Fcq/lOPyBq5wT9a5PCvtBS/++ixY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/620] usb: chipidea/ci_hdrc_imx: Convert to platform remove callback returning void
Date: Mon, 10 Mar 2025 18:01:13 +0100
Message-ID: <20250310170554.585938130@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit ad593ed671feb49e93a77653886c042f68b6cdfd ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart from
emitting a warning) and this typically results in resource leaks. To improve
here there is a quest to make the remove callback return void. In the first
step of this quest all drivers are converted to .remove_new() which already
returns void. Eventually after all drivers are converted, .remove_new() is
renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230517230239.187727-6-u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 74adad500346 ("usb: chipidea: ci_hdrc_imx: decrement device's refcount in .remove() and in the error path of .probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index caa91117ba429..9f4253777d0de 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -505,7 +505,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int ci_hdrc_imx_remove(struct platform_device *pdev)
+static void ci_hdrc_imx_remove(struct platform_device *pdev)
 {
 	struct ci_hdrc_imx_data *data = platform_get_drvdata(pdev);
 
@@ -525,8 +525,6 @@ static int ci_hdrc_imx_remove(struct platform_device *pdev)
 		if (data->hsic_pad_regulator)
 			regulator_disable(data->hsic_pad_regulator);
 	}
-
-	return 0;
 }
 
 static void ci_hdrc_imx_shutdown(struct platform_device *pdev)
@@ -672,7 +670,7 @@ static const struct dev_pm_ops ci_hdrc_imx_pm_ops = {
 };
 static struct platform_driver ci_hdrc_imx_driver = {
 	.probe = ci_hdrc_imx_probe,
-	.remove = ci_hdrc_imx_remove,
+	.remove_new = ci_hdrc_imx_remove,
 	.shutdown = ci_hdrc_imx_shutdown,
 	.driver = {
 		.name = "imx_usb",
-- 
2.39.5



