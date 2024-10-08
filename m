Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BB41DEFD7;
	Tue,  8 Oct 2024 13:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393884; cv=none; b=d43VtAhb2JbUiGaFFiMwH8Qmsp+hT1VNHT7kkzpL+nlqgQkwE8ssw9tsCVE6NZfUVwfs3H4w1dyLvmDknmIzmd99Z0eNy1eEfFSKSs96oZ9JTO0yX5rpmQHwkskaH8TSescP4fv0iYxxh2vRfdAF+TdtrQ+/BPA+fpjld49qJZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393884; c=relaxed/simple;
	bh=0MK4+47xUtj2+HtbuBWsSzrzWhBPq4HrAiKbgpGjq9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QiL6jWGppNhOg9FJhgnoEWZwbYFS+v8xIpZ/w9XO/iPfFqoUmp/WepDZwVycK/x9wReOz6RvjktiaVNrekfwjMJPYfMHxiEV0eLU8TDobkN4f89gFTfo1aJrH8UXQ4drTCndsUXdEg6RNf7vdLnJ7zVRrrfBOfcDu8vC39CfLpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j21ta5QS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j21ta5QS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2EFC4CEC7;
	Tue,  8 Oct 2024 13:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393883;
	bh=0MK4+47xUtj2+HtbuBWsSzrzWhBPq4HrAiKbgpGjq9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j21ta5QSwQYYcQid0y0XgcQWdquj6yu8lCU6UmTQ8Rt8vtzs1nJnTsjoNpJux5TXA
	 Lej8Mwr3h00y9ogyW7X6Ijnb7AXr4y6uSG9flOZEXj553vLsNzBIAN+H8u/wqONB7S
	 88MRi/WKIDa4XMNCVIEskuQLeCsz3wEfJlFk5VRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 282/386] clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks
Date: Tue,  8 Oct 2024 14:08:47 +0200
Message-ID: <20241008115640.484633263@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 0e93c6320ecde0583de09f3fe801ce8822886fec upstream.

Add CLK_SET_RATE_PARENT for several branch clocks. Such clocks don't
have a way to change the rate, so set the parent rate instead.

Fixes: 80a18f4a8567 ("clk: qcom: Add display clock controller driver for SM8150 and SM8250")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240804-sm8350-fixes-v1-1-1149dd8399fe@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/dispcc-sm8250.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/clk/qcom/dispcc-sm8250.c
+++ b/drivers/clk/qcom/dispcc-sm8250.c
@@ -851,6 +851,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link1_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -886,6 +887,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1011,6 +1013,7 @@ static struct clk_branch disp_cc_mdss_md
 				&disp_cc_mdss_mdp_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},


