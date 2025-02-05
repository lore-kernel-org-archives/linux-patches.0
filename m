Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE32A1519AA;
	Wed,  5 Feb 2025 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764909; cv=none; b=d6cVQV7jvfG6+2S4VVYqPgWiF9U6UiXUUqy05pJFbS/+npoLwpFbfSosPaOXG8a5D/AC7y/MbwATU+2FXat1qxQIgCD1LjbtUotYMVPxy93Tee3f+N5PAWhjScC4AR2iY+e1BVRJRD+pKmhV/Nt+8mQLskvWCM9KAeSm6yAvpEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764909; c=relaxed/simple;
	bh=kjkNOJNNs8iWOz1ZsEbJHPgKWgEM1N1Q9pTOmvBXSiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+ajV8/vNTOtydFgM1g8aRlyKW1L+HMJdwKTx680QN/6TrJqnUro+GgwfAM0ZigKYSDfYggqgZ51kagHz6GcLm8QhTg+aJo+y8YsK9ku+15GxGM1y2yRSgSOysbbpTsyBL9O3ASk4LCF21tml/RtLXIYhjxudoNWM8RY4bGbsco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsV+kkvX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsV+kkvX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26963C4CED1;
	Wed,  5 Feb 2025 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764909;
	bh=kjkNOJNNs8iWOz1ZsEbJHPgKWgEM1N1Q9pTOmvBXSiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsV+kkvXtC12BlkL6Tdvgl2GeUi4LiK/dgUxx9DQ+xMNVqGimVrLfRnBltTplvGBw
	 KEZhYKypnonn5LQhpICt8GXYzcPT8jN5xuL4Nk4sv2d+Pm7m/4kRYfyHYbvr+Pu1sd
	 0K0gKzvMbBL4HTjRpLKVyOFh0a5IP/7/w8ndUwSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Drew Fustini <dfustini@tenstorrent.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 168/590] clk: thead: Add CLK_IGNORE_UNUSED to fix TH1520 boot
Date: Wed,  5 Feb 2025 14:38:43 +0100
Message-ID: <20250205134501.708956383@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Drew Fustini <dfustini@tenstorrent.com>

[ Upstream commit 037705e94bf6e1810b7f9dc077d0e23292229e74 ]

Add the CLK_IGNORE_UNUSED flag to apb_pclk, cpu2peri_x2h_clk,
perisys_apb2_hclk and perisys_apb3_hclk.

Without this flag, the boot hangs after "clk: Disabling unused clocks"
unless clk_ignore_unused is in the kernel cmdline.

Fixes: ae81b69fd2b1 ("clk: thead: Add support for T-Head TH1520 AP_SUBSYS clocks")
Signed-off-by: Drew Fustini <dfustini@tenstorrent.com>
Link: https://lore.kernel.org/r/20250113-th1520-clk_ignore_unused-v1-2-0b08fb813438@tenstorrent.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/thead/clk-th1520-ap.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/thead/clk-th1520-ap.c b/drivers/clk/thead/clk-th1520-ap.c
index c95b6e26ca531..d02a18fed8a85 100644
--- a/drivers/clk/thead/clk-th1520-ap.c
+++ b/drivers/clk/thead/clk-th1520-ap.c
@@ -657,7 +657,7 @@ static struct ccu_div apb_pclk = {
 		.hw.init	= CLK_HW_INIT_PARENTS_DATA("apb-pclk",
 						      apb_parents,
 						      &ccu_div_ops,
-						      0),
+						      CLK_IGNORE_UNUSED),
 	},
 };
 
@@ -794,13 +794,13 @@ static CCU_GATE(CLK_X2X_CPUSYS, x2x_cpusys_clk, "x2x-cpusys", axi4_cpusys2_aclk_
 		0x134, BIT(7), 0);
 static CCU_GATE(CLK_CPU2AON_X2H, cpu2aon_x2h_clk, "cpu2aon-x2h", axi_aclk_pd, 0x138, BIT(8), 0);
 static CCU_GATE(CLK_CPU2PERI_X2H, cpu2peri_x2h_clk, "cpu2peri-x2h", axi4_cpusys2_aclk_pd,
-		0x140, BIT(9), 0);
+		0x140, BIT(9), CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_PERISYS_APB1_HCLK, perisys_apb1_hclk, "perisys-apb1-hclk", perisys_ahb_hclk_pd,
 		0x150, BIT(9), 0);
 static CCU_GATE(CLK_PERISYS_APB2_HCLK, perisys_apb2_hclk, "perisys-apb2-hclk", perisys_ahb_hclk_pd,
-		0x150, BIT(10), 0);
+		0x150, BIT(10), CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_PERISYS_APB3_HCLK, perisys_apb3_hclk, "perisys-apb3-hclk", perisys_ahb_hclk_pd,
-		0x150, BIT(11), 0);
+		0x150, BIT(11), CLK_IGNORE_UNUSED);
 static CCU_GATE(CLK_PERISYS_APB4_HCLK, perisys_apb4_hclk, "perisys-apb4-hclk", perisys_ahb_hclk_pd,
 		0x150, BIT(12), 0);
 static CCU_GATE(CLK_NPU_AXI, npu_axi_clk, "npu-axi", axi_aclk_pd, 0x1c8, BIT(5), 0);
-- 
2.39.5



