Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447F52ECE9B;
	Tue, 17 Jun 2025 16:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177793; cv=none; b=IIvzAfw+TTSC10jt5CBt2ds+pxoqgDhAYWaFM75tHQhP7ShCu9+4NsphKh5kXl+/nj9AK8wydNJkffTlzmnpBDTVw94APMpnu4uGxwsuEzkLwr5T37DXeP2vSUJ3wJqj5DZ9Poy59szzCnAzVf1TdAoVEEnGrMWu4Tr5+1T1jr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177793; c=relaxed/simple;
	bh=o7BUGOQPzlk+xKY36HxfaUJ+jf95tpS6lWmJ0y7tlRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkrRO/Xeg+26aPGXG9UOuaQgGs6LO4aZ+LUTmFK95GwAFwH2pqzeBIQtgpz3qaDnu53eIQyuuq+m+xb9tE9W2vzZi7jSokMm2ktMLXtG8HJzJ+g+Qn6QCW2pZytFyRFppONWcfj20iYV7KjxF2hg4/4gKSjzz+yAq1PsvpfOhMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUX0p/Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUX0p/Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BB1C4CEE7;
	Tue, 17 Jun 2025 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177793;
	bh=o7BUGOQPzlk+xKY36HxfaUJ+jf95tpS6lWmJ0y7tlRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUX0p/OtHH8k5sLZkPt2ksoPcgBfomUducfONnO/vqo8j/nijzS8z/1rbuqaiLfYd
	 sBiHkSfmtEKQNHHkrAHcK5brkFWkqYL1siuiPc1ml7us6qN1/9myfhA4ScdIrauZMC
	 /WAGphCzoGkuNSiWFAuBmKO5g2zrNxRTcxvxXcwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 364/780] ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select
Date: Tue, 17 Jun 2025 17:21:12 +0200
Message-ID: <20250617152506.280612475@linuxfoundation.org>
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
index 60d7936dc5627..6af450cb387c9 100644
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



