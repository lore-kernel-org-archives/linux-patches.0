Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029556;
	b=IsvQMt89EyPvG8kTbdY2QERWmAZMAuYdpdvwVk9nyUjOfPJdE+RUJMKAC80WYEUrSZmd
	 DJ6ksGZnJI+OfLPnKbnDfu46bKQjALphVx+OBvVhNGJVhNhAjFV82X44ufK04RdHtvDWC
	 FjeJTfaQQdsuyUkE3KON5Ysj097GIWHaMT4G16Iil14NdxcRpogqo4AWVxFRG+lFnHfWN
	 X+jN2U1qYQMkniEd8xXOg/wOI7a4ZxIkimxOx2h78vMOm9TzA1AyptFGfxGnTKNFB7tB/
	 hTaGtHDRw+ms1gM2ta8BTMxPhdjzFjpBeS8RBpvKZvP2JVltxrJWWg+0Tyiuv6ot63g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029556;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f8XLRwdaQkFvWf1MsUDZddzglza8Bmi3JL3HMv8226s=;
	b=LkOTlAbcWQy87BbW9HOh93xEn6BW0h1pKkcEdvJc1LaVjA2CCPcgacfZ6dDL0Mdzk9kQ
	 hsNI1QFawvtspTKGw/XJZlEma2whdI4XdbN62zylu4AWNttVKAwlbPTccfkXK8IUM6wJF
	 rXrRx2KSwlx4XRJgaGm4fE3TjlP0kgL31VYzck8+BeYedkxc3iXXXu7ltGFnVGwSr0ej1
	 rBF1GBWOcEBOFtX85gO+96/whRbTk3JmC+ONgYZT4Ki6LajpZujXEMcb5y57fBYcm3tFQ
	 UJmEppVcT/S3YRPi1Bo/+8Q0z0wBhN8KRXfGqB28ZdHBL1tkBp3Z2o/lAf1CRz3cMAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VyQjpuLi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829B7606A320;
	Wed, 18 Nov 2026 19:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VyQjpuLi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D585A1F000C4;
	Wed, 18 Nov 2026 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029556;
	bh=f8XLRwdaQkFvWf1MsUDZddzglza8Bmi3JL3HMv8226s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyQjpuLiPciw+cFnvdxF1B6BduT2XMwn98GxZfVmEOaiRzzmIsQKeANAcDcUErgps
	 jEHiXmcZWZtZw7ZASI5vAlLSPrDJRj4fVBdnVi7Iu2ZkZPtDQOnXqjPefrFz4ngrzE
	 EJSUDS6Mjovku+p6nnezEu2ri+Mszrd8ooUzZh3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nora Schiffer <nora.schiffer@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0375/1756] ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints
Date: Wed, 18 Nov 2026 15:41:42 +0100
Message-ID: <20261118150023.403959550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 91ca23a66bf3c..b66decb19117d 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7-tqma7.dtsi
@@ -46,8 +46,8 @@ pfuze3000: pmic@8 {
 
 		regulators {
 			sw1a_reg: sw1a {
-				regulator-min-microvolt = <700000>;
-				regulator-max-microvolt = <3300000>;
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <1225000>;
 				regulator-boot-on;
 				regulator-always-on;
 				regulator-ramp-delay = <6250>;
@@ -55,34 +55,33 @@ sw1a_reg: sw1a {
 
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
@@ -95,18 +94,25 @@ vref_reg: vrefddr {
 
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
@@ -118,13 +124,13 @@ vgen4_reg: v33 {
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



