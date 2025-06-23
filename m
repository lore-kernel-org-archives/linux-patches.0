Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B163F4C6E;
	Mon, 23 Jun 2025 13:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685577; cv=none; b=haM1QtorS4R8cdafUjCgJCg6DwLAD5aYbgR1SOGIyk4RDk+Er4tSoewC1wxMd/4kd31iJjaSJLMdyYbjpfdCtq8Tu+uHSwsgkZ06ebAANz8wRsUrewv6ovbAnSJcS1Z9uIuZG/C9pRwcbRX09YVgXM7T8PVlpMnkXkeCoSOUX9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685577; c=relaxed/simple;
	bh=Qpf032d/LevHgfNKcgssQC73OnXLmzzWu+itWnDm4PA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQEEK4bHPsseBfY6GOoVCHnnqV1o8/At7tjvkjga736mCGbvvUhM8GHz+yAgnoiJNeRVWbaBbPSc26rM8U0f5B6fCw94j8bQi3rDNoP+Rn5+rPQQ7wVgVNKSbW4JxfTjHXifmgGBs5UFIwZWNJEFXEDn6lSWoda+714ez9vqInM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0LIzeHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0LIzeHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A72C4CEEA;
	Mon, 23 Jun 2025 13:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685577;
	bh=Qpf032d/LevHgfNKcgssQC73OnXLmzzWu+itWnDm4PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0LIzeHGxakZjLRjeavgEJjn4BqIBZ28bym5jsnzdAF23z7skGLSAfU75irkxE0jf
	 G+zi0GW43HNpErbVTdAHbbIdTOOCRGkmMmCUoO7ZWKiEOByhLtWX0c1ZFB90TuUv+4
	 48aylWX5f+hYrRUEzx8IxLcxppgH4BF6h5Xd2kQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/355] ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select
Date: Mon, 23 Jun 2025 15:04:21 +0200
Message-ID: <20250623130628.627646645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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
index 8a0cfbfd0c452..d1c07503ff76f 100644
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



