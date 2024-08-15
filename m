Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4471A706A;
	Thu, 15 Aug 2024 14:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731926; cv=none; b=CnyMCBT4UllFMW9K5+n1w+WpFQ+i8jfi5cYTj7UadDbp6mIrcPJIGan7bnN2nmg1wqHtgzuWw04NlGz7lnebYepC0u+8mby1ZtqMWuT/Ksym1mZvRi80p34QoG6uUrPhuJ68GTvXRPUi/L9ocv/1VVhuJPnlbbkwWGvzyAuoZnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731926; c=relaxed/simple;
	bh=UH9Z1v4fKUCDNbMcUBraMe2FrAcS/mUUnYsSnw1Rxe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0uyS1d+l0u1sdpzavVNvFPbqGZRrDiwImISLmk53SVu4j74F6KmjaLTF4OULrBA975vXPPVHLpaP3+ggV15HL68pgEzgLdVk2asAC6McLcAbIpP80KujNoBgl/ZDLyfBzdfuzEchGMMSMelRjWazBK7yyK+pVwZ1JJFKWudnNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtqP//ZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtqP//ZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A979FC4AF0A;
	Thu, 15 Aug 2024 14:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731926;
	bh=UH9Z1v4fKUCDNbMcUBraMe2FrAcS/mUUnYsSnw1Rxe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtqP//ZBStqzPaRKxihYNfgDIdnvF/unBhtxtPSbcUwXFXRsvnDWh0Hjv/PKYR//P
	 08WNEEQTp4RF3TSlsbdW4bDN9OHPwAz45RxiUH5fOl5fVIwrQ6mI++QGyqkj9zaMtr
	 gSzt1ZNaCXaAU1HfIk4RmTquSFwe/PMvcH7VWJgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/352] ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset
Date: Thu, 15 Aug 2024 15:21:27 +0200
Message-ID: <20240815131920.036605684@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit edfea889a049abe80f0d55c0365bf60fbade272f ]

The PHY reset line is connected to both the SoC (GPIO1_25) and
the CPLD. We must not use the GPIO1_25 as it will drive against
the output buffer of the CPLD. Instead there is another GPIO
(GPIO2_01), an input to the CPLD, which will tell the CPLD to
assert the PHY reset line.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Fixes: 5694eed98cca ("ARM: dts: imx6qdl-kontron-samx6i: move phy reset into phy-node")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index e2b7bfddedcda..cf001c251fe37 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -269,7 +269,7 @@ mdio {
 		ethphy: ethernet-phy@1 {
 			compatible = "ethernet-phy-ieee802.3-c22";
 			reg = <1>;
-			reset-gpios = <&gpio1 25 GPIO_ACTIVE_LOW>;
+			reset-gpios = <&gpio2 1 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <1000>;
 		};
 	};
@@ -512,7 +512,7 @@ MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL 0x1b0b0
 			MX6QDL_PAD_ENET_MDIO__ENET_MDIO       0x1b0b0
 			MX6QDL_PAD_ENET_MDC__ENET_MDC         0x1b0b0
 			MX6QDL_PAD_ENET_REF_CLK__ENET_TX_CLK  0x1b0b0
-			MX6QDL_PAD_ENET_CRS_DV__GPIO1_IO25    0x1b0b0 /* RST_GBE0_PHY# */
+			MX6QDL_PAD_NANDF_D1__GPIO2_IO01       0x1b0b0 /* RST_GBE0_PHY# */
 		>;
 	};
 
-- 
2.43.0



