Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E8F12FF64;
	Tue, 14 May 2024 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684420; cv=none; b=Fhq8/EgA6M5pMN/vcg1lkZfKipTQQ33Dh0zFhtsL+f0JOHNt9xa6048v3UbRPPNlpzIh10y9ivXKevhcz91v5uZUYACb3wr4I3T9mpaK2jsFhF3faHttAMUkudPZZRwJ0iG5Hv/A2iNZgVW9b+znHOhGs5hMK09BgNjTivn47XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684420; c=relaxed/simple;
	bh=ZC2lTe3F/AGgFRqeOmghbSmgGoCNJbMhAPI2N7RRFRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WitSamQX4sqJW+8b44/RcMsFYfUE+q/ZGElb9c8RV2g6iIq+UFgdh1x66pCa/M0ToaJvLIJyV03/E0+6pcZK8Vj441fEWX349JSpBxUqVMoW6eXHyN0XLJnYEfGELcukBTeuZosCAx+k74sTQ6Zkc/i0AC2nCbsU2ZwsA71QkYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2UQZvM+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2UQZvM+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A98C2BD10;
	Tue, 14 May 2024 11:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684420;
	bh=ZC2lTe3F/AGgFRqeOmghbSmgGoCNJbMhAPI2N7RRFRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2UQZvM+RXQIQtnb0LmMTl5beamldGNPyCFa2i2t0SbPJnzOXb5hbkT62WpkKFgRe7
	 If1GfIhDDVwWAXC3s3NRnzd3RPPSLd6JB4whB0Nfc7ginKGtn9pqo5rLgQR+chaxIK
	 Azv2sFkhRGpHH0vj6/NwydAkt26E3VO4UqMZRjUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/301] spi: axi-spi-engine: use common AXI macros
Date: Tue, 14 May 2024 12:15:10 +0200
Message-ID: <20240514101033.721535778@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 88c2b56c2690061121cad03f0f551db465287575 ]

This avoid duplicating the same macros in multiple drivers by reusing
the common AXI macros for the version register.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240202213132.3863124-2-dlechner@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 0064db9ce4aa ("spi: axi-spi-engine: fix version format string")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index 9ca5b45c4b4cc..9c7b6a92417ce 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/fpga/adi-axi-common.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -14,12 +15,6 @@
 #include <linux/platform_device.h>
 #include <linux/spi/spi.h>
 
-#define SPI_ENGINE_VERSION_MAJOR(x)	((x >> 16) & 0xff)
-#define SPI_ENGINE_VERSION_MINOR(x)	((x >> 8) & 0xff)
-#define SPI_ENGINE_VERSION_PATCH(x)	(x & 0xff)
-
-#define SPI_ENGINE_REG_VERSION			0x00
-
 #define SPI_ENGINE_REG_RESET			0x40
 
 #define SPI_ENGINE_REG_INT_ENABLE		0x80
@@ -535,12 +530,12 @@ static int spi_engine_probe(struct platform_device *pdev)
 	if (IS_ERR(spi_engine->base))
 		return PTR_ERR(spi_engine->base);
 
-	version = readl(spi_engine->base + SPI_ENGINE_REG_VERSION);
-	if (SPI_ENGINE_VERSION_MAJOR(version) != 1) {
+	version = readl(spi_engine->base + ADI_AXI_REG_VERSION);
+	if (ADI_AXI_PCORE_VER_MAJOR(version) != 1) {
 		dev_err(&pdev->dev, "Unsupported peripheral version %u.%u.%c\n",
-			SPI_ENGINE_VERSION_MAJOR(version),
-			SPI_ENGINE_VERSION_MINOR(version),
-			SPI_ENGINE_VERSION_PATCH(version));
+			ADI_AXI_PCORE_VER_MAJOR(version),
+			ADI_AXI_PCORE_VER_MINOR(version),
+			ADI_AXI_PCORE_VER_PATCH(version));
 		return -ENODEV;
 	}
 
-- 
2.43.0



