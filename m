Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD051D043C;
	Wed,  2 Oct 2024 13:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875564; cv=none; b=ONjbgLEFrXJkUdNOcMbqE15O1oCbxm7ojYRHvGc5eIw22e2W9q9pNH7LCgiaKiRH0iioMZE3LTvRZczDa1aqfqpcUD3+NyULz2LRN7g0+MK0mo18+P2QnoX5lTjyEpUqQITvXLpwfuob2emL3gfaWx5QdUL0t9JIGIVYhs50eEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875564; c=relaxed/simple;
	bh=r2tU+QP6MFaTAtf69PmoH3yS+wwaneaSDZAFp4jByY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMdqx9OdHgeBsHVmuhGYDvVRraAM6JwTbIGfrqfzD5t6t/98pish0oJXdqo8mtCgya7JZcaXbIheFOYKzQLWfObmvz/vVSRbfeoXXYmdS5E2GFCMk7fIP7KembZaChIRhfcgMk+PeagzYfl34n4/q+3ZcmeGHMLemZB4P6NdGzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmtDXMzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmtDXMzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E086C4CEC5;
	Wed,  2 Oct 2024 13:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875564;
	bh=r2tU+QP6MFaTAtf69PmoH3yS+wwaneaSDZAFp4jByY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmtDXMzJuzI/yh0jCCqnXJDX7MGzXAB/hWSbXRioSCBUTuqrRFJnKiC4pzc8pyUxF
	 FysbnNLVwA8WezNmar0GZf8SKmEF3nLTduJwIvGDOEscnTpwO/8gZbyLQVRSsA48x+
	 ISUJLd3lUfyVy1DFjkDCeTCVh8xSKegNp/r1OpKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Dahl <ada@thorsis.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 144/695] ARM: dts: microchip: sam9x60: Fix rtc/rtt clocks
Date: Wed,  2 Oct 2024 14:52:22 +0200
Message-ID: <20241002125828.232136736@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 291540e5d81e7..d077afd5024db 100644
--- a/arch/arm/boot/dts/microchip/sam9x60.dtsi
+++ b/arch/arm/boot/dts/microchip/sam9x60.dtsi
@@ -1312,7 +1312,7 @@
 				compatible = "microchip,sam9x60-rtt", "atmel,at91sam9260-rtt";
 				reg = <0xfffffe20 0x20>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			pit: timer@fffffe40 {
@@ -1338,7 +1338,7 @@
 				compatible = "microchip,sam9x60-rtc", "atmel,at91sam9x5-rtc";
 				reg = <0xfffffea8 0x100>;
 				interrupts = <1 IRQ_TYPE_LEVEL_HIGH 7>;
-				clocks = <&clk32k 0>;
+				clocks = <&clk32k 1>;
 			};
 
 			watchdog: watchdog@ffffff80 {
-- 
2.43.0



