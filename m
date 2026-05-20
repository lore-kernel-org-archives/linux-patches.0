Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E20F3E9C3D;
	Wed, 20 May 2026 16:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296330; cv=none; b=F5jW0G8E+Y++OP1hbA7LVgkr5KJB0i7cZDA1h5OPRfRo8PjtxKmbwLSlXYMEko5ZdfM/9mv+dBWQxiR/NJ753sgtPlbyRoJsLMK5hkuKj4rsJl1wBbo2x5RNP5DV7KSnVBmb6hjveOQHNy8b81yWb7NQhzcgS7G3eD1P4uDhcNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296330; c=relaxed/simple;
	bh=AliJf50iBzTetwTBM5jyUM6FGXAUWxFTGZgC4JWOIj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxP7srsp+cymxvVZzI4VEE/M2dQFXVZs+uVa4dwy1cBjIpEW4D/DSkAAXVq0Gp76n8pb+lHMK9htByPOD7aNazzpVHi2mDhtLeDDX/BKYsVeLnJM+XQm+rw4ie2r6J8zxJF4yc6WtbXLlz5IDU/6TPk0yOincSq9JwrEQgZC+/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7hh5dGu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7hh5dGu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A361F1F000E9;
	Wed, 20 May 2026 16:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296329;
	bh=dpTZ1CY3/FfJUUrK07OcIDDTG4/2c7kSm/TrREszzQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7hh5dGu5sP4Pf4AWMyrAicpewHC5Fmu/XZ+fHxBAlaX2Zo/ySKc76lH2qZ5jyo3k
	 Se7NEWUmaUIze7lHunn+hcAB/LwzeznXCgEHs6N3Yy51JUamPQ4BnyMYrcoY3R96vt
	 xuWZCV2eh+VmSPb3Fve8/rybv/CTKTPGDCMBHl4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0758/1146] arm64: dts: imx8mp-ultra-mach-sbc: Correct PAD settings for PMIC_nINT
Date: Wed, 20 May 2026 18:16:48 +0200
Message-ID: <20260520162205.365923079@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit daaf41ee72fb5fad936e7051a015cccae9b33937 ]

With commit 5d0efaf47ee90 ("regulator: pca9450: Correct interrupt type"),
there might be interrupt storm for this board. Need to set PAD PUE and PU
together to make pull up work properly.

Fixes: d1c1400bd3b8b ("arm64: dts: imx8mp: Add initial support for Ultratronik imx8mp-ultra-mach-sbc board")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts b/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts
index 9ecec1a418781..3e6f9c88cc200 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-ultra-mach-sbc.dts
@@ -275,7 +275,7 @@ pmic@25 {
 		reg = <0x25>;
 		pinctrl-0 = <&pinctrl_pmic>;
 		interrupt-parent = <&gpio1>;
-		interrupts = <3 GPIO_ACTIVE_LOW>;
+		interrupts = <3 IRQ_TYPE_LEVEL_LOW>;
 
 		/*
 		 * i.MX 8M Plus Data Sheet for Consumer Products
@@ -739,7 +739,7 @@ MX8MP_IOMUXC_GPIO1_IO07__GPIO1_IO07		0x40	/* NFC_INT */
 
 	pinctrl_pmic: pmic-grp {
 		fsl,pins = <
-			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x40	/* #PMIC_INT */
+			MX8MP_IOMUXC_GPIO1_IO03__GPIO1_IO03		0x1c0	/* #PMIC_INT */
 		>;
 	};
 
-- 
2.53.0



