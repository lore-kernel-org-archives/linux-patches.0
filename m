Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F501549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:59:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F053C433D2;
	Mon,  8 May 2023 09:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539960;
	bh=SS6V6noRa9No7tWZ2QibBrRAurM7snNHzXuFDB9iWkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHPhAbztRNNdnARg1UUdkvW3oubv5LdLzMnasph7pg3U6i025tA5pHIgmVUMMfGrj
	 Vg8dPDvjtMOCAQPf1+sSq/bJMA8Z2htZbnuQeVa4BLWigqz+pU0U0v4yucauF0JcFB
	 u6JMvBCgpJvkKzO6qmiTfoR6QBTgxAEFGQyO+rMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Sven Peter <sven@svenpeter.dev>,
	Hector Martin <marcan@marcan.st>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/611] arm64: dts: apple: t8103: Disable unused PCIe ports
Date: Mon,  8 May 2023 11:40:35 +0200
Message-Id: <20230508094428.640971523@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Janne Grunau <j@jannau.net>

[ Upstream commit a0189fdfb73dac856b8fa9b9f9581e5099c9391f ]

The PCIe ports are unused (without devices) so disable them instead of
removing them.

Fixes: 7c77ab91b33d ("arm64: dts: apple: Add missing M1 (t8103) devices")
Signed-off-by: Janne Grunau <j@jannau.net>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t8103-j274.dts | 10 ++++++++++
 arch/arm64/boot/dts/apple/t8103-j293.dts | 15 ---------------
 arch/arm64/boot/dts/apple/t8103-j313.dts | 15 ---------------
 arch/arm64/boot/dts/apple/t8103-j456.dts | 10 ++++++++++
 arch/arm64/boot/dts/apple/t8103-j457.dts | 11 +++--------
 arch/arm64/boot/dts/apple/t8103.dtsi     |  4 ++++
 6 files changed, 27 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/boot/dts/apple/t8103-j274.dts b/arch/arm64/boot/dts/apple/t8103-j274.dts
index c1f3ba9c39f6a..997ef90614c11 100644
--- a/arch/arm64/boot/dts/apple/t8103-j274.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j274.dts
@@ -33,10 +33,12 @@
 
 &port01 {
 	bus-range = <2 2>;
+	status = "okay";
 };
 
 &port02 {
 	bus-range = <3 3>;
+	status = "okay";
 	ethernet0: ethernet@0,0 {
 		reg = <0x30000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
@@ -44,6 +46,14 @@
 	};
 };
 
+&pcie0_dart_1 {
+	status = "okay";
+};
+
+&pcie0_dart_2 {
+	status = "okay";
+};
+
 &i2c2 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/apple/t8103-j293.dts b/arch/arm64/boot/dts/apple/t8103-j293.dts
index ecb10d237a053..3fd444ac8ae4e 100644
--- a/arch/arm64/boot/dts/apple/t8103-j293.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j293.dts
@@ -21,21 +21,6 @@
 	brcm,board-type = "apple,honshu";
 };
 
-/*
- * Remove unused PCIe ports and disable the associated DARTs.
- */
-
-&pcie0_dart_1 {
-	status = "disabled";
-};
-
-&pcie0_dart_2 {
-	status = "disabled";
-};
-
-/delete-node/ &port01;
-/delete-node/ &port02;
-
 &i2c2 {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/apple/t8103-j313.dts b/arch/arm64/boot/dts/apple/t8103-j313.dts
index df741737b8e6f..9399c42de8a43 100644
--- a/arch/arm64/boot/dts/apple/t8103-j313.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j313.dts
@@ -20,18 +20,3 @@
 &wifi0 {
 	brcm,board-type = "apple,shikoku";
 };
-
-/*
- * Remove unused PCIe ports and disable the associated DARTs.
- */
-
-&pcie0_dart_1 {
-	status = "disabled";
-};
-
-&pcie0_dart_2 {
-	status = "disabled";
-};
-
-/delete-node/ &port01;
-/delete-node/ &port02;
diff --git a/arch/arm64/boot/dts/apple/t8103-j456.dts b/arch/arm64/boot/dts/apple/t8103-j456.dts
index 8c6bf95925107..d80223fa42292 100644
--- a/arch/arm64/boot/dts/apple/t8103-j456.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j456.dts
@@ -51,13 +51,23 @@
 
 &port01 {
 	bus-range = <2 2>;
+	status = "okay";
 };
 
 &port02 {
 	bus-range = <3 3>;
+	status = "okay";
 	ethernet0: ethernet@0,0 {
 		reg = <0x30000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
 		local-mac-address = [00 10 18 00 00 00];
 	};
 };
+
+&pcie0_dart_1 {
+	status = "okay";
+};
+
+&pcie0_dart_2 {
+	status = "okay";
+};
diff --git a/arch/arm64/boot/dts/apple/t8103-j457.dts b/arch/arm64/boot/dts/apple/t8103-j457.dts
index fe7c0aaf7d62a..e24ccb49e33cc 100644
--- a/arch/arm64/boot/dts/apple/t8103-j457.dts
+++ b/arch/arm64/boot/dts/apple/t8103-j457.dts
@@ -33,6 +33,7 @@
 
 &port02 {
 	bus-range = <3 3>;
+	status = "okay";
 	ethernet0: ethernet@0,0 {
 		reg = <0x30000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
@@ -40,12 +41,6 @@
 	};
 };
 
-/*
- * Remove unused PCIe port and disable the associated DART.
- */
-
-&pcie0_dart_1 {
-	status = "disabled";
+&pcie0_dart_2 {
+	status = "okay";
 };
-
-/delete-node/ &port01;
diff --git a/arch/arm64/boot/dts/apple/t8103.dtsi b/arch/arm64/boot/dts/apple/t8103.dtsi
index a4d195e9eb8c8..84fd1b1b48f6f 100644
--- a/arch/arm64/boot/dts/apple/t8103.dtsi
+++ b/arch/arm64/boot/dts/apple/t8103.dtsi
@@ -428,6 +428,7 @@
 			interrupt-parent = <&aic>;
 			interrupts = <AIC_IRQ 699 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&ps_apcie_gp>;
+			status = "disabled";
 		};
 
 		pcie0_dart_2: iommu@683008000 {
@@ -437,6 +438,7 @@
 			interrupt-parent = <&aic>;
 			interrupts = <AIC_IRQ 702 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&ps_apcie_gp>;
+			status = "disabled";
 		};
 
 		pcie0: pcie@690000000 {
@@ -511,6 +513,7 @@
 						<0 0 0 2 &port01 0 0 0 1>,
 						<0 0 0 3 &port01 0 0 0 2>,
 						<0 0 0 4 &port01 0 0 0 3>;
+				status = "disabled";
 			};
 
 			port02: pci@2,0 {
@@ -530,6 +533,7 @@
 						<0 0 0 2 &port02 0 0 0 1>,
 						<0 0 0 3 &port02 0 0 0 2>,
 						<0 0 0 4 &port02 0 0 0 3>;
+				status = "disabled";
 			};
 		};
 	};
-- 
2.39.2



