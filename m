Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4BD1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF29BC433C8;
	Mon, 11 Sep 2023 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441203;
	bh=XW9nSDnE6u/E/rq2d1bLvUgSBPBeDFRfc0vn2NtvSJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWKMii13k9KcQPi21Il8nUZifTmRUwjYfV/gPjr23q67E1GPYFnMz6ihL6KV71o7h
	 OGDZhWoSDVGw6xpnXfPitOMgiNwhlYIGXZzb/pHP3Y7CZ7qtKLampj/GwOYKI7k2XP
	 CY/6aRp2rqpn/0raX/vK0dLreGFaXuZp7OFhFKMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Vaishnav Achath <vaishnav.a@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 313/739] arm64: dts: ti: k3-j721s2: correct pinmux offset for ospi
Date: Mon, 11 Sep 2023 15:41:52 +0200
Message-ID: <20230911134659.857021099@linuxfoundation.org>
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

[ Upstream commit 06c4e7aa4af0682910ea52d7c23d85f59ea7dcc6 ]

Due to non-addressable regions in J721S2 SOC wkup_pmx was split
into four regions from wkup_pmx0 to wkup_pmx3.

Correcting OSPI1 pin mux, which now falls under wkup_pmx1.
Along with that removing unused pin mux for OSPI-0.

Fixes: 6bc829ceea41 ("arm64: dts: ti: k3-j721s2: Fix wkup pinmux range")

Signed-off-by: Udit Kumar <u-kumar1@ti.com>
Reviewed-by: Vaishnav Achath <vaishnav.a@ti.com>
Link: https://lore.kernel.org/r/20230804075341.3858488-1-u-kumar1@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/ti/k3-j721s2-common-proc-board.dts    | 19 ++++++++++---------
 arch/arm64/boot/dts/ti/k3-j721s2-som-p0.dtsi  |  3 ---
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721s2-common-proc-board.dts
index 04d4739d72457..2a5000645752d 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-common-proc-board.dts
@@ -249,18 +249,19 @@ J721S2_WKUP_IOPAD(0x104, PIN_INPUT, 0) /* (N26) MCU_ADC1_AIN6 */
 			J721S2_WKUP_IOPAD(0x108, PIN_INPUT, 0) /* (N27) MCU_ADC1_AIN7 */
 		>;
 	};
+};
 
+&wkup_pmx1 {
 	mcu_fss0_ospi1_pins_default: mcu-fss0-ospi1-default-pins {
 		pinctrl-single,pins = <
-			J721S2_WKUP_IOPAD(0x040, PIN_OUTPUT, 0) /* (A19) MCU_OSPI1_CLK */
-			J721S2_WKUP_IOPAD(0x05c, PIN_OUTPUT, 0) /* (D20) MCU_OSPI1_CSn0 */
-			J721S2_WKUP_IOPAD(0x060, PIN_OUTPUT, 0) /* (C21) MCU_OSPI1_CSn1 */
-			J721S2_WKUP_IOPAD(0x04c, PIN_INPUT, 0) /* (D21) MCU_OSPI1_D0 */
-			J721S2_WKUP_IOPAD(0x050, PIN_INPUT, 0) /* (G20) MCU_OSPI1_D1 */
-			J721S2_WKUP_IOPAD(0x054, PIN_INPUT, 0) /* (C20) MCU_OSPI1_D2 */
-			J721S2_WKUP_IOPAD(0x058, PIN_INPUT, 0) /* (A20) MCU_OSPI1_D3 */
-			J721S2_WKUP_IOPAD(0x048, PIN_INPUT, 0) /* (B19) MCU_OSPI1_DQS */
-			J721S2_WKUP_IOPAD(0x044, PIN_INPUT, 0) /* (B20) MCU_OSPI1_LBCLKO */
+			J721S2_WKUP_IOPAD(0x008, PIN_OUTPUT, 0) /* (A19) MCU_OSPI1_CLK */
+			J721S2_WKUP_IOPAD(0x024, PIN_OUTPUT, 0) /* (D20) MCU_OSPI1_CSn0 */
+			J721S2_WKUP_IOPAD(0x014, PIN_INPUT, 0) /* (D21) MCU_OSPI1_D0 */
+			J721S2_WKUP_IOPAD(0x018, PIN_INPUT, 0) /* (G20) MCU_OSPI1_D1 */
+			J721S2_WKUP_IOPAD(0x01c, PIN_INPUT, 0) /* (C20) MCU_OSPI1_D2 */
+			J721S2_WKUP_IOPAD(0x020, PIN_INPUT, 0) /* (A20) MCU_OSPI1_D3 */
+			J721S2_WKUP_IOPAD(0x010, PIN_INPUT, 0) /* (B19) MCU_OSPI1_DQS */
+			J721S2_WKUP_IOPAD(0x00c, PIN_INPUT, 0) /* (B20) MCU_OSPI1_LBCLKO */
 		>;
 	};
 };
diff --git a/arch/arm64/boot/dts/ti/k3-j721s2-som-p0.dtsi b/arch/arm64/boot/dts/ti/k3-j721s2-som-p0.dtsi
index d57dd43da0ef4..17ae27eac39ad 100644
--- a/arch/arm64/boot/dts/ti/k3-j721s2-som-p0.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-som-p0.dtsi
@@ -44,9 +44,6 @@ mcu_fss0_ospi0_pins_default: mcu-fss0-ospi0-default-pins {
 		pinctrl-single,pins = <
 			J721S2_WKUP_IOPAD(0x000, PIN_OUTPUT, 0) /* (D19) MCU_OSPI0_CLK */
 			J721S2_WKUP_IOPAD(0x02c, PIN_OUTPUT, 0) /* (F15) MCU_OSPI0_CSn0 */
-			J721S2_WKUP_IOPAD(0x030, PIN_OUTPUT, 0) /* (G17) MCU_OSPI0_CSn1 */
-			J721S2_WKUP_IOPAD(0x038, PIN_OUTPUT, 0) /* (F14) MCU_OSPI0_CSn2 */
-			J721S2_WKUP_IOPAD(0x03c, PIN_OUTPUT, 0) /* (F17) MCU_OSPI0_CSn3 */
 			J721S2_WKUP_IOPAD(0x00c, PIN_INPUT, 0) /* (C19) MCU_OSPI0_D0 */
 			J721S2_WKUP_IOPAD(0x010, PIN_INPUT, 0) /* (F16) MCU_OSPI0_D1 */
 			J721S2_WKUP_IOPAD(0x014, PIN_INPUT, 0) /* (G15) MCU_OSPI0_D2 */
-- 
2.40.1



