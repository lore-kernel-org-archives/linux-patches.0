Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8FC335F04;
	Fri, 24 Nov 2023 18:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAVGtTJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D755C433C7;
	Fri, 24 Nov 2023 18:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852074;
	bh=8RKcNt9kYUxLGm5yUt/uFTpN+0vpDPIq4ZAlvxMD2kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAVGtTJdiB+5gPGl2yGEZOGvbhaD46Kmwxf+CN1tecOa8MPlHloYgRHaU/V1I2rk9
	 w3EnkosFUQvld76goePEiBJcXomd6wtiFwgufChWNa9hWMgHEaWkCI7CCIjGoiX+0L
	 EGr/fLV1LRZ47/vVo9b6ZK9LxQLSoq+GdjQ0RTKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kathiravan Thirumoorthy <quic_kathirav@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 209/372] clk: qcom: ipq8074: drop the CLK_SET_RATE_PARENT flag from PLL clocks
Date: Fri, 24 Nov 2023 17:49:56 +0000
Message-ID: <20231124172017.433501644@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -419,7 +419,6 @@ static struct clk_fixed_factor gpll0_out
 		},
 		.num_parents = 1,
 		.ops = &clk_fixed_factor_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -466,7 +465,6 @@ static struct clk_alpha_pll_postdiv gpll
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -499,7 +497,6 @@ static struct clk_alpha_pll_postdiv gpll
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -533,7 +530,6 @@ static struct clk_alpha_pll_postdiv gpll
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -547,7 +543,6 @@ static struct clk_fixed_factor gpll6_out
 		},
 		.num_parents = 1,
 		.ops = &clk_fixed_factor_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 
@@ -612,7 +607,6 @@ static struct clk_alpha_pll_postdiv nss_
 		},
 		.num_parents = 1,
 		.ops = &clk_alpha_pll_postdiv_ro_ops,
-		.flags = CLK_SET_RATE_PARENT,
 	},
 };
 


