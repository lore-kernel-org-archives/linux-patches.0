Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4319433A014
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301880; cv=none; b=VhiJ2r3Ck3hrdh4aYlp7IV8QPePDkgfQ7Q8fAHHDyNq+Ur/L6dgkQowc1qaWahD+fcevtOKF8YQm/N55XVtMPHQpnuDM2e6ZwlNSO7e3Bo/n3MNthzwGdYiVObJL33gqMg/uN/YI7LK/+OHDKnSVZmWKp+vpLNGMjIeB03Hc3Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301880; c=relaxed/simple;
	bh=Arj7fb3yPEGjSLDbianKtdFaM/orIMFaPwnpG0WLhus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcY+ArVNXjY0aFWrniIrtpRtdLYFfadQB47PmIAohjq2d6Kf7OnRnm9dRS7Nv3NvCTmi+dsum0oFZPIXkghlkR7aX+arlojMpSeCkPwdZhxs6HNTkoL3efx2IYVLaI6OccFpUjCuK69s+pM+DxuFv4cUbv0O3pi8E1Jhee/H98w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWmHlWfk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWmHlWfk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D4FC19423;
	Sat, 28 Feb 2026 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301880;
	bh=Arj7fb3yPEGjSLDbianKtdFaM/orIMFaPwnpG0WLhus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWmHlWfkEqVa5O9xEKUFzyvpkDvKw9LUp6D5aNB0VcHAthEG7J+MqodJGdZLg3sXn
	 UYfYIE4f0pQBPIkTRpnuepW7jHDfHeYBKHt8EZprHosVuYwGG1Rtm1B8i9I5pRnsJE
	 TEUQhQwbzBMDAeISKZHCSdc/g5+ITml/TS+8jk0wUKFSDTd3F5IOahm1bVCALEmhXb
	 zbukKuNB+M09yEofBgmGKYLepPC7MqlTiO6T2nXAFbqGyKPVp8zHwoW61ISwMWltoo
	 QTZPlkaBWYn6z3X5nuobbXcW6V2IFeA5Q2Pe8QPn5d6kxRTKeU+kAsqF+rPngV6FsS
	 ZB3iKjkW7LwCA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/385] clk: qcom: gcc-sdx75: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 12:58:47 -0500
Message-ID: <20260228180011.1568201-305-sashal@kernel.org>
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

[ Upstream commit 4b057462bb61a6571608ba393e6e018c9da9c9c3 ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: 108cdc09b2de ("clk: qcom: Add GCC driver support for SDX75")
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-4-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sdx75.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sdx75.c b/drivers/clk/qcom/gcc-sdx75.c
index 453a6bf8e8786..1f3cd58483a2d 100644
--- a/drivers/clk/qcom/gcc-sdx75.c
+++ b/drivers/clk/qcom/gcc-sdx75.c
@@ -1033,7 +1033,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_17,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_17),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1057,7 +1057,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_18,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_18),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

