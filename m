Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC79C522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5DDC433C7;
	Sun,  9 Jul 2023 11:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901928;
	bh=5bSjYU4IPcgj+0gWhEfrQaWUF+A2w5lIfQCaRQELUs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVcCbVQJcuL6oUFE4FLeh1Ts4zGU/jUpJmqxGZmE6BkCIhnY+R6rkvu3js6Zhz+nv
	 jRs+PK5m1352CkraOogRJq2YNOG7XlZvcQxhHHuSj9/ZfW0uiaI1HxgnzbVnQHvKuM
	 JhH4XErucNqOhS3zSem08wFCGzWYG1REQdIVriLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 195/431] ARM: dts: stm32: Move ethernet MAC EEPROM from SoM to carrier boards
Date: Sun,  9 Jul 2023 13:12:23 +0200
Message-ID: <20230709111455.745788524@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marek Vasut <marex@denx.de>

[ Upstream commit 9660efc2af37f3c12dc6e6a5511ad99e0addc297 ]

The ethernet MAC EEPROM is not populated on the SoM itself, it has to be
populated on each carrier board. Move the EEPROM into the correct place
in DTs, i.e. the carrier board DTs. Add label to the EEPROM too.

Fixes: 7e76f82acd9e1 ("ARM: dts: stm32: Split Avenger96 into DHCOR SoM and Avenger96 board")
Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi   | 6 ++++++
 arch/arm/boot/dts/stm32mp15xx-dhcor-drc-compact.dtsi | 6 ++++++
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi         | 6 ------
 arch/arm/boot/dts/stm32mp15xx-dhcor-testbench.dtsi   | 8 ++++++++
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index 50af4a27d6be4..e67c0fa209cde 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -321,6 +321,12 @@ adv7513_i2s0: endpoint {
 			};
 		};
 	};
+
+	dh_mac_eeprom: eeprom@53 {
+		compatible = "atmel,24c02";
+		reg = <0x53>;
+		pagesize = <16>;
+	};
 };
 
 &ltdc {
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-drc-compact.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-drc-compact.dtsi
index c32c160f97f20..39af79dc654cc 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-drc-compact.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-drc-compact.dtsi
@@ -192,6 +192,12 @@ eeprom@50 {
 		reg = <0x50>;
 		pagesize = <16>;
 	};
+
+	dh_mac_eeprom: eeprom@53 {
+		compatible = "atmel,24c02";
+		reg = <0x53>;
+		pagesize = <16>;
+	};
 };
 
 &sdmmc1 {	/* MicroSD */
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
index bb40fb46da81d..bba19f21e5277 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
@@ -213,12 +213,6 @@ watchdog {
 			status = "disabled";
 		};
 	};
-
-	eeprom@53 {
-		compatible = "atmel,24c02";
-		reg = <0x53>;
-		pagesize = <16>;
-	};
 };
 
 &ipcc {
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-testbench.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-testbench.dtsi
index 5fdb74b652aca..faed31b6d84a1 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-testbench.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-testbench.dtsi
@@ -90,6 +90,14 @@ phy0: ethernet-phy@7 {
 	};
 };
 
+&i2c4 {
+	dh_mac_eeprom: eeprom@53 {
+		compatible = "atmel,24c02";
+		reg = <0x53>;
+		pagesize = <16>;
+	};
+};
+
 &sdmmc1 {
 	pinctrl-names = "default", "opendrain", "sleep";
 	pinctrl-0 = <&sdmmc1_b4_pins_a &sdmmc1_dir_pins_b>;
-- 
2.39.2



