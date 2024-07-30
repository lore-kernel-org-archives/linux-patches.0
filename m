Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F131A619E;
	Tue, 30 Jul 2024 16:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357545; cv=none; b=jINGlVRVzAGLpy44EhMUAzJ1gwPvNyv6NsOCfkqGOL5w0jD5wE8eARfDr8Anx/f/zas8QmpzZ4TLwE5rUrhA6PIjBQYIXrE3dTKUTRnhSy+2WUL9jF/ZPw1Hz53MCZtqCkdsVfMM4VyrBHs2PrvAWrVMrs0QH234dkXoQMuDlxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357545; c=relaxed/simple;
	bh=G2cAH4NAdVvwcLnnh0m/3QnGNS8hkQ6VtEK/ik+Q91k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKl1Fm5RISMDF7wbqOCbwVWvrsQyLkwrqgXHj23owPZaMWDTbQ6i1i2CMR6EgdkvNnKJeN1XDQzjwNQTD3oEcCuYTmVwLmL+JP2B1poDuhq/7VaQWa1rIXRhwqKU31smQybjG+o7fYbP7txD3dW4tsRTMhVzaNbFYyVpD8uMKpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rc4J4/c+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rc4J4/c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12CFC32782;
	Tue, 30 Jul 2024 16:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357545;
	bh=G2cAH4NAdVvwcLnnh0m/3QnGNS8hkQ6VtEK/ik+Q91k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rc4J4/c+ku965qZBWximFlXRwC/uARYfQ63PggcwrQK1ss0mLkWoDdYZ2cQxiGT1l
	 /AuU3qdzHN8nXDK8nTdNWHb2An/S2sThxGoeoOfllB39osQ1tGhIAmBSPLcFBq99P1
	 54PzzvF7HEVPiZNHa/Etpez4MfhaKjJkuXkATLAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 268/568] clk: qcom: gpucc-sa8775p: Park RCGs clk source at XO during disable
Date: Tue, 30 Jul 2024 17:46:15 +0200
Message-ID: <20240730151650.356226125@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit dff68b2f74547617dbb75d0d12f404877ec8f8ce ]

The RCG's clk src has to be parked at XO while disabling as per the
HW recommendation, hence use clk_rcg2_shared_ops to achieve the same.
Also gpu_cc_cb_clk is recommended to be kept always ON, hence use
clk_branch2_aon_ops to keep the clock always ON.

Fixes: 0afa16afc36d ("clk: qcom: add the GPUCC driver for sa8775p")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240612-sa8775p-v2-gcc-gpucc-fixes-v2-5-adcc756a23df@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gpucc-sa8775p.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/gpucc-sa8775p.c b/drivers/clk/qcom/gpucc-sa8775p.c
index 3f05b44c13c53..abcaefa01e386 100644
--- a/drivers/clk/qcom/gpucc-sa8775p.c
+++ b/drivers/clk/qcom/gpucc-sa8775p.c
@@ -161,7 +161,7 @@ static struct clk_rcg2 gpu_cc_ff_clk_src = {
 		.name = "gpu_cc_ff_clk_src",
 		.parent_data = gpu_cc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_0),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -181,7 +181,7 @@ static struct clk_rcg2 gpu_cc_gmu_clk_src = {
 		.parent_data = gpu_cc_parent_data_1,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_1),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -200,7 +200,7 @@ static struct clk_rcg2 gpu_cc_hub_clk_src = {
 		.name = "gpu_cc_hub_clk_src",
 		.parent_data = gpu_cc_parent_data_2,
 		.num_parents = ARRAY_SIZE(gpu_cc_parent_data_2),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_shared_ops,
 	},
 };
 
@@ -294,7 +294,7 @@ static struct clk_branch gpu_cc_cb_clk = {
 		.enable_mask = BIT(0),
 		.hw.init = &(const struct clk_init_data){
 			.name = "gpu_cc_cb_clk",
-			.ops = &clk_branch2_ops,
+			.ops = &clk_branch2_aon_ops,
 		},
 	},
 };
-- 
2.43.0



