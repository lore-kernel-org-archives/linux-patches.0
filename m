Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5F628DC4;
	Wed, 20 May 2026 17:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298448; cv=none; b=l2dgOsJKM24iG1JMaVkEw2kFyLEUN+bgXeNN6yn/D44o5yI9V/GyY1I/nm/GQm3v9aRcQk25/pW9OAUs4vpzj6gZSCRLxrca7edW8ulUgH9NjLCD593+M9FQn9k7BtpJDZmy7d1AxlknpRBrMngWStmYr4fDtPovbboA4AF3kAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298448; c=relaxed/simple;
	bh=7GR5VtYlJl0F5kjN3cWh1Z03HJXqejZgX1RyO7vN0Hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSZE9etVmH/RTSras7ZYEOewtAuRZ4RgsQJKbxTstdBIFvN8u/d/+wstopYji5nfJriamj3Y4WEtGA63ZM1ibIJ902m/CmJ3aG0HSGXzJhsr5cR+EIfJMoeK3rJ8Kiwyen9X0s4IXqb/VcbHUeKh7Z7tUA6NShG55Yxen8wnzTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kproX5Ii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kproX5Ii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40411F000E9;
	Wed, 20 May 2026 17:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298447;
	bh=XPOe4pnrBip5sAeB+eddlbnhvw5SQx60v5w8UwDK/Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kproX5IiSP1MGZeI2telbkp52u7IWjXtraYs/dxsCaBlY2X2XHOwKJmx7ugcXiYgy
	 6x0BBnmj52me1v9jWmfvF32ZS7vgcxlRpumqLk5WpXZ1TPpftG4R9Lxly6sLfv2G6S
	 4qGiKAtGoLEmn7q+YHPK/p7Vju4Lix3urUrrxT3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 414/957] arm64: dts: ti: k3-am62-lp-sk: Enable internal pulls for MMC0 data pins
Date: Wed, 20 May 2026 18:14:57 +0200
Message-ID: <20260520162143.501396480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit ee2a9d9c9e6c9643fb7e45febcaedfbc038e483a ]

AM62 LP SK board does not have external pullups on MMC0 DAT1-DAT7
pins [0]. Enable internal pullups on DAT1-DAT7 considering:
- without a host-side pullup, these lines rely solely on the eMMC
  device's internal pullup (R_int, 10-150K per JEDEC), which may
  exceed the recommended 50K max for 1.8V VCCQ
- JEDEC JESD84-B51 Table 200 requires host-side pullups (R_DAT,
  10K-100K) on all data lines to prevent bus floating

[0] https://www.ti.com/lit/zip/SPRR471

Fixes: a0b8da04153e ("arm64: dts: ti: k3-am62*: Move eMMC pinmux to top level board file")
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260223233731.2690472-4-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts b/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
index ecfba05fe5c27..5ed757c19db60 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
@@ -88,13 +88,13 @@ main_mmc0_pins_default: main-mmc0-default-pins {
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (V3) MMC0_CMD */
 			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (Y1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (V2) MMC0_DAT0 */
-			AM62X_IOPAD(0x210, PIN_INPUT, 0) /* (V1) MMC0_DAT1 */
-			AM62X_IOPAD(0x20c, PIN_INPUT, 0) /* (W2) MMC0_DAT2 */
-			AM62X_IOPAD(0x208, PIN_INPUT, 0) /* (W1) MMC0_DAT3 */
-			AM62X_IOPAD(0x204, PIN_INPUT, 0) /* (Y2) MMC0_DAT4 */
-			AM62X_IOPAD(0x200, PIN_INPUT, 0) /* (W3) MMC0_DAT5 */
-			AM62X_IOPAD(0x1fc, PIN_INPUT, 0) /* (W4) MMC0_DAT6 */
-			AM62X_IOPAD(0x1f8, PIN_INPUT, 0) /* (V4) MMC0_DAT7 */
+			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (V1) MMC0_DAT1 */
+			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (W2) MMC0_DAT2 */
+			AM62X_IOPAD(0x208, PIN_INPUT_PULLUP, 0) /* (W1) MMC0_DAT3 */
+			AM62X_IOPAD(0x204, PIN_INPUT_PULLUP, 0) /* (Y2) MMC0_DAT4 */
+			AM62X_IOPAD(0x200, PIN_INPUT_PULLUP, 0) /* (W3) MMC0_DAT5 */
+			AM62X_IOPAD(0x1fc, PIN_INPUT_PULLUP, 0) /* (W4) MMC0_DAT6 */
+			AM62X_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (V4) MMC0_DAT7 */
 		>;
 	};
 
-- 
2.53.0



