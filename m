Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD029443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A687C433C8;
	Sun, 13 Aug 2023 21:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962341;
	bh=kSz1TJ3NRCKiu8w78gSxuMaRWNMubIwm6rKfWJI0BtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bq47uQyv7SEBd3JvXKuA/DPOVst7auRT4sZsHneQYU19KeKYG83AWB8Ne180uiMOV
	 io8HaMkU1RXH8O/qvD/miOqbQOKUe4uyIfI4uMHp1nNmd6Ffeu0/Je1jTKAzzgwPtR
	 yI+w366ZulMWb18jJ6jW6D55dAs0uDMFL84qXvz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Michael Shych <michaelsh@nvidia.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.4 201/206] platform: mellanox: mlx-platform: Fix signals polarity and latch mask
Date: Sun, 13 Aug 2023 23:19:31 +0200
Message-ID: <20230813211730.760573479@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Pasternak <vadimp@nvidia.com>

commit 3c91d7e8c64f75c63da3565d16d5780320bd5d76 upstream.

Change polarity of chassis health and power signals and fix latch reset
mask for L1 switch.

Fixes: dd635e33b5c9 ("platform: mellanox: Introduce support of new Nvidia L1 switch")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Michael Shych <michaelsh@nvidia.com>
Link: https://lore.kernel.org/r/20230813083735.39090-3-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/mlx-platform.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 5fb3348023a7..69256af04f05 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -237,7 +237,7 @@
 #define MLXPLAT_CPLD_GWP_MASK		GENMASK(0, 0)
 #define MLXPLAT_CPLD_EROT_MASK		GENMASK(1, 0)
 #define MLXPLAT_CPLD_PWR_BUTTON_MASK	BIT(0)
-#define MLXPLAT_CPLD_LATCH_RST_MASK	BIT(5)
+#define MLXPLAT_CPLD_LATCH_RST_MASK	BIT(6)
 #define MLXPLAT_CPLD_THERMAL1_PDB_MASK	BIT(3)
 #define MLXPLAT_CPLD_THERMAL2_PDB_MASK	BIT(4)
 #define MLXPLAT_CPLD_INTRUSION_MASK	BIT(6)
@@ -2475,7 +2475,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_l1_switch_events_items[] = {
 		.reg = MLXPLAT_CPLD_LPC_REG_PWRB_OFFSET,
 		.mask = MLXPLAT_CPLD_PWR_BUTTON_MASK,
 		.count = ARRAY_SIZE(mlxplat_mlxcpld_l1_switch_pwr_events_items_data),
-		.inversed = 0,
+		.inversed = 1,
 		.health = false,
 	},
 	{
@@ -2484,7 +2484,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_l1_switch_events_items[] = {
 		.reg = MLXPLAT_CPLD_LPC_REG_BRD_OFFSET,
 		.mask = MLXPLAT_CPLD_L1_CHA_HEALTH_MASK,
 		.count = ARRAY_SIZE(mlxplat_mlxcpld_l1_switch_health_events_items_data),
-		.inversed = 0,
+		.inversed = 1,
 		.health = false,
 		.ind = 8,
 	},
@@ -3677,7 +3677,7 @@ static struct mlxreg_core_data mlxplat_mlxcpld_default_ng_regs_io_data[] = {
 	{
 		.label = "latch_reset",
 		.reg = MLXPLAT_CPLD_LPC_REG_GP1_OFFSET,
-		.mask = GENMASK(7, 0) & ~BIT(5),
+		.mask = GENMASK(7, 0) & ~BIT(6),
 		.mode = 0200,
 	},
 	{
-- 
2.41.0



