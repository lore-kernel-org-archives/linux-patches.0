Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1988612E;
	Mon,  8 Apr 2024 13:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583334; cv=none; b=b5Gvg5ohAldzcvAS5i/d1MnN2AXjA8PFreLz/j7m3dhY7LgxPhccoopIV6w/27NCIzuZOl2ipa9fsbvQoUy8/2J0UEtQq8x4jPQb9vIght1IXKRBL4nlaJJYuPvDMV72RK2Iy1dvIxOaXMpAlLFYp10C2c7hAaXfPVmm1LPf1fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583334; c=relaxed/simple;
	bh=QIukKv4ugaC1uOqYK0dKvdYozhGycVYDeQJMb3TwaGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/MDfd7ZAjhWyxNehW430zeU55HRLc2WpXDvUOhpD51kcDXyf8m9n6RleGr3IOkEbgy2pmOkK3WwYL4dKTamyQkI10u2qgdpJtwvQMq21ve1zxbhxvqsAcM1nUkRkcjrdpILUCxH406gqzV/vrIPeuTXEbxVd4PcVpZ2jf+VsX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yq35Lcam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yq35Lcam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 489F6C433F1;
	Mon,  8 Apr 2024 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583334;
	bh=QIukKv4ugaC1uOqYK0dKvdYozhGycVYDeQJMb3TwaGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yq35Lcamvxhrr8TvYwD1DMhv1z0hyDkbaowwK9WQLL1EgdwOgalRi66rQ4rjAB/pk
	 K7wkSTFz/TgQ+rt8ZEXP8sZi455DVs7TFUaBcVnTOgvIANIq7tCjpy6A9qREtvPRKj
	 lwB3fiEgSIrq0LmKb4zzZ6XQfYStkbORAQzxnaPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Peter Griffin <peter.griffin@linaro.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 165/273] spi: s3c64xx: sort headers alphabetically
Date: Mon,  8 Apr 2024 14:57:20 +0200
Message-ID: <20240408125314.392039308@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit a77ce80f63f06d7ae933c332ed77c79136fa69b0 ]

Sorting headers alphabetically helps locating duplicates,
and makes it easier to figure out where to insert new headers.

Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Link: https://lore.kernel.org/r/20240207120431.2766269-2-tudor.ambarus@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: a3d3eab627bb ("spi: s3c64xx: Use DMA mode from fifo size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 432ec60d35684..26d389d95af92 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -3,19 +3,18 @@
 // Copyright (c) 2009 Samsung Electronics Co., Ltd.
 //      Jaswinder Singh <jassi.brar@samsung.com>
 
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
 #include <linux/clk.h>
+#include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/platform_data/spi-s3c64xx.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
 #include <linux/spi/spi.h>
-#include <linux/of.h>
-
-#include <linux/platform_data/spi-s3c64xx.h>
 
 #define MAX_SPI_PORTS		12
 #define S3C64XX_SPI_QUIRK_CS_AUTO	(1 << 1)
-- 
2.43.0



