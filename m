Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D953C46E
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Em7UxpXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DD8C433C7;
	Wed, 15 Nov 2023 19:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077264;
	bh=Zkc7Pn24bmRt/hGZQnai+UlS7hosdLXQkPv2FQQyiNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Em7UxpXcDYC+f19FhYflU9bMqLiNOMpoxxIhhYL7/yqIQAPhHcenBGBusFbKyZFK5
	 IYuGI+FmRBCiDHYldtZ6mfZIFxzOYjo6l+74Z+fLQcLrMmm0/SFpFjrFj9YIxik19/
	 7kGuValr4oobrXgp22HA+RP7huz8fPVpITNdSn2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/603] clk: qcom: ipq5018: drop the CLK_SET_RATE_PARENT flag from GPLL clocks
Date: Wed, 15 Nov 2023 14:12:21 -0500
Message-ID: <20231115191626.814589298@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>

[ Upstream commit 01a5e4c6731ab6b4b74822661d296f8893fc1230 ]

GPLL clock rates are fixed and shouldn't be scaled based on the
request from dependent clocks. Doing so will result in the unexpected
behaviour. So drop the CLK_SET_RATE_PARENT flag from the GPLL clocks.

----
Changes in V2:
	- New patch

Fixes: e3fdbef1bab8 ("clk: qcom: Add Global Clock controller (GCC) driver for IPQ5018")
Signed-off-by: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230913-gpll_cleanup-v2-3-c8ceb1a37680@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5018.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5018.c b/drivers/clk/qcom/gcc-ipq5018.c
index 19dc2b71cacf0..2a3c0659b7008 100644
--- a/drivers/clk/qcom/gcc-ipq5018.c
+++ b/drivers/clk/qcom/gcc-ipq5018.c
@@ -128,7 +128,6 @@ static struct clk_alpha_pll_postdiv gpll0 = {
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -143,7 +142,6 @@ static struct clk_alpha_pll_postdiv gpll2 = {
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -158,7 +156,6 @@ static struct clk_alpha_pll_postdiv gpll4 = {
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.42.0



