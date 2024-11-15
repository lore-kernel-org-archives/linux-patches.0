Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C167C154C00;
	Fri, 15 Nov 2024 06:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652962; cv=none; b=jm9whuJuWELaSi7qmnVErdaDBtybUs+s5QNkM9D2KYheVLVxfclO58rx7rRu3RZjBHajti+Mx5AMX03p/b07OucAVXtSnNUSkjrAyz6mmRuTUy9x/NWX4KiqqcPshqOuBYmcvOs5mxJpclUEXtD0NQrpXsXIH27TGn8jq1TDAOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652962; c=relaxed/simple;
	bh=+JakNv1EF51vA6BFC1yz8i+or+QAA0rd3EOsglG1aXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWbDrwnOzOuobrmVVYP0s0tgIF3JlyQUP2I/is98gVk5+qu8QLf1RLrrQWNRmDrZdf4jkMUt9aTEL2mO/gXLPDCxHffBJIDDi94y3kAzaa3uy3e6tGXn5TsKu1Xyn3JkvEgUcyG8h5m9GoRu6FUwxOPTpcGq7rOmael+e/ntlOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1rzLWN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1rzLWN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30AE4C4CECF;
	Fri, 15 Nov 2024 06:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652962;
	bh=+JakNv1EF51vA6BFC1yz8i+or+QAA0rd3EOsglG1aXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1rzLWN+9cWri299BhAFAcCPrjWkswTa7llEVMwYunzAOIk2Bh0UG1zRyZgeGJv4q
	 hyzwSduGJjLFrJ+aw9s6pB+Dw/dLkuzyBy0dN6ZtAFbc5s01MbbAdctO21+aCwj2f3
	 nW/cosd/3ezWlBLoglWEMsIXBy78byKe5fulqQEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/66] ARM: dts: rockchip: drop grf reference from rk3036 hdmi
Date: Fri, 15 Nov 2024 07:37:15 +0100
Message-ID: <20241115063723.069803182@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 69ca841d57e75..7c031260186db 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -333,7 +333,6 @@
 		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru  PCLK_HDMI>;
 		clock-names = "pclk";
-		rockchip,grf = <&grf>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmi_ctl>;
 		status = "disabled";
-- 
2.43.0



