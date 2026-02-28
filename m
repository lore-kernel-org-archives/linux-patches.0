Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABEB379EDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301719; cv=none; b=Y8bd/GSK5S7cIxsovOvY5tlp7d5HBhJ7vU3lDukiaNKzgX6w1GdYCsxoMSBJXOpg/Q/beyLgnmeEre7MgAXLWZG0FAEtBSpoF5eS6OLyl0clZwCGjwm5u8hjXB+2JmtgTPkgrIJy3CLDBen4QCAs65iPBYk7YOIS4ung1JRYhHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301719; c=relaxed/simple;
	bh=SIURdBQ9f5S43XpkxdL4BHU/M1ZT+jikS8rtwQmml2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAXAGN8xv4/UNHzikq+4SSBZN6rYv7SL8Cip4VUkcYji1ImiKRvI3gR5r+StJNHaWYb9knFmZhtveMab/eaqkhrRw5YJ0caaj4dAXfVwK4kwXzUSQuTYtt2s0KnQlusLMeZz+j/XjrK2bvx+X7k5kQ8cu13/Ty9lndXDZXoMJB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxcPWr9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxcPWr9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4686AC19423;
	Sat, 28 Feb 2026 18:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301718;
	bh=SIURdBQ9f5S43XpkxdL4BHU/M1ZT+jikS8rtwQmml2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxcPWr9x0Gm52Pl9aiCaBjXyvyFng9EOQj0dfE3TQ2t/XFjoMCGhaUPdtzDmCwc1V
	 fDXRIHqwbTRqSJD9m+OPgRoZHIRhO+TrNcw8y2AeBFjXChjO/DX6/jpdr2UDvqcw+j
	 CVxsvDF0NDk2XMbnBb56dYk674m1DQGAiCMTweFOPyIQvYw90weQ9jMWbJS86AKsPI
	 93AQsNjhyCPYz4xl5AZi0eP3H6cbtq+Ig62W4hPoME9bxuN2waOJzMhng5dpqVaucZ
	 JlQ1lnYZO9YDu5MA2Yz56yjMhe+1KKoeuAB78/pR1niN7JK6Dvf1kGcJz9E8sfs9LQ
	 PckhUcbD4Xkzg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abhash Kumar Jha <a-kumar2@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/385] arm64: dts: ti: k3-j784s4-j742s2-main-common.dtsi: Refactor watchdog instances for j784s4
Date: Sat, 28 Feb 2026 12:55:37 -0500
Message-ID: <20260228180011.1568201-115-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 013c0d25d3481..079ccefeabe91 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
@@ -2350,42 +2350,6 @@ watchdog3: watchdog@2230000 {
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

