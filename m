Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064078;
	b=1DGf15Wbp6FroIgv/BYo2IR3U8Dgwk4IhbJBhE9RXsAJM9KsQMixnQ4Bw0OD45ySKdGU
	 3U2SXm8c6+PL09M1K61MeWPJT0KWEkSW4pHJ0HAv1pD99jvJn+SX2wdQJIPf5miWw92fZ
	 LoosIQyIn2Xv378qzvK2zR2vk2zV7/1mqucXc7m7owQQJ/hcKVHSKBCMufgnZuPUsUDT2
	 Ev8mKNpnBtUc3sy8A6HchZMrWaPLQxrCMyotnMbYBF3kWXu0SK8+YM6/LMyBvD/bp/v3+
	 BYgwhBXW6XK5zoBlAN31AlBEQsctxsQyHXvQIx2Txl3C1H8I6TixIgQphEYDFJjH9VA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vuV20j6GcTpkycehr9Pe3UolzkLjsdPRUSYGa8XJ00=;
	b=wnJc/O0Xl+h4bf/eSV38jRMD2ASnAY/1/0mV5u9+hzVKZPchHQnWeZFsHCkKTvd5qTtv
	 FV/+Wx2BB5OM6kz5q0iG/Wr+u+eJnDMK6XhLOMPog+ybFT6+farRW3La/ONNq6j6qWyAq
	 GbtB8y9HB7Vd3uVYo6zK1k/bLxX5eHSpSV9p6loaI68NywTcvX9/TsjmmmCP70tb2R1zt
	 UStlr2N6F5qKLWdnJeIP1VhoZn944RnsewHxJUXyUY+gF7qpA85SKll8RjnthiW3LuoQ/
	 yo+6afseo6yzvwnKSzgz/Du7F4UiG8RlT/05vK0O9p3zI4RUdbtXSSRbS0/Q53nnM8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ely6j6/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77FE606C03A;
	Sat,  7 Nov 2026 15:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ely6j6/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EC51F0089F;
	Sat,  7 Nov 2026 15:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064077;
	bh=9vuV20j6GcTpkycehr9Pe3UolzkLjsdPRUSYGa8XJ00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ely6j6/dUCu3AUnBOgEVNwRuTNcQ2liDMAPj68dNf9+gEtHsPOvL+y6yG9YwUr604
	 fLh5LavJB44G1vM5wD+e5YeIPrlR+oZ6v/81EOJIfoU2NfYLg5a8P5rDI7FaDowSWF
	 u6hHvXx92b8ujWl+efSgtclVIlvSsyolxLSyHhO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Stefano Radaelli <stefano.r@variscite.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0243/1257] arm64: dts: ti: k3-am625-var-som: Set MMC clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:42:19 -0500
Message-ID: <20261107134946.227119556@linuxfoundation.org>
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

[ Upstream commit b489fa1808ea807c4467def7947c83d896dfc355 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: 887d9e03c487 ("arm64: dts: ti: Add support for Variscite VAR-SOM-AM62")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Stefano Radaelli <stefano.r@variscite.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-15-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-var-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-var-som.dtsi b/arch/arm64/boot/dts/ti/k3-am625-var-som.dtsi
index c2daa56c35e17..c23b6a90b8b13 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-var-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am625-var-som.dtsi
@@ -277,7 +277,7 @@ pinctrl_mmc0: main-mmc0-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT, 0) /* (AA3) MMC0_DAT2 */
@@ -292,7 +292,7 @@ AM62X_IOPAD(0x1f8, PIN_INPUT, 0) /* (AC2) MMC0_DAT7 */
 	pinctrl_mmc2: main-mmc2-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x120, PIN_INPUT_PULLUP, 0) /* (C24) MMC2_CMD */
-			AM62X_IOPAD(0x118, PIN_INPUT_PULLDOWN, 0) /* (D25) MMC2_CLK */
+			AM62X_IOPAD(0x118, PIN_OUTPUT_PULLDOWN, 0) /* (D25) MMC2_CLK */
 			AM62X_IOPAD(0x114, PIN_INPUT_PULLUP, 0) /* (B24) MMC2_DAT0 */
 			AM62X_IOPAD(0x110, PIN_INPUT_PULLUP, 0) /* (C25) MMC2_DAT1 */
 			AM62X_IOPAD(0x10c, PIN_INPUT_PULLUP, 0) /* (E23) MMC2_DAT2 */
-- 
2.53.0



