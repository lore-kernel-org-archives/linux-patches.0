Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6273E2E658;
	Fri, 24 Nov 2023 18:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bb3C2PUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD84C433C8;
	Fri, 24 Nov 2023 18:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851056;
	bh=8VnTqDjN995EH68KD0oRJeVT8dD+ftkqhBp8MreETIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb3C2PUws7rcuAuOTnQeg77QW2WcqEXDcRJh/7O8pnBacSXH+OUe8AUydOkgY3yv1
	 mMekmJpjmTabKZ1xM08AwzA/Tki81mHaoC88WVxq64H20lUDH6ja0KFMMFp1X3GGaF
	 UOxLr75UxEXwZimriuAyCdmH5uVuDO5n9dDiQrog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.5 295/491] clk: qcom: ipq8074: drop the CLK_SET_RATE_PARENT flag from PLL clocks
Date: Fri, 24 Nov 2023 17:48:51 +0000
Message-ID: <20231124172033.435614576@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>

commit e641a070137dd959932c7c222e000d9d941167a2 upstream.

GPLL, NSS crypto PLL clock rates are fixed and shouldn't be scaled based
on the request from dependent clocks. Doing so will result in the
unexpected behaviour. So drop the CLK_SET_RATE_PARENT flag from the PLL
clocks.

Cc: stable@vger.kernel.org
Fixes: b8e7e519625f ("clk: qcom: ipq8074: add remaining PLL’s")
Signed-off-by: Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>
Link: https://lore.kernel.org/r/20230913-gpll_cleanup-v2-1-c8ceb1a37680@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/qcom/gcc-ipq8074.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -76,7 +76,6 @@ static struct clk_fixed_factor gpll0_out
 				&gpll0_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_fixed_factor_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -122,7 +121,6 @@ static struct clk_alpha_pll_postdiv gpll
 				&gpll2_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -155,7 +153,6 @@ static struct clk_alpha_pll_postdiv gpll
 				&gpll4_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -189,7 +186,6 @@ static struct clk_alpha_pll_postdiv gpll
 				&gpll6_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -202,7 +198,6 @@ static struct clk_fixed_factor gpll6_out
 				&gpll6_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_fixed_factor_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -267,7 +262,6 @@ static struct clk_alpha_pll_postdiv nss_
 				&nss_crypto_pll_main.clkr.hw },
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 


