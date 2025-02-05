Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A621C1519AA;
	Wed,  5 Feb 2025 14:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764522; cv=none; b=RVAtRz9u1wRGgrYQxp9A2KRF0X0N7cDAcqEk7lvEm5NH5WPjBkNOAUwXkluplxthkF1j2dDJGS/LEDVdgAJLZEfjHgaTmoj1wV2eTDgNzY3zLYgCbUVEOEHD9QYA+kS2P1poN303ND5H8HX8MpTI+dy9sblx8sMTuj+/6aQ5DQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764522; c=relaxed/simple;
	bh=2pOvVGI1UVBOIgweXgyPXFfNXgatd3rpY6LADY0iL6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGQbjF1ctVOP3nfNfc9bc5TeffOfjeVfj7RKeO15Iw/CwEO11/vPSnIEvorXYIFJeO8MuVhhDDKCqzlAASD5nFsLPntSAUH5ZOwcV2aXCxjfZOFFRGCB2WZZKBYp70/KA7q+dHjU3WylXGN1b3byfBWQeeCbwvlBvjkeIOpa5aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SON+Tc/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SON+Tc/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8621C4CED1;
	Wed,  5 Feb 2025 14:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764522;
	bh=2pOvVGI1UVBOIgweXgyPXFfNXgatd3rpY6LADY0iL6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SON+Tc/5JJHqvN93otJF+/VkRofT5V1dEks/xzZc3T1oqDd/85SFoc102nbOgUD/F
	 0kLOzJKtSW1+HwrF4uZbLDUfk5EZus7ihoh+uVZYjYT/IUk1z2J710v41M100M5Q7W
	 6W3TxnH8+GbwzJwYehmxBCmq87LDeg1PtmP/L2wI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajendra Nayak <quic_rjendra@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/590] clk: qcom: camcc-x1e80100: Set titan_top_gdsc as the parent GDSC of subordinate GDSCs
Date: Wed,  5 Feb 2025 14:38:03 +0100
Message-ID: <20250205134500.158114044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit d9377941f2732d2f6f53ec9520321a19c687717a ]

The Titan TOP GDSC is the parent GDSC for all other GDSCs in the CAMCC
block. None of the subordinate blocks will switch on without the parent
GDSC switched on.

Fixes: 76126a5129b5 ("clk: qcom: Add camcc clock driver for x1e80100")
Acked-by: Rajendra Nayak <quic_rjendra@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20241227-b4-linux-next-24-12-16-titan-top-gdsc-v1-1-c96ef62fc307@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-x1e80100.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/qcom/camcc-x1e80100.c b/drivers/clk/qcom/camcc-x1e80100.c
index 85e76c7712ad8..b73524ae64b1b 100644
--- a/drivers/clk/qcom/camcc-x1e80100.c
+++ b/drivers/clk/qcom/camcc-x1e80100.c
@@ -2212,6 +2212,8 @@ static struct clk_branch cam_cc_sfe_0_fast_ahb_clk = {
 	},
 };
 
+static struct gdsc cam_cc_titan_top_gdsc;
+
 static struct gdsc cam_cc_bps_gdsc = {
 	.gdscr = 0x10004,
 	.en_rest_wait_val = 0x2,
@@ -2221,6 +2223,7 @@ static struct gdsc cam_cc_bps_gdsc = {
 		.name = "cam_cc_bps_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -2233,6 +2236,7 @@ static struct gdsc cam_cc_ife_0_gdsc = {
 		.name = "cam_cc_ife_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -2245,6 +2249,7 @@ static struct gdsc cam_cc_ife_1_gdsc = {
 		.name = "cam_cc_ife_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -2257,6 +2262,7 @@ static struct gdsc cam_cc_ipe_0_gdsc = {
 		.name = "cam_cc_ipe_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
@@ -2269,6 +2275,7 @@ static struct gdsc cam_cc_sfe_0_gdsc = {
 		.name = "cam_cc_sfe_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = POLL_CFG_GDSCR | RETAIN_FF_ENABLE,
 };
 
-- 
2.39.5



