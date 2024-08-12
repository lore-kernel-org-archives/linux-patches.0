Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F67E1494B8;
	Mon, 12 Aug 2024 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480466; cv=none; b=LV8M12aom2N7r2MoN9Cvu7CIO91hMg0WEFeke3hbP1nJog/Ljw7wRM1oyrSt+a8DzrkgCxdUZjg1jOj1KeZG1OYC3IvI2lhrPjjv2acnJ/0fgj1r+1HmwDWn0H5qVLuljDtjMq2KqANYXwB19akZmdyz8TDwWjBEiAUZtOLS4II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480466; c=relaxed/simple;
	bh=2Vz4XFVMExA/vjQ41kMyGo2xlyxqOIpSNuakI2tF6M4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dv9f1FY+IrRKVY1rS7q7lnVAXrLV6mHn8TtaCLd63mEParIOxq8EC7Qtjt8ML9qDXe6XpI0FMgHcfp6N3IikH54/d7ghkyQ4jPg1tj/y7nvFEYSiLrWrRiMHJysoRBffocXomrPa8oc3DPenJw/f1XEv2b5hanNTWEpontAym24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdxEk3jK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdxEk3jK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F135CC4AF0C;
	Mon, 12 Aug 2024 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480466;
	bh=2Vz4XFVMExA/vjQ41kMyGo2xlyxqOIpSNuakI2tF6M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdxEk3jKOIz+BN44vrA1qD9VEaTwqvATkONjqc4ERN7dUTX8BjoIuVRAU8evclozW
	 luOfK+6vwLYJkx+I9+8NuQDZ58QWp0TJtVJ7v8vgZFB4Q2Yn0U0U5So4TrYAlf2q9h
	 oCRC1DVuH8tbpoQP0/bOKv0G+nF8VSYTRS1L3poI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.10 204/263] arm64: dts: ti: k3-am62-verdin-dahlia: Keep CTRL_SLEEP_MOCI# regulator on
Date: Mon, 12 Aug 2024 18:03:25 +0200
Message-ID: <20240812160154.358247983@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 9438f970296f9c3a6dd340ae0ad01d2f056c88e6 upstream.

This reverts commit 3935fbc87ddebea5439f3ab6a78b1e83e976bf88.

CTRL_SLEEP_MOCI# is a signal that is defined for all the SoM
implementing the Verdin family specification, this signal is supposed to
control the power enable in the carrier board when the system is in deep
sleep mode. However this is not possible with Texas Instruments AM62
SoC, IOs output buffer is disabled in deep sleep and IOs are in
tri-state mode.

Given that we cannot properly control this pin, force it to be always
high to minimize potential issues.

Fixes: 3935fbc87dde ("arm64: dts: ti: k3-am62-verdin-dahlia: support sleep-moci")
Cc:  <stable@vger.kernel.org>
Link: https://e2e.ti.com/support/processors-group/processors/f/processors-forum/1361669/am625-gpio-output-state-in-deep-sleep/5244802
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20240731054804.6061-1-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi |   22 ----------------------
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi        |    6 ------
 2 files changed, 28 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi
@@ -43,15 +43,6 @@
 			sound-dai = <&mcasp0>;
 		};
 	};
-
-	reg_usb_hub: regulator-usb-hub {
-		compatible = "regulator-fixed";
-		enable-active-high;
-		/* Verdin CTRL_SLEEP_MOCI# (SODIMM 256) */
-		gpio = <&main_gpio0 31 GPIO_ACTIVE_HIGH>;
-		regulator-boot-on;
-		regulator-name = "HUB_PWR_EN";
-	};
 };
 
 /* Verdin ETHs */
@@ -193,11 +184,6 @@
 	status = "okay";
 };
 
-/* Do not force CTRL_SLEEP_MOCI# always enabled */
-&reg_force_sleep_moci {
-	status = "disabled";
-};
-
 /* Verdin SD_1 */
 &sdhci1 {
 	status = "okay";
@@ -218,15 +204,7 @@
 };
 
 &usb1 {
-	#address-cells = <1>;
-	#size-cells = <0>;
 	status = "okay";
-
-	usb-hub@1 {
-		compatible = "usb424,2744";
-		reg = <1>;
-		vdd-supply = <&reg_usb_hub>;
-	};
 };
 
 /* Verdin CTRL_WAKE1_MICO# */
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -138,12 +138,6 @@
 		vin-supply = <&reg_1v8>;
 	};
 
-	/*
-	 * By default we enable CTRL_SLEEP_MOCI#, this is required to have
-	 * peripherals on the carrier board powered.
-	 * If more granularity or power saving is required this can be disabled
-	 * in the carrier board device tree files.
-	 */
 	reg_force_sleep_moci: regulator-force-sleep-moci {
 		compatible = "regulator-fixed";
 		enable-active-high;


