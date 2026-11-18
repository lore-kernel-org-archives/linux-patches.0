Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025072;
	b=luEY56xihy4q3tAxcyTmonfN64LrZ/MQOWcr8EA302fHq322oclleuZX59Xw717RkTxQ
	 +q4WxV3V3ZQBkkAt20JioC1LGaH/jVsMbt1eSpInM0/NReboRuWof+sJJoB/COHRb8Go6
	 aa4Xwdc+tNPS9ggG+y2LfraW2Bcbh9hlveBXRp1cALA468B3aiNgORQAImyPBrjZYqqLX
	 Hi46tJgCpG+Wj6HOAnpZiBee9K2j+e4sbS2jkDZQ15yPiLlwYdHmTMytiNf1D6LwS6QAF
	 U6Ggk1RfeBE+DTrHwQ2Q26eLl9NX3nkR6BTs/Qx+QiquM27uCJdU2D1EyodY6crMm6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4naktgheYw0SxxAK+2gmfrwVr2oNXg5x9s2FGklJ8tc=;
	b=lKJu35R9vYMEwPGPV6CNGYd51e6O9sZ6c9EqiWHj56RIRedIhRDK5wQ14f4XwKz8I8RE
	 K6fnt5JCXHVmSCt2/HM/oADsgSvIgBJyEtQA6cO4g/eivKbxN7WDU+R2rNfAkjo2EpioH
	 WkRuG7DaArVQGEie51UQx3QmOR10wIwv0kA4ZqGU2WXzqvDHHTGyg/OPFItX/MP3zpCUp
	 DLbQG1Q7VFSt9QPgf1TDViMv0lp2oLCbchvl2PrufE9/OSPGXopftkT3mgb5oVdh8lAbT
	 WBoJEEorMaVvHOPAkmqqPaReZu2i5xUo4YKiDeflWC8VWza7mrpSnCDxK04YP2q+zqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvzqqzEn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B24E606A31C;
	Wed, 18 Nov 2026 18:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvzqqzEn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7EF1F000C4;
	Wed, 18 Nov 2026 18:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025072;
	bh=4naktgheYw0SxxAK+2gmfrwVr2oNXg5x9s2FGklJ8tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvzqqzEn5l/EF+hxGFJWFGiJJSk9a2h/b7H7n20sy1Gnd+tuzK3qJ2lImMLaG2Xpa
	 ejmURELvCjBLRUjXz2lyiT3kZV5ZJMDbEOupUB9cLStIYMb5ltwuIe0bHvTh/tKoOh
	 f0KumuvZjZaXuL9vJFlSbSxCelIrFgVyNZtPwJ7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0950/2151] arm64: dts: ti: k3-am62a7-sk: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:44:45 +0100
Message-ID: <20261118150157.068481610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Markus Schneider-Pargmann (TI) <msp@baylibre.com>

[ Upstream commit 8d36eb58c06b867f29a8df2f39f7fe6718c726af ]

The wkup_r5fss0_core0_memory_region was reserved with only
0x0f00000 but the MCU SDK linker for the wkup R5F firmware on
AM62A defines the DM code/data DDR footprint differently:

    /* DDR for DM R5F code/data [ size 27 MiB + 364 KB ] */
    DDR                         : ORIGIN = 0x9CAA5000 LENGTH = 0x1B5B000

which results in an end at 0x9e600000. For this memory region which
starts at 0x9c900000 this means a length of:

    0x9e600000 - 0x9c900000 = 0x1d00000

AM62A additionally has a second DM firmware for edgeai whose highest
section end address reaches 0x9e700000, so the region should end there:

    0x9e700000 - 0x9c900000 = 0x1e00000

Link: https://github.com/TexasInstruments/mcupsdk-core-k3/blob/k3_main/examples/drivers/ipc/ipc_rpmsg_echo_linux/am62ax-sk/r5fss0-0_freertos/ti-arm-clang/linker.cmd
Fixes: 77c29ebe76d8 ("arm64: dts: ti: k3-am62a7-sk: Enable IPC with remote processors")
Reviewed-by: Bryan Brattlof <bb@ti.com>
Reviewed-by: Kendall Willis <k-willis@ti.com>
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Link: https://patch.msgid.link/20260918-topic-am62a-ioddr-dt-v6-19-v9-3-40972ef1f663@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index 17ae6f0ceecfc..fdefeaedad916 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -61,7 +61,7 @@ wkup_r5fss0_core0_dma_memory_region: memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0xf00000>;
+			reg = <0x00 0x9c900000 0x00 0x1e00000>;
 			no-map;
 		};
 
-- 
2.53.0



