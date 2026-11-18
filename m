Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046838;
	b=11qRNGimWKMlwr6Y/V6gQuCipdSTKOpS7SEJMs1gN117/fTuloqecV9QSyms0HjNJvKk
	 aCfbhioh7oHF00xUjLZRdXnl085C/Y8Rzk2aBk6DS4p0XSGGvYHtLSgRCgdH+Vq1DXBB0
	 byOaado4Si57c/0j2ao3vgkFc64G45teXJRchOU1LAhLaPLPOOZaujEHhcqHIzXy3byeY
	 xDGHPggWVQbl8gZBtZJQmoDHGBQgR4I0WaBkKLGtW/YCuYOjWF09TRil4xCBU7fKrUdWy
	 A9hJGQiG6VVI4xpZf6gCrqciqZaHarpBTSTIoIAbexzjkXWFxil7PfsboYq3tt4N93Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1apt6skx+tiPcqRGmFWQzaqx+rm9jhZ/cJXGEGVEFgU=;
	b=qc1nbVD2kdG9Qc10DQ325kqbmM/8uGmwkX1qJnDF1cTjNmcG7rvteNXr5fraWuNbrpml
	 w0f0PwZg+XiTiKQp2CbX5+rt8teaO6C6snVpAVW1YFW0ucGRMgqDp2svMMIb2ikeb7FuD
	 mF/X2PHJHaP/NuK0D8/toSQnOxnGuclxT1CyAQF5Ss57xvv4UsVqxqDv314WUXFwuI5HO
	 F6P66VfqpNXvl2mKiYDqsHCEBVC3XHCd0GdiG0WRMkOQAbEaQrXzdIzae5ZNSpWzTM1nW
	 0eUj0ykGIdp+/qNPI9MMyzAukB1bV7NrEQDA3NS9N3wL5HbNhO56j9RqJCHRyMpnX0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPS8u4lH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600EE606A325;
	Thu, 19 Nov 2026 00:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qPS8u4lH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B237E1F000C4;
	Thu, 19 Nov 2026 00:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046838;
	bh=1apt6skx+tiPcqRGmFWQzaqx+rm9jhZ/cJXGEGVEFgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPS8u4lHtDrisUPpx6HrhpOG7uGSBTIZiRncOJpBuTW0RFonUvBh/OGNSuD0iaQGr
	 D3v9G1X+A1Twx2rjzYyTVBTSGGJP1qBtWRPmILgbOK62ovfede/iBIohr49uyLK/ry
	 Zf7IflCpBIOGPL16OQTM4GhrIspp+1QGEB3ARdcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1384/2857] arm64: dts: ti: k3-am62x-sk-common: Set SD clock pin as OUTPUT
Date: Wed, 18 Nov 2026 15:40:18 +0100
Message-ID: <20261118150251.202152014@linuxfoundation.org>
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

[ Upstream commit 1e2e5016bda94b2bcd86258b5eb77fe3006639a0 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-10-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
[ sashal: applied the change to the existing MMC1 pin group in the board device tree because the shared include is absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk.dts b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
index 201b7efd5e706..949b0f42e014e 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk.dts
@@ -192,7 +192,7 @@ AM62X_IOPAD(0x1f8, PIN_INPUT, 0) /* (AC2) MMC0_DAT7 */
 	main_mmc1_pins_default: main-mmc1-pins-default {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



