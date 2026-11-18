Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030199;
	b=yZO+MWYrDX1p0rMkj0c1H5gX58mM6b8pF/gzaIsU2Pg1tpptKYdqtzbvg8C5YAmhByIE
	 14eJ69KwLlNkpwoOGOoGLw7kZ5TO3cQTip+imKDDKN/6b5JUKT4Sp3AhMkHBqPWgv4j1K
	 ZZsQZBdVWHpmllP+gBarzeQO/VmK1LXnJdQinc1om01VN6UUb1eFCNqIaWCNk/f+ry86C
	 DUIVB96Bl30hmBdzb3OVMmur7drQA+S9z5JDxwX3QLAekzglXjpcyRCwklp3xMy5as3JB
	 EMY3GW16XQDejmoSf4SIehvZX0NTg/psVVMiSchcOpoFcV98UNw6xehb/tALFG8X0TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nFikOPBd/fXkI82NF7eEAW1+H3qJ5weGMCgQrNcPTfk=;
	b=P5iGV4ISUbeaRgATaGO2d1qxKL/9o9bmcNgvgV4aUEviudw+OJ75ASEJ1SQoV5f2dq5v
	 WV0aKvOwmnezXwdbpeT5B4lBrcBkDmNS8TkvBuSXiPcxQ7DP50r1MTt7z3Foc1oN51g/u
	 HIvSjtkeeIb3lZ9CdWORgsfu4sNKoCcFBrpUIGUm9/YOByE5qWPfYk79LSQq0IF80SSTB
	 VUpzyWahpQuwbIreropKrM4G0xb4wuX/XOQS3MJWOmGSWKC7Yr+PG5f6ksLIl7m1Dw1zS
	 Q7PRmLbCCGMKuHGivEpXpbiTegu39VRMO4iBH1Ox5Lv2r2XYbMaNvzVh6VBELyj+55A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9YlH8VA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB48606D34E;
	Wed, 18 Nov 2026 19:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K9YlH8VA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD02D1F000C4;
	Wed, 18 Nov 2026 19:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030199;
	bh=nFikOPBd/fXkI82NF7eEAW1+H3qJ5weGMCgQrNcPTfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9YlH8VAJ+g52SSAf4L7miRRuS5yrfLSR8S5shELv0M5PvG6uuducJ3G2HHCiAzZM
	 HK+GR3LyLttrUhuzqCrf6ylhm9YJEYhWFDcbGQMAJH01uuqqR5beTygCs2e2hWCfEr
	 vQs9YDod8x2b2P2RzAilo0g7eq4d4HqKHL07IFDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0603/1756] ARM: dts: qcom: msm8974: Use the header with DSI phy clock IDs
Date: Wed, 18 Nov 2026 15:45:30 +0100
Message-ID: <20261118150032.964991815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 1afdd80d1e021f758c975d857c6beb6da5c891bd ]

Use the header with DSI phy clock IDs to make code more readable.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250408-dts-qcom-dsi-phy-clocks-v2-2-73b482a6dd02@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 542991a1d77e ("ARM: dts: qcom: msm8974: add MDSS reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-msm8974.dtsi | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
index 1bd87170252df..0fd2134934b92 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
@@ -3,6 +3,7 @@
 
 #include <dt-bindings/interconnect/qcom,msm8974.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/clock/qcom,dsi-phy-28nm.h>
 #include <dt-bindings/clock/qcom,gcc-msm8974.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8974.h>
 #include <dt-bindings/clock/qcom,rpmcc.h>
@@ -1871,10 +1872,10 @@ mmcc: clock-controller@fd8c0000 {
 				 <&gcc GPLL0_VOTE>,
 				 <&gcc GPLL1_VOTE>,
 				 <&rpmcc RPM_SMD_GFX3D_CLK_SRC>,
-				 <&mdss_dsi0_phy 1>,
-				 <&mdss_dsi0_phy 0>,
-				 <&mdss_dsi1_phy 1>,
-				 <&mdss_dsi1_phy 0>,
+				 <&mdss_dsi0_phy DSI_PIXEL_PLL_CLK>,
+				 <&mdss_dsi0_phy DSI_BYTE_PLL_CLK>,
+				 <&mdss_dsi1_phy DSI_PIXEL_PLL_CLK>,
+				 <&mdss_dsi1_phy DSI_BYTE_PLL_CLK>,
 				 <0>,
 				 <0>,
 				 <0>;
@@ -1961,8 +1962,10 @@ mdss_dsi0: dsi@fd922800 {
 				interrupt-parent = <&mdss>;
 				interrupts = <4>;
 
-				assigned-clocks = <&mmcc BYTE0_CLK_SRC>, <&mmcc PCLK0_CLK_SRC>;
-				assigned-clock-parents = <&mdss_dsi0_phy 0>, <&mdss_dsi0_phy 1>;
+				assigned-clocks = <&mmcc BYTE0_CLK_SRC>,
+						  <&mmcc PCLK0_CLK_SRC>;
+				assigned-clock-parents = <&mdss_dsi0_phy DSI_BYTE_PLL_CLK>,
+							 <&mdss_dsi0_phy DSI_PIXEL_PLL_CLK>;
 
 				clocks = <&mmcc MDSS_MDP_CLK>,
 					 <&mmcc MDSS_AHB_CLK>,
@@ -2032,8 +2035,10 @@ mdss_dsi1: dsi@fd922e00 {
 				interrupt-parent = <&mdss>;
 				interrupts = <4>;
 
-				assigned-clocks = <&mmcc BYTE1_CLK_SRC>, <&mmcc PCLK1_CLK_SRC>;
-				assigned-clock-parents = <&mdss_dsi1_phy 0>, <&mdss_dsi1_phy 1>;
+				assigned-clocks = <&mmcc BYTE1_CLK_SRC>,
+						  <&mmcc PCLK1_CLK_SRC>;
+				assigned-clock-parents = <&mdss_dsi1_phy DSI_BYTE_PLL_CLK>,
+							 <&mdss_dsi1_phy DSI_PIXEL_PLL_CLK>;
 
 				clocks = <&mmcc MDSS_MDP_CLK>,
 					 <&mmcc MDSS_AHB_CLK>,
-- 
2.53.0



