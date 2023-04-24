Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB7F7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96890C433EF;
	Mon, 24 Apr 2023 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342925;
	bh=a4vUwbNcu5ldHk4wpcsRsRY1WTxIjQrfsljmB5hoHZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7FrbqPtghpuGPbDdHM5kSUPdCcmQwOXULU3hBSYe9kul9RtrqJeQBmaXRIG14fsJ
	 Uhq8H3Ubp991eSx86I9GOQZSCdwcYkRiVCDBExVmaGhYb/OqC7KgT1J6znx7i47hkz
	 w7v9ti/aC4p+P/2tyrFm3UDpae69hn+TPFMKUsC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 011/110] arm64: dts: imx8mp-verdin: correct off-on-delay
Date: Mon, 24 Apr 2023 15:16:33 +0200
Message-Id: <20230424131136.542621503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 02c447a0d79f0c966563e5095a017cbf9477ca6d ]

The property should be off-on-delay-us, not off-on-delay

Fixes: a39ed23bdf6e ("arm64: dts: freescale: add initial support for verdin imx8m plus")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi | 2 +-
 arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi
index cefabe65b2520..c8b521d45fca1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin-dev.dtsi
@@ -12,7 +12,7 @@
 		compatible = "regulator-fixed";
 		enable-active-high;
 		gpio = <&gpio_expander_21 4 GPIO_ACTIVE_HIGH>; /* ETH_PWR_EN */
-		off-on-delay = <500000>;
+		off-on-delay-us = <500000>;
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_ETH";
diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
index 6a1890a4b5d88..947e4537303f2 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin.dtsi
@@ -87,7 +87,7 @@
 		compatible = "regulator-fixed";
 		enable-active-high;
 		gpio = <&gpio2 20 GPIO_ACTIVE_HIGH>; /* PMIC_EN_ETH */
-		off-on-delay = <500000>;
+		off-on-delay-us = <500000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_reg_eth>;
 		regulator-always-on;
@@ -128,7 +128,7 @@
 		enable-active-high;
 		/* Verdin SD_1_PWR_EN (SODIMM 76) */
 		gpio = <&gpio4 22 GPIO_ACTIVE_HIGH>;
-		off-on-delay = <100000>;
+		off-on-delay-us = <100000>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_usdhc2_pwr_en>;
 		regulator-max-microvolt = <3300000>;
-- 
2.39.2



