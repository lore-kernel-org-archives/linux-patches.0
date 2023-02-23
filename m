Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078EA2584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:10:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BC3C433EF;
	Thu, 23 Feb 2023 13:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157846;
	bh=m5w68lAElSkqotMfgm3dTzokS3uk62zy1nIRDv311sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnteZLE2dx8TLdrOtYdjEkzj3g6u5xLPptR9E0DuemytdxwIqGA7EYz3/jzSEKrrN
	 NksZKC/s11JXM/RBodOiQbQ9EBBOwUXpEwEm5kA7/9zaZH2s2Zljc9k+UNZAQfegOK
	 e+ub++U5Gi8RF6vQ5OsXp/HSPS6vkfhwRYsGgUwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@seco.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/18] powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
Date: Thu, 23 Feb 2023 14:06:51 +0100
Message-Id: <20230223130425.936289132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 36926a7d70c2d462fca1ed85bfee000d17fd8662 ]

On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC dtsi
fragments, and mark the QMAN ports as 10G.

Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan support to the SoC device tree(s)")
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 44 +++++++++++++++++++
 .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 44 +++++++++++++++++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  4 +-
 3 files changed, 90 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
 create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi

diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
new file mode 100644
index 0000000000000..437dab3fc0176
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x08: port@88000 {
+		cell-index = <0x8>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x28: port@a8000 {
+		cell-index = <0x28>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e0000 {
+		cell-index = <0>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe0000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy0>;
+	};
+
+	mdio@e1000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe1000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy0: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
new file mode 100644
index 0000000000000..ad116b17850a8
--- /dev/null
+++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
@@ -0,0 +1,44 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
+/*
+ * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset 0x400000 ]
+ *
+ * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
+ * Copyright 2012 - 2015 Freescale Semiconductor Inc.
+ */
+
+fman@400000 {
+	fman0_rx_0x09: port@89000 {
+		cell-index = <0x9>;
+		compatible = "fsl,fman-v3-port-rx";
+		reg = <0x89000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	fman0_tx_0x29: port@a9000 {
+		cell-index = <0x29>;
+		compatible = "fsl,fman-v3-port-tx";
+		reg = <0xa9000 0x1000>;
+		fsl,fman-10g-port;
+	};
+
+	ethernet@e2000 {
+		cell-index = <1>;
+		compatible = "fsl,fman-memac";
+		reg = <0xe2000 0x1000>;
+		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
+		ptp-timer = <&ptp_timer0>;
+		pcsphy-handle = <&pcsphy1>;
+	};
+
+	mdio@e3000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
+		reg = <0xe3000 0x1000>;
+		fsl,erratum-a011043; /* must ignore read errors */
+
+		pcsphy1: ethernet-phy@0 {
+			reg = <0x0>;
+		};
+	};
+};
diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index ecbb447920bc6..74e17e134387d 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -609,8 +609,8 @@
 /include/ "qoriq-bman1.dtsi"
 
 /include/ "qoriq-fman3-0.dtsi"
-/include/ "qoriq-fman3-0-1g-0.dtsi"
-/include/ "qoriq-fman3-0-1g-1.dtsi"
+/include/ "qoriq-fman3-0-10g-2.dtsi"
+/include/ "qoriq-fman3-0-10g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-2.dtsi"
 /include/ "qoriq-fman3-0-1g-3.dtsi"
 /include/ "qoriq-fman3-0-1g-4.dtsi"
-- 
2.39.0



