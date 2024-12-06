Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB6D53A7;
	Fri,  6 Dec 2024 15:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497376; cv=none; b=EgTnR5qqhmLyKfZ0l4Nme8hARU+LgqHLhg2vUar3xAZRH4GK1suYudC4w/AtPl8yWuyVBNvfPhUSM7jRVG7eaEAeB7omq86Z4F0uAqjRIwfv86f+fyvYCL8rUC67PeUPSUB5oNlGOzKDRnho7E+fQE9VfSe494Q2batqJdXyljI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497376; c=relaxed/simple;
	bh=EoufOzY4ENeRsW6UFLBUxkM7QwjvtALVbEWPtZaMx9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T418/jA1L06QF+/T+LsYrOdpKtFKMpjswTLOD199AqXe+NlgHWMAdTgQTJPd0n72rjB6Zw0nCWJI5CpAlxjsg2MF0oSCNyT/mRc2w/TRDe0rUXNbP81wbFitKzzB+uf5u2/F3cqPLkSIZyUtPUzwVWRYBaaF6QYsjN+gfiR6FMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwq/RMQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwq/RMQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F28B8C4CEDE;
	Fri,  6 Dec 2024 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497376;
	bh=EoufOzY4ENeRsW6UFLBUxkM7QwjvtALVbEWPtZaMx9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwq/RMQSHDPKOGwSKF2eqQdY+PlYEJUFsuSCNX/tJHwkPtWorH29NDSVkSihlV2S1
	 o1n54GNf8ZJYV/wFF0c3mQoPJM4W/lNAIPjnYlNJOtNCtULBS6wjpEfnQWm3LxMjgT
	 s0RkLZRuEoUXY5fACJY2qc6cKmHY67pwjCzv1EDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/676] mtd: hyperbus: rpc-if: Convert to platform remove callback returning void
Date: Fri,  6 Dec 2024 15:31:32 +0100
Message-ID: <20241206143704.005339131@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit baaa90c1c923ff2412fae0162eb66d036fd3be6b ]

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
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/linux-mtd/20231008200143.196369-11-u.kleine-koenig@pengutronix.de
Stable-dep-of: 7d189579a287 ("mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/rpc-if.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/hyperbus/rpc-if.c b/drivers/mtd/hyperbus/rpc-if.c
index ef32fca5f785e..b22aa57119f23 100644
--- a/drivers/mtd/hyperbus/rpc-if.c
+++ b/drivers/mtd/hyperbus/rpc-if.c
@@ -154,20 +154,18 @@ static int rpcif_hb_probe(struct platform_device *pdev)
 	return error;
 }
 
-static int rpcif_hb_remove(struct platform_device *pdev)
+static void rpcif_hb_remove(struct platform_device *pdev)
 {
 	struct rpcif_hyperbus *hyperbus = platform_get_drvdata(pdev);
 
 	hyperbus_unregister_device(&hyperbus->hbdev);
 
 	pm_runtime_disable(hyperbus->rpc.dev);
-
-	return 0;
 }
 
 static struct platform_driver rpcif_platform_driver = {
 	.probe	= rpcif_hb_probe,
-	.remove	= rpcif_hb_remove,
+	.remove_new = rpcif_hb_remove,
 	.driver	= {
 		.name	= "rpc-if-hyperflash",
 	},
-- 
2.43.0



