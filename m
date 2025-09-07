Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684B91CDFAC;
	Sun,  7 Sep 2025 20:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275681; cv=none; b=AlliHe6iAFc28StiYSZfDNQz/Tkd8C0cCtsNlBShNeabKXJSZxIMxQwimoZAUAeQ00foqjmvxR2fnH+pi3QfDugBvWhi5L02qZf36AOTmb48u7baTFaLlFHJniFdBVI69mIalSNp/Lf01oH0i0ev0W6YdrtU365f50TJwo4ClNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275681; c=relaxed/simple;
	bh=PIo3p6LJjFQZIb32pX5EWnQ0Vz1UIfi6AG7phU7SOLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlnvJs9kdfAQlGGiWvKeuvo1rDX0PHxfSTGWxXqSoTLqotb4matrSm3/oI+7pj1GSL86RMhJYIzcFYSj3eI9bwOHwMQDd81gXwn/rh2agiWGMl7mUHGaT0t2UVjNusHbrnHDcxJJJzNPZx9zH3KA3ExvTZaE3CAFxeomyaf83zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aL02/adA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aL02/adA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33BAC4CEF0;
	Sun,  7 Sep 2025 20:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275681;
	bh=PIo3p6LJjFQZIb32pX5EWnQ0Vz1UIfi6AG7phU7SOLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aL02/adAdntWyHu9t+C7AVH9LVZtoY5xJcrJj3aHPp0LvSvYdXuB4z7RMtDKJTSwV
	 rFzZkVA7l8uVYsXPRhOdxGDgNbfnUe8Pi2iQqi8XU2EbQshzMlRCuvjLX7IuIWQJhS
	 YvRmKpV1tVPxFM0+EQfvDQdxl/FD5XSFLAMfxneI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 03/52] arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3399-pinebook-pro
Date: Sun,  7 Sep 2025 21:57:23 +0200
Message-ID: <20250907195602.065185640@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195601.957051083@linuxfoundation.org>
References: <20250907195601.957051083@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 015e004bf275c..3dd00ce201f54 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -972,6 +972,7 @@ spiflash: flash@0 {
 		reg = <0>;
 		m25p,fast-read;
 		spi-max-frequency = <10000000>;
+		vcc-supply = <&vcc_3v0>;
 	};
 };
 
-- 
2.50.1



