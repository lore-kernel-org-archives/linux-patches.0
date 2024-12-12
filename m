Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E571B223C58;
	Thu, 12 Dec 2024 16:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019470; cv=none; b=ZzZaABApnP6C2CjDZ4j3Oqj7nsoDqp8jxehgn+uFMrArAR3xRQM6+XaS+zie12Oho4ylxn+z7n6pZbHFM0Uk9ad7o3TJR6SbtXJ/ggzthruX7f9yY6BfIxs+LcO5bYW0U5bO+Mu93pYb0F6bO2CrYXgnE19y0l5DkTzD1gvmd/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019470; c=relaxed/simple;
	bh=t8iVE2fri5dxuQ4WjG7RSZGC2wI5oBu1JOL6nmIIkLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C38Sjtrf1jd9W8fgzgGCBRxag0q6IRCg3+rrHXXyBmBvw8W4MNimRQr0+KbRbNJNkFevgvdtR/PD4NRjQ7KsH/gyfaT4N8r0XBN4PTkdu/TVt+cerG9wxDPmFWqBQEMMbduTOMxcaweqruZhV/qTNSF4wBOaE2bFWg5NZQJq5cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gfz4Lfju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gfz4Lfju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C27C4CECE;
	Thu, 12 Dec 2024 16:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019469;
	bh=t8iVE2fri5dxuQ4WjG7RSZGC2wI5oBu1JOL6nmIIkLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gfz4Lfjud3Luaeben9phNZHeh2wb1V3QZ4fcnwEiE4JhdZdMcWVu81Zcwih2BpJtD
	 3PCWz/0qJSn6Fngox0yln9BU4KcXkzLKao+i1mPN404eKSer2ceaCqrkihoHszdZY3
	 w+UAFWQioP5aW9jRgcGick1MmtWh5cwCwBjIGnro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/772] memory: renesas-rpc-if: Remove Runtime PM wrappers
Date: Thu, 12 Dec 2024 15:52:40 +0100
Message-ID: <20241212144358.801912730@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 27e5f98c30d73cdb8c8baeaf7d0af19af5266d3a ]

Now the rpcif_{en,dis}able_rpm() wrappers just take a pointer to a
device structure, there is no point in keeping them.  Remove them, and
update the callers to call Runtime PM directly.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/d87aa5d7e4a39b18f7e2e0649fee0a45b45d371f.1669213027.git.geert+renesas@glider.be
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 7d189579a287 ("mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/rpc-if.c   |  6 +++---
 drivers/spi/spi-rpc-if.c        |  6 +++---
 include/memory/renesas-rpc-if.h | 10 ----------
 3 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/drivers/mtd/hyperbus/rpc-if.c b/drivers/mtd/hyperbus/rpc-if.c
index 41734e337ac00..ef32fca5f785e 100644
--- a/drivers/mtd/hyperbus/rpc-if.c
+++ b/drivers/mtd/hyperbus/rpc-if.c
@@ -130,7 +130,7 @@ static int rpcif_hb_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, hyperbus);
 
-	rpcif_enable_rpm(hyperbus->rpc.dev);
+	pm_runtime_enable(hyperbus->rpc.dev);
 
 	error = rpcif_hw_init(hyperbus->rpc.dev, true);
 	if (error)
@@ -150,7 +150,7 @@ static int rpcif_hb_probe(struct platform_device *pdev)
 	return 0;
 
 out_disable_rpm:
-	rpcif_disable_rpm(hyperbus->rpc.dev);
+	pm_runtime_disable(hyperbus->rpc.dev);
 	return error;
 }
 
@@ -160,7 +160,7 @@ static int rpcif_hb_remove(struct platform_device *pdev)
 
 	hyperbus_unregister_device(&hyperbus->hbdev);
 
-	rpcif_disable_rpm(hyperbus->rpc.dev);
+	pm_runtime_disable(hyperbus->rpc.dev);
 
 	return 0;
 }
diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index 5063587d2c724..ec0904faf3a10 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -147,7 +147,7 @@ static int rpcif_spi_probe(struct platform_device *pdev)
 
 	ctlr->dev.of_node = parent->of_node;
 
-	rpcif_enable_rpm(rpc->dev);
+	pm_runtime_enable(rpc->dev);
 
 	ctlr->num_chipselect = 1;
 	ctlr->mem_ops = &rpcif_spi_mem_ops;
@@ -169,7 +169,7 @@ static int rpcif_spi_probe(struct platform_device *pdev)
 	return 0;
 
 out_disable_rpm:
-	rpcif_disable_rpm(rpc->dev);
+	pm_runtime_disable(rpc->dev);
 	return error;
 }
 
@@ -179,7 +179,7 @@ static int rpcif_spi_remove(struct platform_device *pdev)
 	struct rpcif *rpc = spi_controller_get_devdata(ctlr);
 
 	spi_unregister_controller(ctlr);
-	rpcif_disable_rpm(rpc->dev);
+	pm_runtime_disable(rpc->dev);
 
 	return 0;
 }
diff --git a/include/memory/renesas-rpc-if.h b/include/memory/renesas-rpc-if.h
index d2130c2c8c82f..b1b6d9126b038 100644
--- a/include/memory/renesas-rpc-if.h
+++ b/include/memory/renesas-rpc-if.h
@@ -75,14 +75,4 @@ void rpcif_prepare(struct device *dev, const struct rpcif_op *op, u64 *offs,
 int rpcif_manual_xfer(struct device *dev);
 ssize_t rpcif_dirmap_read(struct device *dev, u64 offs, size_t len, void *buf);
 
-static inline void rpcif_enable_rpm(struct device *dev)
-{
-	pm_runtime_enable(dev);
-}
-
-static inline void rpcif_disable_rpm(struct device *dev)
-{
-	pm_runtime_disable(dev);
-}
-
 #endif // __RENESAS_RPC_IF_H
-- 
2.43.0



