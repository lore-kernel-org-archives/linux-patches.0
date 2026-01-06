Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322A3226165;
	Tue,  6 Jan 2026 17:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720887; cv=none; b=O3Djzd1G93vJUB8TUQ30y5XcGid1hFBvO56npnBRyLHdl4aCzZysjlFCUNdTd+Mp56D3wyomFE40l/ZH4ZAQmAxYXOGgglrm9B+FRf3ss2OylfX/MA7SD7d57ZFUdn3+LOiYZGhrEDOKIHcp4df+vz/fVcyLIKaNj5dpS+0Fq10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720887; c=relaxed/simple;
	bh=0qe2lM03JLsZImP4SsBzSuknm6p74//1Igts2YoR1zw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1D8J8+DNuqV/XvF1kXiQ7WkKpGvbiKm0iLabFSEveHNy4RnbnEK4BnhY0hAODCh5d31g24gMxTE98hro/t8K9rzYZdkuVIt14OJKbjhmfDvsMfM0WqR2R3qAL1C9CXfS0r+fguQfYOCVXdc3woDj7cZOtXSWGyp02dclrZbXr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K8SG3Zv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K8SG3Zv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C277C116C6;
	Tue,  6 Jan 2026 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720886;
	bh=0qe2lM03JLsZImP4SsBzSuknm6p74//1Igts2YoR1zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K8SG3Zv2yalg+jfqDl0li6kmtNceAoWLVGKqL8BYyIQy3kS00Pli4UHcn00XZXsHb
	 pnsCRLYm7TsYSCnTB/4MqZq4XTE7r7pdFzFfzU4MvcfJ/jYgEORy0R1V2Hryu32eTN
	 u6DMxHnbkvi5ErzJx8XQLzGBw5eAiCzFL1yORJLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.12 371/567] arm64: dts: ti: k3-j721e-sk: Fix pinmux for pin Y1 used by power regulator
Date: Tue,  6 Jan 2026 18:02:33 +0100
Message-ID: <20260106170505.066430637@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -572,6 +572,12 @@
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
@@ -633,12 +639,6 @@
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


