Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3B8143C49;
	Tue, 23 Apr 2024 21:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908721; cv=none; b=QB9c16hbG+n+lqOl/WNAks//y4Y8INd/niE/UH3vjIy8T0NWVfyOiysbUaiCcqE3jr4ueOi2aLPLfnQt8ZE/uR0qXiuFA9r7bi9CPyFJxuuqjr6UPQ908VLZavZbz6b+SglvJQQiM1fwbd1nq/fyEUZZYhs/67RZhFE7D/bTDMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908721; c=relaxed/simple;
	bh=F3psvxwPC28fuc5QluIkpWevUVxQOwFnK1hY7f8wGBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGqXTt2GIawOQGlfO70nDesW9sCXjqt0b1eP3dAVlkBYNbNFrsc5q8eNX87YlXUU9EIQf0gwFGaouTVu1sCyvIvHfmpm1N+51i9OvKWH5PNYawMiVwEj9YiuYkL9yw/JdnjWNInD2yEyR28Ebu0w+Xz6s9ZlYArsxhhDh9SS/AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B6c8uQ0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B6c8uQ0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE454C116B1;
	Tue, 23 Apr 2024 21:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908721;
	bh=F3psvxwPC28fuc5QluIkpWevUVxQOwFnK1hY7f8wGBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6c8uQ0Ti2Ip2U9l5OtSr0pC1FrGhR49E5O1/KLgZSS+O5lqymnOIHWblDP/6RCfU
	 X0nxIhWk4ZcIXL0tXCLsdBvAPHwchdkwN0Xjz+Eq2zTItTTFe9TnXleu1J4VcM4gMz
	 b9UC151Uhp54aUvu5+Nj0yCzhlw8vS20H4eErWO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Tony Lindgren <tony@atomide.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/141] ARM: omap2: n8x0: stop instantiating codec platform data
Date: Tue, 23 Apr 2024 14:38:43 -0700
Message-ID: <20240423213855.037024637@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit faf3b5cb59f84e4056bd84f115a958bc99c61e65 ]

As of 0426370b58b2 ("ARM: dts: omap2420-n810: Correct the audio codec
(tlv320aic33) node") the DTS properly specifies reset GPIO, and the
device name in auxdata lookup table does not even match the one in
device tree anymore, so stop instantiating it.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20221102232004.1721864-1-dmitry.torokhov@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/board-n8x0.c           | 5 -----
 arch/arm/mach-omap2/common-board-devices.h | 2 --
 arch/arm/mach-omap2/pdata-quirks.c         | 1 -
 3 files changed, 8 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 5e86145db0e2a..8897364e550ba 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -22,7 +22,6 @@
 #include <linux/platform_data/spi-omap2-mcspi.h>
 #include <linux/platform_data/mmc-omap.h>
 #include <linux/mfd/menelaus.h>
-#include <sound/tlv320aic3x.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach-types.h>
@@ -567,10 +566,6 @@ struct menelaus_platform_data n8x0_menelaus_platform_data = {
 	.late_init = n8x0_menelaus_late_init,
 };
 
-struct aic3x_pdata n810_aic33_data = {
-	.gpio_reset = 118,
-};
-
 static int __init n8x0_late_initcall(void)
 {
 	if (!board_caps)
diff --git a/arch/arm/mach-omap2/common-board-devices.h b/arch/arm/mach-omap2/common-board-devices.h
index b23962c38fb27..69694af714751 100644
--- a/arch/arm/mach-omap2/common-board-devices.h
+++ b/arch/arm/mach-omap2/common-board-devices.h
@@ -2,12 +2,10 @@
 #ifndef __OMAP_COMMON_BOARD_DEVICES__
 #define __OMAP_COMMON_BOARD_DEVICES__
 
-#include <sound/tlv320aic3x.h>
 #include <linux/mfd/menelaus.h>
 
 void *n8x0_legacy_init(void);
 
 extern struct menelaus_platform_data n8x0_menelaus_platform_data;
-extern struct aic3x_pdata n810_aic33_data;
 
 #endif /* __OMAP_COMMON_BOARD_DEVICES__ */
diff --git a/arch/arm/mach-omap2/pdata-quirks.c b/arch/arm/mach-omap2/pdata-quirks.c
index 5b99d602c87bc..9deba798cc919 100644
--- a/arch/arm/mach-omap2/pdata-quirks.c
+++ b/arch/arm/mach-omap2/pdata-quirks.c
@@ -440,7 +440,6 @@ static struct of_dev_auxdata omap_auxdata_lookup[] = {
 #ifdef CONFIG_MACH_NOKIA_N8X0
 	OF_DEV_AUXDATA("ti,omap2420-mmc", 0x4809c000, "mmci-omap.0", NULL),
 	OF_DEV_AUXDATA("menelaus", 0x72, "1-0072", &n8x0_menelaus_platform_data),
-	OF_DEV_AUXDATA("tlv320aic3x", 0x18, "2-0018", &n810_aic33_data),
 #endif
 #ifdef CONFIG_ARCH_OMAP3
 	OF_DEV_AUXDATA("ti,omap2-iommu", 0x5d000000, "5d000000.mmu",
-- 
2.43.0



