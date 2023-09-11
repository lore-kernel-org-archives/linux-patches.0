Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CFFA1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B82C433C9;
	Mon, 11 Sep 2023 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441214;
	bh=iYqORxiwUecvKAG95dusQwsS1SR80N21jlOAd0tILXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scT4xSYSguUbIRBGVQiKhCYFfhXXcExYvgEEVc08FRNldBVbiGODIasqVQk4l1YIU
	 R6r/HCrzYtu95wvuEelPox036p5RtXD+VHVD7++uG1mg3WDp0kAZMGhYMRPufV41ig
	 KrZz67Oh8PbKMl/FE3M+D//5wF4lSb1OLqVwRd98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 334/739] arm64: dts: ti: k3-j784s4-evm: Correct Pin mux offset for ADC
Date: Mon, 11 Sep 2023 15:42:13 +0200
Message-ID: <20230911134700.421142074@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Udit Kumar <u-kumar1@ti.com>

[ Upstream commit 8be3ac2d8bd77bb9cb9ddbb7a545decf9f5e4181 ]

After splitting wkup_pmx pin mux for J784S4 into four regions.
Pin mux offset for ADC nodes were not updated to align with new
regions, due to this while probing ADC driver out of range
error was seen.

Pin mux offsets for ADC nodes are corrected in this patch.

Fixes: 14462bd0b247 ("arm64: dts: ti: k3-j784s4: Fix wakeup pinmux range and pinctrl node offsets")
Signed-off-by: Udit Kumar <u-kumar1@ti.com>
Reviewed-by: Vaishnav Achath <vaishnav.a@ti.com>
Link: https://lore.kernel.org/r/20230809050108.751164-1-u-kumar1@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-evm.dts | 32 ++++++++++++------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts b/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
index cb852031c8027..bf772f0641170 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-evm.dts
@@ -340,27 +340,27 @@ J784S4_WKUP_IOPAD(0x030, PIN_INPUT, 0) /* (B35) MCU_MDIO0_MDIO */
 
 	mcu_adc0_pins_default: mcu-adc0-default-pins {
 		pinctrl-single,pins = <
-			J784S4_WKUP_IOPAD(0x134, PIN_INPUT, 0) /* (P36) MCU_ADC0_AIN0 */
-			J784S4_WKUP_IOPAD(0x138, PIN_INPUT, 0) /* (V36) MCU_ADC0_AIN1 */
-			J784S4_WKUP_IOPAD(0x13c, PIN_INPUT, 0) /* (T34) MCU_ADC0_AIN2 */
-			J784S4_WKUP_IOPAD(0x140, PIN_INPUT, 0) /* (T36) MCU_ADC0_AIN3 */
-			J784S4_WKUP_IOPAD(0x144, PIN_INPUT, 0) /* (P34) MCU_ADC0_AIN4 */
-			J784S4_WKUP_IOPAD(0x148, PIN_INPUT, 0) /* (R37) MCU_ADC0_AIN5 */
-			J784S4_WKUP_IOPAD(0x14c, PIN_INPUT, 0) /* (R33) MCU_ADC0_AIN6 */
-			J784S4_WKUP_IOPAD(0x150, PIN_INPUT, 0) /* (V38) MCU_ADC0_AIN7 */
+			J784S4_WKUP_IOPAD(0x0cc, PIN_INPUT, 0) /* (P36) MCU_ADC0_AIN0 */
+			J784S4_WKUP_IOPAD(0x0d0, PIN_INPUT, 0) /* (V36) MCU_ADC0_AIN1 */
+			J784S4_WKUP_IOPAD(0x0d4, PIN_INPUT, 0) /* (T34) MCU_ADC0_AIN2 */
+			J784S4_WKUP_IOPAD(0x0d8, PIN_INPUT, 0) /* (T36) MCU_ADC0_AIN3 */
+			J784S4_WKUP_IOPAD(0x0dc, PIN_INPUT, 0) /* (P34) MCU_ADC0_AIN4 */
+			J784S4_WKUP_IOPAD(0x0e0, PIN_INPUT, 0) /* (R37) MCU_ADC0_AIN5 */
+			J784S4_WKUP_IOPAD(0x0e4, PIN_INPUT, 0) /* (R33) MCU_ADC0_AIN6 */
+			J784S4_WKUP_IOPAD(0x0e8, PIN_INPUT, 0) /* (V38) MCU_ADC0_AIN7 */
 		>;
 	};
 
 	mcu_adc1_pins_default: mcu-adc1-default-pins {
 		pinctrl-single,pins = <
-			J784S4_WKUP_IOPAD(0x154, PIN_INPUT, 0) /* (Y38) MCU_ADC1_AIN0 */
-			J784S4_WKUP_IOPAD(0x158, PIN_INPUT, 0) /* (Y34) MCU_ADC1_AIN1 */
-			J784S4_WKUP_IOPAD(0x15c, PIN_INPUT, 0) /* (V34) MCU_ADC1_AIN2 */
-			J784S4_WKUP_IOPAD(0x160, PIN_INPUT, 0) /* (W37) MCU_ADC1_AIN3 */
-			J784S4_WKUP_IOPAD(0x164, PIN_INPUT, 0) /* (AA37) MCU_ADC1_AIN4 */
-			J784S4_WKUP_IOPAD(0x168, PIN_INPUT, 0) /* (W33) MCU_ADC1_AIN5 */
-			J784S4_WKUP_IOPAD(0x16c, PIN_INPUT, 0) /* (U33) MCU_ADC1_AIN6 */
-			J784S4_WKUP_IOPAD(0x170, PIN_INPUT, 0) /* (Y36) MCU_ADC1_AIN7 */
+			J784S4_WKUP_IOPAD(0x0ec, PIN_INPUT, 0) /* (Y38) MCU_ADC1_AIN0 */
+			J784S4_WKUP_IOPAD(0x0f0, PIN_INPUT, 0) /* (Y34) MCU_ADC1_AIN1 */
+			J784S4_WKUP_IOPAD(0x0f4, PIN_INPUT, 0) /* (V34) MCU_ADC1_AIN2 */
+			J784S4_WKUP_IOPAD(0x0f8, PIN_INPUT, 0) /* (W37) MCU_ADC1_AIN3 */
+			J784S4_WKUP_IOPAD(0x0fc, PIN_INPUT, 0) /* (AA37) MCU_ADC1_AIN4 */
+			J784S4_WKUP_IOPAD(0x100, PIN_INPUT, 0) /* (W33) MCU_ADC1_AIN5 */
+			J784S4_WKUP_IOPAD(0x104, PIN_INPUT, 0) /* (U33) MCU_ADC1_AIN6 */
+			J784S4_WKUP_IOPAD(0x108, PIN_INPUT, 0) /* (Y36) MCU_ADC1_AIN7 */
 		>;
 	};
 };
-- 
2.40.1



