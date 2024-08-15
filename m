Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6630719E7FA;
	Thu, 15 Aug 2024 14:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731086; cv=none; b=Nt+8ARw4QkiEiq02KTeYdWXH3Mhf3jZPl4KJny3sJIYTEa4vx5gE6B8/lbSSEzEiDOzKoE3zgXJKLop134GyMIR4UVASxlrWkdmFExFrb8EFHzxEYL8s46HV5yHMEKyk/qkJfBMZza8nYl2WRXs9t0eTNCiNsJzkyoNXoBuyG+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731086; c=relaxed/simple;
	bh=OtPwjlv3Kavgb6l5NiOd4F47kJinZTk9UEFXtm5OCbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cxrmunv0m8Ou6zCUmByWSS1XxFnM2bii6JqVVjeId6Wnz/jRZ/NnuI0Cn7I2kWRWnD9tkoeeOWpRlMJR2od5+mzBpe2/2ngPFKBQIyXKroD9qXFCnCXXktj/qBMF9BZQyMPw2VI4h26KxQxVtleWAe0OCLH8jOtdzkz125aZJYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcHoe+Ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcHoe+Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BF1C32786;
	Thu, 15 Aug 2024 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731086;
	bh=OtPwjlv3Kavgb6l5NiOd4F47kJinZTk9UEFXtm5OCbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcHoe+CeIwo7Ham47eaQysoR0AmjLm3Kb2YAcOgMfU2vGzObpD0ITJIUDefsHO0Qy
	 qhfdGh1ktqVGk1BcscefIvv6o5oMvsOTR2gA12fWyo67mT4rIYcrXB+0dDi+SWOx5c
	 QQ4pRY3e416ZLt/MRohiU5xNsqHz2TuI2aJ1CNSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 019/259] ARM: dts: imx6qdl-kontron-samx6i: fix PHY reset
Date: Thu, 15 Aug 2024 15:22:32 +0200
Message-ID: <20240815131903.539299961@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 1b9e38ec74489..1dcbad290cac0 100644
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



