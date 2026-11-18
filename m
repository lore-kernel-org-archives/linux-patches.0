Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055037;
	b=krIzNtqJEONz13pQiuZvkiD/axsm3bkPVfqpWfeHs+40rCU/n7wnVxtmWNum2+tqQ7e5
	 1fbTzz04rsj/y1gfCPQCvURiozwHKChNl/ktyiJ7fKqdJ7RmJxyouW8Y8XiLJekSDXaDf
	 yYx9sD1T5QVDo2CK6KyMQtQfxaA1ehL4KEFQxTXk7RNLKoM0IJRsri4pqyr+rpvDthUKw
	 K9EfdVunNQzudTaNurvH5G/YESSmsQaUgQfmI32LM50ukWmBpoULqEDHC4gfnbBXLv5Ps
	 Hg0ZamFTBL7WvUaVR7LtxbhAARrLrlnYypX6zsxT6RB3Qx0wpWlbgGqNrpcYh/2ARsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TYbmkLotWgiBsopgC40DT5Ybop1RjergBFh21JqoAQs=;
	b=FpB/ti4bt+36A+b6hazPON84J3pK6tJ6OeMjetVq/c7Hhjf+so6Tjdcuw9MOAqxJxDJC
	 Uyf5PfGDnjB00iwtfvmKvHSC+vHhJ5ajQCHOP4XzBOud1OUl0RJsNBa0LQT0bFZHzQTqv
	 IeuPD1SkqQVWJ3gIK61YQaJmf4qxWR2Daur7wyIuyn6OAXJvPrtoi26/j4IcnpJkbRcsB
	 sqIwn3niQbrsigQ+JVybBvzkxScedkqLKuP88pmS/m15/xJofS4XVRLMXiUqYqfKrDLIQ
	 /7iNtBcjSfTHu2CKnepQ2vweKTSBAv6EkUJTzvwtw30C6k1enUS4FlK2nsAR1oKXmAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwiLHiya;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81256606A320;
	Thu, 19 Nov 2026 02:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwiLHiya
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D64671F000C5;
	Thu, 19 Nov 2026 02:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055037;
	bh=TYbmkLotWgiBsopgC40DT5Ybop1RjergBFh21JqoAQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwiLHiyaImPAhbJNtqV6beG2v6PYD9+r2Zs1T/TbrbEYXx/h/AmCCr93Tpe1o8eYA
	 lMfgVS+JF6qMJTvGEkifDBCZ1KIxhtiFys1rlDkQc0SlkOUQFcAOcDaWNO3uccTjYR
	 VQO9ZRUNduNoNrTdCpykYVmHVTqWlAf55DMxy/G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nora Schiffer <nora.schiffer@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1488/2214] ARM: dts: imx7-tqma7: correctly specify PMIC voltage constraints
Date: Wed, 18 Nov 2026 15:52:44 +0100
Message-ID: <20261118150110.799238099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 22d0eaa4cef79..9fe4819fd34c9 100644
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



