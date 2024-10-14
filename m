Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109041BD01F;
	Mon, 14 Oct 2024 14:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917593; cv=none; b=cLq9X/EE/6hoGVjsDPeoyYdgEKhsgJPgHkNNGNxMly6+o+kivn/7ucjDVxN4z7tUtcn0UUrXfw/9GQQjp95VQ3TdQg8K9if6SIhFcX4LmPIHtThNHDDoNQrPlj4iF6Agxo1KbrlF5jrt4iP8VpigI3yuTjdBt22qW+PCgAtCZDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917593; c=relaxed/simple;
	bh=e9f6jcbQD3iO23TfLeYFXS1mYQXtPd1eVB63706gLRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opHpsi2XTnVEWxGfwiNHTYK9NiaxlJC5wNlngwLFAfzCCAHslrAQKX/7hPl4j0lWbRAA+5kxBhaoM0ACsCbazVH+MrFBK5dTe0LSmr+8UM5qEtHquP2i6XPO5+mUlAxNnGw85PC1gmbKH3NRwE6vbNG14Nv10vDSRVkhf32KoGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCEizsWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCEizsWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74314C4CEC3;
	Mon, 14 Oct 2024 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917592;
	bh=e9f6jcbQD3iO23TfLeYFXS1mYQXtPd1eVB63706gLRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCEizsWrMkLd/ouDS50bPH+WU1h1llT33WzBE3azmkL7ELcBsNMeP7u6nPF+zilN1
	 B4BpdUCeRqzh98FgBe7BbFUWe2jXcX2+0xBblk1DQoNUtibMwAjjTxGrgB+tGJUj/7
	 w92RQOXUjgse5eA4Mc0sKnHzJ9IOTmJaM5UI2XrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/798] ARM: dts: microchip: sam9x60: Fix rtc/rtt clocks
Date: Mon, 14 Oct 2024 16:10:30 +0200
Message-ID: <20241014141220.923741002@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 37a5d96aaf642..d3d49c6144bf6 100644
--- a/arch/arm/boot/dts/sam9x60.dtsi
+++ b/arch/arm/boot/dts/sam9x60.dtsi
@@ -690,7 +690,7 @@ rtt: rtc@fffffe20 {
 				compatible = "microchip,sam9x60-rtt", "atmel,at91sam9260-rtt";
 				reg = <0xfffffe20 0x20>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			pit: timer@fffffe40 {
@@ -716,7 +716,7 @@ rtc: rtc@fffffea8 {
 				compatible = "microchip,sam9x60-rtc", "atmel,at91sam9x5-rtc";
 				reg = <0xfffffea8 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			watchdog: watchdog@ffffff80 {
-- 
2.43.0



