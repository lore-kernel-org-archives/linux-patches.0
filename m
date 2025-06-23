Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9182F24;
	Mon, 23 Jun 2025 13:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685588; cv=none; b=rR4C6yQmedoZG4XNlwIEtQbCU/w5yvmbnWx8S92h7SuEBfe8kDzpMH5Ue7ZL2zJnmO9VMvpZ5Cf+0mQjw/WKfGevoutm024WgxU2ZG5ZwSYqbyIA4BW9mEan8EAWAe5zCqw6KTCHxPjWQSb9j72yziYuWR3FwfDqBRD0nRgANNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685588; c=relaxed/simple;
	bh=5BvW2IopkqCdqc10UhTARxn9uFoqDy+IfddEQDF/vU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvolkICVc6XWoglJJ3Zxe4g4poXqqhbr0GgCAIXrnqWQoRBuzojVDZLD1KdUbIOo6irsuukz4xqeB3Ss0ziXp6obYaiaTIxVJxneIXaxW70Z452Fg7iBJciIHo4HMDNvnovgV7fD9OF0SVjOABmEbBLCGChr5i5MNSFgA9B/CAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/k+pHGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/k+pHGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68041C4CEEA;
	Mon, 23 Jun 2025 13:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685587;
	bh=5BvW2IopkqCdqc10UhTARxn9uFoqDy+IfddEQDF/vU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/k+pHGdhpHmlNFcUMXUx1ccCnxgKb8NMJThjZOPAzlXQU1Krhe53/YcdkfMHa37q
	 icn57HH8VijrFe3EurtZ3i9+to7ul8hMRjiyWnZxg7mgriuh6E0oD2xNDR9CPvkgsh
	 o0/7tNeWCzoKXepASCofd3mmNQgeVap6rwuLvAQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 061/355] ARM: dts: at91: at91sam9263: fix NAND chip selects
Date: Mon, 23 Jun 2025 15:04:22 +0200
Message-ID: <20250623130628.661350455@linuxfoundation.org>
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
 arch/arm/boot/dts/at91sam9263ek.dts | 2 +-
 arch/arm/boot/dts/tny_a9263.dts     | 2 +-
 arch/arm/boot/dts/usb_a9263.dts     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9263ek.dts b/arch/arm/boot/dts/at91sam9263ek.dts
index 71f60576761a0..df206bdb67883 100644
--- a/arch/arm/boot/dts/at91sam9263ek.dts
+++ b/arch/arm/boot/dts/at91sam9263ek.dts
@@ -148,7 +148,7 @@
 				nand@3 {
 					reg = <0x3 0x0 0x800000>;
 					rb-gpios = <&pioA 22 GPIO_ACTIVE_HIGH>;
-					cs-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
+					cs-gpios = <&pioD 15 GPIO_ACTIVE_HIGH>;
 					nand-bus-width = <8>;
 					nand-ecc-mode = "soft";
 					nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/tny_a9263.dts b/arch/arm/boot/dts/tny_a9263.dts
index 62b7d9f9a926c..c8b6318aaa838 100644
--- a/arch/arm/boot/dts/tny_a9263.dts
+++ b/arch/arm/boot/dts/tny_a9263.dts
@@ -64,7 +64,7 @@
 				nand@3 {
 					reg = <0x3 0x0 0x800000>;
 					rb-gpios = <&pioA 22 GPIO_ACTIVE_HIGH>;
-					cs-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
+					cs-gpios = <&pioD 15 GPIO_ACTIVE_HIGH>;
 					nand-bus-width = <8>;
 					nand-ecc-mode = "soft";
 					nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/usb_a9263.dts b/arch/arm/boot/dts/usb_a9263.dts
index d1c07503ff76f..87a5f96014e01 100644
--- a/arch/arm/boot/dts/usb_a9263.dts
+++ b/arch/arm/boot/dts/usb_a9263.dts
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



