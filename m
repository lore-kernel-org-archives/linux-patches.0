Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBEC331212
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301879; cv=none; b=HKrJNaDId29X0fhDBFgABxrP00JlDEurwwtaDFfZhjC9WwiUCg/8g0wkkKLBAe3v7p1eNZ87oJjWFaazhbOS8rAFQw2o2H4rsHSPsomZtFlvdUs80ikxmxiZkFudRczwcO1apjyoNzrtOgW3ZU3NDwDgZvlvWIyo5qKV5eANFuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301879; c=relaxed/simple;
	bh=Fns5rrTlPNYFU+JQadq7m6+O7jFo45RscVHSEcIYmbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGpbBhDisaMYrV3quyv9SlJCsnm3Fzt4X0QtwS/g1GJNkgFVbH9NrzVO0gVstdcWb8Dgr/RvoRir0Cnkz/j9BFT/mhO39W3Tg9mSRxuIDhf7QTjzZlxn1yt880uvl8YNJ2Nax83pZFtD0FuTs+JQ0RzIdgzd8XmcZy/NtS6EmEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IL1xXYE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IL1xXYE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3871DC19424;
	Sat, 28 Feb 2026 18:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301879;
	bh=Fns5rrTlPNYFU+JQadq7m6+O7jFo45RscVHSEcIYmbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IL1xXYE6pSDugJMVRSebQ0d9SxU/UNebNZIvCF/lWasd5EN9IYXlioK/pyAkfqIu/
	 WIpNWEucJzEW1uCVyZ6kJGAqAVNhpUzxUttsnQIfc3MNoivsrF/fbHS8bH0fek7z//
	 s2IXpOyDJQn2pcGaRDGih4HLZK8+DJDgEH2GR/8DCYSNTUimj8zEs1C6k4jjByqV3O
	 ffI9QaacLz6AVFJcN4eJNi2szwzaj0X/DUefzwpguP3PPi+Vrse1kGOQZZiYOkdAQX
	 wbF2+DLY7OMLW59cX6rG8cQW761xRPtooV+YXZHDC5ds4UIEO+0LlqlYG9cbK5aPTP
	 K3AJV+AtPqYWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/385] clk: qcom: gcc-sm4450: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 12:58:46 -0500
Message-ID: <20260228180011.1568201-304-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 458e8a082186335380a9ab83003a385aec9bb254 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: c32c4ef98bac ("clk: qcom: Add GCC driver support for SM4450")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-3-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm4450.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm4450.c b/drivers/clk/qcom/gcc-sm4450.c
index e2d9e4691c5b7..023d840e9f4ef 100644
--- a/drivers/clk/qcom/gcc-sm4450.c
+++ b/drivers/clk/qcom/gcc-sm4450.c
@@ -769,7 +769,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.parent_data = gcc_parent_data_4,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_4),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -791,7 +791,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.parent_data = gcc_parent_data_4,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_4),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -815,7 +815,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_6,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_6),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

