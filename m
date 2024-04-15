Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3DD757E1;
	Mon, 15 Apr 2024 14:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191065; cv=none; b=RaAJ3D0QF0BaNRBiD56U5HXFW+zYdpZVpfEXXuAJWVaRSvfl08v7CSP5i4Oy4Joh61zbL9WpcBje7Q7PbOdNumoRFgCXNXRhC8ofruOlLwW08feqzqCPre99EnJ8OuqK3GeGcpx0Qb11cGkbnbeTAfwAHzqdjDaYs3XaXCDbHpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191065; c=relaxed/simple;
	bh=o+q1LSw2TfF35riHvyXgx9hsmlk1RN2n2ItZKDQw6LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kl0x3nO8GHkfx8EHEMMyIraas1aB/D94AxRsjSEwmRG/J1dov+Do53miQyKUGXfO7b02dX53kqjuM8gVF5zUZqYdgUjrYc4b9xmkizFgmd30I5KP7mn8kXSz+e2uKKk/D1/QEjBIY1LSF1fLkZcf/5q7cfASFxv+ifosmwYYW5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mem9FBL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mem9FBL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0824C113CC;
	Mon, 15 Apr 2024 14:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191064;
	bh=o+q1LSw2TfF35riHvyXgx9hsmlk1RN2n2ItZKDQw6LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mem9FBL36KkYIOT5kayPzqpGpOw+2rI5GlxI18gzS0QH+r9LSRv/OMyQdMo3YXI73
	 FuOTfj+OZh2CaZEi418JGuL1+FDwn1zn/OJ8vzCV5uf3L/56D1ACdsFY7+JlGDYNTm
	 0TFb3ERxMx5J+7apjJbICy2TXEZ01yIAnNSCaLI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 021/172] ARM: OMAP2+: fix N810 MMC gpiod table
Date: Mon, 15 Apr 2024 16:18:40 +0200
Message-ID: <20240415142000.996307500@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

From: Aaro Koskinen <aaro.koskinen@iki.fi>

[ Upstream commit 480d44d0820dd5ae043dc97c0b46dabbe53cb1cf ]

Trying to append a second table for the same dev_id doesn't seem to work.
The second table is just silently ignored. As a result eMMC GPIOs are not
present.

Fix by using separate tables for N800 and N810.

Fixes: e519f0bb64ef ("ARM/mmc: Convert old mmci-omap to GPIO descriptors")
Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Message-ID: <20240223181439.1099750-3-aaro.koskinen@iki.fi>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/board-n8x0.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/board-n8x0.c b/arch/arm/mach-omap2/board-n8x0.c
index 3e48f34016c19..c933a91751e4f 100644
--- a/arch/arm/mach-omap2/board-n8x0.c
+++ b/arch/arm/mach-omap2/board-n8x0.c
@@ -140,7 +140,7 @@ static int slot1_cover_open;
 static int slot2_cover_open;
 static struct device *mmc_device;
 
-static struct gpiod_lookup_table nokia8xx_mmc_gpio_table = {
+static struct gpiod_lookup_table nokia800_mmc_gpio_table = {
 	.dev_id = "mmci-omap.0",
 	.table = {
 		/* Slot switch, GPIO 96 */
@@ -152,6 +152,8 @@ static struct gpiod_lookup_table nokia8xx_mmc_gpio_table = {
 static struct gpiod_lookup_table nokia810_mmc_gpio_table = {
 	.dev_id = "mmci-omap.0",
 	.table = {
+		/* Slot switch, GPIO 96 */
+		GPIO_LOOKUP("gpio-96-127", 0, "switch", GPIO_ACTIVE_HIGH),
 		/* Slot index 1, VSD power, GPIO 23 */
 		GPIO_LOOKUP_IDX("gpio-0-31", 23, "vsd", 1, GPIO_ACTIVE_HIGH),
 		/* Slot index 1, VIO power, GPIO 9 */
@@ -412,8 +414,6 @@ static struct omap_mmc_platform_data *mmc_data[OMAP24XX_NR_MMC];
 
 static void __init n8x0_mmc_init(void)
 {
-	gpiod_add_lookup_table(&nokia8xx_mmc_gpio_table);
-
 	if (board_is_n810()) {
 		mmc1_data.slots[0].name = "external";
 
@@ -426,6 +426,8 @@ static void __init n8x0_mmc_init(void)
 		mmc1_data.slots[1].name = "internal";
 		mmc1_data.slots[1].ban_openended = 1;
 		gpiod_add_lookup_table(&nokia810_mmc_gpio_table);
+	} else {
+		gpiod_add_lookup_table(&nokia800_mmc_gpio_table);
 	}
 
 	mmc1_data.nr_slots = 2;
-- 
2.43.0



