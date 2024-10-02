Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12761D175D;
	Wed,  2 Oct 2024 14:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879468; cv=none; b=rLJo1tJ0JtCjYWAiEJlMRAhD78UZRh4nUfWpG4LDPw7rQDKgJm+lq1TsqfqJ6dKm1FvIwiIwgNOUuICWlJ8q2PEIerok+G9vYi2feCUItZ/BaRsXx3mcv38MtY5txYa5ZffYdRIog/XvSLrllG/lpIqXWxvEFb5BaRrM675RWEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879468; c=relaxed/simple;
	bh=udorMtG9Oyp9wggcZCVQA9JpCWNN6WhzQNxSuN/jmVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pTqv/sGsVQCN5lu2TYcB6HdTZ01jyfUWQOs5qqcI0VaatmFmZJVTRFODUKU1vy+V4zoYjPnLhCNTAj0dZ9LXAKRhYANkTxr61TQjZ4V+KsW9rt/kbkark2xqO3VryRfpv32PV4Z1Eq7MD/2moBpo/xFrZU2+Lo7+0Pa0I3Eu+C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjJJgSap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjJJgSap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30910C4CEC2;
	Wed,  2 Oct 2024 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879468;
	bh=udorMtG9Oyp9wggcZCVQA9JpCWNN6WhzQNxSuN/jmVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjJJgSapIfbg1/yLG1JM0Vrg3XJj9/1gCMXRRPcLLpcgAzir3RMaP0Qn+Sd4s4HX6
	 3j5Icqd7/sChIq119Iz34k973QSNG4j6KfUEJNsaIz5Szb4S3FOFeVuHJejF24RlmB
	 WR3yPkiK9LPnxU67KebVuJXGHPNAGJTDt+t68CBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/538] ARM: dts: microchip: sam9x60: Fix rtc/rtt clocks
Date: Wed,  2 Oct 2024 14:55:37 +0200
Message-ID: <20241002125756.099300198@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/microchip/sam9x60.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/microchip/sam9x60.dtsi b/arch/arm/boot/dts/microchip/sam9x60.dtsi
index 73d570a172690..1705c96f4221e 100644
--- a/arch/arm/boot/dts/microchip/sam9x60.dtsi
+++ b/arch/arm/boot/dts/microchip/sam9x60.dtsi
@@ -1312,7 +1312,7 @@ rtt: rtc@fffffe20 {
 				compatible = "microchip,sam9x60-rtt", "atmel,at91sam9260-rtt";
 				reg = <0xfffffe20 0x20>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			pit: timer@fffffe40 {
@@ -1338,7 +1338,7 @@ rtc: rtc@fffffea8 {
 				compatible = "microchip,sam9x60-rtc", "atmel,at91sam9x5-rtc";
 				reg = <0xfffffea8 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			watchdog: watchdog@ffffff80 {
-- 
2.43.0



