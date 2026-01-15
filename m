Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE582D238A;
	Thu, 15 Jan 2026 17:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496560; cv=none; b=Up98a+oXUWbcY8wfk0Rnvtw9W/v8GWu0apRf6K7ViP3hm4AnnRGhe0wcU9EVbRrERiTZpVNmbGIZjPYFhVg2iCwz1rrz5UvH+ubWQ/F0Z11fY8L3MkU34t8Gra1JQMyEmuH3rXlyCJTG9+QkV+4mTA7fE0oDut2lO8CjqCW8nbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496560; c=relaxed/simple;
	bh=Ajap/+yng1ladvtG1IXIRvukESYEv3R0oG2Riw/kTaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4XUDF8BaRa69e5QrVZpCWL6DAhfZZ591hvnGNjmBeVNPGgdibtQsYQAwtFc5lz4JzyUfJyOAeYNa+okRHIyi7rVcAtYXGbG9qW7HS7jL7BFDfjBFEfLklGCO1tzzt2U4ktOzjVtpatAM+cgFNWJRvQNkE7Athmn3edz0iL9J7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TN8li3Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TN8li3Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B523C116D0;
	Thu, 15 Jan 2026 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496560;
	bh=Ajap/+yng1ladvtG1IXIRvukESYEv3R0oG2Riw/kTaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TN8li3DcH/6Tp6caTJ/bCFMBF2l7DTflCvOCmGgmP3BsMRPJJN7GAlwPwlCSyKc8S
	 4GknBnaJzwZOfeWFU7LM+OdTbLNPAnPimRLCEdQLZfdY6f5uRG4IKSm9t2M8LrXipK
	 TTY3QCY7dL70dWohw1eP+RgZlH64yAWrfhdllPpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Christoph Niedermaier <cniedermaier@dh-electronics.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/119] arm64: dts: imx8mp: Fix LAN8740Ai PHY reference clock on DH electronics i.MX8M Plus DHCOM
Date: Thu, 15 Jan 2026 17:47:50 +0100
Message-ID: <20260115164153.944751967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut@mailbox.org>

[ Upstream commit c63749a7ddc59ac6ec0b05abfa0a21af9f2c1d38 ]

Add missing 'clocks' property to LAN8740Ai PHY node, to allow the PHY driver
to manage LAN8740Ai CLKIN reference clock supply. This fixes sporadic link
bouncing caused by interruptions on the PHY reference clock, by letting the
PHY driver manage the reference clock and assure there are no interruptions.

This follows the matching PHY driver recommendation described in commit
bedd8d78aba3 ("net: phy: smsc: LAN8710/20: add phy refclk in support")

Fixes: 8d6712695bc8 ("arm64: dts: imx8mp: Add support for DH electronics i.MX8M Plus DHCOM and PDK2")
Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
index 6835f28c1e3c5..1141b26d6b6f9 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-dhcom-som.dtsi
@@ -113,6 +113,7 @@ mdio {
 		ethphy0f: ethernet-phy@1 { /* SMSC LAN8740Ai */
 			compatible = "ethernet-phy-id0007.c110",
 				     "ethernet-phy-ieee802.3-c22";
+			clocks = <&clk IMX8MP_CLK_ENET_QOS>;
 			interrupt-parent = <&gpio3>;
 			interrupts = <19 IRQ_TYPE_LEVEL_LOW>;
 			pinctrl-0 = <&pinctrl_ethphy0>;
-- 
2.51.0



