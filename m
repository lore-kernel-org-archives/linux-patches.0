Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC0C32C933;
	Mon, 29 Dec 2025 16:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025489; cv=none; b=NDK0Diu9lFw9NLMLOpE/arT1oXTYJ4yjtkF2YFcNluIDjjCZI690tPfdrQWxBx5sId9MORFIg7d9bF84PXbsXdd5QWme5JSeFSa+pKdbqbEidOr7rNm/7zUi2o3b7549KRIDv+wj4La0+9sgo15m9PiRdG1f+WaChD1tMXgO6xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025489; c=relaxed/simple;
	bh=QPdvk71Gj2U5Mms3sThvI6pXVb/NGo9iEisZPLtFQmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ju2fz0s7JcKdQgPgPpc9PJEZF0sKSLCggnxIyE0de/oLeSR7RPlRq3UbuL5Jny7YFemAkSqOo7b3atGAIjRGF7B4JTBW7W7XKJe+hUMWrmHTE6XaeyjXg2BQt99dVBS5FDpp6aTqFC/weYNpamqwHXZlPx8XbkhnzonUh4NM5jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIC8xViS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIC8xViS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EA5C16AAE;
	Mon, 29 Dec 2025 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025489;
	bh=QPdvk71Gj2U5Mms3sThvI6pXVb/NGo9iEisZPLtFQmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HIC8xViSTddkjccQ8/Iz/dlcDrQd+JYEc0MghyRFwfFgzOHz/wYSYVCTdCD+x6dVP
	 f0frf/ODyqZjc+Ue+d1jNhUyj2/ZkPb05OSwPgJ1UW1VkIufWS2c3f7sB7Fkvf12fm
	 TKusrCsq6NyoDE7u+PMaV7SXvnF9TE870fJAnqng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Reidel <adrian@mainlining.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/430] clk: qcom: dispcc-sm7150: Fix dispcc_mdss_pclk0_clk_src
Date: Mon, 29 Dec 2025 17:10:06 +0100
Message-ID: <20251229160731.861503146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Reidel <adrian@mainlining.org>

[ Upstream commit e3c13e0caa8ceb7dec1a7c4fcfd9dbef56a69fbe ]

Set CLK_OPS_PARENT_ENABLE to ensure the parent gets prepared and enabled
when switching to it, fixing an "rcg didn't update its configuration"
warning.

Signed-off-by: Jens Reidel <adrian@mainlining.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250919-sm7150-dispcc-fixes-v1-3-308ad47c5fce@mainlining.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm7150.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/dispcc-sm7150.c b/drivers/clk/qcom/dispcc-sm7150.c
index bdfff246ed3f..ddc7230b8aea 100644
--- a/drivers/clk/qcom/dispcc-sm7150.c
+++ b/drivers/clk/qcom/dispcc-sm7150.c
@@ -356,7 +356,7 @@ static struct clk_rcg2 dispcc_mdss_pclk0_clk_src = {
 		.name = "dispcc_mdss_pclk0_clk_src",
 		.parent_data = dispcc_parent_data_4,
 		.num_parents = ARRAY_SIZE(dispcc_parent_data_4),
-		.flags = CLK_SET_RATE_PARENT,
+		.flags = CLK_SET_RATE_PARENT | CLK_OPS_PARENT_ENABLE,
 		.ops = &clk_pixel_ops,
 	},
 };
-- 
2.51.0



