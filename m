Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E492459D7;
	Tue, 16 Dec 2025 11:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883928; cv=none; b=RKRZzf0LBNlspMXH1uhmzl3QnLcMx83OPIkczFwf0nRaCTqCmhtfAQINKojIQKcQjEq7LeX2knbKvGsyMxXRUTPZ684PX76lKE7bRQNx/6Cm1oQ/p9W+ORxbVS+sUNwpew0lIDtGGncq21lU+6mdnmwWWLnJZZhfcGQntXvbNmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883928; c=relaxed/simple;
	bh=vQ9vtFmQfdKsI6xfFhBLBililNiSyxrtPYJ8cA9ZR88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrDsSgYUYMRyLLU+MbEeIelUtVnfPk2h5m0fAVxOpfKwZHxAGaD3q9aRdcdfxzMEDCziX+qPic9I3ukJDbh3tTyOELH5R9i6iakXkrSeGbRUTO0bsSfHB+jR6WmfiWiBfpBVKX8KcR56rlfM1lygmMcJ7puahm4u9jJ+Y1nXbaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enBpR8rB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enBpR8rB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDD2C4CEF1;
	Tue, 16 Dec 2025 11:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883928;
	bh=vQ9vtFmQfdKsI6xfFhBLBililNiSyxrtPYJ8cA9ZR88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enBpR8rBVHu1S5c9gdS5NRGPX/jAqNSJaAOImN6es4L23k/rYCF4dc9XwG9UajSUU
	 zWDaf133DUrhtas57wVFz4GlZMelr3+meHSoBMl5tcOYaJcHlkhrPahh9nCKLuotK8
	 +Etg7C8qZsfQT3lTwozdLVMbijKMOQEJGfQK8yUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/354] dt-bindings: clock: qcom,x1e80100-gcc: Add missing USB4 clocks/resets
Date: Tue, 16 Dec 2025 12:10:08 +0100
Message-ID: <20251216111322.402606432@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit e4c4f5a1ae18a7828c2bfaf9dfe2473632b92d1b ]

Some of the USB4 muxes, RCGs and resets were not initially described.

Add indices for them to allow extending the driver.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251003-topic-hamoa_gcc_usb4-v2-1-61d27a14ee65@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 8abe970efea5 ("clk: qcom: gcc-x1e80100: Add missing USB4 clocks/resets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/qcom,x1e80100-gcc.yaml     | 62 +++++++++++++++++--
 include/dt-bindings/clock/qcom,x1e80100-gcc.h | 61 ++++++++++++++++++
 2 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/qcom,x1e80100-gcc.yaml b/Documentation/devicetree/bindings/clock/qcom,x1e80100-gcc.yaml
index 5951a60ab0815..61ff277eae544 100644
--- a/Documentation/devicetree/bindings/clock/qcom,x1e80100-gcc.yaml
+++ b/Documentation/devicetree/bindings/clock/qcom,x1e80100-gcc.yaml
@@ -28,9 +28,36 @@ properties:
       - description: PCIe 5 pipe clock
       - description: PCIe 6a pipe clock
       - description: PCIe 6b pipe clock
-      - description: USB QMP Phy 0 clock source
-      - description: USB QMP Phy 1 clock source
-      - description: USB QMP Phy 2 clock source
+      - description: USB4_0 QMPPHY clock source
+      - description: USB4_1 QMPPHY clock source
+      - description: USB4_2 QMPPHY clock source
+      - description: USB4_0 PHY DP0 GMUX clock source
+      - description: USB4_0 PHY DP1 GMUX clock source
+      - description: USB4_0 PHY PCIE PIPEGMUX clock source
+      - description: USB4_0 PHY PIPEGMUX clock source
+      - description: USB4_0 PHY SYS PCIE PIPEGMUX clock source
+      - description: USB4_1 PHY DP0 GMUX 2 clock source
+      - description: USB4_1 PHY DP1 GMUX 2 clock source
+      - description: USB4_1 PHY PCIE PIPEGMUX clock source
+      - description: USB4_1 PHY PIPEGMUX clock source
+      - description: USB4_1 PHY SYS PCIE PIPEGMUX clock source
+      - description: USB4_2 PHY DP0 GMUX 2 clock source
+      - description: USB4_2 PHY DP1 GMUX 2 clock source
+      - description: USB4_2 PHY PCIE PIPEGMUX clock source
+      - description: USB4_2 PHY PIPEGMUX clock source
+      - description: USB4_2 PHY SYS PCIE PIPEGMUX clock source
+      - description: USB4_0 PHY RX 0 clock source
+      - description: USB4_0 PHY RX 1 clock source
+      - description: USB4_1 PHY RX 0 clock source
+      - description: USB4_1 PHY RX 1 clock source
+      - description: USB4_2 PHY RX 0 clock source
+      - description: USB4_2 PHY RX 1 clock source
+      - description: USB4_0 PHY PCIE PIPE clock source
+      - description: USB4_0 PHY max PIPE clock source
+      - description: USB4_1 PHY PCIE PIPE clock source
+      - description: USB4_1 PHY max PIPE clock source
+      - description: USB4_2 PHY PCIE PIPE clock source
+      - description: USB4_2 PHY max PIPE clock source
 
   power-domains:
     description:
@@ -63,7 +90,34 @@ examples:
                <&pcie6b_phy>,
                <&usb_1_ss0_qmpphy 0>,
                <&usb_1_ss1_qmpphy 1>,
-               <&usb_1_ss2_qmpphy 2>;
+               <&usb_1_ss2_qmpphy 2>,
+               <&usb4_0_phy_dp0_gmux_clk>,
+               <&usb4_0_phy_dp1_gmux_clk>,
+               <&usb4_0_phy_pcie_pipegmux_clk>,
+               <&usb4_0_phy_pipegmux_clk>,
+               <&usb4_0_phy_sys_pcie_pipegmux_clk>,
+               <&usb4_1_phy_dp0_gmux_2_clk>,
+               <&usb4_1_phy_dp1_gmux_2_clk>,
+               <&usb4_1_phy_pcie_pipegmux_clk>,
+               <&usb4_1_phy_pipegmux_clk>,
+               <&usb4_1_phy_sys_pcie_pipegmux_clk>,
+               <&usb4_2_phy_dp0_gmux_2_clk>,
+               <&usb4_2_phy_dp1_gmux_2_clk>,
+               <&usb4_2_phy_pcie_pipegmux_clk>,
+               <&usb4_2_phy_pipegmux_clk>,
+               <&usb4_2_phy_sys_pcie_pipegmux_clk>,
+               <&usb4_0_phy_rx_0_clk>,
+               <&usb4_0_phy_rx_1_clk>,
+               <&usb4_1_phy_rx_0_clk>,
+               <&usb4_1_phy_rx_1_clk>,
+               <&usb4_2_phy_rx_0_clk>,
+               <&usb4_2_phy_rx_1_clk>,
+               <&usb4_0_phy_pcie_pipe_clk>,
+               <&usb4_0_phy_max_pipe_clk>,
+               <&usb4_1_phy_pcie_pipe_clk>,
+               <&usb4_1_phy_max_pipe_clk>,
+               <&usb4_2_phy_pcie_pipe_clk>,
+               <&usb4_2_phy_max_pipe_clk>;
       power-domains = <&rpmhpd RPMHPD_CX>;
       #clock-cells = <1>;
       #reset-cells = <1>;
diff --git a/include/dt-bindings/clock/qcom,x1e80100-gcc.h b/include/dt-bindings/clock/qcom,x1e80100-gcc.h
index 710c340f24a57..62aa124255927 100644
--- a/include/dt-bindings/clock/qcom,x1e80100-gcc.h
+++ b/include/dt-bindings/clock/qcom,x1e80100-gcc.h
@@ -363,6 +363,30 @@
 #define GCC_USB3_PRIM_PHY_PIPE_CLK_SRC				353
 #define GCC_USB3_SEC_PHY_PIPE_CLK_SRC				354
 #define GCC_USB3_TERT_PHY_PIPE_CLK_SRC				355
+#define GCC_USB34_PRIM_PHY_PIPE_CLK_SRC				356
+#define GCC_USB34_SEC_PHY_PIPE_CLK_SRC				357
+#define GCC_USB34_TERT_PHY_PIPE_CLK_SRC				358
+#define GCC_USB4_0_PHY_DP0_CLK_SRC				359
+#define GCC_USB4_0_PHY_DP1_CLK_SRC				360
+#define GCC_USB4_0_PHY_P2RR2P_PIPE_CLK_SRC			361
+#define GCC_USB4_0_PHY_PCIE_PIPE_MUX_CLK_SRC			362
+#define GCC_USB4_0_PHY_RX0_CLK_SRC				363
+#define GCC_USB4_0_PHY_RX1_CLK_SRC				364
+#define GCC_USB4_0_PHY_SYS_CLK_SRC				365
+#define GCC_USB4_1_PHY_DP0_CLK_SRC				366
+#define GCC_USB4_1_PHY_DP1_CLK_SRC				367
+#define GCC_USB4_1_PHY_P2RR2P_PIPE_CLK_SRC			368
+#define GCC_USB4_1_PHY_PCIE_PIPE_MUX_CLK_SRC			369
+#define GCC_USB4_1_PHY_RX0_CLK_SRC				370
+#define GCC_USB4_1_PHY_RX1_CLK_SRC				371
+#define GCC_USB4_1_PHY_SYS_CLK_SRC				372
+#define GCC_USB4_2_PHY_DP0_CLK_SRC				373
+#define GCC_USB4_2_PHY_DP1_CLK_SRC				374
+#define GCC_USB4_2_PHY_P2RR2P_PIPE_CLK_SRC			375
+#define GCC_USB4_2_PHY_PCIE_PIPE_MUX_CLK_SRC			376
+#define GCC_USB4_2_PHY_RX0_CLK_SRC				377
+#define GCC_USB4_2_PHY_RX1_CLK_SRC				378
+#define GCC_USB4_2_PHY_SYS_CLK_SRC				379
 
 /* GCC power domains */
 #define GCC_PCIE_0_TUNNEL_GDSC					0
@@ -484,4 +508,41 @@
 #define GCC_VIDEO_BCR						87
 #define GCC_VIDEO_AXI0_CLK_ARES					88
 #define GCC_VIDEO_AXI1_CLK_ARES					89
+#define GCC_USB4_0_MISC_USB4_SYS_BCR				90
+#define GCC_USB4_0_MISC_RX_CLK_0_BCR				91
+#define GCC_USB4_0_MISC_RX_CLK_1_BCR				92
+#define GCC_USB4_0_MISC_USB_PIPE_BCR				93
+#define GCC_USB4_0_MISC_PCIE_PIPE_BCR				94
+#define GCC_USB4_0_MISC_TMU_BCR					95
+#define GCC_USB4_0_MISC_SB_IF_BCR				96
+#define GCC_USB4_0_MISC_HIA_MSTR_BCR				97
+#define GCC_USB4_0_MISC_AHB_BCR					98
+#define GCC_USB4_0_MISC_DP0_MAX_PCLK_BCR			99
+#define GCC_USB4_0_MISC_DP1_MAX_PCLK_BCR			100
+#define GCC_USB4_1_MISC_USB4_SYS_BCR				101
+#define GCC_USB4_1_MISC_RX_CLK_0_BCR				102
+#define GCC_USB4_1_MISC_RX_CLK_1_BCR				103
+#define GCC_USB4_1_MISC_USB_PIPE_BCR				104
+#define GCC_USB4_1_MISC_PCIE_PIPE_BCR				105
+#define GCC_USB4_1_MISC_TMU_BCR					106
+#define GCC_USB4_1_MISC_SB_IF_BCR				107
+#define GCC_USB4_1_MISC_HIA_MSTR_BCR				108
+#define GCC_USB4_1_MISC_AHB_BCR					109
+#define GCC_USB4_1_MISC_DP0_MAX_PCLK_BCR			110
+#define GCC_USB4_1_MISC_DP1_MAX_PCLK_BCR			111
+#define GCC_USB4_2_MISC_USB4_SYS_BCR				112
+#define GCC_USB4_2_MISC_RX_CLK_0_BCR				113
+#define GCC_USB4_2_MISC_RX_CLK_1_BCR				114
+#define GCC_USB4_2_MISC_USB_PIPE_BCR				115
+#define GCC_USB4_2_MISC_PCIE_PIPE_BCR				116
+#define GCC_USB4_2_MISC_TMU_BCR					117
+#define GCC_USB4_2_MISC_SB_IF_BCR				118
+#define GCC_USB4_2_MISC_HIA_MSTR_BCR				119
+#define GCC_USB4_2_MISC_AHB_BCR					120
+#define GCC_USB4_2_MISC_DP0_MAX_PCLK_BCR			121
+#define GCC_USB4_2_MISC_DP1_MAX_PCLK_BCR			122
+#define GCC_USB4PHY_PHY_PRIM_BCR				123
+#define GCC_USB4PHY_PHY_SEC_BCR					124
+#define GCC_USB4PHY_PHY_TERT_BCR				125
+
 #endif
-- 
2.51.0



