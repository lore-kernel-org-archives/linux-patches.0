Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DC215C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903A5C433C1;
	Mon,  5 Dec 2022 19:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268235;
	bh=zEstJ4RD3LA/wAK1L4TIOeczKHSxlhfLt/s8d+/GUB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5KZPietVINAF6f3Kh1eqEcdjFrQCjMIkk2XXVUlztAgcd5S0QP3GGQAPlnX4wBpi
	 /0UEwiAjSTY+vwysChAGEtCz8s/4t4hg2xCx4SUYjy4wrlq0mZsJp+es7/F+qzK5fZ
	 g+IYGUT2b7Lz7v5DHYDPCn6rrYsMSAhGMPs6kuO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shazad Hussain <quic_shazhuss@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Andrew Halaney <ahalaney@redhat.com>,
	Brian Masney <bmasney@redhat.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 028/124] clk: qcom: gcc-sc8280xp: add cxo as parent for three ufs ref clks
Date: Mon,  5 Dec 2022 20:08:54 +0100
Message-Id: <20221205190809.248635634@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shazad Hussain <quic_shazhuss@quicinc.com>

[ Upstream commit f6abcc21d94393801937aed808b8f055ffec8579 ]

The three UFS reference clocks, gcc_ufs_ref_clkref_clk for external
UFS devices, gcc_ufs_card_clkref_clk and gcc_ufs_1_card_clkref_clk for
two PHYs are all sourced from CXO.

Added parent_data for all three reference clocks described above to
reflect that all three clocks are sourced from CXO to have valid
frequency for the ref clock needed by UFS controller driver.

Fixes: d65d005f9a6c ("clk: qcom: add sc8280xp GCC driver")
Link: https://lore.kernel.org/lkml/Y2Tber39cHuOSR%2FW@hovoldconsulting.com/
Signed-off-by: Shazad Hussain <quic_shazhuss@quicinc.com>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Tested-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Andrew Halaney <ahalaney@redhat.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Link: https://lore.kernel.org/r/20221115152956.21677-1-quic_shazhuss@quicinc.com
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8280xp.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sc8280xp.c b/drivers/clk/qcom/gcc-sc8280xp.c
index a2f3ffcc5849..fd332383527f 100644
--- a/drivers/clk/qcom/gcc-sc8280xp.c
+++ b/drivers/clk/qcom/gcc-sc8280xp.c
@@ -5364,6 +5364,8 @@ static struct clk_branch gcc_ufs_1_card_clkref_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_ufs_1_card_clkref_clk",
+			.parent_data = &gcc_parent_data_tcxo,
+			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -5432,6 +5434,8 @@ static struct clk_branch gcc_ufs_card_clkref_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_ufs_card_clkref_clk",
+			.parent_data = &gcc_parent_data_tcxo,
+			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -5848,6 +5852,8 @@ static struct clk_branch gcc_ufs_ref_clkref_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data) {
 			.name = "gcc_ufs_ref_clkref_clk",
+			.parent_data = &gcc_parent_data_tcxo,
+			.num_parents = 1,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.35.1



