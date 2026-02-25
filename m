Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9044F1D5ABA;
	Wed, 25 Feb 2026 01:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983877; cv=none; b=O1fH6eSIjr2VuFjs1aLAmYoO45XJ0SvzDJSXBgBzml5wFTPlJAhE2Yb4ZSEJuVDO4wkJ/yboZ20hq4rH1Pv/PoEP0Fo7W5eOSUacjbBY3sR5YgbNis/W+erawfZnTolNoW4sxlxg56tRSeduNXXH7rNWNWcZUYkokKuNiqrbR34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983877; c=relaxed/simple;
	bh=ElyytJ2/Dl0KThRE1X8YuSHOAKDiIZcxuQwa1TLpH7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4GmAaqu5vRcs1zOf6fkg+uQ5t3GeQB38igZaYTZ9uzdI8OjwU3fP3r2TuLhow4UFSWrA9GTOlmUWobayLwGdJFivR2czn9G1ORgJR/bkN879Z57wAIxQuCPvpQeckxAvkNbm8qk4dl1EyChVnXKYMxMOpw030IOivLhiLhcmzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COWhl0Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COWhl0Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0442DC116D0;
	Wed, 25 Feb 2026 01:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983877;
	bh=ElyytJ2/Dl0KThRE1X8YuSHOAKDiIZcxuQwa1TLpH7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COWhl0XjV4O+m9hydDyyFc7Y5x900ILjcFavI5DehX3V02wyPD+hAmSDPNJHZ0zvj
	 ffxXQnud2EPCXB0FNxjA0C2rHdHKnyIdSzz7pmnWkPo+bjJYM5bOnBU/D2S3DHBOyq
	 Rq72l4++jY6kXJtPGXYsW/Fqd++S6soRBjC8ex+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhash Kumar Jha <a-kumar2@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 152/641] arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog instances for j784s4
Date: Tue, 24 Feb 2026 17:17:58 -0800
Message-ID: <20260225012352.774735249@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhash Kumar Jha <a-kumar2@ti.com>

[ Upstream commit 61acc4428a7f52e0a13e226ba76f2ce2ca66c065 ]

Each A72 core has one watchdog instance associated with it. Since j742s2
has 4 A72 cores, the common file should not define 8 watchdog instances.

Refactor the last 4 extra watchdogs from the common file to j784s4
specific file, as j784s4 has 8 A72 cores and thus hardware description
requires 8 watchdog instances.

Fixes: 9cc161a4509c ("arm64: dts: ti: Refactor J784s4 SoC files to a common file")
Signed-off-by: Abhash Kumar Jha <a-kumar2@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20260112085113.3476193-3-a-kumar2@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/ti/k3-j784s4-j742s2-main-common.dtsi  | 36 -------------------
 arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi    | 36 +++++++++++++++++++
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
index 9cc0901d58fbf..c2636e624f18b 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
@@ -2378,42 +2378,6 @@ watchdog3: watchdog@2230000 {
 		assigned-clock-parents = <&k3_clks 351 4>;
 	};
 
-	watchdog4: watchdog@2240000 {
-		compatible = "ti,j7-rti-wdt";
-		reg = <0x00 0x2240000 0x00 0x100>;
-		clocks = <&k3_clks 352 0>;
-		power-domains = <&k3_pds 352 TI_SCI_PD_EXCLUSIVE>;
-		assigned-clocks = <&k3_clks 352 0>;
-		assigned-clock-parents = <&k3_clks 352 4>;
-	};
-
-	watchdog5: watchdog@2250000 {
-		compatible = "ti,j7-rti-wdt";
-		reg = <0x00 0x2250000 0x00 0x100>;
-		clocks = <&k3_clks 353 0>;
-		power-domains = <&k3_pds 353 TI_SCI_PD_EXCLUSIVE>;
-		assigned-clocks = <&k3_clks 353 0>;
-		assigned-clock-parents = <&k3_clks 353 4>;
-	};
-
-	watchdog6: watchdog@2260000 {
-		compatible = "ti,j7-rti-wdt";
-		reg = <0x00 0x2260000 0x00 0x100>;
-		clocks = <&k3_clks 354 0>;
-		power-domains = <&k3_pds 354 TI_SCI_PD_EXCLUSIVE>;
-		assigned-clocks = <&k3_clks 354 0>;
-		assigned-clock-parents = <&k3_clks 354 4>;
-	};
-
-	watchdog7: watchdog@2270000 {
-		compatible = "ti,j7-rti-wdt";
-		reg = <0x00 0x2270000 0x00 0x100>;
-		clocks = <&k3_clks 355 0>;
-		power-domains = <&k3_pds 355 TI_SCI_PD_EXCLUSIVE>;
-		assigned-clocks = <&k3_clks 355 0>;
-		assigned-clock-parents = <&k3_clks 355 4>;
-	};
-
 	/*
 	 * The following RTI instances are coupled with MCU R5Fs, c7x and
 	 * GPU so keeping them reserved as these will be used by their
diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
index 5b7830a3c0975..78fcd0c40abcf 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-main.dtsi
@@ -6,6 +6,42 @@
  */
 
 &cbass_main {
+	watchdog4: watchdog@2240000 {
+		compatible = "ti,j7-rti-wdt";
+		reg = <0x00 0x2240000 0x00 0x100>;
+		clocks = <&k3_clks 352 0>;
+		power-domains = <&k3_pds 352 TI_SCI_PD_EXCLUSIVE>;
+		assigned-clocks = <&k3_clks 352 0>;
+		assigned-clock-parents = <&k3_clks 352 4>;
+	};
+
+	watchdog5: watchdog@2250000 {
+		compatible = "ti,j7-rti-wdt";
+		reg = <0x00 0x2250000 0x00 0x100>;
+		clocks = <&k3_clks 353 0>;
+		power-domains = <&k3_pds 353 TI_SCI_PD_EXCLUSIVE>;
+		assigned-clocks = <&k3_clks 353 0>;
+		assigned-clock-parents = <&k3_clks 353 4>;
+	};
+
+	watchdog6: watchdog@2260000 {
+		compatible = "ti,j7-rti-wdt";
+		reg = <0x00 0x2260000 0x00 0x100>;
+		clocks = <&k3_clks 354 0>;
+		power-domains = <&k3_pds 354 TI_SCI_PD_EXCLUSIVE>;
+		assigned-clocks = <&k3_clks 354 0>;
+		assigned-clock-parents = <&k3_clks 354 4>;
+	};
+
+	watchdog7: watchdog@2270000 {
+		compatible = "ti,j7-rti-wdt";
+		reg = <0x00 0x2270000 0x00 0x100>;
+		clocks = <&k3_clks 355 0>;
+		power-domains = <&k3_pds 355 TI_SCI_PD_EXCLUSIVE>;
+		assigned-clocks = <&k3_clks 355 0>;
+		assigned-clock-parents = <&k3_clks 355 4>;
+	};
+
 	pcie2_rc: pcie@2920000 {
 		compatible = "ti,j784s4-pcie-host";
 		reg = <0x00 0x02920000 0x00 0x1000>,
-- 
2.51.0



