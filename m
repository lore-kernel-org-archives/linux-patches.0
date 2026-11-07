Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062968;
	b=VdaPQpHaxrqNND+7kcIeaOejB6xAzC3gLE6mk/ZRt6L4Pzc1ssA20pjGB4E52AvNXdL1
	 CCT5Y2IKKADnVb0I3SneKF5kZtbyFh/IY6HK4cuPwIwvyK/WAcaRIo1he6/4L+zrJKjTj
	 d7ymuZ0fyHO8ykEoBZiHjIT0OHiedF7DurPly/wY+Ho1zEpZqFAXBVedrtRApu5dKDN5Y
	 HeJIO42R+DE4Ts/CHTn1cMtPvQwEGEZlduz/f6g5Cwx7+DMw7+ivLUOujU4Ay8OU6JFkY
	 uBOQd5oucgqLSAuiXe2IE0SMYOGOfksCL3Ph3U5s5ooHsSHL/nouEiQKybC27xtG5EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062968;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r+EE+sYk6K80UUGYfPTycSrwJwVGN4bU3TsI/t3BBYg=;
	b=jLe87CpK/f3UzfUOnuFrKUxbjP8J9k9gTkJCdahvCzq+WHGIQA/UMsM24CcRQaCpZfv/
	 TwVKA2RI3zmIF2sQQw0zj1SMTtS6Btz2eDC7C1cxxenFwMt0PeG/5aihP9PfyoI50QDbR
	 tLxiNO4eSdOLCppyEuVDC1Vs5rIMb0HU+Gsr+X1bI+u7kXrT0FwlcruZkl/TWcBfpfJgQ
	 QsewDS8lSKfc1Z0OBnDUcADSLWj/xnRlGzF9smH5YB0DtP5O/IpkEmDrCfNNHbWTxkssc
	 L4Oqk90ktP1UAUqEDdyiqccsdS6L9CrGAFx0+eg8u2Q+proa86RrCNAXrF7FVEhqDZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bb4h4J4s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F169606A32C;
	Sat,  7 Nov 2026 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bb4h4J4s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9281F008A1;
	Sat,  7 Nov 2026 14:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062968;
	bh=r+EE+sYk6K80UUGYfPTycSrwJwVGN4bU3TsI/t3BBYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bb4h4J4scZUcO0NjuiW1W4LG+vFGVFuouNjRhhIpIZk3j+fPPy43qgkVdUFgbM+zP
	 QW8xWW8ooGkAD8ty8hSGjITztn+GKdHW5fZ+f5iXFv/Ta9rfEoOnqpOHtF3H/nrfnN
	 bC7sNqr4QSdeGno2PEjaZ1kPkMXqpaB6Df2Q7UNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 185/869] arm64: dts: ti: k3-am62a: Fix MMC0_CLK register address
Date: Sat,  7 Nov 2026 08:47:47 -0500
Message-ID: <20261107134858.391806812@linuxfoundation.org>
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
index a902b88062093..29e7673dde331 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -313,8 +313,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
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



