Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D4932B126;
	Sat, 12 Sep 2026 18:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239096; cv=none; b=A77mdIcyKGavCLfj2aSP8J9uKlpWlZiyWD16anTYn30HfpupSCavXova3cIsXDHN4szxF0gmKPJ6f49IO8KdOrPC2wFqvHsCjqDSpF/ZDexx/yC8+8D9fllkxe/dJbx9gr1KUCDLovHOhpI1jNLpj/ZD473mCrejbkCbXVIeW2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239096; c=relaxed/simple;
	bh=Mlmvv8yFSZNKE1BYMvX3GbeV1XRZQxd1GDxhy5cyW+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6rjgeBBuTK2m+i+cGLfw6SF4YfRImlLi01pC0pf9676cfie8zTCsTu+bi3JtIkWv8Oj4BBBxKp+htCaHK+yqmm085RGcxWM2A4GZve/78oSYRIg0rudpVvkwixOvtxS3hILsJfzrvAXNpeHw/MnIXTNt4YbUaOr6ZEtBYepBvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDzUBFze; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDzUBFze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456E01F000FF;
	Sat, 12 Sep 2026 18:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239095;
	bh=Rc2yT1F+eOrjvDyQuS0oKTRd+Vv8n4TU6nQJHQLwFpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDzUBFze64z+RGiMa3+iyX1wqo2p1SGn1pSw3i9KujGHOraxsVWh/lhy7x6rgVhZI
	 knZjAHDmC+pQez67NvV9kn8dmO2bKGTd5ZCu9vcmW9YUEmjm6BWaRXwr9KYYKvCDZY
	 5qKhr8hyZRj5OzUo1Zusy+LQK5je1FOTKHNF3ZyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 596/935] arm64: dts: rockchip: Add gru-scarlet-dumo board
Date: Sat, 12 Sep 2026 09:00:26 +0200
Message-ID: <20260912065540.509925354@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7fdb41de01ec9..b24df3aa58d35 100644
--- a/arch/arm64/boot/dts/rockchip/Makefile
+++ b/arch/arm64/boot/dts/rockchip/Makefile
@@ -24,6 +24,7 @@ dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3399-ficus.dtb
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



