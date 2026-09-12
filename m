Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C1538DC7B;
	Sat, 12 Sep 2026 19:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242749; cv=none; b=AfyGabXcmNReWz32+Iy0/+WiCtJtZeKSXDVQEjhTf8cUBZG9U2T1LCbykkG6cIyuCvxKjE5rH8DJ+wWIEg8hafk3vvPWe5H9l7p0LTR6aPT7WQq8Z6Eg1bWWWXVhSC6KSJaRUBdu0QedTHgLJS+I5hc2ssgD0ZHKxmIfGvL5g5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242749; c=relaxed/simple;
	bh=oxc5btXZwmj3E5gAQuCCmGuw97BohtmHyBzVGMtiP04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gh2ZTIB2od11bDt823fgaOQaNI7QM40ES9Gz6WyA/NO0MgeCkHMYMKf1Ij4tuKuSug+D/C5k+0KA15fT8t1IaaBez91IQxN9CInvE6hrsI+CNcc2BoX2NEA3rWNXz40kT0YDSwfURaLojap1kS9KE0ePG712Efp9GZJ997vMYo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEsRAcoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEsRAcoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAFA71F000FF;
	Sat, 12 Sep 2026 19:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242748;
	bh=CdeVhHi3MblflJ+O2RdX4TVKYPQYc3XGKBuUX+9yqDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEsRAcoEzi2PjpxU/fYrEzTzYom6znJ+Cc/kwotp8qepqI3eUV8pVJLNrR/jOwVJ+
	 nut6OY8j/XHW+UOn+VdsOhp+7U5qHis+ppOK47Okz5n1o98orby6LtYE5E6QyOnwYM
	 /wT7ZH1Nr759KIG3aR8pd+jg/5+am8Yi6ItQiI2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 511/798] arm64: dts: rockchip: Add gru-scarlet-dumo board
Date: Sat, 12 Sep 2026 09:02:19 +0200
Message-ID: <20260912065528.846867361@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 5707e34166f546bf1fcdfd3da600e8187d04d937 ]

Dumo is another variant of Scarlet, also known as the ASUS Chromebook
Tablet CT100. This is almost the same as Scarlet-Innolux, but uses a
board-specific calibration variant for the WiFi module.

Add a new device tree for it.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20210812094753.2359087-3-wenst@chromium.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: a761818d9ee1 ("arm64: dts: rockchip: Fix Gru WLAN sideband interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/Makefile         |  1 +
 .../dts/rockchip/rk3399-gru-scarlet-dumo.dts  | 41 +++++++++++++++++++
 2 files changed, 42 insertions(+)
 create mode 100644 arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts

diff --git a/arch/arm64/boot/dts/rockchip/Makefile b/arch/arm64/boot/dts/rockchip/Makefile
index 26661c7b736b7..bfa3b5d0e674b 100644
--- a/arch/arm64/boot/dts/rockchip/Makefile
+++ b/arch/arm64/boot/dts/rockchip/Makefile
@@ -20,6 +20,7 @@ dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-ficus.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-firefly.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-gru-bob.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-gru-kevin.dtb
+dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-gru-scarlet-dumo.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-gru-scarlet-inx.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-gru-scarlet-kd.dtb
 dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-hugsun-x99.dtb
diff --git a/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts
new file mode 100644
index 0000000000000..853e88455e750
--- /dev/null
+++ b/arch/arm64/boot/dts/rockchip/rk3399-gru-scarlet-dumo.dts
@@ -0,0 +1,41 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+/*
+ * Google Gru-Scarlet Rev5+ (SKU-0) board device tree source
+ *
+ * Copyright 2021 Google LLC.
+ */
+
+/dts-v1/;
+
+#include "rk3399-gru-scarlet.dtsi"
+
+/ {
+	model = "Google Scarlet";
+	compatible = "google,scarlet-rev15-sku0", "google,scarlet-rev15",
+		     "google,scarlet-rev14-sku0", "google,scarlet-rev14",
+		     "google,scarlet-rev13-sku0", "google,scarlet-rev13",
+		     "google,scarlet-rev12-sku0", "google,scarlet-rev12",
+		     "google,scarlet-rev11-sku0", "google,scarlet-rev11",
+		     "google,scarlet-rev10-sku0", "google,scarlet-rev10",
+		     "google,scarlet-rev9-sku0",  "google,scarlet-rev9",
+		     "google,scarlet-rev8-sku0",  "google,scarlet-rev8",
+		     "google,scarlet-rev7-sku0",  "google,scarlet-rev7",
+		     "google,scarlet-rev6-sku0",  "google,scarlet-rev6",
+		     "google,scarlet-rev5-sku0",  "google,scarlet-rev5",
+		     "google,scarlet", "google,gru", "rockchip,rk3399";
+};
+
+&mipi_panel {
+	compatible = "innolux,p097pfg";
+	avdd-supply = <&ppvarp_lcd>;
+	avee-supply = <&ppvarn_lcd>;
+};
+
+&pci_rootport {
+	wifi@0,0 {
+		compatible = "qcom,ath10k";
+		reg = <0x00010000 0x0 0x00000000 0x0 0x00000000>,
+		      <0x03010010 0x0 0x00000000 0x0 0x00200000>;
+		qcom,ath10k-calibration-variant = "GO_DUMO";
+	};
+};
-- 
2.53.0



