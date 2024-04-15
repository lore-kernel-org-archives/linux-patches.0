Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CA0763EC;
	Mon, 15 Apr 2024 14:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191575; cv=none; b=ErrPdnzci4ajqnsDanyrz2N56Jf6qAeRV11q6PyClqAUef16/lBguBwXbhFXxV8Nt94rXWLQtJR/eIaXYwHr1Z3jclsdKnq9IZeqShbG4k/nrNQV9SozmhGApR+CIyUEiuFOLT4//j3mqpkmfEdhydZ9RCfS5DXd0eq9kN2zl3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191575; c=relaxed/simple;
	bh=3s86foBE6QlciR2H/afY4NzBRzYGyJ3Tlu7H8ETMcjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzyMpCfKlvZWyj2OA2pmIyrcSDao5u7GnuNWwmldP2NFshe2ETbkab69yH5Mdt3PoFARCOgt+sGUdQ3ev+BPmo396SkUUboXt7zmK/pTm8z+/SHLkwwq7USEQxeXkvYryn0qhqqCtO7ptMccQ98mMtPAkPS9Es7B3vO0TSMcxls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9DkY1zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9DkY1zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1D8C113CC;
	Mon, 15 Apr 2024 14:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191574;
	bh=3s86foBE6QlciR2H/afY4NzBRzYGyJ3Tlu7H8ETMcjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9DkY1zmn2rAPbAsUlWKbxILZtT7weiRytJCr1OQ9PxacjcIxIBs7DVl5RMcZHpD5
	 yLo500uUDeVn2cVSx/zWUnCGNOAFib+x2UYD84NPb55PSRzgv2phzmZfkNxIIRrMXT
	 MwUj5J0f14+6FSBOYqaaeid8TS0mgh0JoDOk1Dtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/122] ARM: OMAP2+: fix N810 MMC gpiod table
Date: Mon, 15 Apr 2024 16:19:41 +0200
Message-ID: <20240415141953.864241814@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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
index 5ac27ed650e0e..c5b2e1e79698d 100644
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



