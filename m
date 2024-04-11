Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DC513DDDD;
	Thu, 11 Apr 2024 09:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829513; cv=none; b=piCITP1tZwABQT0bPLcQVnPzyl6Et2kYBE37QVXHmmZYpsASy80kYQYKlFA1VPhP8OWyIuga0a18pfzFBG3jbvpCZvRUbkY1Gc5hExogfAedAkG8HUm563f7fDmMeYmXI4D/g30nDYuUkDqJkYFT2z5hflk+BWJY4L+fkI6I420=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829513; c=relaxed/simple;
	bh=n8GFU4UKgVOTqct6aZt/EuiDIaxlW/Ddi4EhZRiYTSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJjdhkrweOe5lr1xA8myDMkKML1M8GXi1cGhVuNnZ/cFP4pq9He5YKutrrPl+LjK6snhM/B8ctJXAorx0BgHkEj8rSuNbYInTc5G/u09gDYRUFiZc6QnqiYUHnjQ57fcfqansw19lcBUMBlBVBecoCcsgN9egoot1vFeAGOq65A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTL5En/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTL5En/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10DBBC433C7;
	Thu, 11 Apr 2024 09:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829513;
	bh=n8GFU4UKgVOTqct6aZt/EuiDIaxlW/Ddi4EhZRiYTSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTL5En/e4iAUUyz7+HKR6yTp/1O2GiigfWmTNzhAr8QuffBmu1SKaVO4bOxCJ2GwV
	 ajHIQyMGUdLrmpqkfYxR7hz6toymX4S1lEg6O8fgnWom0IMrf8I+alwk1ri0lUGel1
	 MLwctRyPug+z94d7W+Qd5Ay9Fud4h+WxHwX9Q9h8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Rob Herring <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 013/175] ARM: dts: mmp2-brownstone: Dont redeclare phandle references
Date: Thu, 11 Apr 2024 11:53:56 +0200
Message-ID: <20240411095419.944257508@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 350208c5e1ed2..0fdcc2edcf4b6 100644
--- a/arch/arm/boot/dts/mmp2-brownstone.dts
+++ b/arch/arm/boot/dts/mmp2-brownstone.dts
@@ -21,176 +21,174 @@ chosen {
 	memory {
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



