Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C8FE145353;
	Thu, 11 Apr 2024 10:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830466; cv=none; b=Mmb2k86TCrbuVw6+1cvypWTbYw0K0sP+/xHDElR1vIVoVJlmYtWsvhxuB0BN21ezeu8l3jUAgVJeLxdaLbehzKHvIQf4oprBPSaKCRW9rTpAY9rVsy6+dz/CErwJtl06dFSi61jgMZXFiJVQio7h9biS9NxEcBEUg7e8MMvlJXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830466; c=relaxed/simple;
	bh=walKaUfiGNp3DN4vqIz5ZJA6+ltaeg29LjaJFWWjoNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/I5Ik2+Dba+Q0wuDjTpSLDb+l0EEAVl6lecD5PrOA+H3aSCQ4lQ2XDnjE5bmtlH9weoMI5aznY/bzpI66BsBBZZUsmhsoi7wRJ7tBDiTPwTgsmFe5xs6DzXSpRvhw2Emsw1ybefiF9aodq1wg9MJ+xrZhj6bumJUPrrxQh2auY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=taeSGEO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="taeSGEO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13394C433F1;
	Thu, 11 Apr 2024 10:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830466;
	bh=walKaUfiGNp3DN4vqIz5ZJA6+ltaeg29LjaJFWWjoNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taeSGEO3PffhmRnHI/bFef/7f8z3pFpV6Ro+LN5I9MXnoN1Qmh3wKPQUGxwY9prNg
	 QaDi/c//VK5REqJP/oQkyR1Vzz/sn+dDh41aNRsHRfoT/EqiLFfGW3WbQzr2iZVHP9
	 nTLyRm/3Ze2oJ3A+PkTA3Nb9j16QcZLxqr6ShEBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/215] ARM: dts: mmp2-brownstone: Dont redeclare phandle references
Date: Thu, 11 Apr 2024 11:53:41 +0200
Message-ID: <20240411095425.250631064@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 5a56cf3e8738f5d31d8c024d0c62a4c2bfe76fb2 ]

Extend the nodes by their phandle references instead of recreating the
tree and declaring references of the same names.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Reviewed-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20200320174107.29406-5-lkundrak@v3.sk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 831e0cd4f9ee ("arm: dts: marvell: Fix maxium->maxim typo in brownstone dts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/mmp2-brownstone.dts | 332 +++++++++++++-------------
 1 file changed, 165 insertions(+), 167 deletions(-)

diff --git a/arch/arm/boot/dts/mmp2-brownstone.dts b/arch/arm/boot/dts/mmp2-brownstone.dts
index aaedc4c742ea5..04f1ae1382e7a 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -19,176 +19,174 @@ memory {
 		device_type = "memory";
 		reg = <0x00000000 0x08000000>;
 	};
+};
+
+&uart3 {
+	status = "okay";
+};
 
-	soc {
-		apb@d4000000 {
-			uart3: uart@d4018000 {
-				status = "okay";
-			};
-			twsi1: i2c@d4011000 {
-				status = "okay";
-				pmic: max8925@3c {
-					compatible = "maxium,max8925";
-					reg = <0x3c>;
-					interrupts = <1>;
-					interrupt-parent = <&intcmux4>;
-					interrupt-controller;
-					#interrupt-cells = <1>;
-					maxim,tsc-irq = <0>;
+&twsi1 {
+	status = "okay";
+	pmic: max8925@3c {
+		compatible = "maxium,max8925";
+		reg = <0x3c>;
+		interrupts = <1>;
+		interrupt-parent = <&intcmux4>;
+		interrupt-controller;
+		#interrupt-cells = <1>;
+		maxim,tsc-irq = <0>;
 
-					regulators {
-						SDV1 {
-							regulator-min-microvolt = <637500>;
-							regulator-max-microvolt = <1425000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						SDV2 {
-							regulator-min-microvolt = <650000>;
-							regulator-max-microvolt = <2225000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						SDV3 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO1 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO2 {
-							regulator-min-microvolt = <650000>;
-							regulator-max-microvolt = <2250000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO3 {
-							regulator-min-microvolt = <650000>;
-							regulator-max-microvolt = <2250000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO4 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO5 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO6 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO7 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO8 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO9 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO10 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-						};
-						LDO11 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO12 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO13 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO14 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO15 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO16 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO17 {
-							regulator-min-microvolt = <650000>;
-							regulator-max-microvolt = <2250000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO18 {
-							regulator-min-microvolt = <650000>;
-							regulator-max-microvolt = <2250000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO19 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-						LDO20 {
-							regulator-min-microvolt = <750000>;
-							regulator-max-microvolt = <3900000>;
-							regulator-boot-on;
-							regulator-always-on;
-						};
-					};
-					backlight {
-						maxim,max8925-dual-string = <0>;
-					};
-					charger {
-						batt-detect = <0>;
-						topoff-threshold = <1>;
-						fast-charge = <7>;
-						no-temp-support = <0>;
-						no-insert-detect = <0>;
-					};
-				};
-			};
-			rtc: rtc@d4010000 {
-				status = "okay";
+		regulators {
+			SDV1 {
+				regulator-min-microvolt = <637500>;
+				regulator-max-microvolt = <1425000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			SDV2 {
+				regulator-min-microvolt = <650000>;
+				regulator-max-microvolt = <2225000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			SDV3 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO1 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO2 {
+				regulator-min-microvolt = <650000>;
+				regulator-max-microvolt = <2250000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO3 {
+				regulator-min-microvolt = <650000>;
+				regulator-max-microvolt = <2250000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO4 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO5 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO6 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO7 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO8 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO9 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO10 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
 			};
+			LDO11 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO12 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO13 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO14 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO15 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO16 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO17 {
+				regulator-min-microvolt = <650000>;
+				regulator-max-microvolt = <2250000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO18 {
+				regulator-min-microvolt = <650000>;
+				regulator-max-microvolt = <2250000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO19 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+			LDO20 {
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <3900000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+		};
+		backlight {
+			maxim,max8925-dual-string = <0>;
+		};
+		charger {
+			batt-detect = <0>;
+			topoff-threshold = <1>;
+			fast-charge = <7>;
+			no-temp-support = <0>;
+			no-insert-detect = <0>;
 		};
 	};
 };
+
+&rtc {
+	status = "okay";
+};
-- 
2.43.0



