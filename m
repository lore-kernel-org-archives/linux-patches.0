Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7198831CA7C;
	Tue, 26 Aug 2025 11:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208788; cv=none; b=b+3MT06d2CAAoLSsMrnzbbOajHVHS/zhR6LsJBR9jN637065zHzzSinVQNSm1YcTDizF2SiYUtcbfay/ft9tNEPXI4RQnITO68W/uXfqwRBq6mQ6atE1aPEzlIg/X1TE/iB6hEN53fqLXlLizI5+80FbL4kLrGnoSesI1h/tuP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208788; c=relaxed/simple;
	bh=6yvxxPjL32KMwrfsYjmW3ILnfm5rLnDcxFjGwYFYBp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1sZPBie8K/ofRNXy70PrvsrBmafDR2qivJxExTr3KhAFJQhsiUr5W+A57x6W42T9ZDJyooRSU9IMOxvXo0A2TPqBc4kqvdL9s7OLFBep9d0oqBZ1hPjtncnE4kQGKQB8hNw2BQR/iangHEUstWh7d3QzXVOxvl5B0B5iZEocbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYbUXm+3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYbUXm+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CF2C4CEF1;
	Tue, 26 Aug 2025 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208788;
	bh=6yvxxPjL32KMwrfsYjmW3ILnfm5rLnDcxFjGwYFYBp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYbUXm+31zvp/P+aUoGjS5ZzzuYEmilZNZF3SyDf4r41E3AWOjaXYtSQpJnVIdU+7
	 KibotPcU5i479TB5ixn/1/gAtzZTwUTdA10nk20f00UIPCopLuZDH0FtPu6PLjAret
	 tG94MLy+cxYwt8gb8AeXatCDmln2zhAqQ6TqOA3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 204/322] arm64: dts: ti: k3-am6*: Remove disable-wp for eMMC
Date: Tue, 26 Aug 2025 13:10:19 +0200
Message-ID: <20250826110920.906860313@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit ef839ba8142f14513ba396a033110526b7008096 ]

Remove disable-wp flag for eMMC nodes since this flag is
only applicable to SD according to the binding doc
(mmc/mmc-controller-common.yaml).

For eMMC, this flag should be ignored but lets remove
anyways to cleanup sdhci nodes.

Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://lore.kernel.org/r/20250429151454.4160506-4-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: a0b8da04153e ("arm64: dts: ti: k3-am62*: Move eMMC pinmux to top level board file")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi               |    1 -
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts                |    1 -
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi              |    1 -
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts                       |    1 -
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts                       |    1 -
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi                |    1 -
 arch/arm64/boot/dts/ti/k3-am642-evm.dts                       |    1 -
 arch/arm64/boot/dts/ti/k3-am654-base-board.dts                |    1 -
 arch/arm64/boot/dts/ti/k3-am6548-iot2050-advanced-common.dtsi |    1 -
 arch/arm64/boot/dts/ti/k3-am69-sk.dts                         |    1 -
 10 files changed, 10 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
@@ -317,7 +317,6 @@
 &sdhci0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_mmc0_pins_default>;
-	disable-wp;
 	non-removable;
 	status = "okay";
 };
--- a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
@@ -821,7 +821,6 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&emmc_pins_default>;
-	disable-wp;
 	status = "okay";
 };
 
--- a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
@@ -324,7 +324,6 @@
 &sdhci0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_mmc0_pins_default>;
-	disable-wp;
 	non-removable;
 	status = "okay";
 };
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -603,7 +603,6 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_mmc0_pins_default>;
-	disable-wp;
 	bootph-all;
 };
 
--- a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
@@ -446,7 +446,6 @@
 	status = "okay";
 	non-removable;
 	ti,driver-strength-ohm = <50>;
-	disable-wp;
 	bootph-all;
 };
 
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -419,7 +419,6 @@
 	non-removable;
 	pinctrl-names = "default";
 	pinctrl-0 = <&main_mmc0_pins_default>;
-	disable-wp;
 };
 
 &sdhci1 {
--- a/arch/arm64/boot/dts/ti/k3-am642-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-am642-evm.dts
@@ -584,7 +584,6 @@
 	status = "okay";
 	non-removable;
 	ti,driver-strength-ohm = <50>;
-	disable-wp;
 	bootph-all;
 };
 
--- a/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-am654-base-board.dts
@@ -456,7 +456,6 @@
 	bus-width = <8>;
 	non-removable;
 	ti,driver-strength-ohm = <50>;
-	disable-wp;
 };
 
 /*
--- a/arch/arm64/boot/dts/ti/k3-am6548-iot2050-advanced-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am6548-iot2050-advanced-common.dtsi
@@ -50,5 +50,4 @@
 	bus-width = <8>;
 	non-removable;
 	ti,driver-strength-ohm = <50>;
-	disable-wp;
 };
--- a/arch/arm64/boot/dts/ti/k3-am69-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am69-sk.dts
@@ -926,7 +926,6 @@
 	status = "okay";
 	non-removable;
 	ti,driver-strength-ohm = <50>;
-	disable-wp;
 };
 
 &main_sdhci1 {


