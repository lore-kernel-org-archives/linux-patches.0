Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062037;
	b=0FA8H7sl0ePq/nI27hLjgUzZfPQSp7tG7gzWEpinGf+HyXGykyuzM4EmKZqIzbpqNezV
	 69u7xYKxS2xTbGCby1vMccjbDSC+iPYreX+un4mPBwU3fhhgi7Z/WDCqLMY47FJFd268x
	 quYsoBvvrlfALXTzGknA9gqKuoaPyQSK7x22gKG6lqBXF2Gt5Nx2TfnnG5WQBxafPVlPs
	 49WaTNpxOrII+MmBIWngCRjtXN1LcBkLeQQb6NFulNUKoJKum9H6EVsEaM9CbU55cy5c+
	 DCqtm61A9+Hb5RhR/IMKSRECz08k4DyVwKSfE6rPb/mu5eKApKk/2dXaHggZeCQjPEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FqOrw/oTC1kvCs+GUyhB91Xzzc5CWvrSA7RYrBig/Gs=;
	b=v8W4mTaLLY4Hnbxw9/yqqlS/EPzLQlKTixRlwQsqI67yusru/e4Ao4i5LV68+b08i4K5
	 cYWZagc42NVo6laJSgk0cJOPrTtYBfuyM+yRyUhRvXXJL/MTQezHFLDiYj756CbhJ0Sbr
	 +VfUpv5kr/Gm0rpGIZUhX69ysj4kuN/ktFvd20fpLPG3Q+/pMhZklcbjtcFOvwY03eJ3N
	 xX5Kgje5AQpjqI8AUCyp8m5Wp5IhBZdsVGoUNA1eWz1kjXlUx6yTv1fm5OaFxjK+J5aq+
	 5YY+L8//zTYW+Zb3tWkhGOoWpA92KgNDDGUoXFKg/pOxTC7Py8lKUjFad1Oco2HUJkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2oVW7l4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60274606A336;
	Sat,  7 Nov 2026 14:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y2oVW7l4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186A01F008A1;
	Sat,  7 Nov 2026 14:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062037;
	bh=FqOrw/oTC1kvCs+GUyhB91Xzzc5CWvrSA7RYrBig/Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y2oVW7l4/RgX3hx8r1JkUEbhd625nLhe+jxpNi8cxarV3BZxQKp6AH9/tG+S5YpYE
	 yRsrkCUIez0QIIBhIEF3f8SL9OdOc+oHBrDRUra2Cm2nfNUM1bDNaBawwG4kruNdU6
	 6cOnHCoHsk0Dwk0ClwWrtfJxMkcrwEiV70pImEC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1020/1536] arm64: dts: ti: k3-am62a: Fix MMC0_CLK register address
Date: Sat,  7 Nov 2026 08:50:36 -0500
Message-ID: <20261107135026.327384389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0b6e371eea98d..dd406609ee22c 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -290,8 +290,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
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



