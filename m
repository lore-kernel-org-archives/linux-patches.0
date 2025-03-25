Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D64F1E5B91;
	Tue, 25 Mar 2025 12:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906144; cv=none; b=ZsKBdG/6Xiqm1klgQ6Kr5GBCnIVUJLWKvXUxD+JMwBK6UF5Rv6YfLyjFwxbDCIC9BvpijS9v9p91OJ0SVrwtB+mTuL3PkuMq870KTTQnRpYPAV+BcoF37Jrqhg1cc4/o8OFPoqXFHTvDF0o7nUPAxSV3TkRd4LO1E1bd8bOJgY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906144; c=relaxed/simple;
	bh=XVaCi6noxPjPlntQTkwEBpcCzwkp+TyBkQXwDuzAgGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPXVZN6OuBpyEKzPinA6VmlVDUzYMVQfFZlcrup0sDoXz9lNPAVjpdIS2FfASZPwdkdD9jKHmMGPcoZjA3ZWHVucPiRYoOTg4SM9wfJbDWm1ZOPGc/LPpYP06qqAl1em2l1mVgkaaht5pj/1QCQ8BtfWviur6G6KJU1j4LQdLtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmiYE7vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmiYE7vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27102C4CEE4;
	Tue, 25 Mar 2025 12:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906144;
	bh=XVaCi6noxPjPlntQTkwEBpcCzwkp+TyBkQXwDuzAgGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmiYE7vdkB1j7qdeb1zXELgQR2pFkpmjqxHxttPBFooiVC568r7Ogz231iIowvTq8
	 Bf8cVgivX4WpUajcTKosnsNAGqZgh/SfEAQmD6DLZSkM5GCrohQycv59VzXkVXjkll
	 zSoYWQKWgTFov6Zd3MjvtFt7789inBv8pJZbH7sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Elwell <phil@raspberrypi.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 08/77] ARM: dts: bcm2711: PL011 UARTs are actually r1p5
Date: Tue, 25 Mar 2025 08:22:03 -0400
Message-ID: <20250325122144.530574052@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a379a14966d8..676a12b543557 100644
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
 
@@ -1155,6 +1155,7 @@ &txp {
 };
 
 &uart0 {
+	arm,primecell-periphid = <0x00341011>;
 	interrupts = <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>;
 };
 
-- 
2.39.5



