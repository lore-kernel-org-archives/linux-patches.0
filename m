Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A101DF246;
	Sun,  7 Sep 2025 20:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277516; cv=none; b=GkaeWzjG/G4R4mHWznvDdyRZq5zghNxB+LCs+tKAFxfxTpQ7OsblWWKIPodYVqjMcpbz0XQy7O8N5jZ2i7rbtQoaN1nikYNlULjancYlvF8pzovuvhoWcUDeDb5b0dsMaMJH51cKLqmoROqeiFaB5R9CwLf1PDcnZdIZQebOqrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277516; c=relaxed/simple;
	bh=IOneR6NCt33/Xp/FVrn56JnNv2nOmkOw28BHeFXbGU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRz3C5w+uX0AUu8jufYKd4WnylE7xnwlFqweMyK/PK6hPBrbzdoUAwp3iBHxajzXHfLnkpi46fTRlRGotzQgzC07Jl6Qvny347i4WhgzJgxhJ6gj9J690VjGYT8eD7WMBCu/SpnAYK7IVeKhrsJMnEhMT/hh3Yj9HR13GBedwQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZpDGQ1B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZpDGQ1B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6C3C4CEF8;
	Sun,  7 Sep 2025 20:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277516;
	bh=IOneR6NCt33/Xp/FVrn56JnNv2nOmkOw28BHeFXbGU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZpDGQ1BLM0PwL14kDX0MwAcgyJWRJL+8n1WZimbxLwGj3NMDH1HRqWpbItFrLP9J
	 LfEuo2kjDqYLdi7qo2Etw2gjTEKeEtJ2iSt3lbpDchuChZooFwkzU64kxc0nN0jZ/8
	 28aElmCrkl9OB9IYIYdsuZuryYtGCys2QhZSrbm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 022/183] arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3399-pinebook-pro
Date: Sun,  7 Sep 2025 21:57:29 +0200
Message-ID: <20250907195616.309340525@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 5473070823cb1..6cadde440fff4 100644
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



