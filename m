Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B30C1E89C;
	Wed,  5 Feb 2025 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767579; cv=none; b=GVshpK//IvcsPfDgNaxOj64QdMAkf+yNq1Je/XINndyhAAhMmyBTkiQPF9tnUdGvE96eSxK8iJxjoN5hVias5HJzWLj9fhSxuRj+K1oSgN/waMvv+4UIZP7nDYH+J/45pKbSrH4a4ladxkKrypaTiL6QODyxmh+25yUIynnkt0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767579; c=relaxed/simple;
	bh=CWlmG8xx784GCOI2QBgdRqGt0bmS13rHgRfyNnC8NsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG9RPXVOPFH3qtanHmiMzuubbPuv+sfErUgUi1h5DjfQGCg90wKWiT5gMWCqa90z5MozyqKDrm+kMO/gj4bLAlugzznGuGF7F5xsMYXbmbQkqrqeoLeHF2zhqq0mssYtGUeHk5S7bprgfSRMVUfoJPgsvAp31IHvlG1F+wI2NlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1O7O6Vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1O7O6Vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DF1C4CEDD;
	Wed,  5 Feb 2025 14:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767578;
	bh=CWlmG8xx784GCOI2QBgdRqGt0bmS13rHgRfyNnC8NsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1O7O6Vjq9njRhkPzLFbgLavp6JBomlci8biDCrTxQ9qcUaUThk5g19DPcS+y5mOs
	 3PXVj6Rw4zGFUP+DVw9+RF0Es+uAO8x0nYh0duOZB6kNIlUEAG0LeWledRjEE1Iort
	 5uybZuWuVnhXAKnUHvDzAZiIH51Jw4C/JCabFWw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Josua Mayer <josua@solid-run.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 424/623] arm64: dts: ti: k3-am642-hummingboard-t: Convert overlay to board dts
Date: Wed,  5 Feb 2025 14:42:46 +0100
Message-ID: <20250205134512.445954709@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit e2b69180431968250bf3c0c581155f1b37d057c1 ]

SolidRun HummingBoard-T has two options for M.2 connector, supporting
either PCI-E or USB-3.1 Gen 1 - depending on configuration of a mux
on the serdes lane.
The required configurations in device-tree were modeled as overlays.

The USB-3.1 overlay uses /delete-property/ to unset a boolean property
on the usb controller limiting it to USB-2.0 by default.
Overlays can not delete a property from the base dtb, therefore this
overlay is at this time useless.

Convert both overlays into full dts by including the base board dts.
While the pcie overlay was functional, both are converted for a
consistent user experience when selecting between the two mutually
exclusive configurations.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/linux-devicetree/CAMuHMdXTgpTnJ9U7egC2XjFXXNZ5uiY1O+WxNd6LPJW5Rs5KTw@mail.gmail.com
Fixes: bbef42084cc1 ("arm64: dts: ti: hummingboard-t: add overlays for m.2 pci-e and usb-3")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Link: https://lore.kernel.org/r/20250101-am64-hb-fix-overlay-v2-1-78143f5da28c@solid-run.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/Makefile                    |  4 ----
 ...-pcie.dtso => k3-am642-hummingboard-t-pcie.dts} | 14 ++++++++------
 ...-usb3.dtso => k3-am642-hummingboard-t-usb3.dts} | 13 ++++++++-----
 3 files changed, 16 insertions(+), 15 deletions(-)
 rename arch/arm64/boot/dts/ti/{k3-am642-hummingboard-t-pcie.dtso => k3-am642-hummingboard-t-pcie.dts} (78%)
 rename arch/arm64/boot/dts/ti/{k3-am642-hummingboard-t-usb3.dtso => k3-am642-hummingboard-t-usb3.dts} (74%)

diff --git a/arch/arm64/boot/dts/ti/Makefile b/arch/arm64/boot/dts/ti/Makefile
index 379bfa4425d49..2b3b48a9a8842 100644
--- a/arch/arm64/boot/dts/ti/Makefile
+++ b/arch/arm64/boot/dts/ti/Makefile
@@ -42,10 +42,6 @@ dtb-$(CONFIG_ARCH_K3) += k3-am62x-sk-csi2-imx219.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am62x-sk-hdmi-audio.dtbo
 
 # Boards with AM64x SoC
-k3-am642-hummingboard-t-pcie-dtbs := \
-	k3-am642-hummingboard-t.dtb k3-am642-hummingboard-t-pcie.dtbo
-k3-am642-hummingboard-t-usb3-dtbs := \
-	k3-am642-hummingboard-t.dtb k3-am642-hummingboard-t-usb3.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am642-evm.dtb
 dtb-$(CONFIG_ARCH_K3) += k3-am642-evm-icssg1-dualemac.dtbo
 dtb-$(CONFIG_ARCH_K3) += k3-am642-evm-icssg1-dualemac-mii.dtbo
diff --git a/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-pcie.dtso b/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-pcie.dts
similarity index 78%
rename from arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-pcie.dtso
rename to arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-pcie.dts
index bd9a5caf20da5..023b2a6aaa566 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-pcie.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-pcie.dts
@@ -2,17 +2,19 @@
 /*
  * Copyright (C) 2023 Josua Mayer <josua@solid-run.com>
  *
- * Overlay for SolidRun AM642 HummingBoard-T to enable PCI-E.
+ * DTS for SolidRun AM642 HummingBoard-T,
+ * running on Cortex A53, with PCI-E.
+ *
  */
 
-/dts-v1/;
-/plugin/;
-
-#include <dt-bindings/gpio/gpio.h>
-#include <dt-bindings/phy/phy.h>
+#include "k3-am642-hummingboard-t.dts"
 
 #include "k3-serdes.h"
 
+/ {
+	model = "SolidRun AM642 HummingBoard-T with PCI-E";
+};
+
 &pcie0_rc {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pcie0_default_pins>;
diff --git a/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-usb3.dtso b/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-usb3.dts
similarity index 74%
rename from arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-usb3.dtso
rename to arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-usb3.dts
index ffcc3bd3c7bc5..ee9bd618f3701 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-usb3.dtso
+++ b/arch/arm64/boot/dts/ti/k3-am642-hummingboard-t-usb3.dts
@@ -2,16 +2,19 @@
 /*
  * Copyright (C) 2023 Josua Mayer <josua@solid-run.com>
  *
- * Overlay for SolidRun AM642 HummingBoard-T to enable USB-3.1.
+ * DTS for SolidRun AM642 HummingBoard-T,
+ * running on Cortex A53, with USB-3.1 Gen 1.
+ *
  */
 
-/dts-v1/;
-/plugin/;
-
-#include <dt-bindings/phy/phy.h>
+#include "k3-am642-hummingboard-t.dts"
 
 #include "k3-serdes.h"
 
+/ {
+	model = "SolidRun AM642 HummingBoard-T with USB-3.1 Gen 1";
+};
+
 &serdes0 {
 	#address-cells = <1>;
 	#size-cells = <0>;
-- 
2.39.5



