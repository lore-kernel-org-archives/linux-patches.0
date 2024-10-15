Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9059E1C57B1;
	Tue, 15 Oct 2024 12:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993816; cv=none; b=VusxcmbRN0rfw0zSTPokJXo+Z0SXu3YizVzICoy6HWWM6z0nN3QyGk9o/UmCMKbKDsvSHnRbSnCAFCpWRExZJBfgwtUCDTlqibJcCiibk/HHth44r+35mNt3plEMhUx5cKDhgTzA1cIAziA0HlaJSlCD6CynRquPWTGkBwqP1B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993816; c=relaxed/simple;
	bh=BOw8Rriag/HetO4A3NUNLUM+LQ3idlw+nF6IM3NZ5gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLDd7PpvDQ50g0EW/9APXvWCB+6AXXuyqJjd2zjzqOt3saVUsQUFjRn7fTgdNjFuv1VBgpUWJgDMnEwJ3A5I45LBCnpHIddg5Mmlb9NDlLuaI8FUFGc4CwBO/xGa/wqkdgLRoFOgRDu/4YvBoRDD9UvTCHgXSQ58jYWDQzsNOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZIqOsOvH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZIqOsOvH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3923C4CEC6;
	Tue, 15 Oct 2024 12:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993816;
	bh=BOw8Rriag/HetO4A3NUNLUM+LQ3idlw+nF6IM3NZ5gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZIqOsOvHT9FtbcgZw3hbB2G7K5/9MCrKoc9iOe7wYCkU2sm3gspEGvPlX8SwKHIvI
	 ByeHoNG+7Fp8dK7rbM/Z4m8KVyShb76W2qGUTnTUvWNNa6RKxbufVj9KiXWoJOzKcU
	 dRBqOzDBxxiCM4VqqaJMymBy0OnUTG89XLy7RMNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 525/691] clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks
Date: Tue, 15 Oct 2024 13:27:53 +0200
Message-ID: <20241015112501.178190119@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -832,6 +832,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link1_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -867,6 +868,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -992,6 +994,7 @@ static struct clk_branch disp_cc_mdss_md
 				&disp_cc_mdss_mdp_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},


