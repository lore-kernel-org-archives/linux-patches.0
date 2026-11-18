Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025080;
	b=LGmspy6mYZgiAl7jccfWPUntZQ3DpEWL3eJ8ZveDoe2XWDQZm1rxXVhQY4/noJJ3n1e5
	 QQuF5OFSGp2m+Gy+RUw3g0ayUTF8to0AjQ+kEeTFBRz8jXmk9WNn66WCw+Gamgiy8pq0Q
	 fawNMqt1ZcmvF38dgSFe3u1pialJtydRhgGUj+Y6YdYvFaEugnrnMChcpXyTX8q0pXU2A
	 NfY/aRWIEJruv9RYb5ZE7q+ZkYsK0Rt6cPcd4eBUjSjcL8WO+FxoAywToe5UzuF8as8WW
	 EVc/fNtzW5bcbPCZP2pOPzDKxFzCycOSLHjM3VxPg1M2AAiXm+YZiI9JnUTuRhXV+WQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+LrKag0YL3l6pxdXycgYFA2pracAHQJ6zoWSqWSKFPo=;
	b=GEdjrfQbiQ3eWNWcHSILrhqKlB9PS3mt85EL3rCILwkby5v9N5pY0T3WSgejPW6B+T01
	 SZOLC6sAbvZXpHJut3KyUZRsLja86DZw/PyXAL7N6i63paaIFMgfcyhPtwnR9wZsSIEOc
	 O4TbsGcks+vDYhLpmuWaob5VRvlj6Z9PTuel3KDvjN3z10VoU9Ehsfj/f196C8b5yZgFn
	 24kGPHT5JQhbH93eZAYDxLubuFxnAgXF+WNqno5D142Quagwx/EP47QXBI8RqELeVgEkN
	 smFvGfFjuwkEdRHSqtm3nuHD/HczvQBx2AAm94P+UXKlY+CCtvfHy7CR3vfHfIK5GPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIE0dDOE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85BA7606A325;
	Wed, 18 Nov 2026 18:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIE0dDOE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E699A1F000C5;
	Wed, 18 Nov 2026 18:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025080;
	bh=+LrKag0YL3l6pxdXycgYFA2pracAHQJ6zoWSqWSKFPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIE0dDOE5UrCVwaiGtAWGxSwmXjrZKBPu2nu57H/XMF9h3Ivb3OVmdYhii7FSCNs0
	 hQlglHYikeTOmPOtpOSVGytwyHOF3KbqWa5ryXn52Yu0KyatjYjJ+xxscnwjqJYgot
	 NyCPBVanKmSvp9jomx4ZpRlcBjLlPRFQb8gPt4Rs=
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
Subject: [PATCH 6.18 0953/2151] arm64: dts: ti: var-som-am62p: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:44:48 +0100
Message-ID: <20261118150157.170162875@linuxfoundation.org>
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
index edaa4f99295dc..4b01aafa389a6 100644
--- a/arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p5-var-som.dtsi
@@ -83,7 +83,7 @@ wkup_r5fss0_core0_dma_memory_region: r5f-dma-memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: r5f-memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0x01e00000>;
+			reg = <0x00 0x9c900000 0x00 0x01d08000>;
 			no-map;
 		};
 
-- 
2.53.0



