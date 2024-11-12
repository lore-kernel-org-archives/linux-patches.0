Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2374D21765C;
	Tue, 12 Nov 2024 10:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408088; cv=none; b=rImi8YVozn79tLMMyBDxWb4mgpRfOxRo2ub/P8bYCuOUt2zxks8XoxICHNVHDInKgX8tFghMn0iGJShs8OUEamcyQ6SZx5kGzN+fq7rYx9R/az08ZI2jZ53lEGYRDXh/kk4/VBoY1WcQ4YW54y5DTUML4C6eFPhqx9MBGmgdZps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408088; c=relaxed/simple;
	bh=fqwJ2nix1izA0wza+3iTiDITDeqIlNeyCrG7S6UvBmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlGWQRhpY6CNvCAXPxAeu6sQioXtUOyFk+ZoGJ2+8DMutvMvcFOz4ZaHh3NIydUrK0mhXYmPARZlk7uA92nnl3Nl1KDDtKTTOHieNJNTi6iKLFQqy7KbXk/t+Tbu5YpNbyTtK/mR66ASc7v9yVKPlU1fFWBQdcW00Z72AKDeP0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEahEriX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEahEriX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A533C4CECD;
	Tue, 12 Nov 2024 10:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408088;
	bh=fqwJ2nix1izA0wza+3iTiDITDeqIlNeyCrG7S6UvBmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEahEriXNaHQbk17s4NeEoL7eeVy6h4lDBPys0Xy5wstnVxpZYpvkvNLlqkbnEQ9x
	 qBlfppZRiBdYDtZb3cZHYQ30akenauFVqu8nW51JVVf5azvUkoCHbUO/t9uESRc60y
	 CwtIzIu2rVod9JtzxHmNw+/ESzNCHSpwaCMFYSwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 028/184] ARM: dts: rockchip: drop grf reference from rk3036 hdmi
Date: Tue, 12 Nov 2024 11:19:46 +0100
Message-ID: <20241112101901.947410492@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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
 arch/arm/boot/dts/rockchip/rk3036.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036.dtsi b/arch/arm/boot/dts/rockchip/rk3036.dtsi
index 37369538483f7..09371f07d7b4b 100644
--- a/arch/arm/boot/dts/rockchip/rk3036.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3036.dtsi
@@ -400,7 +400,6 @@
 		interrupts = <GIC_SPI 45 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru  PCLK_HDMI>;
 		clock-names = "pclk";
-		rockchip,grf = <&grf>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&hdmi_ctl>;
 		#sound-dai-cells = <0>;
-- 
2.43.0



