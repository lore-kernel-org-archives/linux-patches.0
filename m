Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DD91D5ABA;
	Wed, 25 Feb 2026 01:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983001; cv=none; b=KbrtIXFOgQvPFgnWfie8/tADaSNmFACb+Y7I5giaiDG4GdXvPdUoV07yTXkBgLy7DAzlZb0QwRLSmumIn4MdGDUAWFFdRsjAF9gYQTFSMwpiG8d1kyMei1vMGTyQkcPvMFAOKwVz8jjjq3XCJfvWTRolVduKFC11L6hpX94J4J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983001; c=relaxed/simple;
	bh=QjzQi7PA1hcgvU47Ull8WlqbkwKRaYjfg3ecUt2AkYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu7SlGwgMrKIkuZj+ydnceNEEmDOhb4NfTkH41mtKrdxTqjENgwgHOEw3oQU/otyPkfKVxC6DKn1Z2T55utshX04QC2Urdogx2L/ri96cea3p9hHcU78GkvzmphKqPEaDX3UwhbKsu/WPxdNMaZQIBZTp1iX7HRrdVU7AT8jX5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azAuwiRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azAuwiRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1941FC19423;
	Wed, 25 Feb 2026 01:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983001;
	bh=QjzQi7PA1hcgvU47Ull8WlqbkwKRaYjfg3ecUt2AkYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azAuwiRFPKE1hkNE8Fs/PjKqKCsTPeGCPrXthSxrKxrSDIHOaLEHVoJxSYqGejRg1
	 cI2/0d6wnOcGVj6ADFCEmfSvDGIwY6RNKiYJQQtK2NHkPR+cO2Xa4oQPR/OwCCejaR
	 AR9WjijzwvfNGmUyaBxMT4vueEovepaZ4EjLWhmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhash Kumar Jha <a-kumar2@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 172/781] arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog instances for j784s4
Date: Tue, 24 Feb 2026 17:14:41 -0800
Message-ID: <20260225012403.869008478@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



