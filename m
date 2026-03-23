Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E001280309;
	Mon, 23 Mar 2026 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279438; cv=none; b=AMfYb1wrHG2TmJ/l2wFmE77xJY5MdpuhHTDuMY+NGuPdUmeBPRrYxHV2998CPqZXZgJGj796HuazV3lnFliBeGShwp3zYTzf2thsRS8JGGfIgf9PmyVUHs8PidnhULscNfmmNiwJP1QZRX+Q9zZVy/DPSpIWDE8W990gwSiAShA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279438; c=relaxed/simple;
	bh=5kyWbR8lyyiCVQRBVy1mLR1qMXuFbbsMRoBTilchgts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VQU7+/FQ226y2tkyLYjSzuBeVsZzqJdYpZ+ORSXlRnTVjRBLoqwds4M0LkFVj0it1t4X5q0BSw6GlNRb5NpOolWVZwHpnombT9F5qrBQ7Yeq6WyIhAwTwiMF62mszOTG5Je9LqIs2BvOqiQpnqT3JfWJrdcKzyyt38glho1ppI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gr8O2Z3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gr8O2Z3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEDFC4CEF7;
	Mon, 23 Mar 2026 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279438;
	bh=5kyWbR8lyyiCVQRBVy1mLR1qMXuFbbsMRoBTilchgts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gr8O2Z3rFvAc6GnBzemSBssBOSMXId9+EWOUYjVYPLy+2U7kMWnUJ7DKcV0JuMa7b
	 gRz0wzlwJZu3SWhs2pWnqZoZBym5tauS+mds/DaUqJKYVS+WszKDWtBmx0YEZlGT0X
	 hz9K1O8M8wnizFJg2Ox26LVI0cRYzA7slj2lTBJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/481] bus: omap-ocp2scp: Convert to platform remove callback returning void
Date: Mon, 23 Mar 2026 14:40:19 +0100
Message-ID: <20260323134526.139703981@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

[ Upstream commit 854f89a5b56354ba4135e0e1f0e57ab2caee59ee ]

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

Link: https://lore.kernel.org/r/20231109202830.4124591-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Stable-dep-of: 5eb63e9bb65d ("bus: omap-ocp2scp: fix OF populate on driver rebind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/omap-ocp2scp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
index e02d0656242b8..7d7479ba0a759 100644
--- a/drivers/bus/omap-ocp2scp.c
+++ b/drivers/bus/omap-ocp2scp.c
@@ -84,12 +84,10 @@ static int omap_ocp2scp_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int omap_ocp2scp_remove(struct platform_device *pdev)
+static void omap_ocp2scp_remove(struct platform_device *pdev)
 {
 	pm_runtime_disable(&pdev->dev);
 	device_for_each_child(&pdev->dev, NULL, ocp2scp_remove_devices);
-
-	return 0;
 }
 
 #ifdef CONFIG_OF
@@ -103,7 +101,7 @@ MODULE_DEVICE_TABLE(of, omap_ocp2scp_id_table);
 
 static struct platform_driver omap_ocp2scp_driver = {
 	.probe		= omap_ocp2scp_probe,
-	.remove		= omap_ocp2scp_remove,
+	.remove_new	= omap_ocp2scp_remove,
 	.driver		= {
 		.name	= "omap-ocp2scp",
 		.of_match_table = of_match_ptr(omap_ocp2scp_id_table),
-- 
2.51.0



