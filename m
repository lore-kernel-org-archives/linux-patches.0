Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A4C1B2185;
	Tue, 15 Oct 2024 13:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998274; cv=none; b=LDL5NhZhF0QsxiSOkUBemDTPCa5JmpYnq5gfIk2wZQpdDQxlkbs8hLv9pkISs+M5wm4ieAA6hfFC8+fc+PBqZ5Fqe0eznFGesU6bdeXsVHQ/Uuw85nILlBA1XTREDQJYAAVYOTy6DTOc3lDOzae2HgOaHOWXkhsJilNZM/uiwyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998274; c=relaxed/simple;
	bh=tvbOXrxv/qIwdxPZfUmLJqFD6oe3MBnjddhn1qMS4UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gz3Am5dhk5mWWeUFW7tOKVoDmhr1Rl0r9a1gvcHNQ0tkw4gbsjhHPPscDyd5Ytc5Z/OPEh4KG2WaduD++qAeUiVYHzVbvsi190+xWOk4BhBVHQQ5vMP7ejBoew5SDwdDJkq9CSyvbTvxMClJ3JzbSJxuxI3UEUsGvgPb3YEB8/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYMc8NQG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYMc8NQG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7E6C4CEC6;
	Tue, 15 Oct 2024 13:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998273;
	bh=tvbOXrxv/qIwdxPZfUmLJqFD6oe3MBnjddhn1qMS4UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYMc8NQGH4HbyYfqLWKm2hCZv75xg+Wb3C6OruP8DgSR94PBGtSIcpxFvApE1/oNt
	 XI1UfwaLmrdzT5yuwPptmEtCJFPJanyQVKPQ5jfGJTzWuhfJ3nHKf8cCqvjyFE6Hlr
	 VVSINtAOtbYZxe8KPZuZ/0hzuIrPWEATwzi18Mu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 429/518] clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks
Date: Tue, 15 Oct 2024 14:45:33 +0200
Message-ID: <20241015123933.549944162@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 0e93c6320ecde0583de09f3fe801ce8822886fec ]

Add CLK_SET_RATE_PARENT for several branch clocks. Such clocks don't
have a way to change the rate, so set the parent rate instead.

Fixes: 80a18f4a8567 ("clk: qcom: Add display clock controller driver for SM8150 and SM8250")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240804-sm8350-fixes-v1-1-1149dd8399fe@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sm8250.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/qcom/dispcc-sm8250.c b/drivers/clk/qcom/dispcc-sm8250.c
index 07a98d3f882d0..bbdd27946bf1f 100644
--- a/drivers/clk/qcom/dispcc-sm8250.c
+++ b/drivers/clk/qcom/dispcc-sm8250.c
@@ -665,6 +665,7 @@ static struct clk_branch disp_cc_mdss_dp_link1_intf_clk = {
 				.hw = &disp_cc_mdss_dp_link1_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -700,6 +701,7 @@ static struct clk_branch disp_cc_mdss_dp_link_intf_clk = {
 				.hw = &disp_cc_mdss_dp_link_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -825,6 +827,7 @@ static struct clk_branch disp_cc_mdss_mdp_lut_clk = {
 				.hw = &disp_cc_mdss_mdp_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
-- 
2.43.0



