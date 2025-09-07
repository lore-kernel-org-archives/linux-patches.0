Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE25189BB0;
	Sun,  7 Sep 2025 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276484; cv=none; b=X16jTViLFJorJrIBycZ33cqjQPkOwixZSXBDnZQUAUOc2xYMXmcOh33StC/llPX9x2n5M1iEjrsodXrzZpNelf3wIxL0JCfFZyVC23sT9MrFoN6Zx2ywK60xFrWkg8p5PO72Eyemf4l9czWnfYAvYaqwpJ/6BR9IlhcAcaBa9Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276484; c=relaxed/simple;
	bh=T+Ajl1m02/JRXO1r5Dz8OkOh6MvBtMjw4cPdrGHcWoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ll+Kx2Vyrt1AOQe7fiCLUgcG+o4VMc8dxdypNl3HETgaWK6O8V0QQxX+rH9qZBMFMFBFvfO1mkQRUtNmkagBdtL8vjB23SSGr9JR1l8iSSm/fPz/uNC3lYHDQ4WJbTdtmmc2crtoCavHjqjwKqtQu1++PcpNgnm/7KPk3be9FKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMmnErdC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMmnErdC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2187CC4CEF0;
	Sun,  7 Sep 2025 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276484;
	bh=T+Ajl1m02/JRXO1r5Dz8OkOh6MvBtMjw4cPdrGHcWoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMmnErdC+0g3ZnP2F7jwTU7LE+EHzGmYDxMjkA1rolQMjALN0r/1VjDwAhPdI9u3N
	 NP0cfpvjtQ4Mhxs4FmWdS/rASdJnlM20WICX6k78+kygMQ+TYO4JFeAcagFABsG+oZ
	 KGCFQyaZatxnOCFh5wOuZoIgdIbFmiWaSlzMcUEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/121] arm64: dts: rockchip: Add vcc-supply to SPI flash on rk3399-pinebook-pro
Date: Sun,  7 Sep 2025 21:57:31 +0200
Message-ID: <20250907195610.203187259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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
index f5e124b235c83..fb3012a6c9fc3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -967,6 +967,7 @@ spiflash: flash@0 {
 		reg = <0>;
 		m25p,fast-read;
 		spi-max-frequency = <10000000>;
+		vcc-supply = <&vcc_3v0>;
 	};
 };
 
-- 
2.50.1



