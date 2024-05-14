Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98E6CDC8;
	Tue, 14 May 2024 10:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682228; cv=none; b=PQpWkCEkAUSXmZN+3hHxCqwLiVBzCpMud9mrMNs980PuAYaY6/HHSBfARri3VhNgpom7wwEGj5KEBqsGm9qXwdyru/HbBGbSFR4cNetJcB/VuY9BtTRUSE4LR6OjVXURBOgKbof/RO/Dn05nrCmaaL20y3iHsTGp2WUk15y9Lq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682228; c=relaxed/simple;
	bh=gJhbNBMoZqJr9H08EcH+1MgLLXnUsVXVFJRAzdgbSFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjP8DVWSCNGs9S55iMZ8ma844luQw4XxLetJdoeoQqpl/BHj0gh2W+EGzekBLWHcliPORT9nscdVwGX4MVl/LPguY+gv6xtbMFkVefhgkBUEFhaCGzVZx86EzrcGKLpNq4TsQG+TQNk4DOWF8GO1vfM0/gAeKXZD9eMVJGtGTR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z89a90Yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z89a90Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36EC5C2BD10;
	Tue, 14 May 2024 10:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682227;
	bh=gJhbNBMoZqJr9H08EcH+1MgLLXnUsVXVFJRAzdgbSFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z89a90YjeyGy1qe4gyLKmkUTJ53lNYmkvxXy6cbGfMJyKj0PlH/JwSDEZ9eeFdeSU
	 /ODp+tXxFVxu5oj40D1JJcx64wY068qAb0V+XLEycwXV3o1znPbxVcLBp0v4q6I194
	 hVRhxVD6Dgn7kfvCGpg90IVQkbzCfKnVr7QhcL8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 031/336] spi: axi-spi-engine: use common AXI macros
Date: Tue, 14 May 2024 12:13:55 +0200
Message-ID: <20240514101039.781614450@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 9ace259d2d29d..6b0c72bf3395f 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -6,6 +6,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/fpga/adi-axi-common.h>
 #include <linux/idr.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
@@ -15,12 +16,6 @@
 #include <linux/spi/spi.h>
 #include <linux/timer.h>
 
-#define SPI_ENGINE_VERSION_MAJOR(x)	((x >> 16) & 0xff)
-#define SPI_ENGINE_VERSION_MINOR(x)	((x >> 8) & 0xff)
-#define SPI_ENGINE_VERSION_PATCH(x)	(x & 0xff)
-
-#define SPI_ENGINE_REG_VERSION			0x00
-
 #define SPI_ENGINE_REG_RESET			0x40
 
 #define SPI_ENGINE_REG_INT_ENABLE		0x80
@@ -661,12 +656,12 @@ static int spi_engine_probe(struct platform_device *pdev)
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



