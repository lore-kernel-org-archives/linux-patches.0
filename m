Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062762;
	b=W+rHFY9ScqBdvw4CbphiaxILfkORafKICpFKcW3La3cOK5zoZx3o7VV8MWbSvXD9g/KW
	 YaAtvwaPBXNRdpZ5wUegtTpjcrLDVgAhGXqTfpGWuZHQCY06lggYu+jcDBEKtMPQ+7mLZ
	 gnvsINz+pTWRz2frSa0L1Z4uJR+Mo6k4ny7MevU5hvQAJnFbb8TeDK/6o2/mfy+3UjB3N
	 zbpTCWblC+7dXJ6JQ72Sif8TJ/hk1+W6QEnlz5V/V6XexvMKELLDEaCNMXqOhTH5p3/nr
	 WePac6RhnRJuqmpClg1eCBbnMTtc7KI+BZZrZLYXOCQayTM5OAUzOGTuSdoDKZeHo5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lz+mqYqccLczJ68wrWRauG0OabmCs1ZKPiq17+UBBlk=;
	b=PRP8/jyOazbDDXir5THgU3XEloweegPRwifmMLpvcyGPa4hZ0x6zNNrDMdnOFyLUfus1
	 lpIcjBQ6xLnfsWHesDtzMOZFH1ykf4eWUTTzNHlgVgUd4X8xdHVSVI2qLxKsNUO0eaaao
	 Q9AmnUrdTk8CkD4Xkw2Y9LCNAz7oRcrTJuNPdwpmLlGXi8WSHu1AnCrPKrWiq+S+yIiJZ
	 wzRiZUL4zvrBmXy5NqlnLkybnoGjnMXuVhDA5csZuvyP1pPor0QCNNO8TGKJ7B7EAjQgr
	 NQD4l5zsbwvN+yW7GODe78nXabl98wScNWW8P7u09kW0bk3G+vmmkTMRuqHpkgexD1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nv+Wxxq7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E714606A32C;
	Sat,  7 Nov 2026 14:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nv+Wxxq7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EE41F008A1;
	Sat,  7 Nov 2026 14:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062762;
	bh=Lz+mqYqccLczJ68wrWRauG0OabmCs1ZKPiq17+UBBlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nv+Wxxq75OB59JUtNHQzp2xQhxQASSlxHMoqnKsAAd19uWjuKeEZpS+FOJ7sF5OfS
	 e6ENLgcK4yJVI0dNRkr0XwEGQS55ItrBYf2N2aX7HHAEv8G5GtoHtfcAeQVqwCxYIZ
	 mi4qzR7QtD4tIoWckJPhGvNZNERfvMzQtnu4wUZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 072/869] arm64: dts: ti: k3-am62-verdin: Set MMC clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:45:54 -0500
Message-ID: <20261107134855.043751016@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 059ec492a973e..5e8830fffb949 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -573,7 +573,7 @@ AM62X_IOPAD(0x15c, PIN_INPUT, 0)  /* (AB22) MDIO0_MDIO */ /* ETH_1_MDIO, SODIMM
 	pinctrl_sdhci0: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT,        0) /*  (Y3) MMC0_CMD  */
-			AM62X_IOPAD(0x218, PIN_INPUT,        0) /* (AB1) MMC0_CLK  */
+			AM62X_IOPAD(0x218, PIN_OUTPUT,       0) /* (AB1) MMC0_CLK  */
 			AM62X_IOPAD(0x214, PIN_INPUT,        0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
@@ -589,7 +589,7 @@ AM62X_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (AC2) MMC0_DAT7 */
 	pinctrl_sdhci1: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT,        0) /* (A21) MMC1_CMD  */ /* SODIMM 74 */
-			AM62X_IOPAD(0x234, PIN_INPUT,        0) /* (B22) MMC1_CLK  */ /* SODIMM 78 */
+			AM62X_IOPAD(0x234, PIN_OUTPUT,       0) /* (B22) MMC1_CLK  */ /* SODIMM 78 */
 			AM62X_IOPAD(0x230, PIN_INPUT,        0) /* (A22) MMC1_DAT0 */ /* SODIMM 80 */
 			AM62X_IOPAD(0x22c, PIN_INPUT,        0) /* (B21) MMC1_DAT1 */ /* SODIMM 82 */
 			AM62X_IOPAD(0x228, PIN_INPUT,        0) /* (C21) MMC1_DAT2 */ /* SODIMM 70 */
@@ -601,7 +601,7 @@ AM62X_IOPAD(0x224, PIN_INPUT,        0) /* (D22) MMC1_DAT3 */ /* SODIMM 72 */
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



