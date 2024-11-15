Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2054189528;
	Fri, 15 Nov 2024 06:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652841; cv=none; b=NkAaNBKiTGZkILvi6Jbo8xMB7Es1YPoEGR7ZHHhFxPlkU4vlyNbVstFO3eJGspnSxDyUaeE+tSMj1FEfRVYsRML2rW62mmoZcB3/F2XWHbHq4Vilb1cZGs/Pn4F/B7JJmeEuXtS9RrvIQfNaR4PjL7qI6Cels3pHTROAlthrEqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652841; c=relaxed/simple;
	bh=egZM142mbwDCiMZsECbq+iSg1+/gWhfHVQE+J1+m5wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mSip+/wtLmZ6nJRF8dMRfibvyFkdX09/st5iVURPEXUYutCRanelSdg3jV7Q7WABu5qo+zYlyk20KeSqT5vQ7oAyEyuZ3G4lrquB0hWseu3ISab+dDrQvRY204yBT4PxbzvrMk9rKN9RU9iveAtWswhb9z5e9tSiCe1COjoNn54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rkt9QOmW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rkt9QOmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268B8C4CECF;
	Fri, 15 Nov 2024 06:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652841;
	bh=egZM142mbwDCiMZsECbq+iSg1+/gWhfHVQE+J1+m5wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkt9QOmWj2Fc4o6eMEPRaN23imLO9zWJ6LcYhAAwK0a92513Q3mUUzvenhEGM9CCK
	 E8XNf1qBFVMqf15UjkvuLaDrI98gT33tvN5A6Q5j7HtjRAn8woQMo1hV8vKgAfl2AG
	 itnxS0KJXKiPOeX13bBJ53K1VntpZ9+4Wijcfxwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 03/52] ARM: dts: rockchip: drop grf reference from rk3036 hdmi
Date: Fri, 15 Nov 2024 07:37:16 +0100
Message-ID: <20241115063722.975246420@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 1580ccb6ed9dc76b8ff3e2d8912e8215c8b0fa6d ]

Neither the binding nor the driver implementation specify/use the grf
reference provided in the rk3036. And neither does the newer rk3128
user of the hdmi controller. So drop the rockchip,grf property.

Fixes: b7217cf19c63 ("ARM: dts: rockchip: add hdmi device node for rk3036")
Cc: Caesar Wang <wxt@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-13-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index f7b5853aeb79f..9e30c726b7082 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -332,7 +332,6 @@
 		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru  PCLK_HDMI>;
 		clock-names = "pclk";
-		rockchip,grf = <&grf>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmi_ctl>;
 		status = "disabled";
-- 
2.43.0



