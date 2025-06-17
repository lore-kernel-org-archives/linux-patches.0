Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA09B2FA64D;
	Tue, 17 Jun 2025 16:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178232; cv=none; b=gejIC3qzF5ZUCT/kd+7AcW/+V8fE4zxjM4IAoUDk2CMyBV3iBXZFre4gtmJ9yB586kpKYcBLL/ceM6B3Tv0/uQMSz9kHvSpdLXlIEX/2FWl2/Eau5ix8527vKFygg7tKgSFYX2jyt0l7mx95g+rZa1SwQVUEJze9E/JLBvQuhhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178232; c=relaxed/simple;
	bh=DD/QbU4QLPxos/yMdtwDmTXQqTx64/4mLmjv0TT48Rw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UPWw1Zi47gf8vGUHcP+96MM/0zfEKXCU1l+sxWJegba+hzuFXinR8cBiXMiE+Ib4KCvveLavN6IEe3xAkCWVhvbPwdUq5LHHUNd9nxkKFGc3h+fVcQEXOUHqIkP7Y7PI4XRUrWkaWoU8zwsWHStgfVaByJ4luZKhuDv9OQJJNPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hw7lzp9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hw7lzp9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485C5C4CEE7;
	Tue, 17 Jun 2025 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178232;
	bh=DD/QbU4QLPxos/yMdtwDmTXQqTx64/4mLmjv0TT48Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hw7lzp9Iw+gM65l6Z50NrTAjkxoUM7o2MBwWV2co5gWssvaGPDaC0bD8NDd0vr9PA
	 pHndyW1qKBFX5Rp4wxlnq0NvULTN7M09Bhcb+22jFsr6MvA12+Jnzd0GkY2XHcyWFb
	 Rim+P2bvfWZPDTiWdezun5sqdkbKUpomPVoRtOeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 407/780] arm64: dts: qcom: msm8998: Use the header with DSI phy clock IDs
Date: Tue, 17 Jun 2025 17:21:55 +0200
Message-ID: <20250617152508.041847143@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit f4220c41decc1944ef319c859840aa5405eee6fa ]

Use the header with DSI phy clock IDs to make code more readable.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250408-dts-qcom-dsi-phy-clocks-v2-9-73b482a6dd02@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 7ebdb205d4b9 ("arm64: dts: qcom: msm8998: Remove mdss_hdmi_phy phandle argument")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8998.dtsi | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8998.dtsi b/arch/arm64/boot/dts/qcom/msm8998.dtsi
index c2caad85c668d..7eca38440cd7e 100644
--- a/arch/arm64/boot/dts/qcom/msm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8998.dtsi
@@ -2,6 +2,7 @@
 /* Copyright (c) 2016, The Linux Foundation. All rights reserved. */
 
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/clock/qcom,dsi-phy-28nm.h>
 #include <dt-bindings/clock/qcom,gcc-msm8998.h>
 #include <dt-bindings/clock/qcom,gpucc-msm8998.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8998.h>
@@ -2790,10 +2791,10 @@
 				      "gpll0_div";
 			clocks = <&rpmcc RPM_SMD_XO_CLK_SRC>,
 				 <&gcc GCC_MMSS_GPLL0_CLK>,
-				 <&mdss_dsi0_phy 1>,
-				 <&mdss_dsi0_phy 0>,
-				 <&mdss_dsi1_phy 1>,
-				 <&mdss_dsi1_phy 0>,
+				 <&mdss_dsi0_phy DSI_PIXEL_PLL_CLK>,
+				 <&mdss_dsi0_phy DSI_BYTE_PLL_CLK>,
+				 <&mdss_dsi1_phy DSI_PIXEL_PLL_CLK>,
+				 <&mdss_dsi1_phy DSI_BYTE_PLL_CLK>,
 				 <&mdss_hdmi_phy 0>,
 				 <0>,
 				 <0>,
@@ -2932,8 +2933,8 @@
 					      "bus";
 				assigned-clocks = <&mmcc BYTE0_CLK_SRC>,
 						  <&mmcc PCLK0_CLK_SRC>;
-				assigned-clock-parents = <&mdss_dsi0_phy 0>,
-							 <&mdss_dsi0_phy 1>;
+				assigned-clock-parents = <&mdss_dsi0_phy DSI_BYTE_PLL_CLK>,
+							 <&mdss_dsi0_phy DSI_PIXEL_PLL_CLK>;
 
 				operating-points-v2 = <&dsi_opp_table>;
 				power-domains = <&rpmpd MSM8998_VDDCX>;
@@ -3008,8 +3009,8 @@
 					      "bus";
 				assigned-clocks = <&mmcc BYTE1_CLK_SRC>,
 						  <&mmcc PCLK1_CLK_SRC>;
-				assigned-clock-parents = <&mdss_dsi1_phy 0>,
-							 <&mdss_dsi1_phy 1>;
+				assigned-clock-parents = <&mdss_dsi1_phy DSI_BYTE_PLL_CLK>,
+							 <&mdss_dsi1_phy DSI_PIXEL_PLL_CLK>;
 
 				operating-points-v2 = <&dsi_opp_table>;
 				power-domains = <&rpmpd MSM8998_VDDCX>;
-- 
2.39.5



