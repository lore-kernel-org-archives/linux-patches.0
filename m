Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E84C1519BE;
	Wed,  5 Feb 2025 14:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765010; cv=none; b=r4e0UXCgeoUvTwbBLmXWUyuA7h3Pv4TB2ZZqEydm/JgNVSIo7kd+mNM7xIStp8HYcYyhtPYt5lsXTBIEk5Yhd82OCqykGn3R79yCoLTw5VYx/qDnaro97/CrSyUc19QrDfL7UwoO6GLwXAjZllui1SJRBDJvhooiwZHu39DKhz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765010; c=relaxed/simple;
	bh=Z5MXwyJeQy573ZasXyes7+ozz1dVjqixwZBgXyUdJQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4XrEE6AuxdcdALUF5UIwdkK8ElwW1Fw2FOlcpgWt2x9DYOFAsEKNf6/mZMnfG7p7UnUnuPw2fijGkN4NT951syjwjd32+PPewQ4TGJjMRtOpOyGvxenUtMhmLhf+UmPMrfxI5hzxu+skgqCNCwNCPT8Z4WjDV1i7l4uQac04Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ffhy0hwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ffhy0hwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA848C4CED1;
	Wed,  5 Feb 2025 14:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765010;
	bh=Z5MXwyJeQy573ZasXyes7+ozz1dVjqixwZBgXyUdJQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ffhy0hwiWm2woiALQ0U1DwPW73ozjU51EUaVcdu520kP/qCiN0C+cDtW2OkZLFvTq
	 DuYCj+HJ/xFUXuUWvs4eveT1Yi75HTXbhwIYZhJFqqhFcQ9sFrkWhclXdVAc71Wb1t
	 BQgKkGlWlu5mhKdHrdkA4I+4OoO89gjcteETVIVo=
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
Subject: [PATCH 6.13 135/623] clk: qcom: camcc-x1e80100: Set titan_top_gdsc as the parent GDSC of subordinate GDSCs
Date: Wed,  5 Feb 2025 14:37:57 +0100
Message-ID: <20250205134501.397757364@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



