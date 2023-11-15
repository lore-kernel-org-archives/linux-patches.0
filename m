Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DAD3C46F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUbIUulx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A6CC433C7;
	Wed, 15 Nov 2023 19:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077267;
	bh=uQue5NzCC7Lw2PuXFQX+sL2vcg5O0i81DJK9CLSQkUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUbIUulxCpsnHtesGQvkyaf7/DAMsn3UrtKj6/ZyTAiMHnJx5cQ6caI4ozCt725Fc
	 fH13snvi2EvA28Zo0d1V6Vfy0KHgKx5f7E4C7ewYQqhP9NyofhMNypBP0RSUyL09vn
	 OpEJfPmHuj0/jKsKvlrnspjbDY+L8/yeeJGU7EHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/603] clk: qcom: ipq5332: drop the CLK_SET_RATE_PARENT flag from GPLL clocks
Date: Wed, 15 Nov 2023 14:12:23 -0500
Message-ID: <20231115191626.956794376@linuxfoundation.org>
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

[ Upstream commit 5635ef0bd1052420bc659a00be6fd0c60cec5cb9 ]

GPLL clock rates are fixed and shouldn't be scaled based on the
request from dependent clocks. Doing so will result in the unexpected
behaviour. So drop the CLK_SET_RATE_PARENT flag from the GPLL clocks.

Fixes: 3d89d52970fd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5332 SoC")
Signed-off-by: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230913-gpll_cleanup-v2-5-c8ceb1a37680@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5332.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5332.c b/drivers/clk/qcom/gcc-ipq5332.c
index b836159fbdefa..f98591148a976 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -112,7 +112,6 @@ static struct clk_alpha_pll_postdiv gpll2 = {
 				&gpll2_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -152,7 +151,6 @@ static struct clk_alpha_pll_postdiv gpll4 = {
 				&gpll4_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.42.0



