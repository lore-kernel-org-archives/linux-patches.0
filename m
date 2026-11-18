Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046673;
	b=I+qbSrQkRNtSFBiQzuDNNtW5zItgWxSx+GKIyhPMb+Zra4bXcAVw2pLJ4dVvdxGDBWMn
	 BpBVoDuRd34qlSi/FCGxIVdxIS4wn1PRnSUIm7XAWo289n2fZtThraz70o01NR0r6lDI8
	 fmMvuGVn2s/txw6DWguH53clJzrG+r5IIsXA4z+NkhGBLA08Sme24PMXSURL+OYb5wz9o
	 dLkxCgFppSqDP86089h7phiszGwae5Asv8DWaCsA23HykIZm8mAmf5xsnBWKoEn34sMoQ
	 CkxvaDM0MCCI1z7dRSc0bZOKak3OR655RWciv4lwk72hf2Cu+eG8wMZC7VWpAMifhjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2MefJCdNF4D05XLATKw8gY/mKyFGngO0BILX8uOrfeE=;
	b=oX4rPwLeznudVsMXtF2rr13nIW7RoRC9qzmLFzE5kid6pSukSAltcJR2Z9FYTUWP454B
	 NcypWhPM8qrxq3vK8NJeFBOhuL/TRny88ZTJzmD11xZmPCyO4eVKLzn3s0xZ4bvNZ590D
	 lRvvBYR2n5C85kyWj+LX/L9VQccn44q0LBfV1a7OO5ULq3Bc4ONyCHv203/I5/Z4we1L1
	 vm13uRLZ+XaWiiXLWT98EpVvGyT7GcrBGfg2Fayktd1pic4n7al1CpsV7nXE+4kICzR8a
	 e/AA2WA5hRifdcIGFK5mITVSxNu16XXPr1nHNFqkFOPDr7NGqe2xdSmBJj2rJYKyC7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bD8vAouo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B461606A31C;
	Thu, 19 Nov 2026 00:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bD8vAouo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 994D61F000C4;
	Thu, 19 Nov 2026 00:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046673;
	bh=2MefJCdNF4D05XLATKw8gY/mKyFGngO0BILX8uOrfeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bD8vAouo5/gk78ewq5MXeh7C3cbRSkmTPN1kRbvw3cgJJHehrxykGEaNsrHoXvWDT
	 3g60GZXQVTdMX624h0o9wwdthKrePCWbw7NN3lUAqdnwR/lYqFCIKWZcu5/w40hhc4
	 zFu0fHv6VgVI5SYXBYVluKdLzhAvI4dQ5gC9wo6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1364/2857] arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT
Date: Wed, 18 Nov 2026 15:39:58 +0100
Message-ID: <20261118150250.514528075@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 8ef8a0e38d1377c6d51c06f95c64d87641b2c717 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-11-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
[ sashal: Applied the change to the existing board device tree because the shared include file is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
index 93a5f0817efc4..201b7efd5e706 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
@@ -177,7 +177,7 @@ AM62X_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
 	main_mmc0_pins_default: main-mmc0-pins-default {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



