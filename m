Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89FE2123CE;
	Tue, 12 Nov 2024 10:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407275; cv=none; b=WjZIpMDiga3QOWu8su/Mqa5mHBCiVYBO1OpESlDj9/pB+ltNR81EZK2ADk0VA2m54E/Z0SC4Q+mv9ugfEsD9xpXBGV5ZI1wtM42MR5WDa4HCdplU2wIv+dZDXZ/A4ahypfmod6zvBAEnU+5gkn2mTQWlpnaKOOntVVXAqtiYc2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407275; c=relaxed/simple;
	bh=aWhcPIkFonYx+ZNbKVNNr6uY+QF3jJusltcMWyOh+2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dLNtDFUqAWnZrIIDl0rJQUQ1wEQ9uKIEtOdcz1sVdXCAY8n+b2mX/kMh9I280XpdR4s06g77aZVHk/mr+DDxDi/zyNCJdi9gnV2bwhYcgqkaovjzO+aBz8kERnTS9g3gauOQ6RU9/ppVYgEU2/B4EgH/LB/r90qoSz7xRN+t/x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHO/sSw8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHO/sSw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB21C4CECD;
	Tue, 12 Nov 2024 10:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407274;
	bh=aWhcPIkFonYx+ZNbKVNNr6uY+QF3jJusltcMWyOh+2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHO/sSw8ejZV4iDaI/ZIc8CUKD4zMPKw9eK4ylaBEhAPa1/YbTnnBuiM2P8+vGXF7
	 wK2WK7VcMK/7O0zXBkOF8/ZNz1OaiQ82bF2SUr6ih+mMJrJKCMNF2//qIB1tW2VE7E
	 fUhq9cINkEsjojLtG542igowT0D3qaPP4hSZ6Z6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Fabio Estevam <festevam@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/98] arm64: dts: imx8qxp: Add VPU subsystem file
Date: Tue, 12 Nov 2024 11:20:24 +0100
Message-ID: <20241112101844.626706570@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 6bcd8b2fa2a9826fb6a849a9bfd7bdef145cabb6 ]

imx8qxp re-uses imx8qm VPU subsystem file, but it has different base
addresses. Also imx8qxp has only two VPU cores, delete vpu_vore2 and
mu2_m0 accordingly.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: eed2d8e8d005 ("arm64: dts: imx8-ss-vpu: Fix imx8qm VPU IRQs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8qxp-ss-vpu.dtsi      | 17 +++++++++++++++++
 arch/arm64/boot/dts/freescale/imx8qxp.dtsi      |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi
new file mode 100644
index 0000000000000..7894a3ab26d6b
--- /dev/null
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: (GPL-2.0-or-later OR X11)
+/*
+ * Copyright 2023 TQ-Systems GmbH <linux@ew.tq-group.com>,
+ * D-82229 Seefeld, Germany.
+ * Author: Alexander Stein
+ */
+
+&vpu_core0 {
+	reg = <0x2d040000 0x10000>;
+};
+
+&vpu_core1 {
+	reg = <0x2d050000 0x10000>;
+};
+
+/delete-node/ &mu2_m0;
+/delete-node/ &vpu_core2;
diff --git a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
index dce699dffb9bf..bec66bb240829 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qxp.dtsi
@@ -48,7 +48,6 @@
 		serial3 = &lpuart3;
 		vpu-core0 = &vpu_core0;
 		vpu-core1 = &vpu_core1;
-		vpu-core2 = &vpu_core2;
 	};
 
 	cpus {
@@ -316,6 +315,7 @@
 };
 
 #include "imx8qxp-ss-img.dtsi"
+#include "imx8qxp-ss-vpu.dtsi"
 #include "imx8qxp-ss-adma.dtsi"
 #include "imx8qxp-ss-conn.dtsi"
 #include "imx8qxp-ss-lsio.dtsi"
-- 
2.43.0



