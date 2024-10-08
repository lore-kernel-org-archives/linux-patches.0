Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F951C9B99;
	Tue,  8 Oct 2024 13:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392664; cv=none; b=Y/APbINOo0q9vXJa60xx4HWDrw2+9JnhfkpbrlzZNSXaclGXpkaJnsFvXsAno36rwAnv09kiPKY8TYjcm7dgxKFS3nyfgMXFFAUXLpsO7FytTbJnpngDsseex3wgpWJPNWgRGkSjRLe0DfwHi1a2kSErL/43/Uis8aF95VKG704=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392664; c=relaxed/simple;
	bh=nWJ7qSWX9Sl9U0JyzuJ1VDAiRCaFEHNbs5O9O62W8LE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZa6oBU2CeRI4mLmlPFmsnmZuI0x4GYHsLJId3HQug4l9bgLu0DjEseKeReQAavnD+6Qx91I9Fzqdo+F4V0V6+EmYouA2HW1LELZYdG4m/RnuLcVNB7yJ4g0PF8PP8VIx+Q9peHyHUh7doNxPuOriI7aMBc5Kf9ZHrKo2ULI74w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZ/b0zFU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZ/b0zFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47447C4CEC7;
	Tue,  8 Oct 2024 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392663;
	bh=nWJ7qSWX9Sl9U0JyzuJ1VDAiRCaFEHNbs5O9O62W8LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZ/b0zFUkyLWhmbxVYyWQF0mybp7RcCRbyxlMnEArjPsx/QH1Cl0HUUbXMIMQgRo3
	 HA8pF5Qhmjs2v39ek5THaVchR58wP/OtFk+WBJSjc0HCjmXmCKkB+0G+INJ6PIPixE
	 1EhsmdprzDqC462x8hBbNA7cfOXOu/BeDvM7OqV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.11 451/558] clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks
Date: Tue,  8 Oct 2024 14:08:01 +0200
Message-ID: <20241008115720.008644089@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


