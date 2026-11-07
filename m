Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062048;
	b=nwiCAsaRvnQ9hWt2kTiahOv6ODosyMSXcKg9oH34f6RH2bMFwpMMrAklTKervGi/apca
	 dOoVzgpgVuFiluXRCQylMOZX3oVuOZQbB+DNm2VDAWRgBy+0xjA+SJauSEzK/DxMmDNGu
	 iWVVBFTKW/FloH8oQDtnw8ZoTZF/jXMrGAiXhv5huC8a6aIa94bIFJ+2j0jruoU1CNOuf
	 o0G4gpJov5GwrUMPlRK3D0FIR8fAemUQw9fObjzjew5nKkrFESUrDSXA/Km9z5bUmDoCW
	 J/T2hcD08+SHwfEbqq3yqEcWNQ2ohik2chp8Is1xlns44wERNqFEXm3oNnZi8RVvAGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aAGpOkljyik/1cfiV8V4+ktrhFmyDURKkgU7kzYo5jw=;
	b=K9/4DFi3f/ITTS04wyHYgX4KBSguxKr3DTicuBjyIZegn64Ya/EdUTgKRag1rBrOdgnr
	 xD8IqsUeB7Jn/u675AzuLjQky/ycgIhO6UYmFsXqamg7lXZTzGrUiQACnlYNagjFRscF9
	 Hr1Hrp8kgSYTMOPFw9jm2/1xfXeWxKXoUtbI+jyY2hyAk/qyU7NSe/ugxMCQBUZ0uBUKc
	 QB4gWA1dTzyyRGOkDyxaE5A1NPJkVgINXVjpk3vmS0Gcowcg7PMS6RmcNpaCXqpxGSeiS
	 DVAGpCxa8k45vk+lb28GoQke/ELdF/TZGsJoM4ZPB4I3fZV87RSefH9/mfo12mPphOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="W3nm/t1Z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBFB606A334;
	Sat,  7 Nov 2026 14:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W3nm/t1Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EAA1F0089F;
	Sat,  7 Nov 2026 14:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062048;
	bh=aAGpOkljyik/1cfiV8V4+ktrhFmyDURKkgU7kzYo5jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3nm/t1ZwFNF9NGPEoQG19Iijs9IuXozFPIv0OBX4kwJihqxorGn3p68ccgS5DJFh
	 DUs4e9RTFzR0LZRPRrjJ/BmqkCeLltFGeoDegkMJPmC1Rag+8mx9V8/D8dRKq0NxoQ
	 GoMwtisN4Y/T/iiywDiYda7B7xfI8hanRJxMYV2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1028/1536] arm64: dts: ti: k3-am62x-phyboard-lyra: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:50:44 -0500
Message-ID: <20261107135026.549411403@linuxfoundation.org>
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

[ Upstream commit 1d62ef8d47b535d31fb9cf38e5c36eb55b0189a4 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: f1b3adade045 ("arm64: dts: ti: Add am62x-phyboard-lyra carrier board")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260909214743.899477-16-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
index d6ce53c6d7481..c93bdae757145 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
@@ -207,7 +207,7 @@ AM62X_IOPAD(0x068, PIN_INPUT, 3) /* (R21) GPMC0_AD11.MCASP2_AXR3 */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT_PULLUP, 0) /* (A21) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT_PULLDOWN, 0) /* (B22) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT_PULLDOWN, 0) /* (B22) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT_PULLUP, 0) /* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT_PULLUP, 0) /* (B21) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT_PULLUP, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



