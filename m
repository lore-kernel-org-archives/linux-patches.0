Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A86A33C530;
	Fri,  9 Jan 2026 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960900; cv=none; b=RT4YMiVjRl3LarCWvod+VaEkSRQ9B2knVvuTePKYHOcEDgt0PM1MNkLDPMRANO28eiQKrnHb6RBYV7mC4QhtsnL16bjvvyWWwzgH3Vs1s93g8XXsrScxmHd8OjU1+3BrrBPeK3dqoxE4fytWHdpmRru64zZboihfElZLr+5oNew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960900; c=relaxed/simple;
	bh=WcQW8epb1y722o8br+2l0TKHQGw5cUjCRSIu5LO+eT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXu4nmn9CPeqduVeA8ITL1ET3jHtfkW6AGSyV7Vp9CUg2zQRTBXO8mMg6FM6eA6gFZ/CdF3K1tvrjp7fkAwDRZzUJxwxbj2/W8kmwGXbn2TsWPCTKWFHseOzbGZUSExPerfkuA58MgarzpEdZu3l87eRC/ot4vbSGJ7uZnlnsfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUPkfz5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUPkfz5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AC8C4CEF1;
	Fri,  9 Jan 2026 12:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960900;
	bh=WcQW8epb1y722o8br+2l0TKHQGw5cUjCRSIu5LO+eT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUPkfz5Ie3lZP+5j21G/Yu7tzlQZkQKbgoesleJ+H41Q/aPqEvyOspo9VQRN7U1th
	 +8i66NEULQVzKqkDmlnZRaK+jb3NDGCUADwuDHn4OF4vD/S01jCCKZGkSaWNS8g2sR
	 6ToZJHdF8bj6GqX8nBA3Xc1rLKHRtDQPMzmdD9m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.6 563/737] arm64: dts: ti: k3-j721e-sk: Fix pinmux for pin Y1 used by power regulator
Date: Fri,  9 Jan 2026 12:41:42 +0100
Message-ID: <20260109112155.182551257@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -571,6 +571,12 @@
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
@@ -626,12 +632,6 @@
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


