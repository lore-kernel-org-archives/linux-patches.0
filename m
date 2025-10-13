Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9517931579B;
	Mon, 13 Oct 2025 15:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369252; cv=none; b=hl1Nic6TU0/lJ8M723FqJ64jWbGYRlhJwNBM3IOpdj43ulqI6tFABpSGA6sdAbcieQh2z1vD6jSh3gJVTCiP5vo5fwShyFLTCAqdROJKLoebDwqfzw2zwUvnQZEwDmekyin6z6LlwRwEJu1CWqKl4m1yZyUbM3LB63/qsff5wZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369252; c=relaxed/simple;
	bh=EjdAHeqadfOuYpKUVm9vsMAjjp50uewsoGMQMpcK4oY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XH2K2fWvaf/X9MwNfsMAuFV1ixLTvQqO4EGcifj7AzhvfSjFnU9uVbQKYK7x085A7wusyi8ghYBm+ylrtLZ/2xaUP7IYMe9mRHlr1Vn6Fn2Mll0h6N6HvtILsCeu60i/hZKMxY5am9pGb+rBfcaVFP8HoxqXa7fLr06h/AdCT8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmMtIclI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmMtIclI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180DCC4CEE7;
	Mon, 13 Oct 2025 15:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369252;
	bh=EjdAHeqadfOuYpKUVm9vsMAjjp50uewsoGMQMpcK4oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmMtIclI6iQXZdiZsjXwMl3D0EX+td4U/5WC4nksfMcJDAnDLu/r2mIiOX4kSXUMv
	 2BHeu7NyB2DLDuc8/xX4mPOV2l8VCyunBnAdbjycPg1BgGv2lxiiGeET9oiU+HTCUe
	 zlbQ43odFZfcU6ckLrxE+E9n+WvjLo1YsWdiQT8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Neal Gompa <neal@gompa.dev>,
	Sven Peter <sven@kernel.org>,
	Janne Grunau <j@jannau.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 181/563] arm64: dts: apple: t600x: Add bluetooth device nodes
Date: Mon, 13 Oct 2025 16:40:42 +0200
Message-ID: <20251013144417.841980285@linuxfoundation.org>
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

[ Upstream commit c34e2ec6a84ea3f7a01d8fcd3073f858c4f47605 ]

Add bluetooth PCIe device nodes to specify per device brcm,board-type
and provide the bootloader filled "local-bd-address" and calibration
data.

Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Reviewed-by: Sven Peter <sven@kernel.org>
Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/r/20250823-apple-dt-sync-6-17-v2-3-6dc0daeb4786@jannau.net
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
 arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi | 8 ++++++++
 arch/arm64/boot/dts/apple/t600x-j375.dtsi      | 8 ++++++++
 8 files changed, 40 insertions(+)

diff --git a/arch/arm64/boot/dts/apple/t6000-j314s.dts b/arch/arm64/boot/dts/apple/t6000-j314s.dts
index ac35870ca129c..1430b91ff1b15 100644
--- a/arch/arm64/boot/dts/apple/t6000-j314s.dts
+++ b/arch/arm64/boot/dts/apple/t6000-j314s.dts
@@ -20,3 +20,7 @@ / {
 &wifi0 {
 	brcm,board-type = "apple,maldives";
 };
+
+&bluetooth0 {
+	brcm,board-type = "apple,maldives";
+};
diff --git a/arch/arm64/boot/dts/apple/t6000-j316s.dts b/arch/arm64/boot/dts/apple/t6000-j316s.dts
index 77d6d8c14d741..da0cbe7d96736 100644
--- a/arch/arm64/boot/dts/apple/t6000-j316s.dts
+++ b/arch/arm64/boot/dts/apple/t6000-j316s.dts
@@ -20,3 +20,7 @@ / {
 &wifi0 {
 	brcm,board-type = "apple,madagascar";
 };
+
+&bluetooth0 {
+	brcm,board-type = "apple,madagascar";
+};
diff --git a/arch/arm64/boot/dts/apple/t6001-j314c.dts b/arch/arm64/boot/dts/apple/t6001-j314c.dts
index 0a5655792a8f1..c37097dcfdb30 100644
--- a/arch/arm64/boot/dts/apple/t6001-j314c.dts
+++ b/arch/arm64/boot/dts/apple/t6001-j314c.dts
@@ -20,3 +20,7 @@ / {
 &wifi0 {
 	brcm,board-type = "apple,maldives";
 };
+
+&bluetooth0 {
+	brcm,board-type = "apple,maldives";
+};
diff --git a/arch/arm64/boot/dts/apple/t6001-j316c.dts b/arch/arm64/boot/dts/apple/t6001-j316c.dts
index 9c215531ea543..3bc6e0c3294cf 100644
--- a/arch/arm64/boot/dts/apple/t6001-j316c.dts
+++ b/arch/arm64/boot/dts/apple/t6001-j316c.dts
@@ -20,3 +20,7 @@ / {
 &wifi0 {
 	brcm,board-type = "apple,madagascar";
 };
+
+&bluetooth0 {
+	brcm,board-type = "apple,madagascar";
+};
diff --git a/arch/arm64/boot/dts/apple/t6001-j375c.dts b/arch/arm64/boot/dts/apple/t6001-j375c.dts
index 88ca2037556ce..2e7c23714d4d0 100644
--- a/arch/arm64/boot/dts/apple/t6001-j375c.dts
+++ b/arch/arm64/boot/dts/apple/t6001-j375c.dts
@@ -20,3 +20,7 @@ / {
 &wifi0 {
 	brcm,board-type = "apple,okinawa";
 };
+
+&bluetooth0 {
+	brcm,board-type = "apple,okinawa";
+};
diff --git a/arch/arm64/boot/dts/apple/t6002-j375d.dts b/arch/arm64/boot/dts/apple/t6002-j375d.dts
index f56d13b37eaff..2b7f80119618a 100644
--- a/arch/arm64/boot/dts/apple/t6002-j375d.dts
+++ b/arch/arm64/boot/dts/apple/t6002-j375d.dts
@@ -42,6 +42,10 @@ &wifi0 {
 	brcm,board-type = "apple,okinawa";
 };
 
+&bluetooth0 {
+	brcm,board-type = "apple,okinawa";
+};
+
 /* delete unused always-on power-domains on die 1 */
 
 /delete-node/ &ps_atc2_usb_aon_die1;
diff --git a/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi b/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi
index b699672a5543c..c0aac59a6fae4 100644
--- a/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi
+++ b/arch/arm64/boot/dts/apple/t600x-j314-j316.dtsi
@@ -13,6 +13,7 @@
 
 / {
 	aliases {
+		bluetooth0 = &bluetooth0;
 		serial0 = &serial0;
 		wifi0 = &wifi0;
 	};
@@ -105,6 +106,13 @@ wifi0: wifi@0,0 {
 		local-mac-address = [00 10 18 00 00 10];
 		apple,antenna-sku = "XX";
 	};
+
+	bluetooth0: bluetooth@0,1 {
+		compatible = "pci14e4,5f71";
+		reg = <0x10100 0x0 0x0 0x0 0x0>;
+		/* To be filled by the loader */
+		local-bd-address = [00 00 00 00 00 00];
+	};
 };
 
 &port01 {
diff --git a/arch/arm64/boot/dts/apple/t600x-j375.dtsi b/arch/arm64/boot/dts/apple/t600x-j375.dtsi
index 95560bf3798bf..ed38acc0dfc36 100644
--- a/arch/arm64/boot/dts/apple/t600x-j375.dtsi
+++ b/arch/arm64/boot/dts/apple/t600x-j375.dtsi
@@ -11,6 +11,7 @@
 
 / {
 	aliases {
+		bluetooth0 = &bluetooth0;
 		serial0 = &serial0;
 		wifi0 = &wifi0;
 	};
@@ -90,6 +91,13 @@ wifi0: wifi@0,0 {
 		local-mac-address = [00 10 18 00 00 10];
 		apple,antenna-sku = "XX";
 	};
+
+	bluetooth0: bluetooth@0,1 {
+		compatible = "pci14e4,5f71";
+		reg = <0x10100 0x0 0x0 0x0 0x0>;
+		/* To be filled by the loader */
+		local-bd-address = [00 00 00 00 00 00];
+	};
 };
 
 &port01 {
-- 
2.51.0



