Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9441D2238;
	Wed,  2 Oct 2024 14:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877602; cv=none; b=MzIEk/Rbt8293vExuImuqKlsg5a4pGu1eTcXYr/aojq3CHnA0Bxtgyo48QaliVV0i2p9aVdeG6Qy6V48ArpqXwPCS59iGXW2ymbMssruHk7OPNRXRv0MDzetcYMwWUEFZH9/hN2DsaSt8Pg8dN6AT73ci/Gh6y4HotJtMboGdk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877602; c=relaxed/simple;
	bh=4FToqmGSC4jYghxtThe1Om225Ze4iK0MMY0bfaOsEYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2QwFTg7gX/Ltms3X9XaXcF7qdVWa3oOgRpyUKaOx3xowy2XwX0cUHdmBPsxlrYhy9ebANCvuQwl8CjyBiRbU8hZVOpHoVw2+B8s8LzfaYy0W1Y03sDcA2qAtzvkDWIzRPntgm9wQakLwBfg7q20T04IqUSud/BTAsu5U6l0XjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUTUv23A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUTUv23A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3038AC4CECD;
	Wed,  2 Oct 2024 14:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877601;
	bh=4FToqmGSC4jYghxtThe1Om225Ze4iK0MMY0bfaOsEYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TUTUv23Aq28sW4N5TUD0fby9hc6OlLmDpIZPG3g6yAeuGBjEsKbAvbtcqRFftbXVP
	 wtgiok1Gi6zFEuJ1urna6fJmHHPq5cJJN5Jw/HIrzAp/QnnES6tF6WqUuFQ/0NXuQ3
	 5PCFqElNkxKakhCnEgBZuHQq7ClureSD8H+KGKhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 129/634] arm64: tegra: Correct location of power-sensors for IGX Orin
Date: Wed,  2 Oct 2024 14:53:49 +0200
Message-ID: <20241002125816.202963445@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit b93679b8f165467e1584f9b23055db83f45c32ce ]

The power-sensors are located on the carrier board and not the
module board and so update the IGX Orin device-tree files to fix this.

Fixes: 9152ed09309d ("arm64: tegra: Add power-sensors for Tegra234 boards")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/nvidia/tegra234-p3701-0008.dtsi  | 33 -------------------
 .../boot/dts/nvidia/tegra234-p3740-0002.dtsi  | 33 +++++++++++++++++++
 2 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3701-0008.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3701-0008.dtsi
index 553fa4ba1cd48..62c4fdad0b600 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3701-0008.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3701-0008.dtsi
@@ -44,39 +44,6 @@
 			status = "okay";
 		};
 
-		i2c@c250000 {
-			power-sensor@41 {
-				compatible = "ti,ina3221";
-				reg = <0x41>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				input@0 {
-					reg = <0x0>;
-					label = "CVB_ATX_12V";
-					shunt-resistor-micro-ohms = <2000>;
-				};
-
-				input@1 {
-					reg = <0x1>;
-					label = "CVB_ATX_3V3";
-					shunt-resistor-micro-ohms = <2000>;
-				};
-
-				input@2 {
-					reg = <0x2>;
-					label = "CVB_ATX_5V";
-					shunt-resistor-micro-ohms = <2000>;
-				};
-			};
-
-			power-sensor@44 {
-				compatible = "ti,ina219";
-				reg = <0x44>;
-				shunt-resistor = <2000>;
-			};
-		};
-
 		rtc@c2a0000 {
 			status = "okay";
 		};
diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002.dtsi b/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002.dtsi
index 527f2f3aee3ad..377f518bd3e57 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002.dtsi
@@ -183,6 +183,39 @@
 			phy-names = "usb2-0", "usb2-1", "usb2-2", "usb2-3",
 				"usb3-0", "usb3-1", "usb3-2";
 		};
+
+		i2c@c250000 {
+			power-sensor@41 {
+				compatible = "ti,ina3221";
+				reg = <0x41>;
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				input@0 {
+					reg = <0x0>;
+					label = "CVB_ATX_12V";
+					shunt-resistor-micro-ohms = <2000>;
+				};
+
+				input@1 {
+					reg = <0x1>;
+					label = "CVB_ATX_3V3";
+					shunt-resistor-micro-ohms = <2000>;
+				};
+
+				input@2 {
+					reg = <0x2>;
+					label = "CVB_ATX_5V";
+					shunt-resistor-micro-ohms = <2000>;
+				};
+			};
+
+			power-sensor@44 {
+				compatible = "ti,ina219";
+				reg = <0x44>;
+				shunt-resistor = <2000>;
+			};
+		};
 	};
 
 	vdd_3v3_dp: regulator-vdd-3v3-dp {
-- 
2.43.0



