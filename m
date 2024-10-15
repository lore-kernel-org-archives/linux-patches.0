Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9CC1C07C2;
	Tue, 15 Oct 2024 12:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997163; cv=none; b=YVe+Ea37g9NiWfZd+qi3y31oBilPpe3kqQ93Ufm59QVDlM47t3KDM7lx55KGu7v2ROWxtie2SKdawZHw7eXRMr9fQ8Vr0xoJBbTkjI+UcPUAO9xp6gd0I9O3gj2hxgt2rDJexm//I3RmvcBylKduA+y3/HhKjQNobucwjxbuEqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997163; c=relaxed/simple;
	bh=/uxYaCrzUeh+29kIF9ywNpiaN0QZZM/xIs7UeDwqArY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EY4flN3mfVQlJmqkjAhEbFhmFHCWLTsHZ8L2/bZSOx+3nt7r4AbUT+DFbti/c03zB9AJQ2wv+VBqVEgQcJavGygUCImRAzFvWZd6VA7oHzi7KnsONUyDY1rSxXFlNj9IQxBzoIE+V66rt03Xy1cXv77WIUvqwhPRS/M+oSU4g/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1nhB9Nn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1nhB9Nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10BAC4CEC6;
	Tue, 15 Oct 2024 12:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997163;
	bh=/uxYaCrzUeh+29kIF9ywNpiaN0QZZM/xIs7UeDwqArY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1nhB9NnSjO854FVGTvoQuj85udyeLDqC5/4Td1I67VrXDvqm6z9IBQGgSgxpWDLQ
	 UjGKAwlIwHf2+s+isrN55TRuRhxEzkzYakiLbYXi0r2hSnLlscmpnIDMatPtyBBSEL
	 bUR3lnFtp65ODVRnxjWRmr90E5kaH2B9vDPTwkeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/518] ARM: dts: microchip: sam9x60: Fix rtc/rtt clocks
Date: Tue, 15 Oct 2024 14:40:01 +0200
Message-ID: <20241015123920.745577677@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



