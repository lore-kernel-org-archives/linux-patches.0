Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029112;
	b=VGOLXygTJeHRvl6mbbTq5UeVmy1eI+Swdz/zicjic3tJ6sDMBiCqj+lSixWTkjEtwtyK
	 3/PvhBXtFV1tU5zLGpSXJyXvLL7i7y1hO7gnOcQSkiDAqnTNxBLxDsOBdYr3psHUbsU1j
	 7xx5kAD+JOYDIyzYLAvxq/0GCO/AyEGqfHdvQqDfYR4Y2mEKwKH2QRl+P5n1SbdIHnKQT
	 6dH8z3Z74F+OXEhO8MvrApK6PpgQCHtsxY7N1o6+abn9zOeNa+q/i9xrX0CvwU7ex2wmS
	 Hfz+x+lXgS9xxv7e5KPp1tO+/OXItuYmHlRT3u0E53SejvHAsOY71zcm63izT8hH7iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xxkzzn9IqxMUpJ7vCw3Cu59ExXYLE1yLO+OiSCRcrLQ=;
	b=uGkRvA6ereWsn/p/KijxCBueyoklsaI3DbqRj2D+7rrSV/Zf2Bq9aeZVkYHfFb8l9jnj
	 Ly0BEKDAouaN8yWKc3+LY4cE80MRpQCuFcQw1WnGGncE15Mv8o+167BHWCc1vkuFCi3cY
	 PLoQoB1wypQIxOsLkVMVfLbtQLi0j50vto3ub90CS5pc+N0RrvlUqnLLZrWKvbzTXluf2
	 EWt+sNsFjb7hIb16H1ksg2MUyALGVyHkgw7PQmi607YiiDAM0vAasvWrqJ/NMHUaSQHte
	 K7cNKfLDi27xm5jvnynQn+pFwIGgsmrpkXQh4lRHaDnpWxUhUmUoL1VVaGvK5GQRyRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WTFZRN9i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6955E606A31C;
	Wed, 18 Nov 2026 19:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WTFZRN9i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823701F000C4;
	Wed, 18 Nov 2026 19:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029112;
	bh=xxkzzn9IqxMUpJ7vCw3Cu59ExXYLE1yLO+OiSCRcrLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WTFZRN9i/7I4fNY4G+Cn3p8dzOmZ3nnBx8++CTuCsgZEA/VLxaUHhlUqWtAC/nNrU
	 hhUbds/n8Eob/mT2eWD5JbubjmTxcWFtkXgeXvG2vwRR91kpzK0WGd6tBtrNdNVEol
	 odJFgCBdOZrOaVybZ70uT2yq9+yrktDEVMnYKnGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Chintan Vankar <c-vankar@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0234/1756] arm64: dts: ti: k3-j722s-evm: Add bootph-all property to enable Ethernet boot
Date: Wed, 18 Nov 2026 15:39:21 +0100
Message-ID: <20261118150017.571729282@linuxfoundation.org>
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

From: Chintan Vankar <c-vankar@ti.com>

[ Upstream commit ab9ec669cf74b6499c0de4f42a6dd756a4e4e2a1 ]

Ethernet boot requires CPSW nodes to be present starting from R5 SPL
stage. Add bootph-all property to required nodes to enable Ethernet boot
for J722S-EVM.

Reviewed-by: Roger Quadros <rogerq@kernel.org>
Signed-off-by: Chintan Vankar <c-vankar@ti.com>
Link: https://lore.kernel.org/r/20250709105326.232608-4-c-vankar@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Stable-dep-of: 432bfc86fe62 ("arm64: dts: ti: k3-j722s-evm: Switch audio codec clock from audio_refclk1 to external clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
index b8464082fa492..ccc04548d3b9a 100644
--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -260,6 +260,14 @@ csi23_mux: mux-controller-1 {
 	};
 };
 
+&cpsw_mac_syscon {
+	bootph-all;
+};
+
+&phy_gmii_sel {
+	bootph-all;
+};
+
 &main_pmx0 {
 
 	main_mcan0_pins_default: main-mcan0-default-pins {
@@ -317,6 +325,7 @@ mdio_pins_default: mdio-default-pins {
 			J722S_IOPAD(0x0160, PIN_OUTPUT, 0) /* (AC24) MDIO0_MDC */
 			J722S_IOPAD(0x015c, PIN_INPUT, 0) /* (AD25) MDIO0_MDIO */
 		>;
+		bootph-all;
 	};
 
 	ospi0_pins_default: ospi0-default-pins {
@@ -351,6 +360,7 @@ J722S_IOPAD(0x0140, PIN_OUTPUT, 0) /* (AF24) RGMII1_TD3 */
 			J722S_IOPAD(0x0130, PIN_OUTPUT, 0) /* (AG26) RGMII1_TXC */
 			J722S_IOPAD(0x012c, PIN_OUTPUT, 0) /* (AF25) RGMII1_TX_CTL */
 		>;
+		bootph-all;
 	};
 
 	main_usb1_pins_default: main-usb1-default-pins {
@@ -395,6 +405,7 @@ &cpsw3g_mdio {
 
 	cpsw3g_phy0: ethernet-phy@0 {
 		reg = <0>;
+		bootph-all;
 		ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
 		ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
 		ti,min-output-impedance;
@@ -405,6 +416,7 @@ &cpsw_port1 {
 	phy-mode = "rgmii-rxid";
 	phy-handle = <&cpsw3g_phy0>;
 	status = "okay";
+	bootph-all;
 };
 
 &main_gpio1 {
-- 
2.53.0



