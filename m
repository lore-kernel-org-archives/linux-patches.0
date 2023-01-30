Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74D328EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5802BC433D2;
	Mon, 30 Jan 2023 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087826;
	bh=VvzwojkYDmUgdP6b2KvJMcjkc7UthmubadaKiz506bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwY+038oddqoDSlX3U7qHo4R3blpiQN6QcONFT858JXD228ZSiSdkhmhqVX/AKxLZ
	 YW8HOhHKEFJ2g0fF7+xtx9DNsePJOSf38QJftuxiE7WmoqBplPcmwmn0pjgvFd1bRX
	 +KXnaEhg7VukYeqMfNSalqbS9FZxSGjafKAz1IVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teresa Remmet <t.remmet@phytec.de>,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/204] arm64: dts: imx8mp-phycore-som: Remove invalid PMIC property
Date: Mon, 30 Jan 2023 14:49:30 +0100
Message-Id: <20230130134316.541592574@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit cfd04dd1c4b6c33afc2a934b957d71cf8ddd1539 ]

'regulator-compatible' is not a valid property according to
nxp,pca9450-regulator.yaml and causes the following warning:

  DTC_CHK arch/arm64/boot/dts/freescale/imx8mp-dhcom-pdk2.dtb
...
pmic@25: regulators:LDO1: Unevaluated properties are not allowed ('regulator-compatible' was unexpected)

Remove the invalid 'regulator-compatible' property.

Cc: Teresa Remmet <t.remmet@phytec.de>
Fixes: 88f7f6bcca37 ("arm64: dts: freescale: Add support for phyBOARD-Pollux-i.MX8MP")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Teresa Remmet <t.remmet@phytec.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
index fc178eebf8aa..8e189d899794 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
@@ -98,7 +98,6 @@ pmic: pmic@25 {
 
 		regulators {
 			buck1: BUCK1 {
-				regulator-compatible = "BUCK1";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <2187500>;
 				regulator-boot-on;
@@ -107,7 +106,6 @@ buck1: BUCK1 {
 			};
 
 			buck2: BUCK2 {
-				regulator-compatible = "BUCK2";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <2187500>;
 				regulator-boot-on;
@@ -116,7 +114,6 @@ buck2: BUCK2 {
 			};
 
 			buck4: BUCK4 {
-				regulator-compatible = "BUCK4";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -124,7 +121,6 @@ buck4: BUCK4 {
 			};
 
 			buck5: BUCK5 {
-				regulator-compatible = "BUCK5";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -132,7 +128,6 @@ buck5: BUCK5 {
 			};
 
 			buck6: BUCK6 {
-				regulator-compatible = "BUCK6";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -140,7 +135,6 @@ buck6: BUCK6 {
 			};
 
 			ldo1: LDO1 {
-				regulator-compatible = "LDO1";
 				regulator-min-microvolt = <1600000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -148,7 +142,6 @@ ldo1: LDO1 {
 			};
 
 			ldo2: LDO2 {
-				regulator-compatible = "LDO2";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1150000>;
 				regulator-boot-on;
@@ -156,7 +149,6 @@ ldo2: LDO2 {
 			};
 
 			ldo3: LDO3 {
-				regulator-compatible = "LDO3";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -164,7 +156,6 @@ ldo3: LDO3 {
 			};
 
 			ldo4: LDO4 {
-				regulator-compatible = "LDO4";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -172,7 +163,6 @@ ldo4: LDO4 {
 			};
 
 			ldo5: LDO5 {
-				regulator-compatible = "LDO5";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 			};
-- 
2.39.0



