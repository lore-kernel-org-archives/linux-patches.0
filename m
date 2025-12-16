Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F8E322B83;
	Tue, 16 Dec 2025 11:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885397; cv=none; b=inirnYh+TQTGW0JX0ywqxBDdyUWcq2QVn+eYwv/rHNVD8JFQNaJ6fkKnyF3q/psV4sNWb1aYSUrPlCWArlCwxoxsuvaTg7uu1iTJZo+sbFUBm43UXTRHbBB1puRZ3MuLjX+wUg/xRxfWCewTHXdngZhY28NXXupofXlqoNt1hd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885397; c=relaxed/simple;
	bh=HVhOFsKZvPxQNA+MsuUYiLy8A5fW6LFN1s63ZDwl/gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HxChiI22t6KtMc87cd/DZQ6B4sAnZpnd898LaPRIf7Eb6EkWPXcnv+qGdWNTMplh5Ab50DAGFUIQSbiAaTB5XYXbjuZJmmHUiVmMbnrKaHaxNhSmRBvoNsoK6a45EuXg9SxmjP+jc8F0NDtO56G01TpIaC+ThYr2NPkt0InU608=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2ifyC+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2ifyC+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8A6C4CEF1;
	Tue, 16 Dec 2025 11:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885397;
	bh=HVhOFsKZvPxQNA+MsuUYiLy8A5fW6LFN1s63ZDwl/gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2ifyC+p0xtjjHkBzNJHn03lP5+u0XOGwJ+caXChjGO+OgnWJpE/mEWeNWpAArIPh
	 lo1ZBJiErJwgB7srymzy5daLbNyn62ypJwscWntZiR/KKSi4ydqnzfArheX7FffO1D
	 CdSCxZkg0fJ9dG11LX9mv03AvZP3OJ6Uum2qkFFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 126/507] clk: qcom: gcc-qcs615: Update the SDCC clock to use shared_floor_ops
Date: Tue, 16 Dec 2025 12:09:27 +0100
Message-ID: <20251216111350.096552297@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <taniya.das@oss.qualcomm.com>

[ Upstream commit 0820c9373369c83de5202871d02682d583a91a9c ]

Fix "gcc_sdcc2_apps_clk_src: rcg didn't update its configuration" during
boot. This happens due to the floor_ops tries to update the rcg
configuration even if the clock is not enabled.
The shared_floor_ops ensures that the RCG is safely parked and the new
parent configuration is cached in the parked_cfg when the clock is off.

Ensure to use the ops for the other SDCC clock instances as well.

Fixes: 39d6dcf67fe9 ("clk: qcom: gcc: Add support for QCS615 GCC clocks")
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251029-sdcc_rcg2_shared_ops-v3-1-ecf47d9601d1@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qcs615.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qcs615.c b/drivers/clk/qcom/gcc-qcs615.c
index 9695446bc2a3c..5b3b8dd4f114b 100644
--- a/drivers/clk/qcom/gcc-qcs615.c
+++ b/drivers/clk/qcom/gcc-qcs615.c
@@ -784,7 +784,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_1,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_1),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -806,7 +806,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.name = "gcc_sdcc1_ice_core_clk_src",
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -830,7 +830,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_8,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_8),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0



