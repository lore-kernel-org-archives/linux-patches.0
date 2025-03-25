Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F15A267F6B;
	Tue, 25 Mar 2025 12:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905873; cv=none; b=u7S2zwy9ifQyJmuz130PmE3LsPDcANt06GZEbpWQubdaI26N6FwwqNk47RdRShapoX35O3+ADqVToDyHqfGxDZ+QyYnCYVognaAqvhBnmG8GGuUh8tnTI15VqX95QJc3i4UxRDzuQTvdRphocC/F87pldtC33euZAgrzeVyuqIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905873; c=relaxed/simple;
	bh=E+kkx/rMhLfn3qBG+Y9J/OBMCxDATbhjEDqFGAy2Cwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gd6M4IqUTLWTHVzeE7KSdy3rlOvuveVC9brY/QQU6YNuthTviSdLcenebrvXcLuJCjBGkmW93yVlH+4Mi8KNCc/bFpwpIzVYhwcnCoSqZsjDb4u4UaOSq1J5viQutZovsc22+Mv+pCSgOfpKt69+Jwtwuv8cp1jpJj4BTkambZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bScOzbRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bScOzbRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54104C4CEE4;
	Tue, 25 Mar 2025 12:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905872;
	bh=E+kkx/rMhLfn3qBG+Y9J/OBMCxDATbhjEDqFGAy2Cwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bScOzbRo99EhGmLghL8UO82eICEOPo7AV5CoMDH/tU6E+7Ey3jGnPIQTVYNMsoF7/
	 Zuiw4jtatPikpxN9uKmvjgCHG6zeqMQKPTzAVI69IYz6NUMBCWDF6CRzbsYvQYo7iv
	 UK0H7hn1jbm1reoMxpQtmcAHdUmuluwTP6d0MPzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 011/119] ARM: dts: bcm2711: PL011 UARTs are actually r1p5
Date: Tue, 25 Mar 2025 08:21:09 -0400
Message-ID: <20250325122149.349583112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 0de09025f161f67c07978c4742e221243d070d41 ]

The ARM PL011 UART instances in BCM2711 are r1p5 spec, which means they
have 32-entry FIFOs. The correct periphid value for this is 0x00341011.
Thanks to N Buchwitz for pointing this out.

Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20250223125614.3592-2-wahrenst@gmx.net
Fixes: 7dbe8c62ceeb ("ARM: dts: Add minimal Raspberry Pi 4 support")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm2711.dtsi | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2711.dtsi b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
index 5eaec6c6a1df3..4fd0732a34d32 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm2711.dtsi
@@ -134,7 +134,7 @@ uart2: serial@7e201400 {
 			clocks = <&clocks BCM2835_CLOCK_UART>,
 				 <&clocks BCM2835_CLOCK_VPU>;
 			clock-names = "uartclk", "apb_pclk";
-			arm,primecell-periphid = <0x00241011>;
+			arm,primecell-periphid = <0x00341011>;
 			status = "disabled";
 		};
 
@@ -145,7 +145,7 @@ uart3: serial@7e201600 {
 			clocks = <&clocks BCM2835_CLOCK_UART>,
 				 <&clocks BCM2835_CLOCK_VPU>;
 			clock-names = "uartclk", "apb_pclk";
-			arm,primecell-periphid = <0x00241011>;
+			arm,primecell-periphid = <0x00341011>;
 			status = "disabled";
 		};
 
@@ -156,7 +156,7 @@ uart4: serial@7e201800 {
 			clocks = <&clocks BCM2835_CLOCK_UART>,
 				 <&clocks BCM2835_CLOCK_VPU>;
 			clock-names = "uartclk", "apb_pclk";
-			arm,primecell-periphid = <0x00241011>;
+			arm,primecell-periphid = <0x00341011>;
 			status = "disabled";
 		};
 
@@ -167,7 +167,7 @@ uart5: serial@7e201a00 {
 			clocks = <&clocks BCM2835_CLOCK_UART>,
 				 <&clocks BCM2835_CLOCK_VPU>;
 			clock-names = "uartclk", "apb_pclk";
-			arm,primecell-periphid = <0x00241011>;
+			arm,primecell-periphid = <0x00341011>;
 			status = "disabled";
 		};
 
@@ -1178,6 +1178,7 @@ &txp {
 };
 
 &uart0 {
+	arm,primecell-periphid = <0x00341011>;
 	interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
 };
 
-- 
2.39.5



