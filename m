Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74D428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD72C4339B;
	Mon, 30 Jan 2023 13:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086913;
	bh=o/oAq+HzCNCmmDYnBpg5D0Mt9vy/jjHbBA6McS5SlDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JZ90oiwShldb3gLca1cWIqoIiGv4uTSXnQJXEtWTZ6kWpNeaftNw5838A1MyAochP
	 yDzAJh9/MHcAqpn8GfUN35CMji2MIBfz/3JI0rrXVl2E3AFFs/3HAsvykfcjwfomec
	 la9lv2+3M6Xvtixm3urCznfYGdNsJUUQ0QuCwb10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teresa Remmet <t.remmet@phytec.de>,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/313] arm64: dts: imx8mp-phycore-som: Remove invalid PMIC property
Date: Mon, 30 Jan 2023 14:47:23 +0100
Message-Id: <20230130134337.045027072@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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
index 79b290a002c1..ecc4bce6db97 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-phycore-som.dtsi
@@ -99,7 +99,6 @@ pmic: pmic@25 {
 
 		regulators {
 			buck1: BUCK1 {
-				regulator-compatible = "BUCK1";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <2187500>;
 				regulator-boot-on;
@@ -108,7 +107,6 @@ buck1: BUCK1 {
 			};
 
 			buck2: BUCK2 {
-				regulator-compatible = "BUCK2";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <2187500>;
 				regulator-boot-on;
@@ -119,7 +117,6 @@ buck2: BUCK2 {
 			};
 
 			buck4: BUCK4 {
-				regulator-compatible = "BUCK4";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -127,7 +124,6 @@ buck4: BUCK4 {
 			};
 
 			buck5: BUCK5 {
-				regulator-compatible = "BUCK5";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -135,7 +131,6 @@ buck5: BUCK5 {
 			};
 
 			buck6: BUCK6 {
-				regulator-compatible = "BUCK6";
 				regulator-min-microvolt = <600000>;
 				regulator-max-microvolt = <3400000>;
 				regulator-boot-on;
@@ -143,7 +138,6 @@ buck6: BUCK6 {
 			};
 
 			ldo1: LDO1 {
-				regulator-compatible = "LDO1";
 				regulator-min-microvolt = <1600000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -151,7 +145,6 @@ ldo1: LDO1 {
 			};
 
 			ldo2: LDO2 {
-				regulator-compatible = "LDO2";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <1150000>;
 				regulator-boot-on;
@@ -159,7 +152,6 @@ ldo2: LDO2 {
 			};
 
 			ldo3: LDO3 {
-				regulator-compatible = "LDO3";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
@@ -167,13 +159,11 @@ ldo3: LDO3 {
 			};
 
 			ldo4: LDO4 {
-				regulator-compatible = "LDO4";
 				regulator-min-microvolt = <800000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
 			ldo5: LDO5 {
-				regulator-compatible = "LDO5";
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-boot-on;
-- 
2.39.0



