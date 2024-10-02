Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BC01D0412;
	Wed,  2 Oct 2024 13:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875567; cv=none; b=CDvj7eULiOU9sUBII0eQOOwLc8nhNLx8SFPe+5IqcH++Ngm/d0bSZ1Neb/mMOhFqB16wq8ehSUc07A6+MSFXvsjOYAJmVYTkdWdJHjLy63j7owyHuTWg+imfuFzjQcWMZyPBQCvXaPfZuDSoOaVG/XfbGMv2DtDwxFtnGhR4m1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875567; c=relaxed/simple;
	bh=ng+8nlro/RSCGzMCAD8bchblk/qRS2vLM2HSyJIgc14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fzWWqdWee8PVKA//MNysg/kPuz33jNTlgVBaLFh7Hkhc4BKEKdDx1qDRlQUrwRSufPR6pKQ9GFoRJydhr0RyT9/RHijPNwby6Y9gvgUnz1H9x8vQ24nYWd2qHR6WuGFWefSGSQQNBSEyrh/KIzif4y+ft1pT5hxGy+cksiWz6dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1EPq9ke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1EPq9ke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A047C4CECE;
	Wed,  2 Oct 2024 13:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875567;
	bh=ng+8nlro/RSCGzMCAD8bchblk/qRS2vLM2HSyJIgc14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1EPq9keBjJQNDdqqErm9LuMFA8U9p0nguJUCju3aR5U51/xwExJ6KloFvW8vU8GS
	 +4GPVGlfyD7/lhVoJl+rFHHCc3iMMLYt7U6ZwG9MEittZOCxuJsXHYjalKyyFjiePq
	 X+CSzY3mRDR2vwnKK7OX6Cb7IEvaptEV9s2RUTfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 145/695] arm64: tegra: Correct location of power-sensors for IGX Orin
Date: Wed,  2 Oct 2024 14:52:23 +0200
Message-ID: <20241002125828.272247439@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



