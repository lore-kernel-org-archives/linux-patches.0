Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC441BDA95;
	Thu, 30 Jan 2025 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246712; cv=none; b=gM9L12LhPBK2OhAZIK2vGGtmsPms09CIYWQV9yEktoplJN+yUDpt//DfPIyYUhCt186y76hP7aXYJHSSdmybBRBZvHWzZYXVruqgbTdLcsapWr83i+8TIEazO8jAe3cZKIRC9dXwBIF7ot3k4yI+zmecWINQ2EkMQagbUZYxOBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246712; c=relaxed/simple;
	bh=4vWBm2LXnIB9uSe940VTgL4JZw4Iwj55DlXHBqQcgOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTT0IfkNuozkIQu7F9MuIS6WGAOj0n1byr7HQ2k8RV3eOsLMz0iMd7HDs/RwMkYHpZqjGlW1zDGLE3iuiG+FenXZ1bwcPNJSIALm0Ca8EvtpKSKrYfn/Qj0DG/vEqO1eB9F31mE3EfWF9PzBrNGlAArJmwmnr5DsaSQYP/hHxmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvyjHTUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvyjHTUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ACFC4CED2;
	Thu, 30 Jan 2025 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246711;
	bh=4vWBm2LXnIB9uSe940VTgL4JZw4Iwj55DlXHBqQcgOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvyjHTUeImnPFQnmK7fzsc8NihOcWicqLZgOK4sBbROp4DWRO0TAYge+1zm8xOD2a
	 XqcaHQvTmE9lyj0aKe1ME7G2FxSHPFG95pesyi8dMSJisqtpz7g+SXmkanQjgWqHLd
	 nwg8wOHPHDpqJIvWHWOGEnGPN+Lkp3zHAURIr7s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 40/91] arm64: dts: rockchip: add #power-domain-cells to power domain nodes
Date: Thu, 30 Jan 2025 15:00:59 +0100
Message-ID: <20250130140135.277535021@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 837188d49823230f47afdbbec7556740e89a8557 ]

Add #power-domain-cells to power domain nodes, because they
are required by power-domain.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210417112952.8516-9-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 3699f2c43ea9 ("arm64: dts: rockchip: add hevc power domain clock to rk3328")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/px30.dtsi   |  8 ++++++++
 arch/arm64/boot/dts/rockchip/rk3328.dtsi |  3 +++
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 20 ++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/px30.dtsi b/arch/arm64/boot/dts/rockchip/px30.dtsi
index f297601c9f71..652998c83640 100644
--- a/arch/arm64/boot/dts/rockchip/px30.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30.dtsi
@@ -219,12 +219,14 @@
 					 <&cru HCLK_OTG>,
 					 <&cru SCLK_OTG_ADP>;
 				pm_qos = <&qos_usb_host>, <&qos_usb_otg>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@PX30_PD_SDCARD {
 				reg = <PX30_PD_SDCARD>;
 				clocks = <&cru HCLK_SDMMC>,
 					 <&cru SCLK_SDMMC>;
 				pm_qos = <&qos_sdmmc>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@PX30_PD_GMAC {
 				reg = <PX30_PD_GMAC>;
@@ -233,6 +235,7 @@
 					 <&cru SCLK_MAC_REF>,
 					 <&cru SCLK_GMAC_RX_TX>;
 				pm_qos = <&qos_gmac>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@PX30_PD_MMC_NAND {
 				reg = <PX30_PD_MMC_NAND>;
@@ -246,6 +249,7 @@
 					  <&cru SCLK_SFC>;
 				pm_qos = <&qos_emmc>, <&qos_nand>,
 					 <&qos_sdio>, <&qos_sfc>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@PX30_PD_VPU {
 				reg = <PX30_PD_VPU>;
@@ -253,6 +257,7 @@
 					 <&cru HCLK_VPU>,
 					 <&cru SCLK_CORE_VPU>;
 				pm_qos = <&qos_vpu>, <&qos_vpu_r128>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@PX30_PD_VO {
 				reg = <PX30_PD_VO>;
@@ -269,6 +274,7 @@
 					 <&cru SCLK_VOPB_PWM>;
 				pm_qos = <&qos_rga_rd>, <&qos_rga_wr>,
 					 <&qos_vop_m0>, <&qos_vop_m1>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@PX30_PD_VI {
 				reg = <PX30_PD_VI>;
@@ -280,11 +286,13 @@
 				pm_qos = <&qos_isp_128>, <&qos_isp_rd>,
 					 <&qos_isp_wr>, <&qos_isp_m1>,
 					 <&qos_vip>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@PX30_PD_GPU {
 				reg = <PX30_PD_GPU>;
 				clocks = <&cru SCLK_GPU>;
 				pm_qos = <&qos_gpu>;
+				#power-domain-cells = <0>;
 			};
 		};
 	};
diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 5bb84ec31c6f..d8af608752e3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -272,13 +272,16 @@
 
 			power-domain@RK3328_PD_HEVC {
 				reg = <RK3328_PD_HEVC>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@RK3328_PD_VIDEO {
 				reg = <RK3328_PD_VIDEO>;
+				#power-domain-cells = <0>;
 			};
 			power-domain@RK3328_PD_VPU {
 				reg = <RK3328_PD_VPU>;
 				clocks = <&cru ACLK_VPU>, <&cru HCLK_VPU>;
+				#power-domain-cells = <0>;
 			};
 		};
 
diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 04ca346b2f28..e52c2dc1710a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1001,6 +1001,7 @@
 				clocks = <&cru ACLK_IEP>,
 					 <&cru HCLK_IEP>;
 				pm_qos = <&qos_iep>;
+				#power-domain-cells = <0>;
 			};
 			pd_rga@RK3399_PD_RGA {
 				reg = <RK3399_PD_RGA>;
@@ -1008,12 +1009,14 @@
 					 <&cru HCLK_RGA>;
 				pm_qos = <&qos_rga_r>,
 					 <&qos_rga_w>;
+				#power-domain-cells = <0>;
 			};
 			pd_vcodec@RK3399_PD_VCODEC {
 				reg = <RK3399_PD_VCODEC>;
 				clocks = <&cru ACLK_VCODEC>,
 					 <&cru HCLK_VCODEC>;
 				pm_qos = <&qos_video_m0>;
+				#power-domain-cells = <0>;
 			};
 			pd_vdu@RK3399_PD_VDU {
 				reg = <RK3399_PD_VDU>;
@@ -1021,6 +1024,7 @@
 					 <&cru HCLK_VDU>;
 				pm_qos = <&qos_video_m1_r>,
 					 <&qos_video_m1_w>;
+				#power-domain-cells = <0>;
 			};
 
 			/* These power domains are grouped by VD_GPU */
@@ -1028,53 +1032,63 @@
 				reg = <RK3399_PD_GPU>;
 				clocks = <&cru ACLK_GPU>;
 				pm_qos = <&qos_gpu>;
+				#power-domain-cells = <0>;
 			};
 
 			/* These power domains are grouped by VD_LOGIC */
 			pd_edp@RK3399_PD_EDP {
 				reg = <RK3399_PD_EDP>;
 				clocks = <&cru PCLK_EDP_CTRL>;
+				#power-domain-cells = <0>;
 			};
 			pd_emmc@RK3399_PD_EMMC {
 				reg = <RK3399_PD_EMMC>;
 				clocks = <&cru ACLK_EMMC>;
 				pm_qos = <&qos_emmc>;
+				#power-domain-cells = <0>;
 			};
 			pd_gmac@RK3399_PD_GMAC {
 				reg = <RK3399_PD_GMAC>;
 				clocks = <&cru ACLK_GMAC>,
 					 <&cru PCLK_GMAC>;
 				pm_qos = <&qos_gmac>;
+				#power-domain-cells = <0>;
 			};
 			pd_sd@RK3399_PD_SD {
 				reg = <RK3399_PD_SD>;
 				clocks = <&cru HCLK_SDMMC>,
 					 <&cru SCLK_SDMMC>;
 				pm_qos = <&qos_sd>;
+				#power-domain-cells = <0>;
 			};
 			pd_sdioaudio@RK3399_PD_SDIOAUDIO {
 				reg = <RK3399_PD_SDIOAUDIO>;
 				clocks = <&cru HCLK_SDIO>;
 				pm_qos = <&qos_sdioaudio>;
+				#power-domain-cells = <0>;
 			};
 			pd_tcpc0@RK3399_PD_TCPD0 {
 				reg = <RK3399_PD_TCPD0>;
 				clocks = <&cru SCLK_UPHY0_TCPDCORE>,
 					 <&cru SCLK_UPHY0_TCPDPHY_REF>;
+				#power-domain-cells = <0>;
 			};
 			pd_tcpc1@RK3399_PD_TCPD1 {
 				reg = <RK3399_PD_TCPD1>;
 				clocks = <&cru SCLK_UPHY1_TCPDCORE>,
 					 <&cru SCLK_UPHY1_TCPDPHY_REF>;
+				#power-domain-cells = <0>;
 			};
 			pd_usb3@RK3399_PD_USB3 {
 				reg = <RK3399_PD_USB3>;
 				clocks = <&cru ACLK_USB3>;
 				pm_qos = <&qos_usb_otg0>,
 					 <&qos_usb_otg1>;
+				#power-domain-cells = <0>;
 			};
 			pd_vio@RK3399_PD_VIO {
 				reg = <RK3399_PD_VIO>;
+				#power-domain-cells = <1>;
 				#address-cells = <1>;
 				#size-cells = <0>;
 
@@ -1084,6 +1098,7 @@
 						 <&cru HCLK_HDCP>,
 						 <&cru PCLK_HDCP>;
 					pm_qos = <&qos_hdcp>;
+					#power-domain-cells = <0>;
 				};
 				pd_isp0@RK3399_PD_ISP0 {
 					reg = <RK3399_PD_ISP0>;
@@ -1091,6 +1106,7 @@
 						 <&cru HCLK_ISP0>;
 					pm_qos = <&qos_isp0_m0>,
 						 <&qos_isp0_m1>;
+					#power-domain-cells = <0>;
 				};
 				pd_isp1@RK3399_PD_ISP1 {
 					reg = <RK3399_PD_ISP1>;
@@ -1098,9 +1114,11 @@
 						 <&cru HCLK_ISP1>;
 					pm_qos = <&qos_isp1_m0>,
 						 <&qos_isp1_m1>;
+					#power-domain-cells = <0>;
 				};
 				pd_vo@RK3399_PD_VO {
 					reg = <RK3399_PD_VO>;
+					#power-domain-cells = <1>;
 					#address-cells = <1>;
 					#size-cells = <0>;
 
@@ -1110,12 +1128,14 @@
 							 <&cru HCLK_VOP0>;
 						pm_qos = <&qos_vop_big_r>,
 							 <&qos_vop_big_w>;
+						#power-domain-cells = <0>;
 					};
 					pd_vopl@RK3399_PD_VOPL {
 						reg = <RK3399_PD_VOPL>;
 						clocks = <&cru ACLK_VOP1>,
 							 <&cru HCLK_VOP1>;
 						pm_qos = <&qos_vop_little>;
+						#power-domain-cells = <0>;
 					};
 				};
 			};
-- 
2.39.5



