Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAA68F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CDF6C433C8;
	Sun, 16 Jul 2023 20:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539902;
	bh=HAq7yjrTqXlOHwty/uovanZ3tEBSE15wua/yNDXbJlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRtsU7pfdGagKuNrEdWHckKW83PZKa1TSAnue6J//eXlagB94n6IACffqIKF3YpuT
	 UDU9lp436LIt8E/BzrHiAklXfchVrBCSEU2S4lE3JF9rHURS0AHHQZQYOkcDzG1zYP
	 rZIs3WONRwvEmXB0/X++nrB+uRncZ+G5tsVWWvMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/591] ARM: dts: stm32: Move ethernet MAC EEPROM from SoM to carrier boards
Date: Sun, 16 Jul 2023 21:45:12 +0200
Message-ID: <20230716194928.340189860@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index b6957cbdeff5f..2c246ac641533 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -322,6 +322,12 @@ adv7513_i2s0: endpoint {
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
index 27477bb219ded..bb4ac6c13cbd3 100644
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
-- 
2.39.2



