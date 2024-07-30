Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF594184535;
	Tue, 30 Jul 2024 16:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355800; cv=none; b=Owr5v1mNrbV5MfWS0yfr5zM7u/p8CukJbcvGveRr4WRVfzhmvbGUVHdCa/Dc5G3KLFnJhVl51hdAhRstXbQKOolFNdjkON5QfGs6M0c5zaEmFdAldvD6i4Fl6avykUrIkT9cAIi4wHNXsjAftYzbTOmpRvA73+kvnfrWXXKfbIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355800; c=relaxed/simple;
	bh=WMEzaU4StKvWpBSEjx0pK908N9TNLQL/wmSLGay3ri8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdtAqmgEtOX5A3UxS2Q7sLQnvJcbJo2HIElCbHvBzSYgxBzuwkAaiVqhsLAEG9vjQ2O22XOT6kaEcYZw56/EF4V+vBhh1tnH7t30Ap+KjYdZ+ms7VsNUQuEY25xGvGsViWVG7Jh0MYKi7Sapkbeeo4sXy3tPyaBOzOd8LEM27/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRCxE6H1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRCxE6H1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D4EC32782;
	Tue, 30 Jul 2024 16:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355799;
	bh=WMEzaU4StKvWpBSEjx0pK908N9TNLQL/wmSLGay3ri8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRCxE6H1EXcONoMn7DviFV9HFLqPY1w8dKxxo0hy4boYRzJOw2YJIeJY2WxKS+NCf
	 M3tpMNOMhkGvnVtR8wxiZdyy9Sqgjd3YiZdo4oq9p/cgI3jlxU4KAEZI3sJTxtgHKq
	 IjC3LtVLdF8fhHoiMyVrUObcasCvtz4n0in36Puk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Ford <aford173@gmail.com>,
	Peng Fan <peng.fan@nxp.com>,
	Marek Vasut <marex@denx.de>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/568] arm64: dts: imx8mp: Fix pgc_mlmix location
Date: Tue, 30 Jul 2024 17:43:18 +0200
Message-ID: <20240730151643.428618699@linuxfoundation.org>
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

[ Upstream commit 106f68fc9da3d4835070b55a2229d2c54ef5cba1 ]

The pgc_mlmix shows a power-domain@24, but the reg value is
IMX8MP_POWER_DOMAIN_MLMIX which is set to 4.

The stuff after the @ symbol should match the stuff referenced
by 'reg' so reorder the pgc_mlmix so it to appear as power-domain@4.

Fixes: 834464c8504c ("arm64: dts: imx8mp: add mlmix power domain")
Fixes: 4bedc468b725 ("arm64: dts: imx8mp: Add NPU Node")
Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Marek Vasut <marex@denx.de>
Reviewed-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi | 34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 56f72d264eee8..0b824120d5488 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -785,6 +785,23 @@ pgc_usb2_phy: power-domain@3 {
 						reg = <IMX8MP_POWER_DOMAIN_USB2_PHY>;
 					};
 
+					pgc_mlmix: power-domain@4 {
+						#power-domain-cells = <0>;
+						reg = <IMX8MP_POWER_DOMAIN_MLMIX>;
+						clocks = <&clk IMX8MP_CLK_ML_AXI>,
+							 <&clk IMX8MP_CLK_ML_AHB>,
+							 <&clk IMX8MP_CLK_NPU_ROOT>;
+						assigned-clocks = <&clk IMX8MP_CLK_ML_CORE>,
+								  <&clk IMX8MP_CLK_ML_AXI>,
+								  <&clk IMX8MP_CLK_ML_AHB>;
+						assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_800M>,
+									 <&clk IMX8MP_SYS_PLL1_800M>,
+									 <&clk IMX8MP_SYS_PLL1_800M>;
+						assigned-clock-rates = <800000000>,
+								       <800000000>,
+								       <300000000>;
+					};
+
 					pgc_audio: power-domain@5 {
 						#power-domain-cells = <0>;
 						reg = <IMX8MP_POWER_DOMAIN_AUDIOMIX>;
@@ -879,23 +896,6 @@ pgc_vpu_vc8000e: power-domain@22 {
 						reg = <IMX8MP_POWER_DOMAIN_VPU_VC8000E>;
 						clocks = <&clk IMX8MP_CLK_VPU_VC8KE_ROOT>;
 					};
-
-					pgc_mlmix: power-domain@24 {
-						#power-domain-cells = <0>;
-						reg = <IMX8MP_POWER_DOMAIN_MLMIX>;
-						clocks = <&clk IMX8MP_CLK_ML_AXI>,
-							 <&clk IMX8MP_CLK_ML_AHB>,
-							 <&clk IMX8MP_CLK_NPU_ROOT>;
-						assigned-clocks = <&clk IMX8MP_CLK_ML_CORE>,
-								  <&clk IMX8MP_CLK_ML_AXI>,
-								  <&clk IMX8MP_CLK_ML_AHB>;
-						assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_800M>,
-									 <&clk IMX8MP_SYS_PLL1_800M>,
-									 <&clk IMX8MP_SYS_PLL1_800M>;
-						assigned-clock-rates = <800000000>,
-								       <800000000>,
-								       <300000000>;
-					};
 				};
 			};
 		};
-- 
2.43.0



