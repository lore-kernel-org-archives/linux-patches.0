Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD5B3BF2EA;
	Thu, 15 Jan 2026 16:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496116; cv=none; b=Zrg6LAvqXYLNQd78S3s7Nc2H1lwJTXEKyuIZJ//goAODGt0Qa5DWszU2EOIPVdetsqneXdpfxZ8oo0YP0cZ70JVhbv3slHw2Pdf/+LHjz+DbhcJ60yj5ZWYJZP2zJx5kmde20ojfsE6lWuPgKSTnXbmdvhXJOeZ5AWYNSE66WIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496116; c=relaxed/simple;
	bh=0tMNpvpXBSa/L606sY4nLbcPeqQdy514qpI4X4xRF+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nyLr0MAI9adO+uyEWhmR+9HfzEyHZtI0EzTdEG4/w9FQyquleYE7auV2EsRNUjd00KcXt9/vV+QqRUahuEWh2kExwAwPpt8Z5U7XNtq4XBoXDphwPifi8pzR/ahqynh/enohKIfEcvWHsRYpX/EY9wPqsg+yi6KiC3upK0nKMzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZjulj48; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZjulj48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE25EC16AAE;
	Thu, 15 Jan 2026 16:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496114;
	bh=0tMNpvpXBSa/L606sY4nLbcPeqQdy514qpI4X4xRF+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZjulj48EI0C1LcpwGVtAUrMXkP5c2y3gGplbfRexOAlaSOCrZyyI4xbpC0J2bzUs
	 t2XaSzcNrj6YwaShJQRfLbhnZDhhJPl6Ca5el3JT43hK8mQsRY9asRD30YwTKLs3p6
	 6F9+rn9BKTMHbP6T1XLTsip9R8/qYG306dq0tiWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maud Spierings <maudspierings@gocontroll.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 083/181] arm64: dts: freescale: tx8p-ml81: fix eqos nvmem-cells
Date: Thu, 15 Jan 2026 17:47:00 +0100
Message-ID: <20260115164205.323372370@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maud Spierings <maudspierings@gocontroll.com>

[ Upstream commit cdf4e631eec5ddd49bb625df9fb144d6ecdd6f15 ]

On this SoM eqos is the primary ethernet interface, Ka-Ro fuses the
address for it in eth_mac1, eth_mac2 seems to be left unfused. In their
downstream u-boot they fetch it from eth_mac1 [1][2], by setting alias
of eqos to ethernet0, the driver then fetches the mac address based on
the alias number.

Set eqos to read from eth_mac1 instead of eth_mac2. Also set fec to
point at eth_mac2 as it may be fused later even though it is disabled
by default.

With this changed barebox is now capable of loading the correct address.

Link: https://github.com/karo-electronics/karo-tx-uboot/blob/380543278410bbf04264d80a3bfbe340b8e62439/drivers/net/dwc_eth_qos.c#L1167 [1]
Link: https://github.com/karo-electronics/karo-tx-uboot/blob/380543278410bbf04264d80a3bfbe340b8e62439/arch/arm/dts/imx8mp-karo.dtsi#L12 [2]

Fixes: bac63d7c5f46 ("arm64: dts: freescale: add Ka-Ro Electronics tx8p-ml81 COM")
Signed-off-by: Maud Spierings <maudspierings@gocontroll.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81.dtsi
index fe8ba16eb40e7..761ee046eb72e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-tx8p-ml81.dtsi
@@ -47,6 +47,7 @@ &eqos {
 				 <&clk IMX8MP_SYS_PLL2_100M>,
 				 <&clk IMX8MP_SYS_PLL2_50M>;
 	assigned-clock-rates = <266000000>, <100000000>, <50000000>;
+	nvmem-cells = <&eth_mac1>;
 	phy-handle = <&ethphy0>;
 	phy-mode = "rmii";
 	pinctrl-0 = <&pinctrl_eqos>;
@@ -75,6 +76,10 @@ ethphy0: ethernet-phy@0 {
 	};
 };
 
+&fec {
+	nvmem-cells = <&eth_mac2>;
+};
+
 &gpio1 {
 	gpio-line-names = "SODIMM_152",
 			  "SODIMM_42",
-- 
2.51.0



