Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062919;
	b=jTsBGWbki1f+TazjNiYIdQGBr1cCzmZwCeY/F07p+eol9vL0FpeNmczRKzfNKrw3ugjE
	 FPPCqhUM98KFSczbLFod2CDjMXt2CjlHp+7YDjpR8E6FCBkz/xOIia9eOd7L0+PmFYoRj
	 IBV7PYRrIqfU4u/B30AqA9Fd6aF9wiE3Qb7ShpIYzhXlpbIQOdpnT1pNARBqb0e3LK4OY
	 Waet6lJAcFCZ3KFsLQyrcGJvvrnOWm5XpIxyOGGbqcOxkCwO7R4FlKyUCZHlhXBU4W/Lq
	 s857RE4ibMY9opM3P28SKh7q56+AlYiH3TXjNr5OFdLPeKIU9ZkJ5eySIYPm4Ifvawg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fKZxqsycgMDeCKKsHKMgVGsp5KG4vdB42WLy4wQwH/c=;
	b=fO1fH/Jt2aH+8InB/la67PoB82bHgDpzF28RJfyhoZqtB4GLhZ/VxmPjoB3mE5vhUHlB
	 uYvc6JQGn6yygITm04KtRWYDp2TXw/LZEqq/18VS7NB0qxJjY6IgNDb3PSCZ3IHXexMyU
	 DCXCVHXhex25Lfg3q86ncGwuAcy44j12odTMXT2BPG3nw1sgOG0iahjXZFFB0Ho6E3uo5
	 s3lFjiNTWXUrePxaE32Q/6Iy8Bgph1OF5I5CzNcDd2+xflfEZ0y+72yYdgP39dWfOFiWg
	 CTRyYsJfeXtJjfXPmbr/N3hkMtpp0781lGI6LMx7chHwywxbYLXnn6SSDdDavBBSdug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sjcf4m4c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86935606A330;
	Sat,  7 Nov 2026 14:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sjcf4m4c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC6C1F0089F;
	Sat,  7 Nov 2026 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062919;
	bh=fKZxqsycgMDeCKKsHKMgVGsp5KG4vdB42WLy4wQwH/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sjcf4m4cjp8WpIrguLd3/pnkCgtTGjZ9P7Fei97pgZT2TyzRkLg2pkECPQDHhqR2r
	 PX1qBjOB5YU2AH74ISAtsm2BKNZunvhAnfxJoTADz2407xsbtArRAs7ohm5xV1DjZ7
	 ogx8cc0PRVYUc26ZfuiWIehcQTW2OiGna36ex+xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/869] arm64: dts: ti: k3-am62-phycore-som: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:56 -0500
Message-ID: <20261107134858.643679021@linuxfoundation.org>
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

[ Upstream commit a3c2b6c52e02d58941c0b91bfba052788aeff890 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: 3443c1c4ed61 ("arm64: dts: ti: Add basic support for phyBOARD-Lyra-AM625")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260909214743.899477-12-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi b/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
index eeca643fedbe9..19ac2dbe66cb5 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
@@ -146,7 +146,7 @@ AM62X_IOPAD(0x15c, PIN_INPUT, 0) /* (AB22) MDIO0_MDIO */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT_PULLUP, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT_PULLDOWN, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT_PULLDOWN, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT_PULLUP, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



