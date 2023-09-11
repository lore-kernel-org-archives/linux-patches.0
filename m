Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306E1170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3E62C433C7;
	Mon, 11 Sep 2023 14:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441431;
	bh=Gsy1/xtEtlxFMtvAIFSAtxsvcf1EcdH7rbosVs0X+WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TWy5HThxbDfa17VyBVpZOfNnPc4j6d5vIWD4AZIt6AJunP9okCu+7wrFUJIq5lhW3
	 /a4eYbx0vPK8jY4Ms3rWWwnFrNIW/bQCyvhGAw1OoAc+BT993yiTV+Yva6Fa2DbWLa
	 xb5tUigufd1mlN9EnJx9c8PEwllZUFqy4Djzlzh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imran Shaik <quic_imrashai@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 411/739] clk: qcom: gcc-qdu1000: Fix clkref clocks handling
Date: Mon, 11 Sep 2023 15:43:30 +0200
Message-ID: <20230911134702.660469442@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imran Shaik <quic_imrashai@quicinc.com>

[ Upstream commit 2524dae5cd453ca39e8ba1b95c2755a8a2d94059 ]

Update the GCC clkref clock's halt_check to BRANCH_HALT, as it's
status bit is not inverted in the latest hardware version of QDU1000
and QRU1000 SoCs. While at it, fix the gcc clkref clock ops as well.

Fixes: 1c9efb0bc040 ("clk: qcom: Add QDU1000 and QRU1000 GCC support")
Signed-off-by: Imran Shaik <quic_imrashai@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230803105741.2292309-4-quic_imrashai@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qdu1000.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qdu1000.c b/drivers/clk/qcom/gcc-qdu1000.c
index c00d26a3e6df5..8df7b79839680 100644
--- a/drivers/clk/qcom/gcc-qdu1000.c
+++ b/drivers/clk/qcom/gcc-qdu1000.c
@@ -1447,14 +1447,13 @@ static struct clk_branch gcc_pcie_0_cfg_ahb_clk = {
 
 static struct clk_branch gcc_pcie_0_clkref_en = {
 	.halt_reg = 0x9c004,
-	.halt_bit = 31,
-	.halt_check = BRANCH_HALT_ENABLE,
+	.halt_check = BRANCH_HALT,
 	.clkr = {
 		.enable_reg = 0x9c004,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_pcie_0_clkref_en",
-			.ops = &clk_branch_ops,
+			.ops = &clk_branch2_ops,
 		},
 	},
 };
@@ -2274,14 +2273,13 @@ static struct clk_branch gcc_tsc_etu_clk = {
 
 static struct clk_branch gcc_usb2_clkref_en = {
 	.halt_reg = 0x9c008,
-	.halt_bit = 31,
-	.halt_check = BRANCH_HALT_ENABLE,
+	.halt_check = BRANCH_HALT,
 	.clkr = {
 		.enable_reg = 0x9c008,
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_usb2_clkref_en",
-			.ops = &clk_branch_ops,
+			.ops = &clk_branch2_ops,
 		},
 	},
 };
-- 
2.40.1



