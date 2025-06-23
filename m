Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECB1253949;
	Mon, 23 Jun 2025 13:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684887; cv=none; b=PJ+lA1472e9bZPZEzriIJwnZjWVOyLzQqYVE0mmemW0yn9s+FRXhNx29kWv+RSJEp8VeLCSdXdx/F/shHO9V5fi25YTlIisCdA+yAWlFDQqkc6UCX51J8gluJYJKiVDSzP91XBSxY7+y1/ZDXQLDdziGexvrLQBIPcKT7ajTPTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684887; c=relaxed/simple;
	bh=z853euJEUcEQGBfLGRbMnZ1kvJuaPI02ImKga58lh34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txap8MLR/9wK1uZfISTcwSHjGAcDbRJmHVh6girTjxLmQGJS3NiQLuq/sQn9iTWGQ2hsT9NhRjo+BsfcrEVFsGf67ItzOFAAjY+tcCmrzTL/A+baAVet5xgajHMgnDvtiSz6ZlrC+DlXj81yHu5SsqbIlDB0qFsnW6ftU1mwsJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzaTnSCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzaTnSCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8661C4CEF1;
	Mon, 23 Jun 2025 13:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684887;
	bh=z853euJEUcEQGBfLGRbMnZ1kvJuaPI02ImKga58lh34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzaTnSCVZImSNT2iKNdpiRnD+XpxTh8y8XFcHAJdyAPPPRq/Ha3ixHk0SN3MZaZJ9
	 FxbtppdsMS+rguoEXxCM7bIf4iZEpFa+Z6M7xkj6DNlVB4TJFb3ETedMDi3xRKgzMt
	 pi7p0S8SrU3YPlFVm0SQeiLEbGaT7NHI8QjXLxt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/222] ARM: dts: at91: at91sam9263: fix NAND chip selects
Date: Mon, 23 Jun 2025 15:06:18 +0200
Message-ID: <20250623130613.205684133@linuxfoundation.org>
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
index 62d218542a480..64e4a56b30e07 100644
--- a/arch/arm/boot/dts/at91sam9263ek.dts
+++ b/arch/arm/boot/dts/at91sam9263ek.dts
@@ -147,7 +147,7 @@
 				nand@3 {
 					reg = <0x3 0x0 0x800000>;
 					rb-gpios = <&pioA 22 GPIO_ACTIVE_HIGH>;
-					cs-gpios = <&pioA 15 GPIO_ACTIVE_HIGH>;
+					cs-gpios = <&pioD 15 GPIO_ACTIVE_HIGH>;
 					nand-bus-width = <8>;
 					nand-ecc-mode = "soft";
 					nand-on-flash-bbt;
diff --git a/arch/arm/boot/dts/tny_a9263.dts b/arch/arm/boot/dts/tny_a9263.dts
index 2820635952e33..f31bacf641b4a 100644
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
index 937adf3ed3611..a22c7628e2b58 100644
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



