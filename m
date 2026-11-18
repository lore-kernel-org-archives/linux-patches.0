Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016195;
	b=Cnv+yCGxa7vM2I8yx04Yt1rU+J8Wk1lLXd+fKgH4gNt2ljMmjvJPZai48MpIhPmadXP7
	 WOqV1A+QdAXBAboW5iLip6+mhAc2wx0w9MDTrEfvsephwy0yLj0H0yLfnP2W13VQD5yme
	 3xBx9winz4ammDy/Br5fxnaiDDEfBGdQpBr7d3rPTpRk9O5FzYKvoCvEq1pVOVvEXTozQ
	 x7bzVKbiK+Qs/O6ASlXdXJClQLzL8LF3JToQYmEZA+bySfu+tjud3jsaDXKyaE8mkH+ux
	 KTMjCWRg40TG8oR505dsMQKXI1tavP5KQ2N6zeD/ONHn9c/HvhVYDFVei6I0fVBcWcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7V1Xt1988ty1h3jrCDrziylSVuEW0OAcYkAjqpod+FE=;
	b=yq53trKxdCslN9VR3aU9/BWWgI1iyqBmKzqKoVQ2zDpkgAdeOUNobiLVODYiakjFQeNN
	 xN+liZOlM1KNZsqzIb0u6/AlbTCimbQxLHEbHtilamaYErK0r8xLIlmtcSxP2Yu+qFIdu
	 DxrEpisHjTktlb6OT02LbKlNatqvppx2s9X7Hh//rnaUl7rR/BY17JawJUxEzCp7S3bgP
	 STezHsYIDjQNIA0rt5QmzWZF0RqLCt/OkIj/mQ1n2zwH8vZtdteO8QEsUi8KolFFYGcBH
	 dYXUZ3Yz+1QzO+yF8slL7OraznDflNBgN4yEkrgl/O+l+0r4mlgYc/KvNLRaMF0n//g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sm+MaQrD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491A9606A320;
	Wed, 18 Nov 2026 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sm+MaQrD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E25D1F000C4;
	Wed, 18 Nov 2026 15:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016195;
	bh=7V1Xt1988ty1h3jrCDrziylSVuEW0OAcYkAjqpod+FE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sm+MaQrDdp0hSPpPu3kOCb79ghkD/BRZDIq3JOcESZLf0N//2rYOqKmf+daPp+ssf
	 MAW8T/i5KYZYJVByufg/dvw3QBM4QidHGFEQ2P4iBXZ+lPVPm0b8o77eOEDlcKhyD4
	 XT3fzDstWdfxpAImNbdpHOdA07WWZvVM/BVYAlM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhui Liu <junhui.liu@pigmoral.tech>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0444/2651] clk: sunxi-ng: sun55i-a523-ccu: Use M-only clocks for MBUS, IOMMU and DRAM
Date: Wed, 18 Nov 2026 15:28:04 +0100
Message-ID: <20261118150303.798311588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



