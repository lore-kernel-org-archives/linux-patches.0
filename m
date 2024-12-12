Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C123223C46;
	Thu, 12 Dec 2024 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019473; cv=none; b=DJ2nCOsw3VHK8nRZ7S+yGZ4WMy1mYf7i+n8xTkkxX/l7dSogw1nmQux7P2c9jtUGK3ZnjRBneTrcOqCkRtf0vBzuJ3r1f6snPW/Yr6tg7x6M37a7Yy7iR2zhu3jjxnsVtiX7GKSRvZcG8O2sg2Md87GooWS230UlDhpoGGXopPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019473; c=relaxed/simple;
	bh=Pj/8TaB0NrLF79Ow/JmFZmMHWq/DHkW1baku7afNPfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=urc6hCusRAer7iSkfp8wfJzAliH2xI1C4RYian6K9qmz3xh4GqEhs+Q6nvikID/AweBpDdXOrRXgILXXN2bMleXcLFBoTCR43Tg6y+Cc/9n4fn86ksTf2rTAbz+9ZTWkABGrS+3SehgFzCSBQk4+PCtxGXmAH5cbWO77cwOIHjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QHNIvYcv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QHNIvYcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA005C4CECE;
	Thu, 12 Dec 2024 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019473;
	bh=Pj/8TaB0NrLF79Ow/JmFZmMHWq/DHkW1baku7afNPfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QHNIvYcvP8mB2cVins0yBaao25QeTZOJzL6TBVXjIkdd0GCsqkrwAj/kA6YqBCwmO
	 COt2REf0FIYZC0pN2Y2tJjOd3dc5dM9ID7WYM8lBZp4Sc8YUl8Tllai+VpNUK0sHSS
	 PTnWRUzSYKtyztFjNJiKWI0juRFZ00ZbZ0aFFiWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/772] mtd: hyperbus: rpc-if: Convert to platform remove callback returning void
Date: Thu, 12 Dec 2024 15:52:41 +0100
Message-ID: <20241212144358.840909815@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



