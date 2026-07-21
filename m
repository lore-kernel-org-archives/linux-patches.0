Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDBE46AA9D;
	Tue, 21 Jul 2026 15:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648401; cv=none; b=NEYxvKFrnFrM3JFfYiCOsd9XrTASRuQN77PPPqr5Gm868SbwDmGuqZsQFtESBA1qogC+GeLIfLX8+SAF20T3PRaSC5NTfoznWwfADwocAHjX7XNaYDxk9uGswjOCRDNAIzsfVkaSL1A1X/ToEUsFIQvdi/0avs3s1+HhYht+zIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648401; c=relaxed/simple;
	bh=78In+HEJn2qDd8i0cqgoCcLZv1VD69sSN0i0G1uEGJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOeVEBgT+mb10muors2+/9osiLktk51pAFZFQUA9mETfUU0kmUQffGi/q9eIA4XNxuiobKbgx4hpAKsRJASnpGdIHazJavna63/NT5iJO1zaw4HYHCu/sH8VKhsF81PI1hNKyj3mXAPUgvwOICXK7wTaEn7Lqok1YtBwHh4qHXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFt64HNG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFt64HNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9F71F000E9;
	Tue, 21 Jul 2026 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648399;
	bh=RaBYH14B6IcXaw5UM+YhXJ5/yMKasUio79ZC9KCJn0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFt64HNGFeBOyyivdHuPOYbFZWe/6AvkaJIk2uMFEv1VehwwzYXL0n1tFax2BLBko
	 XmpMvsRFARlrM0xphOOse6IBnWJuCkMTvp/oQ5ZJ67RpRZng64Wm9vi1/mwZWaeS7k
	 POT4pcov9A57Sx4jmlbKQuW2oQ4u+u+tTK+AS+fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0186/2077] arm64: dts: mediatek: mt7988a-bpi-r4pro: rework pcie gpio-hog handling
Date: Tue, 21 Jul 2026 16:57:39 +0200
Message-ID: <20260721152557.071016117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit e309fa232d12b969afac43a4b7d83dee025cfe63 ]

The active-high property in base-dt cannot be overwritten and must be
set in separate overlay.

Fixes: f397471a6a8c ("arm64: dts: mediatek: mt7988: Add devicetree for BananaPi R4 Pro")
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/Makefile         |  8 ++++++++
 .../mt7988a-bananapi-bpi-r4-pro-cn13.dtso     | 20 +++++++++++++++++++
 .../mt7988a-bananapi-bpi-r4-pro-cn14.dtso     | 20 +++++++++++++++++++
 .../mediatek/mt7988a-bananapi-bpi-r4-pro.dtsi |  2 --
 4 files changed, 48 insertions(+), 2 deletions(-)
 create mode 100644 arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso
 create mode 100644 arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso

diff --git a/arch/arm64/boot/dts/mediatek/Makefile b/arch/arm64/boot/dts/mediatek/Makefile
index 387faa9c2a09b5..a86fb313b1a9db 100644
--- a/arch/arm64/boot/dts/mediatek/Makefile
+++ b/arch/arm64/boot/dts/mediatek/Makefile
@@ -47,6 +47,8 @@ dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-2g5.dtb
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-emmc.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-4e.dtb
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-8x.dtb
+dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-cn13.dtbo
+dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-cn14.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-cn15.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-cn18.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-emmc.dtbo
@@ -70,18 +72,24 @@ mt7988a-bananapi-bpi-r4-2g5-sd-dtbs := \
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-2g5-sd.dtb
 mt7988a-bananapi-bpi-r4-pro-8x-emmc-dtbs := \
 	mt7988a-bananapi-bpi-r4-pro-8x.dtb \
+	mt7988a-bananapi-bpi-r4-pro-cn13.dtbo \
+	mt7988a-bananapi-bpi-r4-pro-cn14.dtbo \
 	mt7988a-bananapi-bpi-r4-pro-emmc.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-8x-emmc.dtb
 mt7988a-bananapi-bpi-r4-pro-8x-sd-dtbs := \
 	mt7988a-bananapi-bpi-r4-pro-8x.dtb \
+	mt7988a-bananapi-bpi-r4-pro-cn13.dtbo \
+	mt7988a-bananapi-bpi-r4-pro-cn14.dtbo \
 	mt7988a-bananapi-bpi-r4-pro-sd.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-8x-sd.dtb
 mt7988a-bananapi-bpi-r4-pro-8x-sd-cn15-dtbs := \
 	mt7988a-bananapi-bpi-r4-pro-8x-sd.dtb \
+	mt7988a-bananapi-bpi-r4-pro-cn14.dtbo \
 	mt7988a-bananapi-bpi-r4-pro-cn15.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-8x-sd-cn15.dtb
 mt7988a-bananapi-bpi-r4-pro-8x-sd-cn18-dtbs := \
 	mt7988a-bananapi-bpi-r4-pro-8x-sd.dtb \
+	mt7988a-bananapi-bpi-r4-pro-cn13.dtbo \
 	mt7988a-bananapi-bpi-r4-pro-cn18.dtbo
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt7988a-bananapi-bpi-r4-pro-8x-sd-cn18.dtb
 dtb-$(CONFIG_ARCH_MEDIATEK) += mt8167-pumpkin.dtb
diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso
new file mode 100644
index 00000000000000..973b76ba0cbfba
--- /dev/null
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn13.dtso
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright (C) 2025 MediaTek Inc.
+ * Author: Frank Wunderlich <frank-w@public-files.de>
+ */
+
+/* This enables key-m slot CN13 on pcie2(11280000 1L0) on BPI-R4-Pro */
+
+/dts-v1/;
+/plugin/;
+
+#include <dt-bindings/gpio/gpio.h>
+
+/ {
+	compatible = "bananapi,bpi-r4-pro", "mediatek,mt7988a";
+};
+
+&{/soc/pinctrl@1001f000/pcie-2-hog} {
+	output-high;
+};
diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso
new file mode 100644
index 00000000000000..90b2a64459c316
--- /dev/null
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro-cn14.dtso
@@ -0,0 +1,20 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Copyright (C) 2025 MediaTek Inc.
+ * Author: Frank Wunderlich <frank-w@public-files.de>
+ */
+
+/* This enables key-m slot CN14 on pcie3(11290000 1L1) on BPI-R4-Pro */
+
+/dts-v1/;
+/plugin/;
+
+#include <dt-bindings/gpio/gpio.h>
+
+/ {
+	compatible = "bananapi,bpi-r4-pro", "mediatek,mt7988a";
+};
+
+&{/soc/pinctrl@1001f000/pcie-3-hog} {
+	output-high;
+};
diff --git a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro.dtsi b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro.dtsi
index a48132f0941143..ff778e8305d5be 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7988a-bananapi-bpi-r4-pro.dtsi
@@ -437,14 +437,12 @@ mux {
 	pcie-2-hog {
 		gpio-hog;
 		gpios = <79 GPIO_ACTIVE_HIGH>;
-		output-high;
 	};
 
 	/* 1L1 0=key-b (CN18), 1=key-m (CN14) */
 	pcie-3-hog {
 		gpio-hog;
 		gpios = <63 GPIO_ACTIVE_HIGH>;
-		output-high;
 	};
 
 	pwm0_pins: pwm0-pins {
-- 
2.53.0



