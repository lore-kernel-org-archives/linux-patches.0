Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C349C35FF77;
	Wed, 21 Jan 2026 18:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020403; cv=none; b=lskvzElJ6Q4anyUNPJr+qJtrhIDGkMcxMCHXEyqEHckg7TvefVAFv3Fjm9Snp3uREVgnIrBFGcVwUHydRg5X0tgVLVBRem8+jMAyKcGkW5/wqGVdcZ6roOlSBW8BfVw91eLEdp4yqDlPDfq+7NcgEhphm15y7k0YecEaLrfPBBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020403; c=relaxed/simple;
	bh=XTM4uL9WJvmmWsCK5h+pap8g9c6o6nUodo9wkMVIA9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWpw1IUWOjlLN1YRIhHtxqntmnKO5ESK8+X39BzcR3Cs37nNRzUkiLmrrxr1xx8GYixOcnRhVgvFr1WZyKGUp0T5Q1JJOFLwTOCaACBtrvPLxOnhElO9DsTAL2bzP0c1vObufIgEsfZtSO+69nBhpy041zUXCfinDSJm0d9K/sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjJlxAgl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjJlxAgl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4484DC4CEF1;
	Wed, 21 Jan 2026 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020403;
	bh=XTM4uL9WJvmmWsCK5h+pap8g9c6o6nUodo9wkMVIA9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjJlxAglBYHaAbk9fa3kLNjG8syQXxyW4TAaYaAGYRkmBhAuNO9g0klqejWocaFhe
	 B95OYPqCEG/4WGbSPvUVmiscPWaG88OYtCBftvnJgrUbhsQ+Kr/v0P91l7c39A14qs
	 MydGfKuZs6B2dgK4G1cptW4KjB0NrakTstKX9BFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <me@ziyao.cc>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 148/198] LoongArch: dts: Describe PCI sideband IRQ through interrupt-extended
Date: Wed, 21 Jan 2026 19:16:16 +0100
Message-ID: <20260121181423.885244512@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Yao Zi <me@ziyao.cc>

commit 762cf75bec2ad9d17899087899a34336b1757238 upstream.

SoC integrated peripherals on LS2K1000 and LS2K2000 could be discovered
as PCI devices, but require sideband interrupts to function, which are
previously described by interrupts and interrupt-parent properties.

However, pci/pci-device.yaml allows interrupts property to only specify
PCI INTx interrupts, not sideband ones. Convert these devices to use
interrupt-extended property, which describes sideband interrupts used by
PCI devices since dt-schema commit e6ea659d2baa ("schemas: pci-device:
Allow interrupts-extended for sideband interrupts"), eliminating
dtbs_check warnings.

Cc: stable@vger.kernel.org
Fixes: 30a5532a3206 ("LoongArch: dts: DeviceTree for Loongson-2K1000")
Signed-off-by: Yao Zi <me@ziyao.cc>
Signed-off-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/boot/dts/loongson-2k1000.dtsi |   25 +++++++--------------
 arch/loongarch/boot/dts/loongson-2k2000.dtsi |   32 ++++++++++-----------------
 2 files changed, 21 insertions(+), 36 deletions(-)

--- a/arch/loongarch/boot/dts/loongson-2k1000.dtsi
+++ b/arch/loongarch/boot/dts/loongson-2k1000.dtsi
@@ -437,54 +437,47 @@
 
 			gmac0: ethernet@3,0 {
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
-				interrupt-parent = <&liointc0>;
-				interrupts = <12 IRQ_TYPE_LEVEL_HIGH>,
-					     <13 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&liointc0 12 IRQ_TYPE_LEVEL_HIGH>,
+						      <&liointc0 13 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
 				status = "disabled";
 			};
 
 			gmac1: ethernet@3,1 {
 				reg = <0x1900 0x0 0x0 0x0 0x0>;
-				interrupt-parent = <&liointc0>;
-				interrupts = <14 IRQ_TYPE_LEVEL_HIGH>,
-					     <15 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&liointc0 14 IRQ_TYPE_LEVEL_HIGH>,
+						      <&liointc0 15 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
 				status = "disabled";
 			};
 
 			ehci0: usb@4,1 {
 				reg = <0x2100 0x0 0x0 0x0 0x0>;
-				interrupt-parent = <&liointc1>;
-				interrupts = <18 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&liointc1 18 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			ohci0: usb@4,2 {
 				reg = <0x2200 0x0 0x0 0x0 0x0>;
-				interrupt-parent = <&liointc1>;
-				interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&liointc1 19 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			display@6,0 {
 				reg = <0x3000 0x0 0x0 0x0 0x0>;
-				interrupt-parent = <&liointc0>;
-				interrupts = <28 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&liointc0 28 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			hda@7,0 {
 				reg = <0x3800 0x0 0x0 0x0 0x0>;
-				interrupt-parent = <&liointc0>;
-				interrupts = <4 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&liointc0 4 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			sata: sata@8,0 {
 				reg = <0x4000 0x0 0x0 0x0 0x0>;
-				interrupt-parent = <&liointc0>;
-				interrupts = <19 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&liointc0 19 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
--- a/arch/loongarch/boot/dts/loongson-2k2000.dtsi
+++ b/arch/loongarch/boot/dts/loongson-2k2000.dtsi
@@ -291,65 +291,57 @@
 
 			gmac0: ethernet@3,0 {
 				reg = <0x1800 0x0 0x0 0x0 0x0>;
-				interrupts = <12 IRQ_TYPE_LEVEL_HIGH>,
-					     <13 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&pic 12 IRQ_TYPE_LEVEL_HIGH>,
+						      <&pic 13 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
-				interrupt-parent = <&pic>;
 				status = "disabled";
 			};
 
 			gmac1: ethernet@3,1 {
 				reg = <0x1900 0x0 0x0 0x0 0x0>;
-				interrupts = <14 IRQ_TYPE_LEVEL_HIGH>,
-					     <15 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&pic 14 IRQ_TYPE_LEVEL_HIGH>,
+						      <&pic 15 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
-				interrupt-parent = <&pic>;
 				status = "disabled";
 			};
 
 			gmac2: ethernet@3,2 {
 				reg = <0x1a00 0x0 0x0 0x0 0x0>;
-				interrupts = <17 IRQ_TYPE_LEVEL_HIGH>,
-					     <18 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&pic 17 IRQ_TYPE_LEVEL_HIGH>,
+						      <&pic 18 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "macirq", "eth_lpi";
-				interrupt-parent = <&pic>;
 				status = "disabled";
 			};
 
 			xhci0: usb@4,0 {
 				reg = <0x2000 0x0 0x0 0x0 0x0>;
-				interrupts = <48 IRQ_TYPE_LEVEL_HIGH>;
-				interrupt-parent = <&pic>;
+				interrupts-extended = <&pic 48 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			xhci1: usb@19,0 {
 				reg = <0xc800 0x0 0x0 0x0 0x0>;
-				interrupts = <22 IRQ_TYPE_LEVEL_HIGH>;
-				interrupt-parent = <&pic>;
+				interrupts-extended = <&pic 22 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			display@6,1 {
 				reg = <0x3100 0x0 0x0 0x0 0x0>;
-				interrupts = <28 IRQ_TYPE_LEVEL_HIGH>;
-				interrupt-parent = <&pic>;
+				interrupts-extended = <&pic 28 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 
 			i2s@7,0 {
 				reg = <0x3800 0x0 0x0 0x0 0x0>;
-				interrupts = <78 IRQ_TYPE_LEVEL_HIGH>,
-					     <79 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts-extended = <&pic 78 IRQ_TYPE_LEVEL_HIGH>,
+						      <&pic 79 IRQ_TYPE_LEVEL_HIGH>;
 				interrupt-names = "tx", "rx";
-				interrupt-parent = <&pic>;
 				status = "disabled";
 			};
 
 			sata: sata@8,0 {
 				reg = <0x4000 0x0 0x0 0x0 0x0>;
-				interrupts = <16 IRQ_TYPE_LEVEL_HIGH>;
-				interrupt-parent = <&pic>;
+				interrupts-extended = <&pic 16 IRQ_TYPE_LEVEL_HIGH>;
 				status = "disabled";
 			};
 


