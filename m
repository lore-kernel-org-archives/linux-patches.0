Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF54817BB21;
	Sun,  7 Sep 2025 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276880; cv=none; b=TEvf8PYgQT9lkvGarnGWICXSUKftxKVFsUEwnEzQPux6YJGcy07lY/6mVzqhz9ZSjUpkje4Cafv2So8K0sjj1UO9Vy/3b20j0xwh258WjntWcCpGBklPpg5LUJdDnFCpO+6RLXlho89U7sWKsdL46XTWXBnR3qjHC2NIz4IGq/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276880; c=relaxed/simple;
	bh=NaPrEL6TKgNOlka63iGj+CUPCHtV/lDLtmVC+K1MLGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owBJKW1FBr5OkJHfGc6XvK9dJCEhef++7fymOLZyXmJXVm4KwACUK3aSFhtOIZrQIDKN9+Nca3vJzmqsW0ZN4qLCAOoWofpiwF50T4LFZakgbmb728tUEzrmxchtK4ZoJKSGCg0LkbR5sBjpKNjiyR0yiezpfiOQA3OsZ6txnyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XI1Gg06g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XI1Gg06g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6ECC4CEF0;
	Sun,  7 Sep 2025 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276880;
	bh=NaPrEL6TKgNOlka63iGj+CUPCHtV/lDLtmVC+K1MLGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XI1Gg06gvnikER5gyCntL+Dn/ZQlCfORmRzwB6OagASzKdWl+EG4ewYEnIJsOPQSq
	 G9rnhSClSvO4oMVBpdtz0Empw8xNL/KFf1AzCD4R3nle7MoqJXn38GUQeJ8ueMxxZW
	 4i5gss9Be5biKAGCI8D13cb01DRch3HU1y4clYqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/175] arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3399-pinebook-pro
Date: Sun,  7 Sep 2025 21:56:53 +0200
Message-ID: <20250907195615.317510290@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit d1f9c497618dece06a00e0b2995ed6b38fafe6b5 ]

As described in the pinebookpro_v2.1_mainboard_schematic.pdf page 10,
he SPI Flash's VCC connector is connected to VCC_3V0 power source.

This fixes the following warning:

  spi-nor spi1.0: supply vcc not found, using dummy regulator

Fixes: 5a65505a69884 ("arm64: dts: rockchip: Add initial support for Pinebook Pro")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/20250730102129.224468-1-pbrobinson@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index a5a7e374bc594..a7afc83d2f266 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -966,6 +966,7 @@ spiflash: flash@0 {
 		reg = <0>;
 		m25p,fast-read;
 		spi-max-frequency = <10000000>;
+		vcc-supply = <&vcc_3v0>;
 	};
 };
 
-- 
2.50.1



