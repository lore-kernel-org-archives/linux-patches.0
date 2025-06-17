Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C772EBDCE;
	Tue, 17 Jun 2025 15:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175320; cv=none; b=JsnJwgFlcETbzPZW8jS7Log9+2HWdFKy0Gq31WHhC2YuSZKPTifdbUSxbQIrBnntzi8leRMQgur6dYxZHvb4qoLDeocfsnViWt3WjHIvdqWFyfKTbfYSemPxHTY6T4MEuxKEuSSsjsBPKM5toUR725H9zpw1WiqU+oeNcjw9O4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175320; c=relaxed/simple;
	bh=RYpmZ/f6OLJULaSoquh4eNKFrfMNPJXyInN/x8c+MUY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3882xDmVUk5l0CxnNf9kePzwUgB7ex8MO1jx7m2k3I+5mqSjI5bbYJJgUlcu7dUhv4rHyvfQ8aX25xms86014TUQY2YyPUQGjpkK89DePQf6Xy3nQFOZrlDyHnPF9cFRJXfU+W9YvsIZU9bKvYEDVZufzBSCYk1X1FMraqLN4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TTJH94SD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TTJH94SD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 134A3C4CEE3;
	Tue, 17 Jun 2025 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175319;
	bh=RYpmZ/f6OLJULaSoquh4eNKFrfMNPJXyInN/x8c+MUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TTJH94SDQjRzIP4gncH6Q3Ff5vvESxx7pNFPtNArkt15Eu9eKlX7XKDHAHPvl4C4A
	 sdTRk52zMaOz/z1SVqiH2Nu4p+Eu1KYKLzIBt2vMEb3bBH+9dAa2wzMJGkdDV/JZ9x
	 nfHtC4cCLmMCB5aM6wV5oIvovnSLpEIEZ9quPZqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/356] ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select
Date: Tue, 17 Jun 2025 17:24:39 +0200
Message-ID: <20250617152344.818205771@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
 arch/arm/boot/dts/microchip/usb_a9263.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/microchip/usb_a9263.dts b/arch/arm/boot/dts/microchip/usb_a9263.dts
index 45745915b2e16..25c643067b2ec 100644
--- a/arch/arm/boot/dts/microchip/usb_a9263.dts
+++ b/arch/arm/boot/dts/microchip/usb_a9263.dts
@@ -58,7 +58,7 @@
 			};
 
 			spi0: spi@fffa4000 {
-				cs-gpios = <&pioB 15 GPIO_ACTIVE_HIGH>;
+				cs-gpios = <&pioA 5 GPIO_ACTIVE_LOW>;
 				status = "okay";
 				flash@0 {
 					compatible = "atmel,at45", "atmel,dataflash";
-- 
2.39.5



