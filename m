Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF522F3C31;
	Mon, 13 Oct 2025 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369249; cv=none; b=XaDpJBmk7sv24WDJSCOsgYOkk/TybFf+hB6+bRP4oNIKrbe+u3m2FV8nGQ1Yy8KAWDoxNDLGeHTpLIFErSoGHs8gu594G2cEsuR18P6KbnBMg+idV9Na2YwggIq9+eD6jxG0c5Vd9X4aY8cNppK8UEfAw4RPPAhJ98dYs6+jKAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369249; c=relaxed/simple;
	bh=/7LyWUBIeBGvVgy8h+QDDxGgGqCBi9sRM2rLDB2txJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cl1SzR9DC7v/DTFZiZaMW0/UDKMXxvw2up2fk/wzvRr4Bn/i/AXXmw0ecPtJkLePahypvuJ2GzY5XzHdIeBuhl0LZOkWQ9lG4ppviWf8NqnZuGYAKG43pJFG5R6ToYqRFHi13aAO6HMQcGP/2xA9wQpzj0S5Y3O54jPHw9NSY8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwCYPC1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwCYPC1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE30C4CEFE;
	Mon, 13 Oct 2025 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369249;
	bh=/7LyWUBIeBGvVgy8h+QDDxGgGqCBi9sRM2rLDB2txJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UwCYPC1DSul307AKhKkLYvb0Pvekk5a5HzX2dzAtVZZkrNCJl+j/zKrqGJU9JphYT
	 fG8se82Fk5ps8v9+mqYWieJZVaaSKZEi9G/WE7zgpb0CI1KN7vvrig6Y5LBrhXie/P
	 ZhqsvxgryW3Sfue4uRzJWoyprErRy7zFLyJ4zexY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 180/563] arm64: dts: apple: t600x: Add missing WiFi properties
Date: Mon, 13 Oct 2025 16:40:41 +0200
Message-ID: <20251013144417.805829656@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 3050713d84f58d2e4ba463c5474092fa6738c527 ]

Add compatible and antenna-sku properties to the shared node and
brcm,board-type property to individuall board device trees.

Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/r/20250823-apple-dt-sync-6-17-v2-2-6dc0daeb4786@jannau.net
Signed-off-by: Sven Peter <sven@kernel.org>
Stable-dep-of: 6313115c55f4 ("arm64: dts: apple: Add ethernet0 alias for J375 template")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/apple/t6000-j314s.dts      | 4 ++++
 arch/arm64/boot/dts/apple/t6000-j316s.dts      | 4 ++++
 arch/arm64/boot/dts/apple/t6001-j314c.dts      | 4 ++++
 arch/arm64/boot/dts/apple/t6001-j316c.dts      | 4 ++++
 arch/arm64/boot/dts/apple/t6001-j375c.dts      | 4 ++++
 arch/arm64/boot/dts/apple/t6002-j375d.dts      | 4 ++++
 arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi | 2 ++
 arch/arm64/boot/dts/apple/t600x-j375.dtsi      | 2 ++
 8 files changed, 28 insertions(+)

diff --git a/arch/arm64/boot/dts/apple/t6000-j314s.dts b/arch/arm64/boot/dts/apple/t6000-j314s.dts
index c9e192848fe3f..ac35870ca129c 100644
--- a/arch/arm64/boot/dts/apple/t6000-j314s.dts
+++ b/arch/arm64/boot/dts/apple/t6000-j314s.dts
@@ -16,3 +16,7 @@ / {
 	compatible = "apple,j314s", "apple,t6000", "apple,arm-platform";
 	model = "Apple MacBook Pro (14-inch, M1 Pro, 2021)";
 };
+
+&wifi0 {
+	brcm,board-type = "apple,maldives";
+};
diff --git a/arch/arm64/boot/dts/apple/t6000-j316s.dts b/arch/arm64/boot/dts/apple/t6000-j316s.dts
index ff1803ce23001..77d6d8c14d741 100644
--- a/arch/arm64/boot/dts/apple/t6000-j316s.dts
+++ b/arch/arm64/boot/dts/apple/t6000-j316s.dts
@@ -16,3 +16,7 @@ / {
 	compatible = "apple,j316s", "apple,t6000", "apple,arm-platform";
 	model = "Apple MacBook Pro (16-inch, M1 Pro, 2021)";
 };
+
+&wifi0 {
+	brcm,board-type = "apple,madagascar";
+};
diff --git a/arch/arm64/boot/dts/apple/t6001-j314c.dts b/arch/arm64/boot/dts/apple/t6001-j314c.dts
index 1761d15b98c12..0a5655792a8f1 100644
--- a/arch/arm64/boot/dts/apple/t6001-j314c.dts
+++ b/arch/arm64/boot/dts/apple/t6001-j314c.dts
@@ -16,3 +16,7 @@ / {
 	compatible = "apple,j314c", "apple,t6001", "apple,arm-platform";
 	model = "Apple MacBook Pro (14-inch, M1 Max, 2021)";
 };
+
+&wifi0 {
+	brcm,board-type = "apple,maldives";
+};
diff --git a/arch/arm64/boot/dts/apple/t6001-j316c.dts b/arch/arm64/boot/dts/apple/t6001-j316c.dts
index 750e9beeffc0a..9c215531ea543 100644
--- a/arch/arm64/boot/dts/apple/t6001-j316c.dts
+++ b/arch/arm64/boot/dts/apple/t6001-j316c.dts
@@ -16,3 +16,7 @@ / {
 	compatible = "apple,j316c", "apple,t6001", "apple,arm-platform";
 	model = "Apple MacBook Pro (16-inch, M1 Max, 2021)";
 };
+
+&wifi0 {
+	brcm,board-type = "apple,madagascar";
+};
diff --git a/arch/arm64/boot/dts/apple/t6001-j375c.dts b/arch/arm64/boot/dts/apple/t6001-j375c.dts
index 62ea437b58b25..88ca2037556ce 100644
--- a/arch/arm64/boot/dts/apple/t6001-j375c.dts
+++ b/arch/arm64/boot/dts/apple/t6001-j375c.dts
@@ -16,3 +16,7 @@ / {
 	compatible = "apple,j375c", "apple,t6001", "apple,arm-platform";
 	model = "Apple Mac Studio (M1 Max, 2022)";
 };
+
+&wifi0 {
+	brcm,board-type = "apple,okinawa";
+};
diff --git a/arch/arm64/boot/dts/apple/t6002-j375d.dts b/arch/arm64/boot/dts/apple/t6002-j375d.dts
index 3365429bdc8be..f56d13b37eaff 100644
--- a/arch/arm64/boot/dts/apple/t6002-j375d.dts
+++ b/arch/arm64/boot/dts/apple/t6002-j375d.dts
@@ -38,6 +38,10 @@ hpm5: usb-pd@3a {
 	};
 };
 
+&wifi0 {
+	brcm,board-type = "apple,okinawa";
+};
+
 /* delete unused always-on power-domains on die 1 */
 
 /delete-node/ &ps_atc2_usb_aon_die1;
diff --git a/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi b/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi
index 22ebc78e120bf..b699672a5543c 100644
--- a/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi
+++ b/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi
@@ -99,9 +99,11 @@ &port00 {
 	/* WLAN */
 	bus-range = <1 1>;
 	wifi0: wifi@0,0 {
+		compatible = "pci14e4,4433";
 		reg = <0x10000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
 		local-mac-address = [00 10 18 00 00 10];
+		apple,antenna-sku = "XX";
 	};
 };
 
diff --git a/arch/arm64/boot/dts/apple/t600x-j375.dtsi b/arch/arm64/boot/dts/apple/t600x-j375.dtsi
index d5b985ad56793..95560bf3798bf 100644
--- a/arch/arm64/boot/dts/apple/t600x-j375.dtsi
+++ b/arch/arm64/boot/dts/apple/t600x-j375.dtsi
@@ -84,9 +84,11 @@ &port00 {
 	/* WLAN */
 	bus-range = <1 1>;
 	wifi0: wifi@0,0 {
+		compatible = "pci14e4,4433";
 		reg = <0x10000 0x0 0x0 0x0 0x0>;
 		/* To be filled by the loader */
 		local-mac-address = [00 10 18 00 00 10];
+		apple,antenna-sku = "XX";
 	};
 };
 
-- 
2.51.0



