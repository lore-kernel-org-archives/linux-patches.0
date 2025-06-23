Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211C52F24;
	Mon, 23 Jun 2025 13:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686020; cv=none; b=jWhLyH72/hc8a+a25RErQKPZIvFNEAUsBOW5EgGSAewqcS5pQG5GSDAJPCm750ifxt0DalVDChpHMHYO+iBm9mDpMp9sYxWcS4uRPDRQ60KrxfG3BaW88ksF7wOBE879CdGvg19F6L/Ic1cfXB2+0tlHvuJEi9idnVC8G/TaT3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686020; c=relaxed/simple;
	bh=KbxM3hJkyjpn1JNZuxjD3OxPKorwoE6WgXSmNZUGWtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4e6x1N4WNq+4PdO97uZFW7BkUK1VDQvx2L4aecSm61Xxmd/im4fRg6NNf6B5rCrwrdme71hOrnCOlgjqw6jIsqdd6LYmD7vwjEpS7XyFjB0GW9CDlPD5VTn8iVraE0C3rl77ntmAtIRGZ9k9KKwnGBsOrv+7HDFxWKZzrNgFas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6wpZ+kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6wpZ+kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D03C4CEF0;
	Mon, 23 Jun 2025 13:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686020;
	bh=KbxM3hJkyjpn1JNZuxjD3OxPKorwoE6WgXSmNZUGWtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6wpZ+kEcIapZEkHbieg9r/7YyK5MBKCNEJgle+ir8rVT4oYriCcS0BEkzr2ewiKU
	 GiTZp0PVnxNow4gx0AOrdS31F+VvSZNeC1NUCagnj0RLwwzHiuYH9Ob+T7ugJla3UH
	 Lk1LtbH2BRevRO6HgGR/KYeDPia0bSjKFyIc2Bpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/411] ARM: dts: at91: usb_a9263: fix GPIO for Dataflash chip select
Date: Mon, 23 Jun 2025 15:03:39 +0200
Message-ID: <20250623130635.256424718@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



