Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB7A2DFF20;
	Tue, 17 Jun 2025 16:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177803; cv=none; b=fOxHe34bfPQ3Y59TwMG0afII4IfdQS3cbZKw/l6BgxdNW3/djotRCYptIAHCln6gaWnEDP8sNZHwYFJuDyHVFh/GP7m+HS5FZcNjTPUEN5/XfiFtowgaKNQMMOKg/FM1gJx4lgACJMv3s1SrRTlj/GpLrRDI4ZbeosBuWAKLsdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177803; c=relaxed/simple;
	bh=3pV6C4gV7w533UGQDjcH7Bv2fYKkxk6hXjaEEchwFoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+Oo7BZcijnSCtistenEUEaqi9IQbtITY7Gypnx7b1w92wfW9n/mVUsGRUdQLvdNWOsaaS7707DGzVwYrvLIBP67yA9pJdtRGdnX3qJDGZAkiWx3n7IJM8otfzeUvFAT3WAEnpxfXaVmIEy9o8d95JJKnqTpAgIHy17D5V1lJNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KU4R6MnJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KU4R6MnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AADC4CEE3;
	Tue, 17 Jun 2025 16:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177803;
	bh=3pV6C4gV7w533UGQDjcH7Bv2fYKkxk6hXjaEEchwFoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KU4R6MnJW6jaF8FVwNABNVDFafNpAptsnMXitPngt0f7GmyxbFCXTlZllRpJyKBQe
	 GnevoTzWWIvXo6sffDfn2chuZ3a05ylAvgu5bKabTh36K3xNKcQHjnsrpMNBCIx7uw
	 uGzCsRtUefIDSXwJUzXZhuKdbVzX28ErYwg1SXWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 365/780] ARM: dts: at91: at91sam9263: fix NAND chip selects
Date: Tue, 17 Jun 2025 17:21:13 +0200
Message-ID: <20250617152506.320137667@linuxfoundation.org>
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

[ Upstream commit c72ede1c24be689733bcd2233a3a56f2478429c8 ]

NAND did not work on my USB-A9263. I discovered that the offending
commit converted the PIO bank for chip selects wrongly, so all A9263
boards need to be fixed.

Fixes: 1004a2977bdc ("ARM: dts: at91: Switch to the new NAND bindings")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20250402210446.5972-2-wsa+renesas@sang-engineering.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/at91sam9263ek.dts | 2 +-
 arch/arm/boot/dts/microchip/tny_a9263.dts     | 2 +-
 arch/arm/boot/dts/microchip/usb_a9263.dts     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/microchip/at91sam9263ek.dts b/arch/arm/boot/dts/microchip/at91sam9263ek.dts
index 471ea25296aa1..93c5268a0845d 100644
--- a/arch/arm/boot/dts/microchip/at91sam9263ek.dts
+++ b/arch/arm/boot/dts/microchip/at91sam9263ek.dts
@@ -152,7 +152,7 @@
 				nand@3 {
 					reg = <0x3 0x0 0x800000>;
 					rb-gpios = <&pioA 22 GPIO_ACTIVE_HIGH>;
-					cs-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
+					cs-gpios = <&pioD 15 GPIO_ACTIVE_HIGH>;
 					nand-bus-width = <8>;
 					nand-ecc-mode = "soft";
 					nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/microchip/tny_a9263.dts b/arch/arm/boot/dts/microchip/tny_a9263.dts
index 3dd48b3e06da5..fd8244b56e059 100644
--- a/arch/arm/boot/dts/microchip/tny_a9263.dts
+++ b/arch/arm/boot/dts/microchip/tny_a9263.dts
@@ -64,7 +64,7 @@
 				nand@3 {
 					reg = <0x3 0x0 0x800000>;
 					rb-gpios = <&pioA 22 GPIO_ACTIVE_HIGH>;
-					cs-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
+					cs-gpios = <&pioD 15 GPIO_ACTIVE_HIGH>;
 					nand-bus-width = <8>;
 					nand-ecc-mode = "soft";
 					nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/microchip/usb_a9263.dts b/arch/arm/boot/dts/microchip/usb_a9263.dts
index 6af450cb387c9..8e1a3fb61087c 100644
--- a/arch/arm/boot/dts/microchip/usb_a9263.dts
+++ b/arch/arm/boot/dts/microchip/usb_a9263.dts
@@ -84,7 +84,7 @@
 				nand@3 {
 					reg = <0x3 0x0 0x800000>;
 					rb-gpios = <&pioA 22 GPIO_ACTIVE_HIGH>;
-					cs-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
+					cs-gpios = <&pioD 15 GPIO_ACTIVE_HIGH>;
 					nand-bus-width = <8>;
 					nand-ecc-mode = "soft";
 					nand-on-flash-bbt;
-- 
2.39.5



