Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD2F1B583F;
	Tue, 30 Jul 2024 15:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355044; cv=none; b=EhhItVU34h8IBUOvBphYyAABRfDsGL4Gp72IdYegnvhbH0uo4H67k2iTxUkyoq6OnHZxU7pwA0LOxus65JQbTgz8j1jc3UmawHQvnP6EMsww9QxTQ8PjjaW8cV9WMnHX58Os4KfSX8hVZ5RpwiuwB5L5OaFYqDon98xq3nGKCAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355044; c=relaxed/simple;
	bh=SO+eOmCXb5zBXGi3RS1E7GwWSUhiPh1lNqH4iq0Lqjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cC1YYdlmfB3Cgv/TQCia+KrMQ3UBMWVbPHXj/HDrCtcfxGPY7oOCCcx0+F0i6eSB/UMc+rWmzt+pptk/XO+DDuQVxOQRXnle2sII2QnGMdxi+7MTvvDEgZkOjGgmzUCm7yLlLdQjlEIzJ6JtT8wUe+mi8O5VDx0S8ItR0Szptoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVaW6h9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVaW6h9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22EE6C32782;
	Tue, 30 Jul 2024 15:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355044;
	bh=SO+eOmCXb5zBXGi3RS1E7GwWSUhiPh1lNqH4iq0Lqjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVaW6h9qDoFL0v89G3Wbkmxd8WDruCtnxPRRBVI/gbwMSGBLjsJ0XmLi8m/U414Ly
	 05WquykOCAhcUldmwrltDUJwThEH/1NRlrrIJXadyUcTxhxtY13rMN6li+gJC6ZAgO
	 ZhC7cD0t1q335XCYAviTyMXkLSVimQ80zH9R8xog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/440] ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset
Date: Tue, 30 Jul 2024 17:44:46 +0200
Message-ID: <20240730151617.833966921@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d8c1dfb8c9abb..d6c049b9a9c69 100644
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
@@ -516,7 +516,7 @@ MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL 0x1b0b0
 			MX6QDL_PAD_ENET_MDIO__ENET_MDIO       0x1b0b0
 			MX6QDL_PAD_ENET_MDC__ENET_MDC         0x1b0b0
 			MX6QDL_PAD_ENET_REF_CLK__ENET_TX_CLK  0x1b0b0
-			MX6QDL_PAD_ENET_CRS_DV__GPIO1_IO25    0x1b0b0 /* RST_GBE0_PHY# */
+			MX6QDL_PAD_NANDF_D1__GPIO2_IO01       0x1b0b0 /* RST_GBE0_PHY# */
 		>;
 	};
 
-- 
2.43.0



