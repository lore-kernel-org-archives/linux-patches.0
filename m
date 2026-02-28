Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A7533A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301882; cv=none; b=CSPY8jngzOEjpxEl1M9ePE9Xu019XSoFoJGF3qz323eB8PRdKftIglEKOmEzalIVxWnpnQBvAZJ7YC041FBxXbOgfISF868hd7raCtxFgTDRWohG+b1+f5pTFgkOUgEnez4G4pTS0fDhuXZB8SwpXssoog1LcgZbSzkh2KF08JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301882; c=relaxed/simple;
	bh=FRhI759Prmk/+wo066IKjl++/5lb8+QTIqvkjev8rFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLy5b8wu9zEjoCKY+w/INu67/ocHmQ3Nc5Smy51H1bOSgpwJqvYAz+J+pNkAP4w6dVmo4ReWLRJKD9lCNn2UAX5DlOG/a50tjPLdXwC6xxsM2uITwQnMh1/WkAmhzjWuCps4d2Ve9w7f1MmEwTl21s0ExnXu60fNs0TybPIwUj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2/omtgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2/omtgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D20C19423;
	Sat, 28 Feb 2026 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301882;
	bh=FRhI759Prmk/+wo066IKjl++/5lb8+QTIqvkjev8rFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2/omtgfR8GZQhg6YLIR6weRSKc48B/QnWclk4GCX/AcmhOUGor8rv4aEVepIB1z7
	 7mKI6hXwOy/T69Cb0mxxtL6xzuJ45NIAjguBSdmPiQqz96mOqKZbdKmm6DWYJDdIVb
	 uc1nqBF7pF2hmSDaAEJSDaA00OZZFAw1ABRUHn9PqvdYMstz+kwO9cRM4f7RT2XukN
	 7xGA1HG23mCFEr89w7l4NJ+iNvrBb5OTfwPweUG4FaF+/XXl16kAQy8Yl1fDCRI9ew
	 2l84B8l/AAHhggpb/ugv9sUDaKE0yojgoDCrX4R+BY+SdNDYCFhix3ycuVHlnuPjz5
	 XvZgtRJbnLQKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/385] clk: qcom: gcc-qdu1000: Update the SDCC RCGs to use shared_floor_ops
Date: Sat, 28 Feb 2026 12:58:49 -0500
Message-ID: <20260228180011.1568201-307-sashal@kernel.org>
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

[ Upstream commit 947c4b326c1f4dc64aed42170b39c2cf551ba8ca ]

Use shared_floor_ops for the SDCC RCGs so the RCG is safely parked
during disable and the new parent configuration is programmed in
hardware only when the new parent is enabled, avoiding cases where
the RCG configuration fails to update.

Fixes: baa316580013 ("clk: qcom: gcc-qdu1000: Update the SDCC clock RCG ops")
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20251127-sdcc_shared_floor_ops-v2-7-473afc86589c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-qdu1000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-qdu1000.c b/drivers/clk/qcom/gcc-qdu1000.c
index dbe9e9437939a..915bb9b4ff813 100644
--- a/drivers/clk/qcom/gcc-qdu1000.c
+++ b/drivers/clk/qcom/gcc-qdu1000.c
@@ -904,7 +904,7 @@ static struct clk_rcg2 gcc_sdcc5_apps_clk_src = {
 		.name = "gcc_sdcc5_apps_clk_src",
 		.parent_data = gcc_parent_data_8,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_8),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -923,7 +923,7 @@ static struct clk_rcg2 gcc_sdcc5_ice_core_clk_src = {
 		.name = "gcc_sdcc5_ice_core_clk_src",
 		.parent_data = gcc_parent_data_2,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_2),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

