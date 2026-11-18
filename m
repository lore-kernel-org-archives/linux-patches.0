Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025077;
	b=2xEhnNXJnjWSnLiRwyUBiOfPlUFLcAcK2YBjsPwmc2ztadb+fxWCta43q9yHoEENIWbM
	 HPe+yQmHddsI0suE21BzrP3zXcOLu2EaiCit8j+vm/9N2YcmVlMJa+snhOdlQHo/3s9+y
	 dRMQaBGk4T1xMsrFlGMjMS8D+F3ntkrXlKsbmcDPSFEvSdPJGW/tmCCfidB7EObbE0cgT
	 wdnvoH0WnKi6Hl7NvBclVbgz/JjohF9QpPkCcozu1JeSHFrSTqPPqaUL/H7l0iJU1bqio
	 5F9jOASjeiD3qsGuuDpM+Ut//UOFwV8qFbiuv/kfAZWuhI4JlprymWwdHvq+QHnCB1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0n60oNy5ym6r4Wy17vbF9GmywTH8qtpxOxrTzHrC304=;
	b=vDXX1wQ82JCDf3tDYw1BmQqvyXpPafz8uG8mT3Mj8FPpNiEkMa4a4Oyhy3SEjVbv9NE2
	 hyQc+TlXe6t3QnxCAE+4sVHSJxHM/OLEathKZl39FV5xfD59gc1BfPHNfCTVZ9UiEAKrN
	 6CVV94Bpd3vm8ttTJIHgQGrYauQXXmPPINSIloApBHv7QHpLuDuR/0Abt1pv7Dm8tJbBt
	 ZzOMwH4VMk/v7sRAc6rwb0rFIQJNCmMCgzD/ntpd9W08ihwoIoyHdHPGGw/CiNW/KmE4y
	 1ddm97jtLBcJ7hwP+J7rld8+AZYL1HCsI8/ftJxah9ePRA5UfH2APE+S7nY68zrNk/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc9r0hbU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA21D606A330;
	Wed, 18 Nov 2026 18:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc9r0hbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5BF1F000C7;
	Wed, 18 Nov 2026 18:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025077;
	bh=0n60oNy5ym6r4Wy17vbF9GmywTH8qtpxOxrTzHrC304=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rc9r0hbUJN7cKTNfiwCKwgLn31CYCP47cJlpvD2AqOf4z74qwqN18P6/bmMwZGh8m
	 QcgUhE9m5FvVEXLG01LwTAMKG9tmSNjZO5swguPsGugyxIm364H7WL7jZxIH+v2NlM
	 4cGNd+2w4Fgo/NNeQdvDf2gcB/SEyESf2GzHXoXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0952/2151] arm64: dts: ti: k3-am62p5-sk: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:44:47 +0100
Message-ID: <20261118150157.136771188@linuxfoundation.org>
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

[ Upstream commit 93cfb76923603ccaec3720dec065a7874458e67d ]

The wkup_r5fss0_core0_memory_region was reserved with only
0x0f00000 but the MCU SDK linker for the wkup R5F firmware on
AM62P defines the DM code/data DDR footprint differently:

    /* DDR for DM R5F code/data [ size 27 MiB + 396 KB ] */
    DDR                         : ORIGIN = 0x9CAA5000 LENGTH = 0x1B63000

which results in an end at 0x9e608000. For this memory region which
starts at 0x9c900000 this means a length of:

    0x9e608000 - 0x9c900000 = 0x1d08000

Link: https://github.com/TexasInstruments/mcupsdk-core-k3/blob/k3_main/examples/drivers/ipc/ipc_rpmsg_echo_linux/am62px-sk/wkup-r5fss0-0_freertos/ti-arm-clang/linker.cmd
Fixes: b05a6c145001 ("arm64: dts: ti: k3-am62p5-sk: Enable IPC with remote processors")
Reviewed-by: Bryan Brattlof <bb@ti.com>
Reviewed-by: Kendall Willis <k-willis@ti.com>
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Link: https://patch.msgid.link/20260918-topic-am62a-ioddr-dt-v6-19-v9-5-40972ef1f663@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p5-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
index f5054912ad910..22a7d8f66f105 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-sk.dts
@@ -57,7 +57,7 @@ wkup_r5fss0_core0_dma_memory_region: memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0xf00000>;
+			reg = <0x00 0x9c900000 0x00 0x1d08000>;
 			no-map;
 		};
 
-- 
2.53.0



