Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142D033A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301878; cv=none; b=BKcwyW2AoqAcGsHrXoSx4NVM6PhJTMmBwexGCL7XRr+uE/ArdWpCF3bnPbx0whtWVxxMhibJNIQC8PAIt4lfgjs+DDzs5pjbtxZXMmO2XNCNtON4WHbXj4kkeLp5GMCymQg8GtgPQyODMiCUoFAjecbhZY9Ky3fSUaRgFHdVSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301878; c=relaxed/simple;
	bh=hkI20BvmI7259dlv+31MtMoAPReAPYSFYXlbkl/MyU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMH+bBmLcPyCCmY5xJvDwpkB7MOqvZu8h7Nv2ogGD5/7u+iyN3nVlsjuuch6MoCjMPRu+LCiuBlzFrYBlt9PNpJy0XsbL3UP3knmFP5mM5jtEAw69cV3Cf4iOi1I2RlAhdgFHiHj2c0E7C6cAG9f4h/9rSG1VHmLJwhTFKFYqeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dKkC1/yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dKkC1/yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236E4C19425;
	Sat, 28 Feb 2026 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301878;
	bh=hkI20BvmI7259dlv+31MtMoAPReAPYSFYXlbkl/MyU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKkC1/yjC8v04dO3Q8a3qbkLN9MH5EiixyC0m89BVDNJeVhPWyk880daVytcSEMCw
	 pOwcOZDuCzuMjQvo9OtPbn4rivhlzbkWTsZ8qxrLaVraTA6N/d1t4cNpOFQ9qY7YTw
	 9tzK6MRQwd3Y5TIJC2KOUoNn2ZYkmst/NnVWQevCEn2sCU1BLPexgIAh6ypilu3vVY
	 WGiYeKExa3RcV/m46CiEp6no2zTaYZrCNEXlqShdCXl44143NZzfY2DLBzXdTqAKHE
	 wO+PxG4m9avrSH/AF0HaV03bWjT2pPL/CpwY8A2hq23Xx5odItlVo7dmGa+TUitKtW
	 dHKHvOXMIeoTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/385] clk: qcom: gcc-sm8450: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 12:58:45 -0500
Message-ID: <20260228180011.1568201-303-sashal@kernel.org>
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

[ Upstream commit 89428516f99572a9c37ebbb7859595881e7025a0 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: a27ac3806b0a ("clk: qcom: gcc-sm8450: Use floor ops for SDCC RCGs")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-1-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8450.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8450.c b/drivers/clk/qcom/gcc-sm8450.c
index c445c271678a5..ff62381ecdd97 100644
--- a/drivers/clk/qcom/gcc-sm8450.c
+++ b/drivers/clk/qcom/gcc-sm8450.c
@@ -936,7 +936,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_7,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_7),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -959,7 +959,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

