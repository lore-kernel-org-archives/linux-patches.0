Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0417437881B;
	Mon,  4 May 2026 14:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903370; cv=none; b=ssQnl8tvtYXsHoFUMbVOJukuLmHS9h7lpaGCci5BwsqaGGt8+r/huS2eECqp3KLifwPX4acaLqlAoKHRnv4AtuH9S34cOKD4dPaYdQv37G8nxszefHfWMSqnnFHxW0EgjQu4W+5mOn1f4Ii5uG+HdtlXzyTy5N3Mi+/cazIatwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903370; c=relaxed/simple;
	bh=m6MGNC2gm34X2/9er+i5vAFENiEa9soBgDf0yyjBPYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhSy7s3qzHbKT9xmb1pFC6YzjneMg79uJTm8VTO96LGfVrzpwi76khjwS6NVKLSW+zugWXCLBMYCPIB/QIZWLQ0+IqjbrA1Rm5ZLyUX0Dei6eCymAbfxwz/vXP3q6PAfPo2MPQTXsSlnsQhCJGwxswyPQIR/Lm7zZuPk/MqxIDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+9BIqDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+9BIqDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB21C2BCB8;
	Mon,  4 May 2026 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903369;
	bh=m6MGNC2gm34X2/9er+i5vAFENiEa9soBgDf0yyjBPYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+9BIqDRuRKN2tKA4k7i0COIGRQiVhGFyzfMlLa+JjPAx2lAVuCT+v1SwVhZBh359
	 ycxqGltpeQDNq3WhAPUNHHk+3TMUVN4NRc0fmje9qwWM9UYgltc6eTt1BHuFYK0Ilv
	 pH6tfa7OeTrpmYJhojgzdSneiv3jNDlwIo3JlQo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 7.0 175/307] arm64: dts: ti: am62-verdin: Enable pullup for eMMC data pins
Date: Mon,  4 May 2026 15:51:00 +0200
Message-ID: <20260504135149.449787730@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit d5325810814ee995debfa0b6c4a22e0391598bef upstream.

Verdin AM62 board does not have external pullups on eMMC DAT1-DAT7 pins.
Enable internal pullups on DAT1-DAT7 considering:

 - without a host-side pullup, these lines rely solely on the eMMC
   device's internal pullup (R_int, 10kohm-150kohm per JEDEC), which may
   exceed the recommended 50kohm max for 1.8V VCCQ
 - JEDEC JESD84-B51 Table 200 requires host-side pullups (R_DAT,
   10kohm-100kohm) on all data lines to prevent bus floating

Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260320073032.10427-1-francesco@dolcini.it
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -572,16 +572,16 @@
 	/* On-module eMMC */
 	pinctrl_sdhci0: main-mmc0-default-pins {
 		pinctrl-single,pins = <
-			AM62X_IOPAD(0x220, PIN_INPUT, 0) /*  (Y3) MMC0_CMD  */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK  */
-			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
-			AM62X_IOPAD(0x210, PIN_INPUT, 0) /* (AA1) MMC0_DAT1 */
-			AM62X_IOPAD(0x20c, PIN_INPUT, 0) /* (AA3) MMC0_DAT2 */
-			AM62X_IOPAD(0x208, PIN_INPUT, 0) /*  (Y4) MMC0_DAT3 */
-			AM62X_IOPAD(0x204, PIN_INPUT, 0) /* (AB2) MMC0_DAT4 */
-			AM62X_IOPAD(0x200, PIN_INPUT, 0) /* (AC1) MMC0_DAT5 */
-			AM62X_IOPAD(0x1fc, PIN_INPUT, 0) /* (AD2) MMC0_DAT6 */
-			AM62X_IOPAD(0x1f8, PIN_INPUT, 0) /* (AC2) MMC0_DAT7 */
+			AM62X_IOPAD(0x220, PIN_INPUT,        0) /*  (Y3) MMC0_CMD  */
+			AM62X_IOPAD(0x218, PIN_INPUT,        0) /* (AB1) MMC0_CLK  */
+			AM62X_IOPAD(0x214, PIN_INPUT,        0) /* (AA2) MMC0_DAT0 */
+			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
+			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
+			AM62X_IOPAD(0x208, PIN_INPUT_PULLUP, 0) /*  (Y4) MMC0_DAT3 */
+			AM62X_IOPAD(0x204, PIN_INPUT_PULLUP, 0) /* (AB2) MMC0_DAT4 */
+			AM62X_IOPAD(0x200, PIN_INPUT_PULLUP, 0) /* (AC1) MMC0_DAT5 */
+			AM62X_IOPAD(0x1fc, PIN_INPUT_PULLUP, 0) /* (AD2) MMC0_DAT6 */
+			AM62X_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (AC2) MMC0_DAT7 */
 		>;
 	};
 


