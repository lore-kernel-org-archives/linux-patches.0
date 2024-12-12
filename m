Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD97223C7B;
	Thu, 12 Dec 2024 17:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024843; cv=none; b=iJyExCklD5DdlKwkyYPZuQw/phEonqtQONMnXpBNlyQQamblgPDvF+fLmuyMwQjUELk9K9HPu4eaH0BzxKu+Xe19eIibpIvH/hI/tv3FcTuRtXLmVaMgNXhEDCiShBrvwkLt3WO1MgBC7vhtrEWeb5HIkFKVUWbsAxU9/zLkyA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024843; c=relaxed/simple;
	bh=9LoRq7CiV5lOQLdhiVcHqGmEHuqrDsGQTx9CjmQPfS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uV6KQ9DgutCjEcXAAodrZvTFK2exNUQGt0pnEBjaSrXd1zdm5E9aUkyvwIE7vK+Tg9ftutly6h6vGPeo7xlyTSKF6uzrtiJ37IjuCs1Y8PbpZSaBKRbBgiiN+x8nHxHVx6lTusa74OsW9Exo50dvrYtmaRKKAqErrgkRsWCkeZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlQQHqMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlQQHqMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5309C4CED0;
	Thu, 12 Dec 2024 17:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024843;
	bh=9LoRq7CiV5lOQLdhiVcHqGmEHuqrDsGQTx9CjmQPfS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlQQHqMl+5PRRsZreWS8rDNC83M64NrOy3uCuPE9CRFIZKWS6m/0DdO4SwRkAcgDQ
	 F8MGG3db1Ry2Ns8UMpG7zJ8ZM0EZqLym7jnJ7ouLb8KyRDuqSbxFdnbstC4Q1dhNaT
	 HwLm6Nbr8i9LQyPVv/X5t+Bq1jk6bnO6O1miKTZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xi Ruoyao <xry111@xry111.site>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 430/459] MIPS: Loongson64: DTS: Really fix PCIe port nodes for ls7a
Date: Thu, 12 Dec 2024 16:02:48 +0100
Message-ID: <20241212144310.747029330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xi Ruoyao <xry111@xry111.site>

[ Upstream commit 4fbd66d8254cedfd1218393f39d83b6c07a01917 ]

Fix the dtc warnings:

    arch/mips/boot/dts/loongson/ls7a-pch.dtsi:68.16-416.5: Warning (interrupt_provider): /bus@10000000/pci@1a000000: '#interrupt-cells' found, but node is not an interrupt provider
    arch/mips/boot/dts/loongson/ls7a-pch.dtsi:68.16-416.5: Warning (interrupt_provider): /bus@10000000/pci@1a000000: '#interrupt-cells' found, but node is not an interrupt provider
    arch/mips/boot/dts/loongson/loongson64g_4core_ls7a.dtb: Warning (interrupt_map): Failed prerequisite 'interrupt_provider'

And a runtime warning introduced in commit 045b14ca5c36 ("of: WARN on
deprecated #address-cells/#size-cells handling"):

    WARNING: CPU: 0 PID: 1 at drivers/of/base.c:106 of_bus_n_addr_cells+0x9c/0xe0
    Missing '#address-cells' in /bus@10000000/pci@1a000000/pci_bridge@9,0

The fix is similar to commit d89a415ff8d5 ("MIPS: Loongson64: DTS: Fix PCIe
port nodes for ls7a"), which has fixed the issue for ls2k (despite its
subject mentions ls7a).

Signed-off-by: Xi Ruoyao <xry111@xry111.site>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/loongson/ls7a-pch.dtsi | 73 +++++++++++++++++++----
 1 file changed, 60 insertions(+), 13 deletions(-)

diff --git a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
index f99a7a11fded8..cdb1c40b4fd14 100644
--- a/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
+++ b/arch/mips/boot/dts/loongson/ls7a-pch.dtsi
@@ -63,7 +63,6 @@ pci@1a000000 {
 			device_type = "pci";
 			#address-cells = <3>;
 			#size-cells = <2>;
-			#interrupt-cells = <2>;
 			msi-parent = <&msi>;
 
 			reg = <0 0x1a000000 0 0x02000000>,
@@ -226,7 +225,7 @@ phy1: ethernet-phy@1 {
 				};
 			};
 
-			pci_bridge@9,0 {
+			pcie@9,0 {
 				compatible = "pci0014,7a19.1",
 						   "pci0014,7a19",
 						   "pciclass060400",
@@ -236,12 +235,16 @@ pci_bridge@9,0 {
 				interrupts = <32 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 32 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@a,0 {
+			pcie@a,0 {
 				compatible = "pci0014,7a09.1",
 						   "pci0014,7a09",
 						   "pciclass060400",
@@ -251,12 +254,16 @@ pci_bridge@a,0 {
 				interrupts = <33 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 33 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@b,0 {
+			pcie@b,0 {
 				compatible = "pci0014,7a09.1",
 						   "pci0014,7a09",
 						   "pciclass060400",
@@ -266,12 +273,16 @@ pci_bridge@b,0 {
 				interrupts = <34 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 34 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@c,0 {
+			pcie@c,0 {
 				compatible = "pci0014,7a09.1",
 						   "pci0014,7a09",
 						   "pciclass060400",
@@ -281,12 +292,16 @@ pci_bridge@c,0 {
 				interrupts = <35 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 35 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@d,0 {
+			pcie@d,0 {
 				compatible = "pci0014,7a19.1",
 						   "pci0014,7a19",
 						   "pciclass060400",
@@ -296,12 +311,16 @@ pci_bridge@d,0 {
 				interrupts = <36 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 36 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@e,0 {
+			pcie@e,0 {
 				compatible = "pci0014,7a09.1",
 						   "pci0014,7a09",
 						   "pciclass060400",
@@ -311,12 +330,16 @@ pci_bridge@e,0 {
 				interrupts = <37 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 37 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@f,0 {
+			pcie@f,0 {
 				compatible = "pci0014,7a29.1",
 						   "pci0014,7a29",
 						   "pciclass060400",
@@ -326,12 +349,16 @@ pci_bridge@f,0 {
 				interrupts = <40 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 40 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@10,0 {
+			pcie@10,0 {
 				compatible = "pci0014,7a19.1",
 						   "pci0014,7a19",
 						   "pciclass060400",
@@ -341,12 +368,16 @@ pci_bridge@10,0 {
 				interrupts = <41 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 41 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@11,0 {
+			pcie@11,0 {
 				compatible = "pci0014,7a29.1",
 						   "pci0014,7a29",
 						   "pciclass060400",
@@ -356,12 +387,16 @@ pci_bridge@11,0 {
 				interrupts = <42 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 42 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@12,0 {
+			pcie@12,0 {
 				compatible = "pci0014,7a19.1",
 						   "pci0014,7a19",
 						   "pciclass060400",
@@ -371,12 +406,16 @@ pci_bridge@12,0 {
 				interrupts = <43 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 43 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@13,0 {
+			pcie@13,0 {
 				compatible = "pci0014,7a29.1",
 						   "pci0014,7a29",
 						   "pciclass060400",
@@ -386,12 +425,16 @@ pci_bridge@13,0 {
 				interrupts = <38 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 38 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 
-			pci_bridge@14,0 {
+			pcie@14,0 {
 				compatible = "pci0014,7a19.1",
 						   "pci0014,7a19",
 						   "pciclass060400",
@@ -401,9 +444,13 @@ pci_bridge@14,0 {
 				interrupts = <39 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-parent = <&pic>;
 
+				#address-cells = <3>;
+				#size-cells = <2>;
+				device_type = "pci";
 				#interrupt-cells = <1>;
 				interrupt-map-mask = <0 0 0 0>;
 				interrupt-map = <0 0 0 0 &pic 39 IRQ_TYPE_LEVEL_HIGH>;
+				ranges;
 			};
 		};
 
-- 
2.43.0



