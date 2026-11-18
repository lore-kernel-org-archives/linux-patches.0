Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045074;
	b=q/X+TNvQfytrpEKDvUR7T0gKmJFy+X1hI1edr1cCGpFi2bzr6K5AefSiPPUiCKgsh7oV
	 /7aOG0XmqGdFM7wEAXOSq1N1m72jBZmybghdALTjgH7weX18SqV3fsAs3LMDIT8smJwS9
	 txiWlsjshkIz5iQWA+qJ0eb39Gtf8PUiYhCNQMjhP2MUKOcXU1koS7owmhqvun7KSVEfV
	 TBEzX4TgvQrK1xAaZacC2cm9anH2N3wwKD27VimcDlAX8FAfQib2dw9/GBYdclpjJo40y
	 kiMOVvaOROYyMxrKf+JHnOA11CDzHjpEJNCAGk7zOIZ2YinoQdtbzi7zRPor01AOgiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5VhyJNkgRzVXVPX6Bz7Rm5PgNYiJL56hLyLuuefQWrw=;
	b=3xSDy1tXVGVQznB1k0XryNAc9nc0eBUxwSmnZBSB8d5FqhxVphMbHMWu4HWdW4jhkJu4
	 /Z3plG8uNqWG2cQVX93LUVqI7LvERCVvoBZvtLAu/0+Gyk3JOoJOV+TtkZHM6kTgCDGQd
	 ld1k/LRbBKXacueE2JhqY9ew+DWr+r153aNuZSfdn7k1dEd5dF5QJN7tfLZ1o58pkpPAW
	 ukBHLqU/eHvo9FePIi2jjYX5Nd164h7RzNyOwk6pJBGlgloz7l/jZLdqISKVyiNiiXAsg
	 jPutjZ8rn7jjDIb7brZe6YP5UZA2DK5DKozmaXEvfViW1uKuZcHrt2YYQbvtn42RIkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBiYyNRj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4B9606A337;
	Wed, 18 Nov 2026 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UBiYyNRj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB70B1F000CA;
	Wed, 18 Nov 2026 23:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045074;
	bh=5VhyJNkgRzVXVPX6Bz7Rm5PgNYiJL56hLyLuuefQWrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UBiYyNRj8xnEaEOPDNw4swfQ6WgbWYv9bt4IU+2ipdGXz3H9vjiULfk+P+ipcE3CT
	 Uu4juSQ+iBOL/rMkTXC8iHQ+eXoNVdOAH0d4gqCwzfMJIjkYuv88NtWzMm+bUBMhRZ
	 Bv0chWW4WokomkMPtLg0QpA9ODq8MDfq8TK1h7lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0795/2857] arm64: dts: ti: k3-am62a7-sk: Set SD clock pin as OUTPUT
Date: Wed, 18 Nov 2026 15:30:29 +0100
Message-ID: <20261118150230.193675114@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit cfad4f39124b218c2cbbbe17e742971abc9ac8b4 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: 38c4a08c820c ("arm64: dts: ti: Add support for AM62A7-SK")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-5-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index 7f265c671654d..30987c424a270 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -145,7 +145,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
 	main_mmc1_pins_default: main-mmc1-pins-default {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x23c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62AX_IOPAD(0x234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62AX_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62AX_IOPAD(0x230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62AX_IOPAD(0x22c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62AX_IOPAD(0x228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



