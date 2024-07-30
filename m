Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC41418C91F;
	Tue, 30 Jul 2024 16:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355790; cv=none; b=qgmbzSfWU2tNZtM/wfDMkMM9oaPTvcOVUIkqhPGriaJoRKIppWPgZmQcNZj862ArniR4Y2bJDopNRJ7vFdZ8oZY7+9+8KOOlRoB0rQP8K7ebLF2W6WeO3Qu4qJqf739MBn61qz/lwIGslgb43EowYUB4sfow2vF3l862QyeAcsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355790; c=relaxed/simple;
	bh=z0FT26++zGwyniWONlbKTcK1RBlB/WK6A/QJwVYLeV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RU+ICDe8Bw3QKziNj+XcmaZ0KbPTSDH2RIicHM8nuoOZW8n730cszeJqIoAsUy7CHuc5gGd8bEDaI037COvm/dENUWwlwzJpc2qpNolKLBgAOfRFkulCA6FOTgD1hXNQE9oQoKbcG7+K69szwngJ5nSJB88VMHXIB/OaZ5TQyxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tx+JlHaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tx+JlHaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBE3C32782;
	Tue, 30 Jul 2024 16:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355789;
	bh=z0FT26++zGwyniWONlbKTcK1RBlB/WK6A/QJwVYLeV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tx+JlHaDRbLH7unh3CN6vehSMyGLGGB2RyU/1tD3mBl4HYoWO6CyrS5D/4JK9h0Ax
	 N97Ru7K8CW5ApwHTC2YKTJCPdB92hd4Z9UNOkodTPlMkdEfhYPTzyiRjPEbfpFKhgU
	 pgGEOaiBcKaPyjiH6m34hrUDjlis/PnFUwTgKh5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/568] arm64: dts: imx8mp: Add NPU Node
Date: Tue, 30 Jul 2024 17:43:17 +0200
Message-ID: <20240730151643.390591552@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 4bedc468b725d55655dc8c9f5528932f4d77ccb0 ]

The NPU is based on the Vivante GC8000 and its power-domain
is controlled my pgc_mlmix.  Since the power-domain uses
some of these clocks, setup the clock parent and rates
inside the power-domain, and add the NPU node.

The data sheet states the CLK_ML_AHB should be 300MHz for
nominal, but 800MHz clock will divide down to 266 instead.
Boards which operate in over-drive mode should update the
clocks on their boards accordingly.  When the driver loads,
the NPU numerates as:

 etnaviv-gpu 38500000.npu: model: GC8000, revision: 8002

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: 106f68fc9da3 ("arm64: dts: imx8mp: Fix pgc_mlmix location")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 4b50920ac2049..56f72d264eee8 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -886,6 +886,15 @@ pgc_mlmix: power-domain@24 {
 						clocks = <&clk IMX8MP_CLK_ML_AXI>,
 							 <&clk IMX8MP_CLK_ML_AHB>,
 							 <&clk IMX8MP_CLK_NPU_ROOT>;
+						assigned-clocks = <&clk IMX8MP_CLK_ML_CORE>,
+								  <&clk IMX8MP_CLK_ML_AXI>,
+								  <&clk IMX8MP_CLK_ML_AHB>;
+						assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_800M>,
+									 <&clk IMX8MP_SYS_PLL1_800M>,
+									 <&clk IMX8MP_SYS_PLL1_800M>;
+						assigned-clock-rates = <800000000>,
+								       <800000000>,
+								       <300000000>;
 					};
 				};
 			};
@@ -1970,6 +1979,18 @@ vpumix_blk_ctrl: blk-ctrl@38330000 {
 			interconnect-names = "g1", "g2", "vc8000e";
 		};
 
+		npu: npu@38500000 {
+			compatible = "vivante,gc";
+			reg = <0x38500000 0x200000>;
+			interrupts = <GIC_SPI 13 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&clk IMX8MP_CLK_NPU_ROOT>,
+				 <&clk IMX8MP_CLK_NPU_ROOT>,
+				 <&clk IMX8MP_CLK_ML_AXI>,
+				 <&clk IMX8MP_CLK_ML_AHB>;
+			clock-names = "core", "shader", "bus", "reg";
+			power-domains = <&pgc_mlmix>;
+		};
+
 		gic: interrupt-controller@38800000 {
 			compatible = "arm,gic-v3";
 			reg = <0x38800000 0x10000>,
-- 
2.43.0



