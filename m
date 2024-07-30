Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D741898F9;
	Tue, 30 Jul 2024 16:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355823; cv=none; b=MrB1vqfFhvm81sX0eWIlh9NpqxGVTZQPIXcj2zIEcEqjwH5/iKtNbuzqXItwGxKK2Vq9n3FF/jlPUxYJCKSx6IrZXJYGsvAJewalBGHMK81uoJHg3n2JFz+yfOnxvITiLyWjPHptgIjppPPIAImEVfCp9tOKPxHL96w5vU6TLeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355823; c=relaxed/simple;
	bh=zXYECPFsDUxO+JsGWyRh5YI8F5pkgT1llIgw8Vsf/z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mo0U1wugiLAXQ+gpWC9r8AZlgymBS1D0fI0rqyeL2Gu0Pj/OjB17At/NJ/2Pv4vdp4Fi4xcfoolyKgl/khCXkjx4FqNeChp2WH4b7fGYdegIQVOQZk/L0pZY/Lg00ifedtvdvSKEj5VtGR5RoTCq5cNwXbGUaHVrnI043UdnT1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE4LN+qu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE4LN+qu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F877C32782;
	Tue, 30 Jul 2024 16:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355822;
	bh=zXYECPFsDUxO+JsGWyRh5YI8F5pkgT1llIgw8Vsf/z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE4LN+quMiPKQbrDUTvlCrGvEFxPeKPrBOVYKHJqKoxGBzguM01icCzDP2bpXTA8k
	 +HSOnAD+A0UqP8bK7yzfeszIgH2co/ly2n8GhxQBxO5PNMre41fuL1ruZmh8Onkw6A
	 pZBab/4mJPRRR9lxwCrPJ0L7Z5BZ9aR5uKDF6iJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Adam Ford <aford173@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/568] arm64: dts: imx8mp: Fix pgc vpu locations
Date: Tue, 30 Jul 2024 17:43:20 +0200
Message-ID: <20240730151643.507059982@linuxfoundation.org>
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
index 2de16e3d21d24..d1488ebfef3f0 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -834,6 +834,12 @@ pgc_gpumix: power-domain@7 {
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
@@ -849,6 +855,28 @@ pgc_mediamix: power-domain@10 {
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
@@ -886,33 +914,6 @@ pgc_ispdwp: power-domain@18 {
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



