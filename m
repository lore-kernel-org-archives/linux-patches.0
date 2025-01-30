Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAC01BDA95;
	Thu, 30 Jan 2025 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246706; cv=none; b=VZO9Gt2ZyKG+bl4x/dtBI3pxNTqiEn1Vzq7fKkkPhtLofhDbWUZeuXAtVq3A+0/+dTcjxxC+Jbz3vzpVbM/qmAptD1zN+IIlpk6LXqpb+iScZ/9JCWxr+3bqii9gmCmlw8hvwbbwqhshuXQAjXslVk6DOMoIQyDqUuBxeL0a5uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246706; c=relaxed/simple;
	bh=l5M+9pt/h6egaIbaYOblgEF3sgpv7ATy1j2aCuFe+yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihKzTTF3FzS6XngMCitfYd3YgUIZ80Nr2U/unCbBPkW5l0u99wehXkp6QTaN+DDNHJzhIw1oTJVc4F6Kex9UfQmI2mj/JCgn03W+QYs8KQs+4MFQjFA8lnpZlNpftNc4ZWllqY3aCu2/ap3HfmIN4KmW0dBGB8H2ZXPCJjpGVC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtJzNWxE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtJzNWxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86D32C4CED2;
	Thu, 30 Jan 2025 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246705;
	bh=l5M+9pt/h6egaIbaYOblgEF3sgpv7ATy1j2aCuFe+yM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YtJzNWxEZqb2riC11dcLY58/lmrrA6foORj3b322rLcqzHsqEkkk5qeGJVGxxHrux
	 sZ1gy0+La7YVnYsoVmszrLpB37GQdTr5o0K1Lp04jm3FUM0dPWetszpHtl2rk87mag
	 w9g7ksRfLCUGAK3A9lNqcl+vvjJbhjJdkyjCUuNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Caesar Wang <wxt@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/91] arm64: dts: rockchip: fix pd_tcpc0 and pd_tcpc1 node position on rk3399
Date: Thu, 30 Jan 2025 15:00:58 +0100
Message-ID: <20250130140135.237193537@linuxfoundation.org>
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

[ Upstream commit 2b99e6196663199409540fb95798dba464e34343 ]

The pd_tcpc0 and pd_tcpc1 nodes are currently a sub node of pd_vio.
In the rk3399 TRM figure of the 'Power Domain Partition' and in the
table of 'Power Domain and Voltage Domain Summary' these power domains
are positioned directly under VD_LOGIC, so fix that in 'rk3399.dtsi'.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Reviewed-by: Caesar Wang <wxt@rock-chips.com>
Link: https://lore.kernel.org/r/20200428203003.3318-2-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 3699f2c43ea9 ("arm64: dts: rockchip: add hevc power domain clock to rk3328")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index dcd989563d27..04ca346b2f28 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -1057,6 +1057,16 @@
 				clocks = <&cru HCLK_SDIO>;
 				pm_qos = <&qos_sdioaudio>;
 			};
+			pd_tcpc0@RK3399_PD_TCPD0 {
+				reg = <RK3399_PD_TCPD0>;
+				clocks = <&cru SCLK_UPHY0_TCPDCORE>,
+					 <&cru SCLK_UPHY0_TCPDPHY_REF>;
+			};
+			pd_tcpc1@RK3399_PD_TCPD1 {
+				reg = <RK3399_PD_TCPD1>;
+				clocks = <&cru SCLK_UPHY1_TCPDCORE>,
+					 <&cru SCLK_UPHY1_TCPDPHY_REF>;
+			};
 			pd_usb3@RK3399_PD_USB3 {
 				reg = <RK3399_PD_USB3>;
 				clocks = <&cru ACLK_USB3>;
@@ -1089,16 +1099,6 @@
 					pm_qos = <&qos_isp1_m0>,
 						 <&qos_isp1_m1>;
 				};
-				pd_tcpc0@RK3399_PD_TCPD0 {
-					reg = <RK3399_PD_TCPD0>;
-					clocks = <&cru SCLK_UPHY0_TCPDCORE>,
-						 <&cru SCLK_UPHY0_TCPDPHY_REF>;
-				};
-				pd_tcpc1@RK3399_PD_TCPD1 {
-					reg = <RK3399_PD_TCPD1>;
-					clocks = <&cru SCLK_UPHY1_TCPDCORE>,
-						 <&cru SCLK_UPHY1_TCPDPHY_REF>;
-				};
 				pd_vo@RK3399_PD_VO {
 					reg = <RK3399_PD_VO>;
 					#address-cells = <1>;
-- 
2.39.5



