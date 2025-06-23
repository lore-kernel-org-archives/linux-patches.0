Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B089724E019;
	Mon, 23 Jun 2025 13:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684879; cv=none; b=DAAW2To5IVNfdXqIcJUdW/DddZUr4qV9SB/5k4HcsgzdlmfcatFWum4tNX2bf08YGPmwZA/3og3Z8T6kgoE1t5MEnEaY9k/6dUsYa/fu6ZgHzksO3AFyDMKg+ve02RrxoImCSx9i2ExaSVYijJVxQjr6A+koAq8YwlXzPu5a+fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684879; c=relaxed/simple;
	bh=jOVyoJspjLrw2isnVgjLgdZk7KhF0xh/GzcQIdk8vL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByktU16dlNNoYMvymffMPddxh1Pq97jFSGKE4Rko9GoxNRQHAs8ac0u1r8mL047JxwshytBhtwUP6tbFxSIXSHvqa6nQAcZ+nEM+1WWi89BWWNQ+pwRu4LAFS5HWkA4DMdU0/eRkvd6ib6jfBwykcmGLTxLXt5e+VvzZXXIm2v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L25nHSAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L25nHSAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463EFC4CEEA;
	Mon, 23 Jun 2025 13:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684879;
	bh=jOVyoJspjLrw2isnVgjLgdZk7KhF0xh/GzcQIdk8vL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L25nHSAs1rl3AQ/Ynis1ojnNoQHcxwjHMjGkJkA0f0M9xEH/yejJEGaMN1F7n44kf
	 zoZJHmyV5Locuw/nbdknsGFevkQUGrmR9pq3Ysby1ODsRoQAUj6kJAKZ/dCz7Y5EEg
	 /NWTe6oOD9iy/nIm3sNoxlPknoD/8RB21KQkXOIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/222] ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select
Date: Mon, 23 Jun 2025 15:06:17 +0200
Message-ID: <20250623130613.169567144@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 67ba341e57ab158423818ed33bfa1c40eb0e5e7e ]

Dataflash did not work on my board. After checking schematics and using
the proper GPIO, it works now. Also, make it active low to avoid:

flash@0 enforce active low on GPIO handle

Fixes: 2432d201468d ("ARM: at91: dt: usb-a9263: add dataflash support")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Link: https://lore.kernel.org/r/20250404112742.67416-2-wsa+renesas@sang-engineering.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/usb_a9263.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/usb_a9263.dts b/arch/arm/boot/dts/usb_a9263.dts
index e7a705fddda95..937adf3ed3611 100644
--- a/arch/arm/boot/dts/usb_a9263.dts
+++ b/arch/arm/boot/dts/usb_a9263.dts
@@ -58,7 +58,7 @@
 			};
 
 			spi0: spi@fffa4000 {
-				cs-gpios = <&pioB 15 GPIO_ACTIVE_HIGH>;
+				cs-gpios = <&pioA 5 GPIO_ACTIVE_LOW>;
 				status = "okay";
 				mtd_dataflash@0 {
 					compatible = "atmel,at45", "atmel,dataflash";
-- 
2.39.5



