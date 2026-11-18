Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039751;
	b=R7/OFJlo3nrOvV4tE+uvyJ1tNSuJ1jDd//nDzMxGrIPIZ6ExIC4+daE8p2jo6QsEJHhX
	 UwJN64tYb7EEt9ZXfU42FVphaCsPQUYi8ExukMHHPThFt+h0fAc2fDAtjF+WeBM0hZqpx
	 8QKMRgLSALI3RMX5/OfobwlOoBqogt0/ZMmYqV61cQry7hBLJg7PcqsIF6DpAdkKCgy9S
	 dBcXkNv2Gbi1hy5/QnX84WBlNfDHxVI4/YhFmI9hCaAzK5kmZFtE1hdHuKAsRbfp+zv6u
	 sSd6lEcWHyuDQcWzm/CyGin4jNsg2q30XxoXTqXohhM3mAR/muMROMBPcOu78Oxh3sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dv2na1X9aw+tVzrXCA/mbuZKRoYpFR7R+VnZB5m+Ldc=;
	b=1yY0RxVvWwJKeo8wGhJLFyuqduuWX+q39DZqGzwGCbtE8YqYzTKoBGbJfwpaOknglGew
	 jElD0Dp0POVuG7/xKw/2KhJSsn0C/yZLxlWpGHY7DPJ+gclq1GUOdBCJBy5ienRogcwgG
	 8gUL3s89LFhkmdAC3uWhHegnnQ40AAI68pRmmr5kh6rLlpq7USbMj5EcJYMmRkmprg291
	 ewpq9F0wWYrOkwgjxbhfnr+zQQcA5XyrtiRrmKYgqY0Yul1lJtihCmeeClR1u4qe9aMIY
	 enPjZRor703sNU9o9BgZsx4U4sSHEqV7e60GnOECIrC555fk+SgkRpwdVGSHR11Qf6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLhmG+bV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9DD606A320;
	Wed, 18 Nov 2026 22:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLhmG+bV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635BD1F000C4;
	Wed, 18 Nov 2026 22:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039750;
	bh=Dv2na1X9aw+tVzrXCA/mbuZKRoYpFR7R+VnZB5m+Ldc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLhmG+bV7LSavmfJxm/ogif8K9s4VglTqP2/62rv+QsZchTO+UOQo1nBmzKvEnc+l
	 g0QTEjb3IshNVskTSgkZ3Qyt+a+CX/3euLbcVK9y8uE8cfgJoIC9Xtdty/d5YXdBwL
	 me+EPbx/njHyo058FTV0Xrza+44HKakXSvHPACu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nora Schiffer <nora.schiffer@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2185/3318] ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints
Date: Wed, 18 Nov 2026 15:46:47 +0100
Message-ID: <20261118150427.510504673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nora Schiffer <nora.schiffer@ew.tq-group.com>

[ Upstream commit f322f8f68c2c3291633ead663effa3b25c18f7b1 ]

regulator-(min|max)-microvolt refer to the supported voltages according
to board design, not the possible range of the regulators themselves.
Update the configuration for the TQMa7x's PMIC and also add a comment
regarding the PMIC's VCC_SD switching feature.

Fixes: a80a1af6ec8a ("ARM: dts: tq imx7 common board support")
Signed-off-by: Nora Schiffer <nora.schiffer@ew.tq-group.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi | 40 +++++++++++++----------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi b/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
index fe42b0a468310..813dc4ae453d3 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
@@ -43,8 +43,8 @@ pfuze3000: pmic@8 {
 
 		regulators {
 			sw1a_reg: sw1a {
-				regulator-min-microvolt = <700000>;
-				regulator-max-microvolt = <3300000>;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1225000>;
 				regulator-boot-on;
 				regulator-always-on;
 				regulator-ramp-delay = <6250>;
@@ -52,34 +52,33 @@ sw1a_reg: sw1a {
 
 			/* use sw1c_reg to align with pfuze100/pfuze200 */
 			sw1c_reg: sw1b {
-				regulator-min-microvolt = <700000>;
-				regulator-max-microvolt = <1475000>;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1000000>;
 				regulator-boot-on;
 				regulator-always-on;
 				regulator-ramp-delay = <6250>;
 			};
 
 			sw2_reg: sw2 {
-				regulator-min-microvolt = <1500000>;
-				regulator-max-microvolt = <1850000>;
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
 			sw3a_reg: sw3 {
-				regulator-min-microvolt = <900000>;
-				regulator-max-microvolt = <1650000>;
+				regulator-min-microvolt = <1350000>;
+				regulator-max-microvolt = <1350000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
 			swbst_reg: swbst {
-				regulator-min-microvolt = <5000000>;
-				regulator-max-microvolt = <5150000>;
+				/* Not connected and left unconfigured */
 			};
 
 			snvs_reg: vsnvs {
-				regulator-min-microvolt = <1000000>;
+				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <3000000>;
 				regulator-boot-on;
 				regulator-always-on;
@@ -92,18 +91,25 @@ vref_reg: vrefddr {
 
 			vgen1_reg: vldo1 {
 				regulator-min-microvolt = <1800000>;
-				regulator-max-microvolt = <3300000>;
+				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
 			};
 
 			vgen2_reg: vldo2 {
-				regulator-min-microvolt = <800000>;
-				regulator-max-microvolt = <1550000>;
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <1500000>;
 				regulator-always-on;
 			};
 
 			vgen3_reg: vccsd {
-				regulator-min-microvolt = <2850000>;
+				/*
+				 * Specified values refer to 3.3V operation; voltage for 1.8V
+				 * operation is derived from this.
+				 *
+				 * The base board should usually mux GPIO1_IO08 to SD1_VSELECT for
+				 * automatic switching of SD card IO voltage.
+				 */
+				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 			};
@@ -115,13 +121,13 @@ vgen4_reg: v33 {
 			};
 
 			vgen5_reg: vldo3 {
-				regulator-min-microvolt = <1800000>;
+				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 			};
 
 			vgen6_reg: vldo4 {
-				regulator-min-microvolt = <1800000>;
+				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 			};
-- 
2.53.0



