Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036003;
	b=jG3IinTS1mZ4fIZptgIst9G8XZDQNMyCi9F3yOj2ze3QdCA+L5Vvo9Ksg7L0LekhHr/N
	 TU8UisVQYkw5CCtbh2iVfYEHPU7uxWU3f06K7lIR9mNBkio6k/60ydisOq82mG7JmseWp
	 nwRT5KBQ4YTzYqED7A2JWil50RRKm/8owDNExxWMHAXKbaNmW/CQZWk1bnf/tItJrqyIj
	 PbBjNAni6VBl4RA3HQxDNQGLkoWOtyExBedIdMr1y9L5jUIsvFoGsAnsdkpY8dYuZoCyV
	 /++uf91TQg2rTZ9meiuJFO8SjYMCw56ODmHjzR8iWEzOWnmYO+VcI21LrRqfiKCB2Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PgsO4qtSbQFQrT1G8e3q/c4RGMJSBMyZquf24WZJRww=;
	b=mat9SSfgFK34ow22PlCot41sJuUJ+oN/WDNrVuxFwpSDiPC0QhF42uJhXP/mCAiSw86r
	 N4TP9xiqHAPHeLBf2yw5CK4Aqskot9k/eMjV0mbJ/F49gBkVy1NCfCjM6N8T3h5ckJBJm
	 aguY6SqFJZd2K/iI4QEvSsbroWAx3La87w56r+nA3GWEav4HqIwIV5h1mXMx02O3B6xSW
	 nbWySc9Eki1VyDll/+ydfRqgbAkoTJdHNpm7TFW5G5BBz++bKa0R+7JKsIH1//hS3CCHs
	 ADK56uoz5lNnGDfxvJUPexoDeJqy5FFgwXyGZbgmc4rWF9Apy7abYd6+tkzHP6YaLSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afk4FDr3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5410606A325;
	Wed, 18 Nov 2026 21:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=afk4FDr3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186B81F000C4;
	Wed, 18 Nov 2026 21:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036003;
	bh=PgsO4qtSbQFQrT1G8e3q/c4RGMJSBMyZquf24WZJRww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=afk4FDr3mVcETF5jVfnOp4ltP+ttz5e/w2bW5vJmKL9kWzB6Cca+1U62rdixaA8pk
	 NagRGvZ/zhH+aWm+liV1lbFtBtSnT8YtCGVsunxRzh1zJGuh6l8Pc/len+xFgBDAow
	 IlxjkMavcqIe+lGT0DNHryRGPx6PITGz88ozVdoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0904/3318] arm64: dts: ti: k3-am625-beagleplay: Set MMC clock pins as OUTPUT
Date: Wed, 18 Nov 2026 15:25:26 +0100
Message-ID: <20261118150346.616523728@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit c074abebc76f0e59d13dea499f582806c6a3d94d ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: f5a731f0787f ("arm64: dts: ti: Add k3-am625-beagleplay")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-9-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
index 3560349d63051..fbcb6cfa9db55 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
@@ -323,7 +323,7 @@ AM62X_IOPAD(0x012c, PIN_OUTPUT, 0) /* (AD19) RGMII1_TX_CTL */
 	emmc_pins_default: emmc-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x0220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x0218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x0218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x0214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x0210, PIN_INPUT, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x020c, PIN_INPUT, 0) /* (AA3) MMC0_DAT2 */
@@ -344,7 +344,7 @@ AM62X_IOPAD(0x01c4, PIN_INPUT, 7) /* (B14) SPI0_D1_GPIO1_19 */
 	sd_pins_default: sd-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x023c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62X_IOPAD(0x0234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62X_IOPAD(0x0234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62X_IOPAD(0x0230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x022c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62X_IOPAD(0x0228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
@@ -356,7 +356,7 @@ AM62X_IOPAD(0x0240, PIN_INPUT, 7) /* (D17) MMC1_SDCD.GPIO1_48 */
 	wifi_pins_default: wifi-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x0120, PIN_INPUT, 0) /* (C24) MMC2_CMD */
-			AM62X_IOPAD(0x0118, PIN_INPUT, 0) /* (D25) MMC2_CLK */
+			AM62X_IOPAD(0x0118, PIN_OUTPUT, 0) /* (D25) MMC2_CLK */
 			AM62X_IOPAD(0x0114, PIN_INPUT, 0) /* (B24) MMC2_DAT0 */
 			AM62X_IOPAD(0x0110, PIN_INPUT, 0) /* (C25) MMC2_DAT1 */
 			AM62X_IOPAD(0x010c, PIN_INPUT, 0) /* (E23) MMC2_DAT2 */
-- 
2.53.0



