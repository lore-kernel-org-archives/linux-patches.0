Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D68B2DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301875; cv=none; b=IL2+haWhJqHGqglzs90RFxfHNtPIAJX0aWnHWwoG+Oc1IqU6Hax8Ltqpwb3rYrIKVH9kLjScPVHZbDp/fs0V611pK49aAn7B89PcEfX0CY8o5bUCvOrAsp69rTU7xkQHGW9taGtbmVDfWvq73mxdCuQyUbG8S73Fi33uTiRK+LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301875; c=relaxed/simple;
	bh=UHo6tug+eSHwYyS1zZa0oUcKf7xsVvNEEGHnnPwULHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHzPLRXZo9o0gFlnm16c1m6BTbLt7B/yvbC/0KbFo6+0/zLddeofSx8N+VQu/vrcy3+gMyMImdplwuUg/XFW9byRbMPQEUwnzaeYQezIN+HxzHQ/mezVPAHk1bZntGNCtP2ONcNteL3n6W3D20tW0CpSzpicbZHMitwRW9X2aQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eT6Y8K4C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eT6Y8K4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27A5C19425;
	Sat, 28 Feb 2026 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301875;
	bh=UHo6tug+eSHwYyS1zZa0oUcKf7xsVvNEEGHnnPwULHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eT6Y8K4CXiyV2bh6M00Cmkqc+JNxjRsfZ8yvQzyxgPiRlIHPfkXb1h59wIULrdWBK
	 t4WADL606CR/R9ABr9r+hnkptonQkQwb6SjjXt/kZXQw6x7lm+KFbK6kJwvemWMZPa
	 kASst+h3wT3EJcrVaoZG2+3z+OOF4IQqHfYA8zSaE6oQwM+E2qKwtotBDqN7XG1wuZ
	 /hLrgrSaI4PUMtKw9RJs7MXJlAZCRTzWcXeYEXGqWiElWoyu6Thw5JG+ldHWoKnGIR
	 mQHmLPrthbVHcNp4kbOfLVV+VsPymSy/03POWqUjcXJgncoW4gh64g4nbRhug2Ie1Q
	 PeSCNvePM9uqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/385] clk: qcom: gcc-sm8650: Use floor ops for SDCC RCGs
Date: Sat, 28 Feb 2026 12:58:42 -0500
Message-ID: <20260228180011.1568201-300-sashal@kernel.org>
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

[ Upstream commit 8c4415fd17cd5979c31a4bf303acc702e9726033 ]

In line with commit a27ac3806b0a ("clk: qcom: gcc-sm8450: Use floor ops
for SDCC RCGs") done to fix issues with overclocked SD cards on SM8450
powered boards set floor clock operations for SDCC RCGs on SM8650.

This change fixes initialization of some SD cards, where the problem
is manifested by the SDHC driver:

    mmc0: Card appears overclocked; req 50000000 Hz, actual 100000000 Hz
    mmc0: error -110 whilst initialising SD card

Fixes: c58225b7e3d7 ("clk: qcom: add the SM8650 Global Clock Controller driver, part 1")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251124212012.3660189-3-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm8650.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8650.c b/drivers/clk/qcom/gcc-sm8650.c
index fa1672c4e7d81..8c4b86494183c 100644
--- a/drivers/clk/qcom/gcc-sm8650.c
+++ b/drivers/clk/qcom/gcc-sm8650.c
@@ -1257,7 +1257,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.parent_data = gcc_parent_data_11,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_11),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
@@ -1279,7 +1279,7 @@ static struct clk_rcg2 gcc_sdcc4_apps_clk_src = {
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
 		.flags = CLK_SET_RATE_PARENT,
-		.ops = &clk_rcg2_shared_ops,
+		.ops = &clk_rcg2_shared_floor_ops,
 	},
 };
 
-- 
2.51.0

