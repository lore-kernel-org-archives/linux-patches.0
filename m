Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8452936657D;
	Tue,  6 Jan 2026 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722084; cv=none; b=Ef0h5QYYvknFeb2jPif1shIB0hnGF7L8Awd/cGLVRm/o+XAGKW01GVQa6YROyCSCYdH39VOLwwNkWsaerVcEY0dhUtqvp9EU76BlGAaQH4dGIO36cThEoc0kF3Afb4kwHWQE0kn6ng3+19evQ1quUC0B0mK9z4qpph78Ct7eSc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722084; c=relaxed/simple;
	bh=mjpxydGUCCw4slEuPQQctupA0wwtXlKcApn9EVx0neE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS6TTzYTtfNjmWSBkJjZ0DxqBnj3bQ4h35dISWFmU0MZYQ2YJfNJykdKX7zb7KiLDYExNw1+7OfXq1oT7DLEDYlbDTZLGgGtmrGBNYTm7iI1FgEH7MrcCL6HOPoDJxKrFXHuYu3Zk7rS9QrDxa1vuPv6liyjpdo0CjsUxRRP2lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flY5rHWC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flY5rHWC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5751C116C6;
	Tue,  6 Jan 2026 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722084;
	bh=mjpxydGUCCw4slEuPQQctupA0wwtXlKcApn9EVx0neE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flY5rHWC89mxhp8oj9AdP/vd15y+Zn1DaY0k0dzEp/gVg4bYpj8P6FlX8d5f9+V10
	 v+L+YqEikifkq8qRDEN84ZroNc9bJHlC0LepUrw7WVcrqQjBiOEPT/bpr5fiBMcaxf
	 wHZZNReWvNP7rSyjUvrPKucOGkw3BZhwovxDA610=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.18 127/312] arm64: dts: ti: k3-j721e-sk: Fix pinmux for pin Y1 used by power regulator
Date: Tue,  6 Jan 2026 18:03:21 +0100
Message-ID: <20260106170552.438733743@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 51f89c488f2ecc020f82bfedd77482584ce8027a upstream.

The SoC pin Y1 is incorrectly defined in the WKUP Pinmux device-tree node
(pinctrl@4301c000) leading to the following silent failure:

    pinctrl-single 4301c000.pinctrl: mux offset out of range: 0x1dc (0x178)

According to the datasheet for the J721E SoC [0], the pin Y1 belongs to the
MAIN Pinmux device-tree node (pinctrl@11c000). This is confirmed by the
address of the pinmux register for it on page 142 of the datasheet which is
0x00011C1DC.

Hence fix it.

[0]: https://www.ti.com/lit/ds/symlink/tda4vm.pdf

Fixes: 97b67cc102dc ("arm64: dts: ti: k3-j721e-sk: Add DT nodes for power regulators")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Link: https://patch.msgid.link/20251119160148.2752616-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -474,6 +474,12 @@
 			J721E_IOPAD(0x234, PIN_INPUT, 7) /* (U3) EXT_REFCLK1.GPIO1_12 */
 		>;
 	};
+
+	vdd_sd_dv_pins_default: vdd-sd-dv-default-pins {
+		pinctrl-single,pins = <
+			J721E_IOPAD(0x1dc, PIN_OUTPUT, 7) /* (Y1) SPI1_CLK.GPIO0_118 */
+		>;
+	};
 };
 
 &wkup_pmx0 {
@@ -536,12 +542,6 @@
 		>;
 	};
 
-	vdd_sd_dv_pins_default: vdd-sd-dv-default-pins {
-		pinctrl-single,pins = <
-			J721E_IOPAD(0x1dc, PIN_OUTPUT, 7) /* (Y1) SPI1_CLK.GPIO0_118 */
-		>;
-	};
-
 	wkup_uart0_pins_default: wkup-uart0-default-pins {
 		pinctrl-single,pins = <
 			J721E_WKUP_IOPAD(0xa0, PIN_INPUT, 0) /* (J29) WKUP_UART0_RXD */


