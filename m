Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064062;
	b=jnIfqxnrLUVoUEERPzdh17LDzH4CAEcIyXhCMvfs1o2n1ZERtQ2RYG41elCySVdX66z5
	 SoILoGDHs/Es3ui4Smp0JRq/V5F+/8s5255nNmX30vQ0LWfPIn0pY6/crW8AhEEGaF2Z/
	 uowTFgD+oUQ6OPdwNVqz9On54G2uSP5dikKOlyDx/QAOeGkf2rALlJ57cL7CGPY1f5ETZ
	 CQtFUncwzC6vIeciHQCpYmXFVSBFTSGfKmbnkbgsOsKAWhV0CF6VvAd1F24bhZuFufwNT
	 d2ZFKbAIhDzYPHfSklmXB+Cg7FtVAhxMJMk2KzYN9HkJhMelcjY6QmxgF+hFKDC7M7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h4K24IZCc/vP3oFxo8J0yTOobaazje2j+KZra5zfzSg=;
	b=WCzU316NNFfnBFRwcTaT9tJ11/ZgLkU5Syay1g0cgRH+WiM/Cs65TDnrv18TyhYOpe94
	 tWeBlIHB9/vePqbZUNN+xbkrSRYO7Kk8+INcbYfSlJvBR2CPgE+uDKgKC9QmiT6xWwFRu
	 bJ86S911jiD45Xd/PQtlSPoVTxdJkSiodLTiXHnEU4SD30A0S6GJb+uSqidIY92mnfoRd
	 9AePAXNVw7RBycEVMReR91dRZWqcBgVZqVzvrLI3myXIqsOV63AZVvVZDopb5BjB3JKA7
	 z2yqkrhVGGupFhkrdbTnumWVc3FSXODkRZqRNQwVugzUYKS8uggCTfsITJyD4dQDd0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWARoEKp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B968606A9C2;
	Sat,  7 Nov 2026 15:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWARoEKp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473741F008A1;
	Sat,  7 Nov 2026 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064062;
	bh=h4K24IZCc/vP3oFxo8J0yTOobaazje2j+KZra5zfzSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWARoEKpSvtJff3v7+VnoCg32qcUSKr/zUBdV9LA2auugqtdWIdXS3ulfGicQUCKh
	 lsKrzXb6aZEmrOw2ezYlbG/+z0241j9MHP3k7w4VmAxu1bvtxvmnSOAWj1so77ZtAt
	 oCtftTx4RfeNvf5444dVo6Jl1rETHpFQCT7ctfBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0232/1257] arm64: dts: ti: k3-am62a7-sk: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:08 -0500
Message-ID: <20261107134945.931401281@linuxfoundation.org>
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

[ Upstream commit aa7d5b1efa75e58c9d440dfd720205045fe6a806 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: e041ec6e86e7 ("arm64: dts: ti: k3-am62a7-sk: Enable eMMC support")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-4-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index b04636cab71c7..f6778f9798d40 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -328,7 +328,7 @@ AM62AX_IOPAD(0x0b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62AX_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62AX_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62AX_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62AX_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62AX_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



