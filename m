Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6A8305670;
	Fri, 15 May 2026 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860805; cv=none; b=mvRiHtf1wcDex3JEyyA5A/bQmsMG6QuBONZISVdnxF02aYMhcFWEKuW9IhK60uCos8WiaJRPLLRq829qYnewgAGLCvJKcroUCl/l0SBk0+814Pghrk/R/El72SDabHfVP5MhgHa02pbaDtwTRMYVqN4pooNmx1jH52Vpp6VbZd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860805; c=relaxed/simple;
	bh=WOu8lDHboO+Z/8Fe4XRkm7mw7dhGR6IEWY9ZREllflo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U34HMJUMi6fPZxyxkD6xeB+G+/8iYBvl3UWb0EpxGGrlVeBU5yE9BHaC8vSTOLFD6qeDYSx0+prg2rXMNBETBHxuow2ccHkOMJZfbqzXW3CRq7AqbwU/s/k/dxTawFFsA/KoINM7BRTDK1UTgHN7127kZX/SKNvYWD9Y8ZkEL/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dajfb8At; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dajfb8At"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC23C2BCB3;
	Fri, 15 May 2026 16:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860805;
	bh=WOu8lDHboO+Z/8Fe4XRkm7mw7dhGR6IEWY9ZREllflo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dajfb8Athf1sYNn+ba3QpbmNb96Kj4D5NMX98Aj556y172avUAiu6cXB1TBG8YY4/
	 tIyTB4yP3qpIk+5B1MdOp5wQJBbXnksrZlurj/3PUs5oVYj/g/NZRJz0atCm89iqLz
	 HxvqsJ0y54Ux52enLgtATD8rU4f9oUpphJXZuFlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.6 086/474] arm64: dts: ti: am62-verdin: Enable pullup for eMMC data pins
Date: Fri, 15 May 2026 17:43:15 +0200
Message-ID: <20260515154716.899095971@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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
@@ -507,16 +507,16 @@
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
 


