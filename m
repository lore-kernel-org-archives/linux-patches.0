Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBBD1A0724;
	Tue, 30 Jul 2024 16:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356175; cv=none; b=AFGagcVqvAyUUYTKu1n+fuSWAy9jOVZCHY+jeuDt/fKrbKF/zSLUSbYQk5oIQ6MgS1NLUdhLbE9RIwvycg7Fvga30cPIQ4MhrCoEjFrMPj0MyKEZG6Xq9ChrOJF15jF4Bo25p6cskRCtBC9RZF93U/9qbRwMEXq+hdNDTn3TKiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356175; c=relaxed/simple;
	bh=qPcldIElnBaq5M0HPa+v5K616Tn3BuZIg9vF0hit/a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HghozfofCGIohQvhoZ/3x6iXC05HdqTA7DqcsPUSIqy+jrjBAmkx/gfSxSFOyYsDg2bE61UwoI42ODD7ftSg86hi4iQUoui7yq9Cq06Xll+FfWNyQubyEfLfkWEhz/tfah+OQ6PzqDqZlqsIP0+BrvzyweILLeNXdZE1ioATG8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CmySaFR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CmySaFR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5482DC32782;
	Tue, 30 Jul 2024 16:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356175;
	bh=qPcldIElnBaq5M0HPa+v5K616Tn3BuZIg9vF0hit/a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CmySaFR2peuEDPvGJCMbY9Jrgtj1fIOIpoih7sn0SJHN6pTTMmdQ0Xsv1M0B1hZMF
	 FXXRmwKW+9G9ZJ206QAzh9Y3x56AKwVo+NWfKOQFp43DaaSXG/stAeUQ1gwCCslVV8
	 mcT+LG17dMcDECJdG3K4OGFt4CxUPCPaFS9uvamc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 126/809] arm64: dts: imx8mp: Fix pgc vpu locations
Date: Tue, 30 Jul 2024 17:40:02 +0200
Message-ID: <20240730151729.591810717@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Ford <aford173@gmail.com>

[ Upstream commit 2f8405fb077bcb8e98c8cd87c2a0a238b15d8da8 ]

The various pgv_vpu nodes have a mismatch between the value after
the @ symbol and what is referenced by 'reg' so reorder the nodes
to align.

Fixes: df680992dd62 ("arm64: dts: imx8mp: add vpu pgc nodes")
Suggested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewd-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 55 ++++++++++++-----------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 3576d2b89b439..ee0c864f27e89 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -838,6 +838,12 @@ pgc_gpumix: power-domain@7 {
 						assigned-clock-rates = <800000000>, <400000000>;
 					};
 
+					pgc_vpumix: power-domain@8 {
+						#power-domain-cells = <0>;
+						reg = <IMX8MP_POWER_DOMAIN_VPUMIX>;
+						clocks = <&clk IMX8MP_CLK_VPU_ROOT>;
+					};
+
 					pgc_gpu3d: power-domain@9 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MP_POWER_DOMAIN_GPU3D>;
@@ -853,6 +859,28 @@ pgc_mediamix: power-domain@10 {
 							 <&clk IMX8MP_CLK_MEDIA_APB_ROOT>;
 					};
 
+					pgc_vpu_g1: power-domain@11 {
+						#power-domain-cells = <0>;
+						power-domains = <&pgc_vpumix>;
+						reg = <IMX8MP_POWER_DOMAIN_VPU_G1>;
+						clocks = <&clk IMX8MP_CLK_VPU_G1_ROOT>;
+					};
+
+					pgc_vpu_g2: power-domain@12 {
+						#power-domain-cells = <0>;
+						power-domains = <&pgc_vpumix>;
+						reg = <IMX8MP_POWER_DOMAIN_VPU_G2>;
+						clocks = <&clk IMX8MP_CLK_VPU_G2_ROOT>;
+
+					};
+
+					pgc_vpu_vc8000e: power-domain@13 {
+						#power-domain-cells = <0>;
+						power-domains = <&pgc_vpumix>;
+						reg = <IMX8MP_POWER_DOMAIN_VPU_VC8000E>;
+						clocks = <&clk IMX8MP_CLK_VPU_VC8KE_ROOT>;
+					};
+
 					pgc_hdmimix: power-domain@14 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MP_POWER_DOMAIN_HDMIMIX>;
@@ -890,33 +918,6 @@ pgc_ispdwp: power-domain@18 {
 						reg = <IMX8MP_POWER_DOMAIN_MEDIAMIX_ISPDWP>;
 						clocks = <&clk IMX8MP_CLK_MEDIA_ISP_ROOT>;
 					};
-
-					pgc_vpumix: power-domain@19 {
-						#power-domain-cells = <0>;
-						reg = <IMX8MP_POWER_DOMAIN_VPUMIX>;
-						clocks = <&clk IMX8MP_CLK_VPU_ROOT>;
-					};
-
-					pgc_vpu_g1: power-domain@20 {
-						#power-domain-cells = <0>;
-						power-domains = <&pgc_vpumix>;
-						reg = <IMX8MP_POWER_DOMAIN_VPU_G1>;
-						clocks = <&clk IMX8MP_CLK_VPU_G1_ROOT>;
-					};
-
-					pgc_vpu_g2: power-domain@21 {
-						#power-domain-cells = <0>;
-						power-domains = <&pgc_vpumix>;
-						reg = <IMX8MP_POWER_DOMAIN_VPU_G2>;
-						clocks = <&clk IMX8MP_CLK_VPU_G2_ROOT>;
-					};
-
-					pgc_vpu_vc8000e: power-domain@22 {
-						#power-domain-cells = <0>;
-						power-domains = <&pgc_vpumix>;
-						reg = <IMX8MP_POWER_DOMAIN_VPU_VC8000E>;
-						clocks = <&clk IMX8MP_CLK_VPU_VC8KE_ROOT>;
-					};
 				};
 			};
 		};
-- 
2.43.0



