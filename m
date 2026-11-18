Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023740;
	b=RhuuvVHq99K9tuPYGq+x3XT+V49DWH76NhDmm4lXXOsA0/dPQ07emczbkKwTlFVpn+vX
	 29BnkUw3GuVSrSsDVW1F07cTKhTWd3JyTA45UtgAG+wff68W5Axg5D0cJP/dTMrR6pA/X
	 N4g9XHkHbjHP1SZeoa6dSxjVBvknZAjXJh+hohUMUgAHy4tMiSQKIYQiEnWIIriv9BUyq
	 bgUYNe8jqOCYyuY3Sc76FPnj5Rv+49azy51iEXiWGZHxw+OOTk3WhQZmBlKHpeSfc7OOf
	 g1Ijm9oS6K0BsvdXy673SEAFFL9UsDty6eKqHIYYrML14G9kf4ViCGS0fiBAAuyvwLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mcDMFBt9gA0F6k4HOXGBaS+IOZUxwmU5l9UKVgTCagA=;
	b=ay0brhPP52w3CCUhGKIUWbZ7M+5JiE6nUiE6/gph22f3scaPSb6CZOrSL2VTzADEgBEa
	 Qsr+3Zd/4/wqVC7syZlBizCPpbrx3bBaaO7CuFoZy5T6NBDyM+0JFmybqnge4PR49BpyS
	 uQb5UKPJtnvmjhkg7VyZhHVcSFGTmixpwaRw6EilBhrgkCwxmwT0OS6KgpEXUUJr1fl5C
	 EALxXTNKUQYpsTeOBIB8uAzpviRafyq1AOPcvC0ALS1ePiWzUDL0pJzjZ6k25swyv6ZLt
	 EVp3YZ3GMxcxZbOGoR7wwrm6TZg953xQurqBMkuYC+1JE5czOkYxEASvALfMHxeBdUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rkZWFIO1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78450606A31C;
	Wed, 18 Nov 2026 17:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rkZWFIO1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC0E1F000C4;
	Wed, 18 Nov 2026 17:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023740;
	bh=mcDMFBt9gA0F6k4HOXGBaS+IOZUxwmU5l9UKVgTCagA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rkZWFIO1CZPBgnVz2TsvdXqIcwXn64T092yASnaP88YbwSmpX9d3MAPk1DqYSFHKZ
	 WHnAdoH+FLpgT3g+tlTH3LFPFBFI3mgmWGhiHL2MxyXX0dQQRWeZKfNnG00S6vn/AJ
	 GGKTRNdV3hOtyRSmAq+feeYxvYy1XHFaflDFScOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0426/2151] clk: sunxi-ng: sun55i-a523-ccu: Use M-only clocks for MBUS, IOMMU and DRAM
Date: Wed, 18 Nov 2026 15:36:01 +0100
Message-ID: <20261118150137.574764056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhui Liu <junhui.liu@pigmoral.tech>

[ Upstream commit 59dced16a82d1ec685b88365c64dde27a0a0b46a ]

The MBUS, IOMMU, and DRAM clocks only have an M divider, but are
currently modeled as MP clocks with a zero-width P divider.

ccu_mp_set_rate() generates an invalid mask for the zero-width P
divider, clearing unrelated register fields. It also ignores
CCU_FEATURE_UPDATE_BIT, so the new divider value does not take effect.

Model these clocks as M-only clocks instead. This avoids accessing a
nonexistent P divider and uses ccu_div_set_rate(), which handles the
update bit.

Fixes: 74b0443a0d0a ("clk: sunxi-ng: a523: add system mod clocks")
Signed-off-by: Junhui Liu <junhui.liu@pigmoral.tech>
Link: https://patch.msgid.link/20260906-sunxi-clk-no-p-v1-2-cbde21c9fe69@pigmoral.tech
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun55i-a523.c | 45 ++++++++++++--------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun55i-a523.c b/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
index 20dad06b37ca3..9bc3ff0ab12d7 100644
--- a/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
+++ b/drivers/clk/sunxi-ng/ccu-sun55i-a523.c
@@ -380,14 +380,13 @@ static const struct clk_parent_data mbus_parents[] = {
 	{ .hw = &pll_periph1_150M_clk.hw },
 	{ .fw_name = "hosc" },
 };
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE_FEAT(mbus_clk, "mbus", mbus_parents,
-					    0x540,
-					    0, 5,		/* M */
-					    0, 0,		/* no P */
-					    24, 3,	/* mux */
-					    BIT(31),	/* gate */
-					    CLK_IS_CRITICAL,
-					    CCU_FEATURE_UPDATE_BIT);
+static SUNXI_CCU_M_DATA_WITH_MUX_GATE_FEAT(mbus_clk, "mbus", mbus_parents,
+					   0x540,
+					   0, 5,	/* M */
+					   24, 3,	/* mux */
+					   BIT(31),	/* gate */
+					   CLK_IS_CRITICAL,
+					   CCU_FEATURE_UPDATE_BIT);
 
 static const struct clk_hw *mbus_hws[] = { &mbus_clk.common.hw };
 
@@ -584,14 +583,13 @@ static const struct clk_parent_data iommu_parents[] = {
 	{ .fw_name = "hosc" },
 };
 
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE_FEAT(iommu_clk, "iommu", iommu_parents,
-					    0x7b0,
-					    0, 5,	/* M */
-					    0, 0,	/* no P */
-					    24, 3,	/* mux */
-					    BIT(31),	/* gate */
-					    CLK_SET_RATE_PARENT,
-					    CCU_FEATURE_UPDATE_BIT);
+static SUNXI_CCU_M_DATA_WITH_MUX_GATE_FEAT(iommu_clk, "iommu", iommu_parents,
+					   0x7b0,
+					   0, 5,	/* M */
+					   24, 3,	/* mux */
+					   BIT(31),	/* gate */
+					   CLK_SET_RATE_PARENT,
+					   CCU_FEATURE_UPDATE_BIT);
 
 static SUNXI_CCU_GATE_HWS(bus_iommu_clk, "bus-iommu", apb0_hws, 0x7bc,
 			  BIT(0), 0);
@@ -603,14 +601,13 @@ static const struct clk_parent_data dram_parents[] = {
 	{ .hw = &pll_periph0_400M_clk.hw },
 	{ .hw = &pll_periph0_150M_clk.hw },
 };
-static SUNXI_CCU_MP_DATA_WITH_MUX_GATE_FEAT(dram_clk, "dram", dram_parents,
-					    0x800,
-					    0, 5,	/* M */
-					    0, 0,	/* no P */
-					    24, 3,	/* mux */
-					    BIT(31),	/* gate */
-					    CLK_IS_CRITICAL,
-					    CCU_FEATURE_UPDATE_BIT);
+static SUNXI_CCU_M_DATA_WITH_MUX_GATE_FEAT(dram_clk, "dram", dram_parents,
+					   0x800,
+					   0, 5,	/* M */
+					   24, 3,	/* mux */
+					   BIT(31),	/* gate */
+					   CLK_IS_CRITICAL,
+					   CCU_FEATURE_UPDATE_BIT);
 
 static SUNXI_CCU_GATE_HWS(mbus_dma_clk, "mbus-dma", mbus_hws,
 			  0x804, BIT(0), 0);
-- 
2.53.0



