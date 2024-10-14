Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0B01AAE1D;
	Mon, 14 Oct 2024 15:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919342; cv=none; b=aad6ruhDbrcyvKvQ6sh7UEUbeCp4Nrk/fDb0J9xo0QPYCtaZjVkc/1UoBa+d5NRahbcniFJLacdVR4vh78Cgr58LCeEeDZjIMo3ojUgUIgKMxaPkPvtieQhZ3/zcqhNy7h8iLhzRTswk8jp9QxlddGbfpEbHf6BjsDadnA6/gYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919342; c=relaxed/simple;
	bh=kcc6XKyNg2ecMJD7PKggJ4T7l1updRKI8/DY7K8flTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h01ZWz7hiBFL10Z8uSzFnhxXjNuC6TB42N3i0bijUmsJwsDSSfBQzp817BfQ/dUtzdyw6CYzzOu/VNpAUyOOH2RN2aqSbjf1slsBeGbhJOr70M7cYejeWk7aiAfZll+0BOkcXHzYhsFQb7r0r9oeRSAItzgbW+JMz+DzqjndTJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWNcJsOi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWNcJsOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2ABC4CEC3;
	Mon, 14 Oct 2024 15:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919341;
	bh=kcc6XKyNg2ecMJD7PKggJ4T7l1updRKI8/DY7K8flTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWNcJsOiMz9+/PSoGSoPFfARQNgh0W2AGa35FOiC4VCuK4QAZ0Wy84bVntCvOnSvw
	 cTL0bQOohYFGgOS2DwF8yn2ddEmuRqOIi+amjJP+OhaBaAjQ0UZyf03aq1jBPsWVi4
	 GbT6ZThaD9g8Ex2fxkcuO7iyu+h+Sdze8hJHXL/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 582/798] clk: qcom: dispcc-sm8250: use CLK_SET_RATE_PARENT for branch clocks
Date: Mon, 14 Oct 2024 16:18:56 +0200
Message-ID: <20241014141240.868752231@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -837,6 +837,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link1_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -872,6 +873,7 @@ static struct clk_branch disp_cc_mdss_dp
 				&disp_cc_mdss_dp_link_div_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},
@@ -997,6 +999,7 @@ static struct clk_branch disp_cc_mdss_md
 				&disp_cc_mdss_mdp_clk_src.clkr.hw,
 			},
 			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
 			.ops = &clk_branch2_ops,
 		},
 	},


