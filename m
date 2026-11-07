Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062046;
	b=xU78oa+0/teBWDlcFN6gxQ48o0x1wnQ44jlnuAtQmYY1fk+5Kdqr3bnHVHK+mzAtOaQE
	 PG7eFsDUpc6s7KAupzmAQhW5fK7hjMiWu7mT/7KZu+W4TLR4hlu5uvv/rWG9bkUrVmnJ8
	 ASEPMchOw05RlzaWtO89Zg3jPOria82F/CNziKRVGcjH1AuKQOrcmBs+CrRNAvNNaya5p
	 Ofa2tw+qj/eM0Yiynme26gD6eHx9zkuna3xvwJYORRdSYCDzapDXFSQZPixhr3YrkhWYX
	 ERqr4vBqJN7lapqxkwWxn24FX9hR4tcoW2Vs0CZyuEdhYLy3tQV4gjTt+o0VAU5K2yQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ue4Vy0z9c24Y4zlBvGqi8dLdZzFtmXEeK5LMeZQsYI8=;
	b=kYOu0SqLslE651NEBKOI+DH6PhU2Ux2wolu/+e7Q1JDC7cIAKDJuWai6x1PlDFqgQ1D0
	 tMqULkJnsev1nsYbB/TbdO4cHn2iqDuf1iRV2yd0FzNZMnPWwzzUhtjpRn+hOrTCK5zkZ
	 qeelQEtG6AIZDA/5eUwL+PpbgeXaHhLImlzweWACSpEAHeAqqL8lwXNaUGba3ddVDaWar
	 YtppObZSyBVyr1jok1192Sv25LiyhgBjpsQ/pIikrXTzjfaSUB1VO+dPu+fS2TtELM1HP
	 tJpYPsQ5U9W9+WW4Fsw3jlTb7ka0e9uYonbbRRra8n/NoV0CPF8ocbbApYeAdxM9YYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ndE3Cus;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1955606A336;
	Sat,  7 Nov 2026 14:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ndE3Cus
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904681F0089F;
	Sat,  7 Nov 2026 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062045;
	bh=ue4Vy0z9c24Y4zlBvGqi8dLdZzFtmXEeK5LMeZQsYI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ndE3CusFcXX0zTDSiO+krIUKz5896HX78LU7WS08AudBrBE8YL6C1KcaqiwoMX/f
	 8creDAvAI49XtIUGNBq83dwi9utE5ogTqXkgrb/nU2WTg4oI8ZOFC7ld5P3HeSZBnj
	 e8CP9qqhMcQx+KaBVmQ47dfbwPYrxsJhKE0phjF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1027/1536] arm64: dts: ti: k3-am62-phycore-som: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:50:43 -0500
Message-ID: <20261107135026.523376763@linuxfoundation.org>
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
index ec87d18568fa1..e36f3c181866b 100644
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



