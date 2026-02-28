Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C3D4A340F;
	Sat, 28 Feb 2026 17:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301307; cv=none; b=G53hgODtMS4Gf5gzYGKR0Q25RiiX/ceNx5ieoB/snx7pnqwK8MnXmVBEORrhw3fyAyk9qe8Do5FLo/kZTKc1c2+qB+46v8csUoiQXa12CJQC7Sn5uKeV9BqOcmvwArA2X+WRwJVjIlQzT8Y0dpGJQ/q95BF7XNt1YzayC3TRgcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301307; c=relaxed/simple;
	bh=3drQ1pntDgD8cKr0pOMNBsPMBL2VYyAvXw5eXc5afp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/4c5D1lWqrx6tM+WB7sekfvxuesM/eJerwIB3s2Pi16ms4Z2FsJSzzxN6uSo12ivLBR583FHQuU49+AEAv3L01/3+CHCb7GjwrsYO+lM6Qy9jewA7Ue3FgpPCoVaMj4fDvyl7JHFqEm8zRvme5ILBT+L2PfYpjMjiQrvN42fkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoAsJfJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoAsJfJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88C9C19424;
	Sat, 28 Feb 2026 17:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301307;
	bh=3drQ1pntDgD8cKr0pOMNBsPMBL2VYyAvXw5eXc5afp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VoAsJfJu10aCFc61RP8ICpEQtXrZnxUufHrzH+aqKXMsUEBmWAYroGYLfY6/+yHx0
	 dH+OS2W/cVIsO8ZFR7e3Rtr2/j4ef6w1G5LzPcULUM9/Ao7fdSlzcl+dtdWmhTcPu2
	 wud7ANbH/NVsobUedUAqIDsaO4pmEDKACHwrPY0rqe4hbj8ifgfLlZjSF88K6hJpIb
	 nhx10Vlav6HVYlwF7abTLGrwVKi3zyvtDMq46Wl/3oDb7PcxJl+U3TWGaH1FUsAmnQ
	 O6drhLO2DSXoPKuJmh/mORYBlqyYBRXYbxwXSg/VyxMpvb4Ea7vriBl5pl46OTfSH3
	 1RIKeBfGsHWbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abel Vesa <abel.vesa@linaro.org>,
	stable@vger.kernel.org,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 492/752] arm64: dts: qcom: x1e80100: Add missing TCSR ref clock to the DP PHYs
Date: Sat, 28 Feb 2026 12:43:23 -0500
Message-ID: <20260228174750.1542406-492-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 0907cab01ff9746ecf08592edd9bd85d2636be58 ]

The DP PHYs on X1E80100 need the ref clock which is provided by the
TCSR CC.

The current X Elite devices supported upstream work fine without this
clock, because the boot firmware leaves this clock enabled. But we should
not rely on that. Also, even though this change breaks the ABI, it is
needed in order to make the driver disables this clock along with the
other ones, for a proper bring-down of the entire PHY.

So lets attach it to each of the DP PHYs in order to do that.

Cc: stable@vger.kernel.org # v6.9
Fixes: 1940c25eaa63 ("arm64: dts: qcom: x1e80100: Add display nodes")
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20251224-phy-qcom-edp-add-missing-refclk-v5-3-3f45d349b5ac@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 512a75da4f13f..6d97329995fe7 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -5811,9 +5811,11 @@ mdss_dp2_phy: phy@aec2a00 {
 			      <0 0x0aec2000 0 0x1c8>;
 
 			clocks = <&dispcc DISP_CC_MDSS_DPTX2_AUX_CLK>,
-				 <&dispcc DISP_CC_MDSS_AHB_CLK>;
+				 <&dispcc DISP_CC_MDSS_AHB_CLK>,
+				 <&tcsr TCSR_EDP_CLKREF_EN>;
 			clock-names = "aux",
-				      "cfg_ahb";
+				      "cfg_ahb",
+				      "ref";
 
 			power-domains = <&rpmhpd RPMHPD_MX>;
 
@@ -5831,9 +5833,11 @@ mdss_dp3_phy: phy@aec5a00 {
 			      <0 0x0aec5000 0 0x1c8>;
 
 			clocks = <&dispcc DISP_CC_MDSS_DPTX3_AUX_CLK>,
-				 <&dispcc DISP_CC_MDSS_AHB_CLK>;
+				 <&dispcc DISP_CC_MDSS_AHB_CLK>,
+				 <&tcsr TCSR_EDP_CLKREF_EN>;
 			clock-names = "aux",
-				      "cfg_ahb";
+				      "cfg_ahb",
+				      "ref";
 
 			power-domains = <&rpmhpd RPMHPD_MX>;
 
-- 
2.51.0

