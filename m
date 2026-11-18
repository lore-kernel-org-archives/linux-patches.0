Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018177;
	b=rc1sRU/iLSWZfLSztly5ItUD0Vmk3yy24+88g4sawVdrPq7xfkoOJ28egDcUSUuEACP4
	 qXEeGBhwA9TCPtWtSiGmE7nmBMYxPZsLnDsaA7KjtlY01wMMXTIQr1pPY5oFk2+0PJdt9
	 WWW4MBwLIG4bCBJ4+SilXS9lmQRTjTxh685bvbFDp/KDY3yr5VICqdim2AwXTVYgNWBPI
	 1//aOCxpE13GEDU8i9j+vNeRgkq4P4315M1Mw9zi+uWGtzYWJAu7umybbJIFS2RB24ESW
	 XlE/5dySPzvuaIyQDLgBFA2fpIEFhTyzNkZJYeR7di9Zf0zUEWEZ/0Wpa5jTkHTdfIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zT2jUpQk/S8aV+X0RLhSlJzf3VaNvJ/EQw35HxIUnY8=;
	b=hoK+yXgkSGFxoMmbmuTs0nKpNHfwJszkT4EFD4DGAOo/LG4ZDbpkXNorFFac+UeSXQb7
	 AJlVNFUUUU93W0T4L11Nugq1Wwbt5DrNr6syrtd9uaUIjf/EfiQ3I5vNC60TLZIR6gFmk
	 uQMQnPy16k3H11H5LX2RPyEpZiY4u8FJ2brB/iKpUnKTkJPDjCRjdY4wpTClK5Aknu4NG
	 FFJUeeY4nFIcME2fAb4eaFX1AeJsaI5ZPIUr/B3RHxm23V5F34Cl4bzEIzsmVzVpDvZiZ
	 TXkktrdPoDqJivH5ISgJhayt6YTHRa0Tv9WI/dcuQ1wqXblK0V76F9d+4VZN3KIptow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xk3p2vWG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0696606A33F;
	Wed, 18 Nov 2026 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xk3p2vWG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5402C1F000C9;
	Wed, 18 Nov 2026 16:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018176;
	bh=zT2jUpQk/S8aV+X0RLhSlJzf3VaNvJ/EQw35HxIUnY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xk3p2vWGWAYs2Dh1Xg7hvaX2EMdDoJnipGZvnloQbzdFJTgv/m+4DuldYAjLyv+Ln
	 c/Twz8h+CgzNgeT8p7rLbScvPDF/iKGkFIXiqWP7cNhInHwW1OfqVhd+Gm4w0h2ext
	 AbfreOtlrSqsToRs8xu1OJMpj8MpSk75Hqe3smeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Radaelli <stefano.r@variscite.com>,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1148/2651] arm64: dts: ti: var-som-am62p: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:39:48 +0100
Message-ID: <20261118150329.336092201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Markus Schneider-Pargmann (TI) <msp@baylibre.com>

[ Upstream commit c9b15cd49b3fbd54f3382655b4e898921a7adb4e ]

The wkup_r5fss0_core0_memory_region was reserved with
0x01e00000 but the MCU SDK linker for the wkup R5F firmware on
AM62P defines the DM code/data DDR footprint differently:

    /* DDR for DM R5F code/data [ size 27 MiB + 396 KB ] */
    DDR                         : ORIGIN = 0x9CAA5000 LENGTH = 0x1B63000

which results in an end at 0x9e608000. For this memory region which
starts at 0x9c900000 this means a length of:

    0x9e608000 - 0x9c900000 = 0x1d08000

Link: https://github.com/TexasInstruments/mcupsdk-core-k3/blob/k3_main/examples/drivers/ipc/ipc_rpmsg_echo_linux/am62px-sk/wkup-r5fss0-0_freertos/ti-arm-clang/linker.cmd
Fixes: 571562e76458 ("arm64: dts: ti: Add support for Variscite VAR-SOM-AM62P")
Reviewed-by: Stefano Radaelli <stefano.r@variscite.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Reviewed-by: Kendall Willis <k-willis@ti.com>
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Link: https://patch.msgid.link/20260918-topic-am62a-ioddr-dt-v6-19-v9-6-40972ef1f663@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi b/arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi
index 8a8dec80cb30e..3d1a2c5bc4647 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi
@@ -71,7 +71,7 @@ wkup_r5fss0_core0_dma_memory_region: r5f-dma-memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: r5f-memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0x01e00000>;
+			reg = <0x00 0x9c900000 0x00 0x01d08000>;
 			no-map;
 		};
 
-- 
2.53.0



