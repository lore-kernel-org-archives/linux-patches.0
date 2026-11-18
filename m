Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025075;
	b=rS8P7FE2pCzPDvGE4/MmuQ/iPpceAW7akDeTmx+NC4WbPnxpxCesdXoCGjhH3KUiVGpF
	 ebQaRBZ/kc3mdZ8bq4a2MpnelC8xlMKzzHTsxfKfH+DrppYmhMzxq2oQjfCC7mOSjlaEK
	 feQkXP6S6TzK5szOs1PuVTRwj9zDfzkB/ALx4mifyIYs1CNRge3YwntlkMdQ0G8dRD3sM
	 5dwNMtKd2EjNLQnxqVsrtMRghNUXUErC9BVLF+JIuQsOmoX1/orDhRSwC+wMXWiko9duw
	 yLZx5FgWyCt8d56XJLgyTOPfXCc1EQvU9ckNZm56hRh5Q4blYEaGCwm/Kl5nxcSvcTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j2vHesooD3CiNJBSRcvvBr9DdGoJ/U8igkiE7Fl4+kw=;
	b=KVOAeLh7S/8G65aPvkKyNy8sSwbaheTiBtiqTndqf5yP6P2gn+xElR3ddV26kKfF+Gv+
	 LVOdVE4+iIK9ke10vhl6JIDy0Zq6bYwDvomNAy2wfEPnbsft2Y6n5TuDDWIZxhJLrABRW
	 BzHkuVRs2780CPsLqde7pne8n3Zn/dhQuN4OAgNluuC1NRtiI/TIFjdYr3BlvTm4iN/oV
	 kfIMOaubkU4iQAKfm02lN3O9k0LivS+t4LBc6Is9eKYqh+xwtwvke4LOXkTOOG7ZtKTGW
	 QzYS6yJ4yL0hA5Izya9ePP2BtliMPFn8n9vdA2PZpjyuFOZUE3AAoeX67+ewSsgS3XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvu51yDj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197D1606A32C;
	Wed, 18 Nov 2026 18:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvu51yDj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F4991F000C6;
	Wed, 18 Nov 2026 18:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025075;
	bh=j2vHesooD3CiNJBSRcvvBr9DdGoJ/U8igkiE7Fl4+kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvu51yDjQjai85rubMiXlTJAGhU7qrF5lhyeY/zS91Uk/kElz2HGWu46X1H5YFJpt
	 UVZBplBF+4qw+bJiMtN4Y2Xb5Vt9LBCS4494NTJsB6UWMNmys1V6MAt356/5vXlFwd
	 daeX6RbZONi53Ear5Ulx8rEaKWG03pOnXSFChLZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0951/2151] arm64: dts: ti: k3-am62p-verdin: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:44:46 +0100
Message-ID: <20261118150157.104233206@linuxfoundation.org>
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

[ Upstream commit 70c9859fcca8dd964a588a0642aed3bd71bc1dcd ]

The wkup_r5fss0_core0_memory_region was reserved with
0x01e00000 but the MCU SDK linker for the wkup R5F firmware on
AM62P defines the DM code/data DDR footprint differently:

    /* DDR for DM R5F code/data [ size 27 MiB + 396 KB ] */
    DDR                         : ORIGIN = 0x9CAA5000 LENGTH = 0x1B63000

which results in an end at 0x9e608000. For this memory region which
starts at 0x9c900000 this means a length of:

    0x9e608000 - 0x9c900000 = 0x1d08000

Link: https://github.com/TexasInstruments/mcupsdk-core-k3/blob/k3_main/examples/drivers/ipc/ipc_rpmsg_echo_linux/am62px-sk/wkup-r5fss0-0_freertos/ti-arm-clang/linker.cmd
Fixes: 87f95ea316ac ("arm64: dts: ti: Add Toradex Verdin AM62P")
Acked-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Reviewed-by: Kendall Willis <k-willis@ti.com>
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Link: https://patch.msgid.link/20260918-topic-am62a-ioddr-dt-v6-19-v9-4-40972ef1f663@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
index b7d559c61f3f8..c45b807095c43 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-verdin.dtsi
@@ -170,7 +170,7 @@ wkup_r5fss0_core0_dma_memory_region: memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0x01e00000>;
+			reg = <0x00 0x9c900000 0x00 0x01d08000>;
 			no-map;
 		};
 	};
-- 
2.53.0



