Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47EE11B85CB;
	Mon, 14 Oct 2024 15:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919575; cv=none; b=QOzFYVesZFlJeKMd1sGrcloxCrbETNENR57P/Ykz31Z06sbbp6yPoycT0aA/t90CC+4Mkd/D5kbVFcMRatQEYl/mKIkE4xTPvt8CoHsOAGqXzOm/z3hyUcR1gGXUBbsI/7YQvqLJ3wCpqdQbCYzcmPpVQmz0GtLRILS0mXJWT3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919575; c=relaxed/simple;
	bh=FWorPPaYnRMzBV5O6z/h6vjb1y/AIde1KOGzz5nRSUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXZt3EqayE+zAvntlllDcOyltQ9EMIZvBWRq1PpyKbFkLASOKDgwkVuTx4UlNU5oxoYMds/H5Mja0cfOCV5FcPDv1M4XkiQj4t8m/ww2UdpZHuYxFFdnKOm3jyQREg/Yn4zrWBwyUm0FIuX21dajTQfLZo644kII0WKNULJj+Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdehocrI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdehocrI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8782BC4CEC3;
	Mon, 14 Oct 2024 15:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919575;
	bh=FWorPPaYnRMzBV5O6z/h6vjb1y/AIde1KOGzz5nRSUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdehocrIAUhiIEiaPgSZQ6QtPWVFqPFGNIYDNoJJZyaftPzFmm2sJIpX2qD+jivoT
	 AXLpbx2VsaOR7ly/zLOxHEB90uRRLOXv5DTDCOFY3DknD1Bob0EswqRLFQBb5nR74L
	 w3j6F2SNroxEEs4ZsW5o7fPtJ03oyiYvn2lYNm7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 646/798] clk: samsung: exynos7885: do not define number of clocks in bindings
Date: Mon, 14 Oct 2024 16:20:00 +0200
Message-ID: <20241014141243.429549096@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ef4923c8e0523d83b7cd4918760e03b03b2b08ad ]

Number of clocks supported by Linux drivers might vary - sometimes we
add new clocks, not exposed previously.  Therefore these numbers of
clocks should not be in the bindings, as that prevents changing them.

Define number of clocks per each clock controller inside the driver
directly.

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Chanwoo Choi <cw00.choi@samsung.com>
Link: https://lore.kernel.org/r/20230808082738.122804-9-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Stable-dep-of: 217a5f23c290 ("clk: samsung: exynos7885: Update CLKS_NR_FSYS after bindings fix")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-exynos7885.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos7885.c b/drivers/clk/samsung/clk-exynos7885.c
index 0d2a950ed1844..5d58879606eef 100644
--- a/drivers/clk/samsung/clk-exynos7885.c
+++ b/drivers/clk/samsung/clk-exynos7885.c
@@ -17,6 +17,12 @@
 #include "clk.h"
 #include "clk-exynos-arm64.h"
 
+/* NOTE: Must be equal to the last clock ID increased by one */
+#define CLKS_NR_TOP			(CLK_GOUT_FSYS_USB30DRD + 1)
+#define CLKS_NR_CORE			(CLK_GOUT_TREX_P_CORE_PCLK_P_CORE + 1)
+#define CLKS_NR_PERI			(CLK_GOUT_WDT1_PCLK + 1)
+#define CLKS_NR_FSYS			(CLK_GOUT_MMC_SDIO_SDCLKIN + 1)
+
 /* ---- CMU_TOP ------------------------------------------------------------- */
 
 /* Register Offset definitions for CMU_TOP (0x12060000) */
@@ -334,7 +340,7 @@ static const struct samsung_cmu_info top_cmu_info __initconst = {
 	.nr_div_clks		= ARRAY_SIZE(top_div_clks),
 	.gate_clks		= top_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(top_gate_clks),
-	.nr_clk_ids		= TOP_NR_CLK,
+	.nr_clk_ids		= CLKS_NR_TOP,
 	.clk_regs		= top_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(top_clk_regs),
 };
@@ -553,7 +559,7 @@ static const struct samsung_cmu_info peri_cmu_info __initconst = {
 	.nr_mux_clks		= ARRAY_SIZE(peri_mux_clks),
 	.gate_clks		= peri_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(peri_gate_clks),
-	.nr_clk_ids		= PERI_NR_CLK,
+	.nr_clk_ids		= CLKS_NR_PERI,
 	.clk_regs		= peri_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(peri_clk_regs),
 	.clk_name		= "dout_peri_bus",
@@ -662,7 +668,7 @@ static const struct samsung_cmu_info core_cmu_info __initconst = {
 	.nr_div_clks		= ARRAY_SIZE(core_div_clks),
 	.gate_clks		= core_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(core_gate_clks),
-	.nr_clk_ids		= CORE_NR_CLK,
+	.nr_clk_ids		= CLKS_NR_CORE,
 	.clk_regs		= core_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(core_clk_regs),
 	.clk_name		= "dout_core_bus",
@@ -744,7 +750,7 @@ static const struct samsung_cmu_info fsys_cmu_info __initconst = {
 	.nr_mux_clks		= ARRAY_SIZE(fsys_mux_clks),
 	.gate_clks		= fsys_gate_clks,
 	.nr_gate_clks		= ARRAY_SIZE(fsys_gate_clks),
-	.nr_clk_ids		= FSYS_NR_CLK,
+	.nr_clk_ids		= CLKS_NR_FSYS,
 	.clk_regs		= fsys_clk_regs,
 	.nr_clk_regs		= ARRAY_SIZE(fsys_clk_regs),
 	.clk_name		= "dout_fsys_bus",
-- 
2.43.0



