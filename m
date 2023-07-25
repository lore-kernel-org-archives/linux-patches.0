Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E800F1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD2BC433C8;
	Tue, 25 Jul 2023 11:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283757;
	bh=WwrxdMD8v1h+0Wwj2tx/kmXh2ML5BovZ9Wz64iku9Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFDxaN02S1OM5UncJpaN5pl4vzuG1J4mod1q1EJRTnVdGtrxLUjeoKmyVNpvVyEij
	 BUlTlEfdQ2w6k+41yiNEZfTekT/aUAdG+ADSZjrIPdfjuEpviCN2zLF3IOuW5/2xcZ
	 ibRT5AOlO9xWUEW+CDa9K18eY4RHR5rmNt6HmCVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/509] ARM: dts: stm32: Move ethernet MAC EEPROM from SoM to carrier boards
Date: Tue, 25 Jul 2023 12:40:50 +0200
Message-ID: <20230725104558.769514110@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi | 6 ++++++
 arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi       | 6 ------
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
index 723b39bb2129c..c43cf62736a6f 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi
@@ -232,6 +232,12 @@ adv7513_i2s0: endpoint {
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
diff --git a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
index 5af32140e128b..7dba02e9ba6da 100644
--- a/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp15xx-dhcor-som.dtsi
@@ -167,12 +167,6 @@ watchdog {
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
 
 &iwdg2 {
-- 
2.39.2



