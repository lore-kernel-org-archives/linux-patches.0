Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062914;
	b=5V7JyUwzMOcw3sxZPXeQayWRaYMiH+/5UQLo2Kzz+ADpLmbBVC4EZa0+fqEt+QGZPrDy
	 vJErw4RgngAHu3UsGmaEoSXXvIEJZJuMolCY3cAln1Qghav1x1PO0KtY9UsrujmlqRHtu
	 t6nSsanTvMJWLBTYlQ4T/r+sRcS57VuI+Lr6TJv2UxfBtBMYuPAjO+b/O6cf6EdGYUuxN
	 tPbzm4fxn777WGBfFRplp2UlveV8v0cP8Y44w2UAs84iRjg7ICghbvw7im26Mr9AMYHtT
	 tE1eUaTNmyWRpuhzXHtvciUKsXuIwxkeNuIoP+SITSVL+xAUHvHkZdd1hHjVOheTmZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062914;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wi0Rcvmi2X+EH4qXKqZEoysPv8npVStgD2gsThmUw4Y=;
	b=OR7uKcu+6SCExQmcUC4oWF8VpH8ugGzFzYatLCJJtsGuSvEEUYe4mZ6WNdxm+QUBUCne
	 UTqxrp0ejEa1iIa3rthiTYVbbJQeIuV+teMjQS88jV70Zmp+nQ4cjgtxcJJ4Sv1haIBgQ
	 Br2SCfueekMGyEBJ4F1tYlvezKbcY8TwGmuaW9RR7ZCKDzC0tY96Gp3mTSb7MIW4r06Lb
	 vp1vhvEru31X/bTL0XE9rUxE9VT7Itq3zed6Fss8gbO0kp6NkO8IYIh4jPM4UGR68+Fy2
	 1cwEO/jMnkOX1BYieeIErPbDdheLBGDkpjgBIrTamsRj0olrS5WUzN0o/3uNZ+oCIuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gC/UGkEY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44631606A326;
	Sat,  7 Nov 2026 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gC/UGkEY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67761F0089F;
	Sat,  7 Nov 2026 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062914;
	bh=wi0Rcvmi2X+EH4qXKqZEoysPv8npVStgD2gsThmUw4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gC/UGkEYlXr8LiNWZJ/ZeOg8BpFEmvClDv6Dsm0U5j9AoxRevNanBYP11wnTZ3P5m
	 rvNOv1V/K/+Z3EKVoHPZdQpVRS7vD+rULquPkK5RKAw+ufzwcAtZzsFis0OuDmg6zf
	 hA7fKJkPPRxERW9VQ7li3VUNdJmh5IvJ6fWisaDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 190/869] arm64: dts: ti: k3-am62-pocketbeagle2: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:52 -0500
Message-ID: <20261107134858.530348254@linuxfoundation.org>
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



