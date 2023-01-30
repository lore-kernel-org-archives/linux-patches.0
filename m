Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F6828EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788EBC433EF;
	Mon, 30 Jan 2023 14:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087870;
	bh=Q2F2xsnlUwXx0ft16LWnzPAtKRrvVWQG96vS6GTFW2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKJgyTGX4luvPmHDVhU+Wy4d/k/Pn+Ryt5w+pHszP35Hbj1B8objkzXUPWg+f+6NK
	 0Uw6YdecHlMO9LbeMwTp5KfB7b42yHTmShUD2YqOm45dNmiGn72IshncpqaR/KeKXp
	 3qGA1k6oTgJYS2eQewNdbjh/otrEdi23rckq5fQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 007/204] ARM: dts: imx7d-pico: Use clock-frequency
Date: Mon, 30 Jan 2023 14:49:32 +0100
Message-Id: <20230130134316.632563550@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit f4dd0845c4f1f5371f1e06fef0e4a1734a2db964 ]

'clock_frequency' is not a valid property.

Use the correct 'clock-frequency' instead.

Fixes: 8b646cfb84c3 ("ARM: dts: imx7d-pico: Add support for the dwarf baseboard")
Fixes: 6418fd92417f ("ARM: dts: imx7d-pico: Add support for the nymph baseboard")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-pico-dwarf.dts | 4 ++--
 arch/arm/boot/dts/imx7d-pico-nymph.dts | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx7d-pico-dwarf.dts b/arch/arm/boot/dts/imx7d-pico-dwarf.dts
index 5162fe227d1e..fdc10563f147 100644
--- a/arch/arm/boot/dts/imx7d-pico-dwarf.dts
+++ b/arch/arm/boot/dts/imx7d-pico-dwarf.dts
@@ -32,7 +32,7 @@ sys_mclk: clock-sys-mclk {
 };
 
 &i2c1 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
@@ -52,7 +52,7 @@ pressure-sensor@60 {
 };
 
 &i2c4 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
diff --git a/arch/arm/boot/dts/imx7d-pico-nymph.dts b/arch/arm/boot/dts/imx7d-pico-nymph.dts
index 104a85254adb..5afb1674e012 100644
--- a/arch/arm/boot/dts/imx7d-pico-nymph.dts
+++ b/arch/arm/boot/dts/imx7d-pico-nymph.dts
@@ -43,7 +43,7 @@ sys_mclk: clock-sys-mclk {
 };
 
 &i2c1 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c1>;
 	status = "okay";
@@ -64,7 +64,7 @@ adc@52 {
 };
 
 &i2c2 {
-	clock_frequency = <100000>;
+	clock-frequency = <100000>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_i2c2>;
 	status = "okay";
-- 
2.39.0



