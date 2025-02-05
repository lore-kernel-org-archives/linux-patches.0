Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD085157465;
	Wed,  5 Feb 2025 14:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766796; cv=none; b=ALx8PmzGhR8dcUCzFEPKERqSYaMdPV6ZEJx+2DXPFp1GJ9bSBoucD9cns7nwzAbHl3SdwQ1+nfxY6kxKq42IIlkl4nNwubkgE8a7sgnMgN5jTWmQM2ZpNTyW96PaGUs0ZKY94aKfhcvEn3ZQVNjwmQ1CgWUZLuQZVUQ3ObgWuyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766796; c=relaxed/simple;
	bh=TX4ZnJFmY6whwAFMv3U5aCm/euirC8WI2L1ikrWRfw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tr5MVkX34kpbAG4utvVZnmycULGNsVoWV3letkyO6G/rQrEoVQXMPZBwNDo39O6i/SYFuiTkQ2mXdPYTCHPx/n8NH10PxVk+HNwI+yKLaJTxfZBzgikGsdtSM8SME9b32ZxyHP/eD1NlXqNLZjwG3LEzW+YaRdINSu8f1Jt2q78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WBZobzX6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WBZobzX6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354D0C4CED1;
	Wed,  5 Feb 2025 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766796;
	bh=TX4ZnJFmY6whwAFMv3U5aCm/euirC8WI2L1ikrWRfw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WBZobzX6UfNmfUwdZyA8onTk6YpZ3tlKJRSYrxG7FtpfJA6fiWc2POR68t5/mGWbe
	 z9V2vmqinsM499a2LWS9nV/8gYj3zZjNVFVMyENTVU3qE9Hz7TdzNHVu3JTYobbKdk
	 EHEkh09AqwJOQN+WFbYOrduOfu4xwewFvWUZg/C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mihai Sain <mihai.sain@microchip.com>,
	Cristian Birsan <cristian.birsan@microchip.com>,
	Andrei Simion <andrei.simion@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 362/590] ARM: dts: microchip: sama5d27_wlsom1_ek: Add no-1-8-v property to sdmmc0 node
Date: Wed,  5 Feb 2025 14:41:57 +0100
Message-ID: <20250205134509.120052175@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



