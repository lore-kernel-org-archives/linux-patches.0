Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064061;
	b=qkQJyFi7EPtZYmm9Zfokm8HyxsOwc5KW8/tx/8qoMGXleDxFMdDQHpd/bPiGRHEAsD1O
	 GCvfh9PRZ06Ih8CsnawH/SAX2g6v5yTNIwm6WTdfLsoun5B9BbpTAR0vlpOp5zAI+5Owe
	 zjMxXZ0k/keiLG1JcuQnFZOAepzs1qCDUgZii9aRttvNv1CVOe72453BzdrzsJxpPPdqH
	 If3gcLeb/HW8Sa7EqJ07wTa6H6GyZL78GxmeXvU4eoL+Trsawo5R9nrN1efR8wcrPiokM
	 BfrTjpE4Ie11fiwI/FprgbouhJvXbrBHkmwhr59Ld6hmcQnKBv2mSolgxlAEZtmi2RA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XljQnURcD0FRreBkv4MeC1EfoxFt3V8BtCrZ2kknTpc=;
	b=C/4TM2kJTT+KKeloWD5TvaRn6IOnIaFntcMQlbX6NP7oHDFGoiOoIpkQUQNHJz5M27XF
	 mQ2nnUbjBwlYSUamFum5GIs3gGx0iICC4UPJeVNDJs/OyTuCMoqWrM6AGGV+ZR17/l6aQ
	 s6zJ68GfdP6Vo1IhT80O46BMdKC7dl4H1a9iOWcQWj9JI3oLhW6bTTCF0Z0+wCejfVQ+Q
	 VRdnAJxz3Ked6ZomULgGS8zJNh3ekH/+R/TMZoWq2Rqk4yt3AEkEXute1W1O8zE4QjfZ8
	 k+qJqBb89pXSa5G/fd5TCaqej2QXrufGMsm0ppgOhPt1/aaZA4jNc2lmhNzF+Hrx7Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbHPezq3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641D4606A9EC;
	Sat,  7 Nov 2026 15:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbHPezq3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1059F1F008A1;
	Sat,  7 Nov 2026 15:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064061;
	bh=XljQnURcD0FRreBkv4MeC1EfoxFt3V8BtCrZ2kknTpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbHPezq3RDA4cMM5ih0FsTbH8SWILqTHdIcQwYpKW0c64yw5tdp+Pc3Lnuc/5Y6S+
	 m8S04Og4R3UNlc1vHWR1JGWN/uKiJOTuvjYFY/ULjvyehb+M2sugGXRG5k3EzwxhP5
	 iVwErK/o/0Wu2cFvj3uuQjCV8dP3H2XRthxGNEX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0231/1257] arm64: dts: ti: k3-am62a: Fix MMC0_CLK register address
Date: Sat,  7 Nov 2026 08:42:07 -0500
Message-ID: <20261107134945.905722669@linuxfoundation.org>
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

[ Upstream commit 9852f2badc438de82b6828c11c80ef0a656f1d4d ]

MMC0_CLKLB and MMC0_CLK have incorrectly swapped register addresses
as per datasheet [0]. Set the correct MMC0_CLK address and drop the
unneeded MMC0_CLKLB pin configuration.

[0] https://www.ti.com/lit/gpn/am62a7 Rev. E: Table 5-1. Pin Attributes

Fixes: e041ec6e86e7 ("arm64: dts: ti: k3-am62a7-sk: Enable eMMC support")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-2-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index d3b3675e7a8fc..b04636cab71c7 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -328,8 +328,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62AX_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLKLB */
-			AM62AX_IOPAD(0x21c, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62AX_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
 			AM62AX_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62AX_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62AX_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



