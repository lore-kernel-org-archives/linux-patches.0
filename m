Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036012;
	b=TkJbfVNYTLjz9VNgR9tkIp1c5cMnUK8I3CEiBbwQL+J4hbejBCiqDi8N3p9qO5d+t/J3
	 /EZRFIJoimhsuc4FfWas8A/Q7NciGPrG1hja5a0owFuI3nZfAi2hOkdZL9e2lB2rXR+UC
	 ISLEj1VCBiiI/OX1cbr+hcLswqLYsoussjI+7chWyau4cLU5X7XPK5Q1tZ3dwa56JKt+b
	 E3CaPA8Vj37jv0QLUmVhN3l638rER9o5o1sJiJ/J3VS6Y3dCFD0w1S84BzehhWBjn2tMw
	 h0wtbIZwkmGOzK28csG8Dw6YVA2x9f0iRLcJWD/ljcp5dVkP8jhSCVHLq1a7/QX7q0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f/nraGmBse96y0Uf/dMffOLF5XVel/y/IUI9hFkkh5s=;
	b=WWfg8EAYinB4VhbD44b2Z49lLfeIRPPeaYXzeS2PW4GiwqiF4u3YC30tRr+6qp2hFjd4
	 iUrisg4pxq04kXP02HSXxXERHaj0Q5syEPPspr2E+3E36DbIyDDAgG6Nx8DSGwL48QLf+
	 CLjfUAgIN5DEv3FetPfXrjVFRgALGRstbQv27t/xOggxRc0lCfm2XdQFLhoo9lOHxzBoY
	 ZI0cUICau/RkiOpC4uOzBX/QZauIfxbBfifLxdFaXd4GwghFZ7Au/tWjMKAwx1v1uF4kd
	 dbnGBOLEn4zD3CLNs3s8hoZZdMAiEj7STEjN2LbishAtj6T4KTlmIqNtjZqA/8ZVqAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JnKSsNgD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DAC5606A31C;
	Wed, 18 Nov 2026 21:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JnKSsNgD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6369C1F000C5;
	Wed, 18 Nov 2026 21:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036011;
	bh=f/nraGmBse96y0Uf/dMffOLF5XVel/y/IUI9hFkkh5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JnKSsNgDrlnFv4ssGyvDdea+lOyaIcYbrWFYA7AU6oylhvV06Y80rk2kIutwbAGOP
	 f81z4RIgfnNOprmVimrTqyfkT+kzkZhEWScbGGEbORnEUUxX4s66B13vxmTzGaxYEM
	 BivP6BQnbuzruG/DJ5YlrLqGc9ekrjwKxqkJfWNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0906/3318] arm64: dts: ti: k3-am62-phycore-som: Set eMMC clock pin as OUTPUT
Date: Wed, 18 Nov 2026 15:25:28 +0100
Message-ID: <20261118150346.683018308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa43e7407eee4..d39985504587e 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
@@ -121,7 +121,7 @@ AM62X_IOPAD(0x15c, PIN_INPUT, 0) /* (AB22) MDIO0_MDIO */
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



