Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C172343D64
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301874; cv=none; b=m53eVGRTBa9gBjgp22uV162uA2nVIFGSuyMrhQssV5QlwjZV08TW6RdWVgtecv3hm3HAaS3gF5FaVIviwHiA/dVkTUUsbwmOizDNvswNsLVDPz+MAnjHlgBsYawPJjn9g3CLNUTCu+34xv+AvaP64fdNzG7orxfxZ/fkLkhZz0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301874; c=relaxed/simple;
	bh=DkuxwYsjusBqSoVTPvEm1DlGw1bSpOpt2/TZjDMOgV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxXCYTW+8jKRboRISuj9rdSPmOJoMsu7H6cGpFlwDZw4PdTfTi08BNh3XAaMOsoonXxW1yXagDXfVcVvTRYVRoPnqxZyJ2sBuezWCZeMLPUcfjh/csJ3Rslmy5UisouJ+QvRRx9YNfA0rtmmz7GVy1zDOeHXMaPuHBFRDiFZ8f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ek0pAGQt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ek0pAGQt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D03C116D0;
	Sat, 28 Feb 2026 18:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301874;
	bh=DkuxwYsjusBqSoVTPvEm1DlGw1bSpOpt2/TZjDMOgV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek0pAGQta9WW2IGy1gay7iFZiUqWaFP39ANGX/+KBnobB3rivAv/fs1s4KsZzdyad
	 6QUDpPFALj5W15FJKXq16rTrGzm79RtFFfDz72rL6ZLQrzoAdKAXnjPb2nkVA9ZmmE
	 iEjAkt2uaETVfBA0G9rXOQlvAj8KnUu4NXS7Koj59tqcEuoeC3iCtAMcalT1z1+Lo6
	 iVkp+0nIVdFgUDjdF8Rn99+V+HuE4cGmxvTcSAUm7tniGvZtD53vC76erTqwolnKz3
	 ljPtaxBdGRZPyG6OjFQTgWIeu9dEn98tnudujgTcnVYnFvpi9jG1FHYrZhkyF5Hfkl
	 tRGZmaMwGQDTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 299/385] clk: qcom: gcc-sm8550: Use floor ops for SDCC RCGs
Date: Sat, 28 Feb 2026 12:58:41 -0500
Message-ID: <20260228180011.1568201-299-sashal@kernel.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 1c06e3956054fb5a0930f07b02726b1774b6c700 ]

In line with commit a27ac3806b0a ("clk: qcom: gcc-sm8450: Use floor ops
for SDCC RCGs") done to fix issues with overclocked SD cards on SM8450
powered boards set floor clock operations for SDCC RCGs on SM8550.

This change fixes initialization of some SD cards, where the problem
is manifested by the SDHC driver:

    mmc0: Card appears overclocked; req 50000000 Hz, actual 100000000 Hz
    mmc0: error -110 whilst initialising SD card

Fixes: 955f2ea3b9e9 ("clk: qcom: Add GCC driver for SM8550")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251124212012.3660189-2-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8550.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8550.c b/drivers/clk/qcom/gcc-sm8550.c
index 862a9bf73bcb5..36a5b7de5b55d 100644
--- a/drivers/clk/qcom/gcc-sm8550.c
+++ b/drivers/clk/qcom/gcc-sm8550.c
@@ -1025,7 +1025,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_9,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_9),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1048,7 +1048,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

