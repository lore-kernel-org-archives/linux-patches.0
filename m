Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048308;
	b=KBPzVhdodDVIdFPJdKza1PSkZTXBmGEMmD7/5DGGB6yW1k0TxTKzlmq1MnZrHaavtDFu
	 zhCNKzxbIMjzcqiFwh3MeXG3XaTHl4qDPV+9HBDRlMu6gatKTi9m6aKl3aNJtn/iFxe5o
	 Tkve5Jx8NrHZjQDFxAJdAfhl7SyWkSKaRYIwzP093HCHLiVq4lGcQQEC1RLh/BklVcHlN
	 cupWOtqTZqraKVi5kD3xysa1NS8/1X0n7SIrsJfq7ZdEISOoZqKR99YkqizxqwB9zTmNA
	 P9KHMbLugLPlUcvGNqFMV9seTqI92wwvW6E9a/mIHfFM4ZAwZJvxKwfeNDgejNb23qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048308;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XK0QJrJwAUFal/2HwbSiesv4549yNpyYjpToKIY1R+Y=;
	b=ELrS3HVFz8U8dGSO3xTJJIRSmMkgEC1tN/Cr7Qy+sLr/ZZFa4zy2Y5+3hZbvL0xwHyL0
	 imY9cVVCve1WWM0K+wBNEeJ8vAuo22kBmdg4EeAElfKFCZBmFmHMe5e2DRIutm6w1EzN/
	 4mTGNJDoXRjHQ2Sfo/dYVHMVxZg6tbB8wyKTvGSFvQXOk7Cj31VpN6IaDN4U/AX9R3osT
	 W8c1p6vA8bo0b6O4jsEwsWwkuSoSrAauvYQ+Sb24F99z2NRyItV28CMaHJpE3iH0nv1vQ
	 SmYOuiI1NFwy3bec/ct90HszclNFMAOgu0S4FIA3F5JYqV2LvFQ+wrhoyjyPHBNr6aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8ZLfRoI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5DD606A320;
	Thu, 19 Nov 2026 00:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h8ZLfRoI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE411F000C9;
	Thu, 19 Nov 2026 00:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048308;
	bh=XK0QJrJwAUFal/2HwbSiesv4549yNpyYjpToKIY1R+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h8ZLfRoI7aSVTZRQRVTb+MIUnmRqFjcmVuo1EybmjyMIdGmu50hRuoUriDgfbC4cZ
	 sbrQenncxtbyo6dixB0EbuX6o1aPUeIc4g4JppIs6dY3hYn/WCn0AM1G4VYXcr78n8
	 dcBt11NgMgYIo3mhuAKT3SkirLRRwhtQg/QhfKxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nora Schiffer <nora.schiffer@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1907/2857] ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints
Date: Wed, 18 Nov 2026 15:49:01 +0100
Message-ID: <20261118150309.883711661@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx7-tqma7.dtsi | 40 ++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/arm/boot/dts/imx7-tqma7.dtsi b/arch/arm/boot/dts/imx7-tqma7.dtsi
index fe42b0a468310..813dc4ae453d3 100644
--- a/arch/arm/boot/dts/imx7-tqma7.dtsi
+++ b/arch/arm/boot/dts/imx7-tqma7.dtsi
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



