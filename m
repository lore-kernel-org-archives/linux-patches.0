Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062970;
	b=D6DQYoDAiSLY6xQaXR5y+ZPVmnhc7QKwfD9V6lTHjXNaw5HnaQKz9xa/WmrYiOYFa6gi
	 1/HfK3ix+L3nT+J2ZxuJeMdEbMuqAtwbUREKmXgnF8aLqQ/hppXsM26iemOXjeoXrHBtc
	 SegZWllYBwaKPbi1DoHSqdm6AQzCNbbhXgB4ChPKAUgWk9bhM865JcslhGE/ptKPVC7TA
	 nDhLkp1Xt5DojGq92CfqzgsITBBEDudmUPadLS6TZ0ZEBxFMmCZOh9QtBLoYn7VmGmv3W
	 +ezCE/+Z2kaAc9K+ncMBhvJuvEAUrkx4lnCBlGZJFapiy2F90j04WesgFhtVItjTDGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m8maJqBz8isQZomxL1BZQV50h8RELc7tsiGOZEhm7qQ=;
	b=Cb/0P5HOhfP5cQbiPHMrDRhTj0gctsMlxOlAKhBrstkJMD/ExRcYXo/yXJSCTJs/curj
	 mITUXoe5OrU/0s+DCNzy/w4AC3OZVVnLMv/9/c9UU9QUxPQQhYHCYidGzaRIxnR+POXu1
	 3dh7OQP3hjucsYTq7V9bSPUattwzQSYpsm5wPYAkEcfe0jfwJ/GsBkFV7nW1vKlabNmCI
	 MIxF6+ZHVSSJOtFB61gIVuenSmhLP9wIjgjYBDmmVuqpz5ZgVJpIIjCI33S59D+hxkZmK
	 8b9k1ANUnTgaF2ZROWq08OViXf08/1ssnFhevWm6rjQu8T4t4m/cEGNIs9sas1Dy/Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=txwOQ6Ht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A64606A32C;
	Sat,  7 Nov 2026 14:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=txwOQ6Ht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F04C1F008A1;
	Sat,  7 Nov 2026 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062969;
	bh=m8maJqBz8isQZomxL1BZQV50h8RELc7tsiGOZEhm7qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txwOQ6HtQMMJW1sx24vKsx4lMG17fsS3nxwiuj7otjSu7GapqRBdAShSQ41Qvug+8
	 SnAjjqu9YSAsoXix5GSUPBEpwFiFqy53ifzfhKzoy+EuTWcpkIkiZKA6PUph/QM4It
	 nFwCDoKLJWiLC+pjdvjc76VGCq4aIm5unhyvsghA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 186/869] arm64: dts: ti: k3-am62a7-sk: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:48 -0500
Message-ID: <20261107134858.420006173@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit aa7d5b1efa75e58c9d440dfd720205045fe6a806 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: e041ec6e86e7 ("arm64: dts: ti: k3-am62a7-sk: Enable eMMC support")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-4-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index 29e7673dde331..a9141640c35e6 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -313,7 +313,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62AX_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62AX_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62AX_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62AX_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62AX_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



