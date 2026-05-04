Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D9C3E4C99;
	Mon,  4 May 2026 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904695; cv=none; b=dNsCvzVOTiW0xaBdF1r9hpZ6yv2SNAXHtV2KdL9cdo3m0msZ5ivar3UbeGkwKw4HOjPu3EWyKOSw3M5dDXpvNToWOXYw/Q3tJfiGr6y37MiHBcNo/9sQlaWda8jc1tl6obFrKVIWMih8WF4JPqKID930/t18w0jrE83AOvBaNEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904695; c=relaxed/simple;
	bh=eeRyGq3I1See2KOUbDsmhMBKy1AgIVx3srSWVlt3KlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mpsehl3KvK7cBt+Pw47djMSrlONvGtQ3OXBz4OLTUN1Uem/dggdQYOu/78KVNiJt8gh4B06WBZzhS/HcHdHDb+Sfb+w5vFRyXFSrwvFWjtOCoVvHtr6CmtbBt9dznhCvvrT8aVACZRH3b1Tmfm4b4F4dT+Vo2z4mA5A7m1/OkfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxRJCT+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxRJCT+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF378C2BCB8;
	Mon,  4 May 2026 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904695;
	bh=eeRyGq3I1See2KOUbDsmhMBKy1AgIVx3srSWVlt3KlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxRJCT+ANBqSUGwPjPy8F/0CckvJXqM0Zzc/KkvGPINK5OBFuOvJxd9Ks5+wER21Z
	 BF9jZWJ0GXiPzZq4IXX2lB4NHJVQhkXQBKgqa2xfZ4B9qI73prObVVup1M1u6ZHMZU
	 pEdvoaE1qSwsMQNyJwG9as+FzuHjVVpEQFRN0QxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.12 105/215] arm64: dts: ti: am62-verdin: Enable pullup for eMMC data pins
Date: Mon,  4 May 2026 15:52:04 +0200
Message-ID: <20260504135133.988148615@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -566,16 +566,16 @@
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
 


