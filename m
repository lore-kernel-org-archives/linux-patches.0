Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF921863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97AFDC433EF;
	Wed, 28 Dec 2022 14:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238867;
	bh=35cZwjIkshA2Ay9vlvOfvedHRYE1QOuN38cd7osSdl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbG65LPjfjejLOipu47IjvLrr93Y7j2SybiltjCYm3bBKH5dcZROwyjqz8ZCoTQ3l
	 7xzb0sFa5gqclXawvO7RLZzVcm8r7pUrkFPEyPsObMlAiGFafw3QC7m+5st8wcTl4d
	 rHOs2NTtr5q5krbOehBlscfG81l0GzdaMwmTCzwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/731] arm64: dts: mt6779: Fix devicetree build warnings
Date: Wed, 28 Dec 2022 15:32:26 +0100
Message-Id: <20221228144257.687062734@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 4d759c524c15dc4151e40b9e3f368147fda7b789 ]

Rename fixed-clock oscillators to oscillator-26m and oscillator-32k
and remove the unit address to fix the unit_address_vs_reg warning;
fix the unit address for interrupt and intpol controllers by
removing a leading zero in their unit address.

This commit fixes the following warnings:

(unit_address_vs_reg): /oscillator@0: node has a unit name, but
no reg or ranges property
(unit_address_vs_reg): /oscillator@1: node has a unit name, but
no reg or ranges property
(simple_bus_reg): /soc/interrupt-controller@0c000000: simple-bus
unit address format error, expected "c000000"
(simple_bus_reg): /soc/intpol-controller@0c53a650: simple-bus
unit address format error, expected "c53a650"

Fixes: 4c7a6260775d ("arm64: dts: add dts nodes for MT6779")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-3-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6779.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6779.dtsi b/arch/arm64/boot/dts/mediatek/mt6779.dtsi
index 9bdf5145966c..dde9ce137b4f 100644
--- a/arch/arm64/boot/dts/mediatek/mt6779.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6779.dtsi
@@ -88,14 +88,14 @@ pmu {
 		interrupts = <GIC_PPI 7 IRQ_TYPE_LEVEL_LOW 0>;
 	};
 
-	clk26m: oscillator@0 {
+	clk26m: oscillator-26m {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <26000000>;
 		clock-output-names = "clk26m";
 	};
 
-	clk32k: oscillator@1 {
+	clk32k: oscillator-32k {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
 		clock-frequency = <32768>;
@@ -117,7 +117,7 @@ soc {
 		compatible = "simple-bus";
 		ranges;
 
-		gic: interrupt-controller@0c000000 {
+		gic: interrupt-controller@c000000 {
 			compatible = "arm,gic-v3";
 			#interrupt-cells = <4>;
 			interrupt-parent = <&gic>;
@@ -138,7 +138,7 @@ ppi_cluster1: interrupt-partition-1 {
 
 		};
 
-		sysirq: intpol-controller@0c53a650 {
+		sysirq: intpol-controller@c53a650 {
 			compatible = "mediatek,mt6779-sysirq",
 				     "mediatek,mt6577-sysirq";
 			interrupt-controller;
-- 
2.35.1



