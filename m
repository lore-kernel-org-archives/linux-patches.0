Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A8E3C471
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sw/FKhfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E028C433C7;
	Wed, 15 Nov 2023 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077215;
	bh=PCw3QbC1N591S+wBIqvNa1HDt5NYeMG3j/J3tTLR0Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sw/FKhfVnJr0aUHYmJCoEnrBoAYmQLP30bQi/cFX8sHZZ2t520Y9aAExzgi6z7cXZ
	 NevrrSZ7gsouRjpNN/vgi9suXETAZsCcmunpH46xXP4vvH65LdP72qC0dfsUYCJOjT
	 G/uu8oImmPJ43fK3nk4JTGXoxsRBdZmGUPZJE3C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varadarajan Narayanan <quic_varada@quicinc.com>,
	Kathiravan T <quic_kathirav@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 160/603] clk: qcom: ipq5332: Drop set rate parent from gpll0 dependent clocks
Date: Wed, 15 Nov 2023 14:11:45 -0500
Message-ID: <20231115191624.264194684@linuxfoundation.org>
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

From: Varadarajan Narayanan <quic_varada@quicinc.com>

[ Upstream commit ccd8ab030643040600a663edde56b434b6f4fb6c ]

IPQ5332's GPLL0's nominal/turbo frequency is 800MHz.
This must not be scaled based on the requirement of
dependent clocks. Hence remove the CLK_SET_RATE_PARENT
flag.

Fixes: 3d89d52970fd ("clk: qcom: add Global Clock controller (GCC) driver for IPQ5332 SoC")
Signed-off-by: Varadarajan Narayanan <quic_varada@quicinc.com>
Reviewed-by: Kathiravan T <quic_kathirav@quicinc.com>
Link: https://lore.kernel.org/r/1693474133-10467-1-git-send-email-quic_varada@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq5332.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq5332.c b/drivers/clk/qcom/gcc-ipq5332.c
index b02026f8549b2..b836159fbdefa 100644
--- a/drivers/clk/qcom/gcc-ipq5332.c
+++ b/drivers/clk/qcom/gcc-ipq5332.c
@@ -71,7 +71,6 @@ static struct clk_fixed_factor gpll0_div2 = {
 				&gpll0_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_fixed_factor_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -85,7 +84,6 @@ static struct clk_alpha_pll_postdiv gpll0 = {
 				&gpll0_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
-- 
2.42.0



