Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064071;
	b=ZbZT8lf1CHD/LJOWXe2d8aADe/hpgBUUqjUUNSAWFz+M8QLy3WC9y7rysX/xk5quWxs/
	 ScmC88xLpjakrMD7ooi0rEeEGoP/ZWLSEu0isyV4BcEU/bWCC4k81NrFMo/sOrfez2xqK
	 tyJ4+po8doi+xyDDdjJe+DEgGwjCrvd5Z1Abo8qNvbgMn8EmuOitJxew4EhEtLxxKIVck
	 j1aY45X1VIo0IhzqLtO1Fr91iDaSzSHWg7XfsxTwIhEI6+RQFgRwJijibhabW1QZluO4q
	 TwhkSOCZFuFM2Iwv+tmV9LrTKbOQ2oWCm3AqvIi2+IvuJaV2KznfWhVB0F3LxJSohOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c/QgAods3FyFTgglcyrPi6whiyjlfJfkiIJpHU5uu/M=;
	b=hkWMltmMDLRauK+oAg8FcAmVc4cxg4w3ji7pM6Fsn4zzThlTi4q5EGNt+swSq1EkWfte
	 p2kquSgBhhEx5pwOjwffgVJrTBw8tpa+g3BBwBJDWBMVi6QTzKwqSWUr5IT9GGxvUqH9a
	 /yr+t0K/kcIUdSxPkNAiQgcKxWA91mmLyfs9yDlHkKseY3mJng7M1+eAmXs2tpCO7WnsN
	 2Mz8pct2divWQBOzj8khWPmyjRhSj2PfJjh7S0vI1ir5Hg1AIuSXNVVp5uvVt7nNeo4mE
	 uafpT43D6aUyHUk9udUHrCmMoCIgPzLtytyUDCBige2NFIloM5LhL8QQY6rQEce+kPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjQuv68W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C17606A9DA;
	Sat,  7 Nov 2026 15:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PjQuv68W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B7C1F0089F;
	Sat,  7 Nov 2026 15:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064070;
	bh=c/QgAods3FyFTgglcyrPi6whiyjlfJfkiIJpHU5uu/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjQuv68WBcQxLp0eVy1qyBXq3J4ISVM8YinbLk/tqDbmpYSxEp9kcpM6EvryUgOoD
	 DzCBjke7EnHOHj30YaR3tbOKFg14vQbtdYdwt0xdRyQg1VFcZHIR25auLNS2W6nCO7
	 tQtLkKRqRGIHbWPEjT9UPSCTHzeeuR49GeRhLbCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0237/1257] arm64: dts: ti: k3-am625-beagleplay: Set MMC clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:42:13 -0500
Message-ID: <20261107134946.066574229@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c468b9c5fc09a..898e4ca3fd87e 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
@@ -323,7 +323,7 @@ emmc_pins_default: emmc-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x0220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x0218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x0218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x0214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x0210, PIN_INPUT, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x020c, PIN_INPUT, 0) /* (AA3) MMC0_DAT2 */
@@ -346,7 +346,7 @@ sd_pins_default: sd-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x023c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62X_IOPAD(0x0234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62X_IOPAD(0x0234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62X_IOPAD(0x0230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x022c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62X_IOPAD(0x0228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
@@ -358,7 +358,7 @@ AM62X_IOPAD(0x0240, PIN_INPUT, 7) /* (D17) MMC1_SDCD.GPIO1_48 */
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



