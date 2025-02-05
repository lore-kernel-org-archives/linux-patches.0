Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ED01519BE;
	Wed,  5 Feb 2025 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765285; cv=none; b=oCODzmQlrPICf5vbXAL4NQKkfPNTHtgJdKRbnU6H9O+YOa59UOWqCF2+hE093TtJnKAip+zETxJ6vOqUMe2Y0Pvs+b9SnFXHwSphAH4wkRKukAgS+9OIgbfaYPXbsIH/2w9TMbfJA/TY5Q+ZvFE6lm/aM3Wq991dftfDUOKXNts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765285; c=relaxed/simple;
	bh=fANy96USdNhBoxC0JaaHN1A5j6+R2Nc7BsCKA8uV4f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NmpLHUCGJNtbFN4ckm95/1D3sO1cBgNrRPh4SSRoj/9TneiOnOHl4ha5ZnIYP87QvVQSpiYAxJ8CJwUNYuYzvI3oRQcFB1KgO3H83b5tq3yOH5c45xzWHjHhoJyE+GhXcuz1W6T3uz+I0sff2ujXJmiAm88XYj6nV/ugIXyfKPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9ksUhhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9ksUhhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1314BC4CED1;
	Wed,  5 Feb 2025 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765285;
	bh=fANy96USdNhBoxC0JaaHN1A5j6+R2Nc7BsCKA8uV4f8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b9ksUhhsrtnbXYlBNVrm+Mzk95aw/HlpN8hHpq6vbHUnsqNx6tLaJjPilJLZfkcFO
	 O2q1y7/JZoJxev3e9RxV0NhjNsqmXtW2AayWoWRTTA2DsqVKnqIBXNLZpUdK2DmGty
	 e+Lpb+5XoMTO7a5PB/lkywUhUZUZMG+Oj313EF6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Andrei Simion <andrei.simion@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/393] ARM: dts: microchip: sama5d27_wlsom1_ek: Add no-1-8-v property to sdmmc0 node
Date: Wed,  5 Feb 2025 14:42:49 +0100
Message-ID: <20250205134429.872567153@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

From: Cristian Birsan <cristian.birsan@microchip.com>

[ Upstream commit 4d9e5965df04c0adf260c3009c55d5fe240f7286 ]

Add no-1-8-v property to sdmmc0 node to keep VDDSDMMC power rail at 3.3V.
This property will stop the LDO regulator from switching to 1.8V when the
MMC core detects an UHS SD Card. VDDSDMMC power rail is used by all the
SDMMC interface pins in GPIO mode (PA0 - PA13).

On this board, PA10 is used as GPIO to enable the power switch controlling
USB Vbus for the USB Host. The change is needed to fix the PA10 voltage
level to 3.3V instead of 1.8V.

Fixes: 5d4c3cfb63fe ("ARM: dts: at91: sama5d27_wlsom1: add SAMA5D27 wlsom1 and wlsom1-ek")
Suggested-by: Mihai Sain <mihai.sain@microchip.com>
Signed-off-by: Cristian Birsan <cristian.birsan@microchip.com>
Tested-by: Andrei Simion <andrei.simion@microchip.com>
Link: https://lore.kernel.org/r/20241119160107.598411-3-cristian.birsan@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts b/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts
index 15239834d886e..35a933eec5738 100644
--- a/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts
+++ b/arch/arm/boot/dts/microchip/at91-sama5d27_wlsom1_ek.dts
@@ -197,6 +197,7 @@
 
 &sdmmc0 {
 	bus-width = <4>;
+	no-1-8-v;
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_sdmmc0_default>;
 	status = "okay";
-- 
2.39.5



