Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03539178384;
	Tue,  8 Oct 2024 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390763; cv=none; b=rqae0kCV+eTsnq9FIWEQJK5o7oHjVM1jILpKSRotn9EeKtpplXBdTI2iwjE+BgEPR9SW/kCDUE923lgrJMncSG/xLflIYkqyBxdM+SfAyfF/GYyJCIERfraiQJVoZ3K9K+jxI7gfaNQ8syrVRJ5jHouU3eYuk07rzLgzbjh7qz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390763; c=relaxed/simple;
	bh=6aNnBKhRvPZpL2Pa1t1HpLM7a2XSzwCEUksa6LJvA1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9buP9BRUzn+XXWkRtguXOIHV/UuRYxHa9n6A4FB+Q83XRLSRqoUuD5yKxp/eRMcnh8j9EHvgDMh6NKzPjnhspN/VqhpALTYJDgso/NCtDUyA/Ng6JjH+qvO+/YGOF4HgomehNYfuBNYHJhLkj5ciYnZKfnyBVWo9LlBhYQ0Qpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boT+X6qE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boT+X6qE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65134C4CEC7;
	Tue,  8 Oct 2024 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390762;
	bh=6aNnBKhRvPZpL2Pa1t1HpLM7a2XSzwCEUksa6LJvA1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boT+X6qEY1Jb77nZAdQsbicbuvXh7tklMg6ol+yp2tkJ8la0yWaUrZjgeAzNN47j/
	 o4QSlUkFS+zOHVNqTiCkdV9x1J1NryuHNQUXlNVlTIs10RNbNnrJRlDnSyZGirYpr6
	 +JXtO5w4MHlb4pTJJSlI1bhehHgItLQwag1JLTPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.10 385/482] clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks
Date: Tue,  8 Oct 2024 14:07:28 +0200
Message-ID: <20241008115703.565371943@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -849,6 +849,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link1_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -884,6 +885,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -1009,6 +1011,7 @@ static struct clk_branch disp_cc_mdss_md
 				&disp_cc_mdss_mdp_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},


