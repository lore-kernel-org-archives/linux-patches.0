Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A54671863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A69BC433D2;
	Wed, 28 Dec 2022 14:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239519;
	bh=+Y2k4XNb1phLqqeVeTe/06TPXKKCp5VXlH2m2UFDNVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0gjXlFOhAII+XO1dsXHn090G/ZRkFN8T7EH0M4fV7VOg/ZG8NqhNz7jRHgM8MYhn
	 a13L8NDYqiD2FY4Sqhl9uGGcc+EaQKmP5y1aXetw/NLxQG5C9Gs6OEa23qfcnMkmkP
	 EhN00EUy2jNbwqVFX7XlNi5QBGCrbHww+HiWwd/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0045/1073] arm64: dts: renesas: r9a09g011: Fix unit address format error
Date: Wed, 28 Dec 2022 15:27:13 +0100
Message-Id: <20221228144329.346677509@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabrizio Castro <fabrizio.castro.jz@renesas.com>

[ Upstream commit 278f5015a3deaa2ea0db6070bbc2a8edf2455643 ]

Although the HW User Manual for RZ/V2M states in the "Address Map"
section that the interrupt controller is assigned addresses starting
from 0x82000000, the memory locations from 0x82000000 0x0x8200FFFF
are marked as reserved in the "Interrupt Controller (GIC)" section
and are currently not used by the device tree, leading to the below
warning:

arch/arm64/boot/dts/renesas/r9a09g011.dtsi:51.38-63.5: Warning
(simple_bus_reg): /soc/interrupt-controller@82000000: simple-bus unit
address format error, expected "82010000"

Fix the unit address accordingly.

Fixes: fb1929b98f2e ("arm64: dts: renesas: Add initial DTSI for RZ/V2M SoC")
Signed-off-by: Fabrizio Castro <fabrizio.castro.jz@renesas.com>
Link: https://lore.kernel.org/r/20221103230648.53748-2-fabrizio.castro.jz@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g011.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g011.dtsi b/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
index d4cc5459fbb7..4ce0f3944649 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g011.dtsi
@@ -48,7 +48,7 @@ soc: soc {
 		#size-cells = <2>;
 		ranges;
 
-		gic: interrupt-controller@82000000 {
+		gic: interrupt-controller@82010000 {
 			compatible = "arm,gic-400";
 			#interrupt-cells = <3>;
 			#address-cells = <0>;
-- 
2.35.1



