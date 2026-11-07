Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064068;
	b=H/5w5syym6Q7FmGthmO7mVYStmSo5iMQCVhrofjm2dxkixw1/6C76D76O1IfzQ5mOhKz
	 VcCp78mfkkK/NlyAZGbfD9bQGJd7eejTd2qWzY3hc/+6vgp0jV5sUxIxx4RdvtDt05880
	 k48Hr41CQXnbeK2Vymm8PwY+pMpmNJyL7dMFidt9B/EElBtRf3OXcsuNLYL1zuMg/8z+P
	 pRXnnn+S34BRt4Akx/PnQ/GbZ3+f5N1C6VhhrT1cPbRldthSFF3EvXwSaxo+KNKfrbhgv
	 UtLTVsOlvBBwW71LHedzGR81CTTAPbNUb1+usxBNjTF04sWNEIQ+eWh3qjEOw5DPsPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o6VFhpNBSBbS4eFcZb8H0qAfNjNsAWsQt7a6pEBLlfQ=;
	b=mN1bmPxD9wUJUNKv8ibstHRzJKj3apkB1oKbPYVJGANVD44I3gMDoP5U5vgzG8lHSfUS
	 sBGG+/1IE9dXc5icSKoh0iYagB78vKis1Etyh0dckO2arAZTi9+qEofgIC6hNJ4YCVqmq
	 tE0YuqWnruAspTBo+tjHNknjQcIvQjgkZZTV5PwM3V1AEwG1a5/76EfmzguWU0mqzNmeO
	 LZVh5vSZqxJk9BeHwxR5DEu/gLMMCkn3GdshSJuDWLnrhem8ShuilQCBw6pZl6zJb3dFJ
	 1EoStDCqnWhdeF6R8UNA0my5Jo1UTYYV4K3YF8E5mcRdbm2EBo7AV55cIOLBlXJ19KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1eP0EhI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18977606A9F1;
	Sat,  7 Nov 2026 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1eP0EhI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DF71F0089F;
	Sat,  7 Nov 2026 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064068;
	bh=o6VFhpNBSBbS4eFcZb8H0qAfNjNsAWsQt7a6pEBLlfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1eP0EhI9asLuQyZ5bEFWfv6eDIaufdeONIrkkaAHUkh6KfQ93x77JHyrZFCBO3tv
	 2EbOc/2Ywbqp5cM1ZwKpOyYuClRLhsKE2i139BaarO0O4N3+nklh3v9K35kYQCAzTd
	 SQEaa1k+sride0rQmHWGf+q4pZlqbP8eodAh6Zl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0236/1257] arm64: dts: ti: k3-am62-pocketbeagle2: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:12 -0500
Message-ID: <20261107134946.037323143@linuxfoundation.org>
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

[ Upstream commit 843c4d171975059eaa1436c8403d9a29f677a75c ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: 92d8c028aa92 ("arm64: dts: ti: Add k3-am62-pocketbeagle2")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-8-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-pocketbeagle2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-pocketbeagle2.dts b/arch/arm64/boot/dts/ti/k3-am62-pocketbeagle2.dts
index 7a4cffc27bda3..1c691629d4ad0 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-pocketbeagle2.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62-pocketbeagle2.dts
@@ -235,7 +235,7 @@ AM62X_IOPAD(0x0020, PIN_OUTPUT, 3) /* (J25) OSPI0_D5.UART6_TXD */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT, 0) /* (A21/C18) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT, 0) /* (B22/A20) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22/A20) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT, 0) /* (A22/A19) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT, 0) /* (B21/B19) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT, 0) /* (C21/B20) MMC1_DAT2 */
-- 
2.53.0



