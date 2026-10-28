Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215780;
	b=Vc7ZqY99b7Tr3P4dqO209+EDxiWnEqQ8coOL1xUBXQWzAifLLarsq61vLR2yUBp+OZ+X
	 TB4b9s92EZXwS1yylw2yLY7+mQWL1nExbmnrsXoTg0eEXlkkB255zbOFh2tNJvF2BU8gp
	 cR5t1c8SXh1aC/qSdf9heT1NlnfosSzwYFw8/8pAge+RbUgDcoFgev3nHn5wPEO3KI3Px
	 S5rKohSMPAsdI/B3r2+PIupBE+9eb8nalY/2xJ5KGdPr0C5krECbjYwCZjBIO1fChcFlm
	 YK+qwRU3Owz07PY2JvIxIfuPkJs+8w/MeWSFDCBl/9IgA25wP6z3f/OYfML/EvPSEVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BrRtIIRmbWcG1NQrCu0h9BZA7B/nhl/BfGW67iWsMNM=;
	b=spqaqZ+KqgwBT0L+WNNAXaCIVAKSztlgV6RdXji4S/LO8rBbUk9Q1BpXpgfreyegzkYr
	 VNz65lMvoYRIaGP1Dn4CeqibbLYNYrlukZJKRuesaDbiQIr12O7CxXyuocF+BFYR36WfY
	 zyj5OYMLaw3UwA3nKBcCf+vdBLtCFyqrgLsIlL0e+5Egsix9XLKpa1cV68qQimBOsrX7m
	 VHlDXSCvEYaBtxeeJatHAmghnS8Cz3kPAW0dplul29yXgOvGMvVar3Qr3O2DEUxTQ/5I4
	 f2JkuSBrkTvH7CdlwcjS59vj0ZbWI8FodYjdtR1E9anZCFoqS1kTPkd2sz2mtjH55SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEYS8hEM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AE6606A31E;
	Wed, 28 Oct 2026 19:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yEYS8hEM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9209A1F01825;
	Wed, 28 Oct 2026 19:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215780;
	bh=BrRtIIRmbWcG1NQrCu0h9BZA7B/nhl/BfGW67iWsMNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yEYS8hEMBQ9bK8zhScj4WXcnIHZTbllzYifQ6+JFrTfNyBjj+P6D/EBS7VjvYe43v
	 RtTdhipxoeRw0andHoGyDbVmVrZDze94/Ad7C8I7SXvObUWDSczhZ1Vvgt2yZR684g
	 tmBhoXPHHYWs/8P6u31SwhzjRTLo7kDGwKjJev4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1331/1887] soc/xilinx: zynqmp_power: Convert to platform remove callback returning void
Date: Wed, 28 Oct 2026 17:57:07 +0100
Message-ID: <20261028170529.720695835@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5d41763414ad0..f50fc8bf67e9e 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -276,7 +276,7 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int zynqmp_pm_remove(struct platform_device *pdev)
+static void zynqmp_pm_remove(struct platform_device *pdev)
 {
 	sysfs_remove_file(&pdev->dev.kobj, &dev_attr_suspend_mode.attr);
 	if (event_registered)
@@ -284,8 +284,6 @@ static int zynqmp_pm_remove(struct platform_device *pdev)
 
 	if (!rx_chan)
 		mbox_free_channel(rx_chan);
-
-	return 0;
 }
 
 static const struct of_device_id pm_of_match[] = {
@@ -296,7 +294,7 @@ MODULE_DEVICE_TABLE(of, pm_of_match);
 
 static struct platform_driver zynqmp_pm_platform_driver = {
 	.probe = zynqmp_pm_probe,
-	.remove = zynqmp_pm_remove,
+	.remove_new = zynqmp_pm_remove,
 	.driver = {
 		.name = "zynqmp_power",
 		.of_match_table = pm_of_match,
-- 
2.53.0



