Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035790;
	b=e49TGdHdEo4+LtCwU+B3NpgQ6Tl2GU4ViJ+7gE3+YG649DY8BSfl38APBji+i3FbqZRe
	 oZEqe7zp4o2EgjRePw2WbTMl75FNaxTI9uDp77uPxyv7ErvaARl0FWtmmxfnbgJrqeTW/
	 Y4HZ4Z2EZc8UgeNjztVQHjjTblI+NpXoXNfHHIjEi+r/5/6c4rhiHsQg8nStriis2vPsm
	 kp1+7VIIYIJdC0/hPERjjvDawGUwq86s6i7RSiM6k4eXpdClboXWsNZOrhm/3vTR+xZ6V
	 2N8EDLhspLdMxkilSvZ8T4BmnnpwWWvxkb/KHaWUS4j9Lu2DG+y+7FgiM5mZqI6oKVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YeN8OyXPzfF8ueQgndgjmkRjFXfWP3ks7nckpCCGqB4=;
	b=GZXQ81yZoY/ShX5Vgk+YzEiGhDQVg/u+jJlipCDbDIGQJ3MNFdD4XUlvLaORdHfiVkpa
	 nT5PyAX2pZPcUbPWAHyxy73TmpLoWAi132PYbWg1jf79KgE3p/zegjCOR7QoGpY9lTVdZ
	 9Gk0dGAc3gYMZALc/T+LD7diyEtCWSYiWzmDJ5Xq9Oda0wVNZC9Ut+VgML6lpnxV0/VLm
	 S7garDkJbpivno4+zLr/ohXk+k1LqPjOLQEQB3wGYBv9wVaQEh9wX/Ao4qH9F4VPGL/Md
	 xCE7gg3M5Y/Ki5RL1ZjnSKz/DhN2A8VIbCmH2PQyWOlzGRAi4ZfgL0X7skNzjSiQgfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiPFHhZx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60377606A333;
	Wed, 18 Nov 2026 21:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EiPFHhZx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68521F000C4;
	Wed, 18 Nov 2026 21:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035790;
	bh=YeN8OyXPzfF8ueQgndgjmkRjFXfWP3ks7nckpCCGqB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EiPFHhZxs9LnwRvIPQsMbmm5KBPRJEmxlB79ELLUso+D8zIBjREJsOt+tQOgJHvBF
	 26CeAlWV/rDPZbGwJQxDKjY6Ydu0sMGh9mHoeOH8QeQ5Lrmv0Af2qNVnB4rHY56pYi
	 N+RZ6YuVPZ3H7Pxu+RLz1flslEBZNUb+AlijgbpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0826/3318] arm64: dts: ti: k3-am62-verdin: Set MMC clock pins as OUTPUT
Date: Wed, 18 Nov 2026 15:24:08 +0100
Message-ID: <20261118150343.862602580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 0ddd661c19ec1465e1f2c204fa9b2488acfabf4b ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

Link: https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals [0]
Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Judith Mendez <jm@ti.com>
Link: https://patch.msgid.link/20260813111238.56892-1-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
index 7c1063f5b18ba..466a214a165f3 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -508,7 +508,7 @@ AM62X_IOPAD(0x15c, PIN_INPUT, 0)  /* (AB22) MDIO0_MDIO */ /* ETH_1_MDIO, SODIMM
 	pinctrl_sdhci0: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT,        0) /*  (Y3) MMC0_CMD  */
-			AM62X_IOPAD(0x218, PIN_INPUT,        0) /* (AB1) MMC0_CLK  */
+			AM62X_IOPAD(0x218, PIN_OUTPUT,       0) /* (AB1) MMC0_CLK  */
 			AM62X_IOPAD(0x214, PIN_INPUT,        0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
@@ -524,7 +524,7 @@ AM62X_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (AC2) MMC0_DAT7 */
 	pinctrl_sdhci1: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT,        0) /* (A21) MMC1_CMD  */ /* SODIMM 74 */
-			AM62X_IOPAD(0x234, PIN_INPUT,        0) /* (B22) MMC1_CLK  */ /* SODIMM 78 */
+			AM62X_IOPAD(0x234, PIN_OUTPUT,       0) /* (B22) MMC1_CLK  */ /* SODIMM 78 */
 			AM62X_IOPAD(0x230, PIN_INPUT,        0) /* (A22) MMC1_DAT0 */ /* SODIMM 80 */
 			AM62X_IOPAD(0x22c, PIN_INPUT,        0) /* (B21) MMC1_DAT1 */ /* SODIMM 82 */
 			AM62X_IOPAD(0x228, PIN_INPUT,        0) /* (C21) MMC1_DAT2 */ /* SODIMM 70 */
@@ -537,7 +537,7 @@ AM62X_IOPAD(0x240, PIN_INPUT_PULLUP, 0) /* (D17) MMC1_SDCD */ /* SODIMM 84 */
 	pinctrl_sdhci2: main-mmc2-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x120, PIN_INPUT, 0) /* (C24) MMC2_CMD   */ /* WiFi_SDIO_CMD   */
-			AM62X_IOPAD(0x118, PIN_INPUT, 0) /* (D25) MMC2_CLK   */ /* WiFi_SDIO_CLK   */
+			AM62X_IOPAD(0x118, PIN_OUTPUT,0) /* (D25) MMC2_CLK   */ /* WiFi_SDIO_CLK   */
 			AM62X_IOPAD(0x114, PIN_INPUT, 0) /* (B24) MMC2_DAT0  */ /* WiFi_SDIO_DATA0 */
 			AM62X_IOPAD(0x110, PIN_INPUT, 0) /* (C25) MMC2_DAT1  */ /* WiFi_SDIO_DATA1 */
 			AM62X_IOPAD(0x10c, PIN_INPUT, 0) /* (E23) MMC2_DAT2  */ /* WiFi_SDIO_DATA2 */
-- 
2.53.0



