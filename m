Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D101E6321;
	Tue, 15 Oct 2024 11:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992532; cv=none; b=pwJQt4wcA9YYcz5MrlIWTnCdPq88zXywkWEsvjMXIpx5rH2ugYvK/uf70Z8YPibsJxLLVMintrHlAMLSbbDsQ2/eT6gOQaONqTA+d+bqUIcADmQrXgaGXzqtON2nGoMuZDvu67bBsXjAhLFpKJLDJZS+FeW9CohsHiiONyCM/tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992532; c=relaxed/simple;
	bh=9lz+PdWwhPs4lsDLdONYzjKx3PmVoeQMjS1PZ7iy5wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUGfnGhaHpnYrjgGURur4Ni6noCHjRoUPy03c3IeIqinCcN07QgkPIGOuHeRxDU0zHvGneeiCbjJCBDilEXx1tr8+qloJIpZVijY7hSt576oL1b+RKOJzth4jhM3kkqhl9lmAoyhHiOSmGHuljLyU7qpeVPvT8yUjZ1mXvZBY44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UGScBMON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UGScBMON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10ADC4CEC6;
	Tue, 15 Oct 2024 11:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992532;
	bh=9lz+PdWwhPs4lsDLdONYzjKx3PmVoeQMjS1PZ7iy5wA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGScBMOND4OOt1eUaaKnStDS54ASeq6n1bnnxVKKcMg1bIBfFFy1reFp4vudtZ0ME
	 j29eSdwiRSrLKAvTf6quwiVxJnl3LLHTHb2xf7p6z3TFBgCL/rvsrcz1w4U3XX+oY1
	 1HFXl59qs6ogx3rgXz1L1IOmAGF2c8t//4nIr85M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/691] ARM: dts: microchip: sam9x60: Fix rtc/rtt clocks
Date: Tue, 15 Oct 2024 13:21:30 +0200
Message-ID: <20241015112445.990084235@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Dahl <ada@thorsis.com>

[ Upstream commit d355c895fa4ddd8bec15569eee540baeed7df8c5 ]

The RTC and RTT peripherals use the timing domain slow clock (TD_SLCK),
sourced from the 32.768 kHz crystal oscillator or slow rc oscillator.

The previously used Monitoring domain slow clock (MD_SLCK) is sourced
from an internal RC oscillator which is most probably not precise enough
for real time clock purposes.

Fixes: 1e5f532c2737 ("ARM: dts: at91: sam9x60: add device tree for soc and board")
Fixes: 5f6b33f46346 ("ARM: dts: sam9x60: add rtt")
Signed-off-by: Alexander Dahl <ada@thorsis.com>
Link: https://lore.kernel.org/r/20240821055136.6858-1-ada@thorsis.com
[claudiu.beznea: removed () around the last commit description paragraph,
 removed " in front of "timing domain slow clock", described that
 TD_SLCK can also be sourced from slow rc oscillator]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sam9x60.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/sam9x60.dtsi b/arch/arm/boot/dts/sam9x60.dtsi
index e1e0dec8cc1f2..5e569cf1cccfc 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -692,7 +692,7 @@ rtt: rtt@fffffe20 {
 				compatible = "microchip,sam9x60-rtt", "atmel,at91sam9260-rtt";
 				reg = <0xfffffe20 0x20>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			pit: timer@fffffe40 {
@@ -718,7 +718,7 @@ rtc: rtc@fffffea8 {
 				compatible = "microchip,sam9x60-rtc", "atmel,at91sam9x5-rtc";
 				reg = <0xfffffea8 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			watchdog: watchdog@ffffff80 {
-- 
2.43.0



