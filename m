Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040218;
	b=EirWyBhCWlbQD//38YTzO20QWdWU+t+12S/tED+eaElWOM4uzXUADgHshHysJxmAeiRG
	 BxdlDt3+yw2cEaziZGoTzGT17nps9j94jIlIH8EolzaTwZU0RpazcKHdteqmDzZ90zcoC
	 ptTW/hTsq7ZAXJLl007Rkd+jKmatbctH3zVNDT2eo8N4P+4HePfL0aChOTXtVnT5IBlS+
	 qANk71XEdAV3vpCHmaqijf8iorMdm/kQa3AobUXkGlWV75M7jSutZYCvttDte9oA0DneY
	 U/FrZ6Indc4XxM/r8KTB0cT9Xq+KYY3Z66h1CNnzIEVJ69E1o9RWA6KPJgCkMO34LBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zBZ/jJuFTheWfaaIu8sd21JVGs2hKhOuJfG3csDdwfU=;
	b=5b5TsGeTPfUnX9Vx5ItGw61UlzgbKR3FXfsoqBvhRTNUBsah6ZCrGm0DAiEq91am4iwJ
	 qCRgCDi+q0kAshK56tdhSk+FFBBB/OY2mDXipnOD6yJjjlQwGndtCeJ4qKgYt2D2fGTnL
	 Pwru1itzKlgP+xuCJbC2ZXZn+X+YiU8DXrd0pAvBiVLdCxqU8PCU16pvLYznlFvHcm8+Y
	 cw0/GV+SmR5Stsq5Ou2KlfuFZMSmwJ/8x3j+oYBbio5+E1lC/mpqKeajczjKAJXwI2Zdx
	 vSWMXbfOyD7ZjqnIB2rufNNaIUlPMGHpe+3Oqyn6LODo0Hw/Yu1fvwpHMCB7eBX1emw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbLX5Jei;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF48D606A320;
	Wed, 18 Nov 2026 22:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbLX5Jei
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124F41F000C4;
	Wed, 18 Nov 2026 22:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040218;
	bh=zBZ/jJuFTheWfaaIu8sd21JVGs2hKhOuJfG3csDdwfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbLX5JeioYU10uVRkoHElBi9wOAUyllP72cgxCimDUWcRVnmo1Klnuvd+SQ3vnipD
	 F4oqHFDtg+lh/Os+5n4ICGpSmXqwwZaNurQjzyw/Dj3z/8/Q7UFeTteFlQS0tYFN7V
	 x2GXeT3I8+d4nudP7IHjeq3AwRAybjqWesaa7qso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2379/3318] ARM: dts: qcom: msm8974: Use the header with DSI phy clock IDs
Date: Wed, 18 Nov 2026 15:50:01 +0100
Message-ID: <20261118150432.913167001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a8eb8b423290..132233cf0d61c 100644
--- a/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-msm8974.dtsi
@@ -3,6 +3,7 @@
 
 #include <dt-bindings/interconnect/qcom,msm8974.h>
 #include <dt-bindings/interrupt-controller/arm-gic.h>
+#include <dt-bindings/clock/qcom,dsi-phy-28nm.h>
 #include <dt-bindings/clock/qcom,gcc-msm8974.h>
 #include <dt-bindings/clock/qcom,mmcc-msm8974.h>
 #include <dt-bindings/clock/qcom,rpmcc.h>
@@ -1837,10 +1838,10 @@ mmcc: clock-controller@fd8c0000 {
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
@@ -1927,8 +1928,10 @@ mdss_dsi0: dsi@fd922800 {
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
@@ -1998,8 +2001,10 @@ mdss_dsi1: dsi@fd922e00 {
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



