Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A695A2686A8;
	Tue,  8 Apr 2025 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110594; cv=none; b=AH3OrkvkIYCOPdo2ur3WTKTzSO5ZkO/4JlMq++zqtUU8PqVorqK/dqEYqSN8tT29UQhOJPfoRI7IFv1DozBpb4Qe4Jrjytc7/3K8WSu8jU1bEeqd8RBVrvxB302pQW5HqC+9ped7x6ecqIUmc12e0RvrHGw8BW4wGz6W26lapEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110594; c=relaxed/simple;
	bh=GUA2FAeCot4+ucdIzbjDnUIEPseCB2K9vKlm0eREl0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQoM8onwLA6xYDDz0+MbG2UMuLr+aH7rL7FRoJ0mYnbkdDpbB+GGiP5JXYtgjVkW+IA+y8SGv7+fLrM2lMrVcG8LNishW6o5KRpQPqwSpVsdiGdV+Cl4Xs25gbrWr4bpOo8k0uUTl0IF1tLR7IL2hKu9fpeGv6gNb1Dzp5x/IFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9Ud283D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9Ud283D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D5CC4CEE5;
	Tue,  8 Apr 2025 11:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110594;
	bh=GUA2FAeCot4+ucdIzbjDnUIEPseCB2K9vKlm0eREl0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e9Ud283DNZnLg91nol9pOnUMW71cef6/bYg90LmmD2nE0S4eAFmCxGBFSLdJrWRnR
	 2sqJh3uAtwqY/0D8xYAsNP4awf3DyOnQBGiADxMteFm8ZxFil2/bpx199FVs6NHbS8
	 NmMBAQqeERIlDR92R6UdWoLKOXij/JVh/9CMgJT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmad Fatoum <a.fatoum@pengutronix.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 121/731] arm64: dts: imx8mp-skov: correct PMIC board limits
Date: Tue,  8 Apr 2025 12:40:18 +0200
Message-ID: <20250408104917.091253974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmad Fatoum <a.fatoum@pengutronix.de>

[ Upstream commit d19a6f79961df1c29d8b2ac93b01b96788f209fa ]

The PMIC voltage constraints in the device tree currently describe the
permissible range of the PMIC. This is unnecessary as this information
already exists in the driver and wrong as it doesn't account for
board-specific constraints, e.g. a 2.1V on VDD_SOC would fry the SoC and
a maximum voltage of 3.4V on the VDD_3V3 rail may be unexpected across
the board.

Fix this by adjusting constraints to reflect the board limits.

Fixes: 6d382d51d979 ("arm64: dts: freescale: Add SKOV IMX8MP CPU revB board")
Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-skov-reva.dtsi  | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi
index 59813ef8e2bb3..ae82166b5c266 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-skov-reva.dtsi
@@ -247,8 +247,8 @@
 
 			reg_vdd_arm: BUCK2 {
 				regulator-name = "VDD_ARM";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <2187500>;
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <1000000>;
 				vin-supply = <&reg_5v_p>;
 				regulator-boot-on;
 				regulator-always-on;
@@ -259,8 +259,8 @@
 
 			reg_vdd_3v3: BUCK4 {
 				regulator-name = "VDD_3V3";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <3400000>;
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
 				vin-supply = <&reg_5v_p>;
 				regulator-boot-on;
 				regulator-always-on;
@@ -268,8 +268,8 @@
 
 			reg_vdd_1v8: BUCK5 {
 				regulator-name = "VDD_1V8";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <3400000>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 				vin-supply = <&reg_5v_p>;
 				regulator-boot-on;
 				regulator-always-on;
@@ -277,8 +277,8 @@
 
 			reg_nvcc_dram_1v1: BUCK6 {
 				regulator-name = "NVCC_DRAM_1V1";
-				regulator-min-microvolt = <600000>;
-				regulator-max-microvolt = <3400000>;
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
 				vin-supply = <&reg_5v_p>;
 				regulator-boot-on;
 				regulator-always-on;
@@ -286,8 +286,8 @@
 
 			reg_nvcc_snvs_1v8: LDO1 {
 				regulator-name = "NVCC_SNVS_1V8";
-				regulator-min-microvolt = <1600000>;
-				regulator-max-microvolt = <3300000>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 				vin-supply = <&reg_5v_p>;
 				regulator-boot-on;
 				regulator-always-on;
@@ -295,8 +295,8 @@
 
 			reg_vdda_1v8: LDO3 {
 				regulator-name = "VDDA_1V8";
-				regulator-min-microvolt = <800000>;
-				regulator-max-microvolt = <3300000>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 				vin-supply = <&reg_5v_p>;
 				regulator-boot-on;
 				regulator-always-on;
-- 
2.39.5



