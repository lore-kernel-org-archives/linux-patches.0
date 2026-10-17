Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADE337C109;
	Sat, 17 Oct 2026 17:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259487; cv=none; b=dN1L+cNar2rfw93Jydmq60yjsUe3ioKq5et2P2YmbbAwAhOGcbIwCm7f229UiY03J5+OG+4WNSLZ097oriuZhDjGG76dsgHZWOn1bnNj/jB8Rkcc97M9aBaYmdOWDSPNdAj+alPQU+wOzAtcw941LgrD9BlxwqgRzzfiPZ21bPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259487; c=relaxed/simple;
	bh=nNtmScPMOkFYog55SQEAvy9AqRp04fCnUI800k9oNhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jt/OskrD+LlslEQEFM1EoOpMHiJMsp0/6Zf7KJMQvbAprY+rE9W7g2EH9LFPfy0d1tYTdDdPepTpRaVxMfWO8PzfdP8ro/Hp/+AB1+WNQ02dE86dO7skMkAl/7mXxsktZZKeDi3rxYM00FBt3XL2Mz+dMlcNoPApIjZvv7kHBnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNqmVvXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNqmVvXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C53F1F000C4;
	Sat, 17 Oct 2026 17:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259485;
	bh=Hj5pQTW8N1YssIZPW6M79Jfh//iz6hERN45Kq+X0KbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNqmVvXuc1bQRf0/qeD8aHhzdqGo7ols6fgEx3MvCXjMisuHCYFuJyzjnPmg4I1nz
	 PcP4WUC680e0hh2+dgWNZkPnCluB/8dlQ+Yqaczgu44tF9furlX+X+4AGFEgfZ/lrQ
	 7EZ9RLDxe9d4VCs59jyjpFK1l1w3Hnn1JpGftUeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1228/1674] soc/xilinx: zynqmp_power: Convert to platform remove callback returning void
Date: Sat, 17 Oct 2026 17:58:20 +0200
Message-ID: <20261017160502.659516926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

[ Upstream commit f1013d8405af0f4fe1812b5901cbac9ce4d1fb6f ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is ignored (apart
from emitting a warning) and this typically results in resource leaks.
To improve here there is a quest to make the remove callback return
void. In the first step of this quest all drivers are converted to
.remove_new() which already returns void. Eventually after all drivers
are converted, .remove_new() will be renamed to .remove().

Trivially convert this driver from always returning zero in the remove
callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20230925095532.1984344-41-u.kleine-koenig@pengutronix.de
Signed-off-by: Michal Simek <michal.simek@amd.com>
Stable-dep-of: fdee7c66c0d7 ("soc: xilinx: Shutdown and free rx mailbox channel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/zynqmp_power.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/xilinx/zynqmp_power.c b/drivers/soc/xilinx/zynqmp_power.c
index d7c784d77208c..6f6484eafeb45 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -277,7 +277,7 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int zynqmp_pm_remove(struct platform_device *pdev)
+static void zynqmp_pm_remove(struct platform_device *pdev)
 {
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_suspend_mode.attr);
 	if (event_registered)
@@ -285,8 +285,6 @@ static int zynqmp_pm_remove(struct platform_device *pdev)
 
 	if (!rx_chan)
 		mbox_free_channel(rx_chan);
-
-	return 0;
 }
 
 static const struct of_device_id pm_of_match[] = {
@@ -297,7 +295,7 @@ MODULE_DEVICE_TABLE(of, pm_of_match);
 
 static struct platform_driver zynqmp_pm_platform_driver = {
 	.probe = zynqmp_pm_probe,
-	.remove = zynqmp_pm_remove,
+	.remove_new = zynqmp_pm_remove,
 	.driver = {
 		.name = "zynqmp_power",
 		.of_match_table = pm_of_match,
-- 
2.53.0



