Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16472367B60;
	Sat, 12 Sep 2026 08:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200818; cv=none; b=r0MOjzijJgEk8pQ/1t3Jct8VFqg8imJ8KrcACUJlT5WWPHDHP+bM4i4HUf+mrXjhRPNhfkMHN0g+jDTMsEBOo3QwM9X5SlMoqF0PAiBh3UxpZrJh50zihCv4yZim9Ex/uik3qstwZHS8KMg/zuY8TCDgxHzNdQ16lCDET932v/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200818; c=relaxed/simple;
	bh=l9Qv64uLrM+Uao/Wc3qyHgThAUasYuLgrbdd6L4SnJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGUiJZBExcG/oc+8yZhg8X/DHfLRfWAtHtvMD+OmLH96dAxug1TkNRBTqkzSPN9a6IlLglUQy/faEQEdK2rq9t3bD06bWZpLWdrIsq5/l1PzOknnwigcRCUwsLceTrX04AsM7YwYSi9/1N2uCVaQoy4EvOVJo4zixNAFhGDleGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BnEpNMwc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BnEpNMwc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0641F000FF;
	Sat, 12 Sep 2026 08:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200817;
	bh=jTH/rCYcvnaZY7omU0hwklhVusFnGSUBwOM3EPMWQLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BnEpNMwcxzbdxMuzY6Y5BTK//flcxZ8F8Y5xltxzDGYSLTCYzRdkV0y8kxDUOAslq
	 jNoIwGb6+vLmNZTLAMCuENgB3NK7BqKOB4Bx7N8lQF0DRd9CZZ2Yua1rVX4vL585kI
	 B/nMB6TbN5G50jXkESZ3LxVxgDnLETqTr7W+ouHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0825/1815] clk: qcom: nord: use BRANCH_HALT_SKIP for PHY pipe clocks
Date: Sat, 12 Sep 2026 08:42:55 +0200
Message-ID: <20260912065708.280327199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 3a8a7d597b07ffe388b47fb524827be52c9f7e0f ]

The PCIe and USB3 pipe clocks on Nord are sourced from their
respective PHYs. The halt bit for these branches does not toggle
reliably when the PHY is powered down or not yet brought up, so
polling for it with BRANCH_HALT_VOTED can spuriously time out.

Switch these pipe clock branches to BRANCH_HALT_SKIP, matching the
convention used for PHY-sourced pipe clocks elsewhere in the Qualcomm
clock drivers.

Fixes: a4f780cd5c7a ("clk: qcom: gcc: Add multiple global clock controller driver for Nord SoC")
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Tested-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260716-b4-nord-pipe-clk-fixes-v1-1-e4f583633356@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-nord.c   | 8 ++++----
 drivers/clk/qcom/negcc-nord.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/gcc-nord.c b/drivers/clk/qcom/gcc-nord.c
index 7c7c2171ac965..970a3e1a5864a 100644
--- a/drivers/clk/qcom/gcc-nord.c
+++ b/drivers/clk/qcom/gcc-nord.c
@@ -701,7 +701,7 @@ static struct clk_branch gcc_pcie_a_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_a_pipe_clk = {
 	.halt_reg = 0x49068,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0x49068,
 	.hwcg_bit = 1,
 	.clkr = {
@@ -850,7 +850,7 @@ static struct clk_branch gcc_pcie_b_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_b_pipe_clk = {
 	.halt_reg = 0x4a068,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x9d008,
 		.enable_mask = BIT(24),
@@ -995,7 +995,7 @@ static struct clk_branch gcc_pcie_c_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_c_pipe_clk = {
 	.halt_reg = 0x4b068,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x9d010,
 		.enable_mask = BIT(1),
@@ -1140,7 +1140,7 @@ static struct clk_branch gcc_pcie_d_phy_rchng_clk = {
 
 static struct clk_branch gcc_pcie_d_pipe_clk = {
 	.halt_reg = 0x4c068,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.clkr = {
 		.enable_reg = 0x9d010,
 		.enable_mask = BIT(10),
diff --git a/drivers/clk/qcom/negcc-nord.c b/drivers/clk/qcom/negcc-nord.c
index 355850a875acb..3427a0375373c 100644
--- a/drivers/clk/qcom/negcc-nord.c
+++ b/drivers/clk/qcom/negcc-nord.c
@@ -1641,7 +1641,7 @@ static struct clk_branch ne_gcc_usb3_prim_phy_com_aux_clk = {
 
 static struct clk_branch ne_gcc_usb3_prim_phy_pipe_clk = {
 	.halt_reg = 0x2a074,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0x2a074,
 	.hwcg_bit = 1,
 	.clkr = {
@@ -1697,7 +1697,7 @@ static struct clk_branch ne_gcc_usb3_sec_phy_com_aux_clk = {
 
 static struct clk_branch ne_gcc_usb3_sec_phy_pipe_clk = {
 	.halt_reg = 0x2c074,
-	.halt_check = BRANCH_HALT_VOTED,
+	.halt_check = BRANCH_HALT_SKIP,
 	.hwcg_reg = 0x2c074,
 	.hwcg_bit = 1,
 	.clkr = {
-- 
2.53.0



