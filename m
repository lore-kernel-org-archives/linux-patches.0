Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D63262EE602;
	Tue, 17 Jun 2025 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177928; cv=none; b=AXjQo4j/O+dPouKKweLfbodeoGHxymokKKytOI7F7l1kinJo2H+4IG7L7Z56Un4ZldOEC9NFl8hM8HdhjazAjwxmxU0nwkFhWiuqP5Vtv488vbzKb4zvpsFqJRQIKvMFMk+sw49bQTFV0WSLEvz3JpeJKOBkEDWxqoUzeg99LXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177928; c=relaxed/simple;
	bh=12S2OnAR81ngcj6IMFG6MgKweGS57sPPT5CuBf2vluQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceuhUoYU+HEwoVz0uM1RvNa8lnfIexEzW1XGHjPGyAmyy2B/mC0YFws6wYJzxiAO85dQ/9ivwY1AP4IFs7NHv3aqxMut3jcZsh3BwmYlvWtdtrpULDvAHYNEO/qjjXRZNVjeLNorFOfvKNjvVFMWYsd8HITD1zMp3ZpYOQAzB5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQOnSHrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQOnSHrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EAFC4CEE3;
	Tue, 17 Jun 2025 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177928;
	bh=12S2OnAR81ngcj6IMFG6MgKweGS57sPPT5CuBf2vluQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQOnSHrfa39MCsDBungGNvi0q6zy6Z0Po4Fa9tPJeq8Ddv3FNiQ+Ltop4z8wWx0r4
	 yxDYZZmwSe6LGldzDbx74RdjnbZmvZyW3D29gGaklP07GlCAfaT5vfE+xFzDD/7TDC
	 p5XtgdzT3pVJW4beMnNMQXKq+nurplzyOThQyrSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 384/780] arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3566-rock3c
Date: Tue, 17 Jun 2025 17:21:32 +0200
Message-ID: <20250617152507.099795188@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit a706a593cb19796f31d3a888423ef1a71885ae72 ]

As described in the radxa_rock_3c_v1400_schematic.pdf, the SPI Flash's
VCC connector is connected to VCCIO_FLASH and according to the
that same schematic, that belongs to the VCC_1V8 power source.

This fixes the following warning:

  spi-nor spi4.0: supply vcc not found, using dummy regulator

Fixes: ee219017ddb5 ("arm64: dts: rockchip: Add Radxa ROCK 3C")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20250506195702.593044-1-pbrobinson@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
index 53e71528e4c4c..6224d72813e59 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
@@ -636,6 +636,7 @@
 		spi-max-frequency = <104000000>;
 		spi-rx-bus-width = <4>;
 		spi-tx-bus-width = <1>;
+		vcc-supply = <&vcc_1v8>;
 	};
 };
 
-- 
2.39.5



