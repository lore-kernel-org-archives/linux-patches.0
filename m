Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018171;
	b=IVhW1ImrfI2zxwkxUcoY+F77GwBy+D65MXYPRkAm3p/y0b2iHVdhVTa9JOd9gmDvuZ/m
	 53G+VGgHe0c62a/JUl6Yh5O9eRGQ7ODntCJiZV0QHT393EHdgFk9k5YYgLA6ClEiI2Q0B
	 Gwgq2wOOR/qpMj++lFbMjXHctKZOHhRWkO61Gb2e9YFkTJEVZ2WhTkS2+D+Wlwqa+Hsih
	 1ccxdZHj9IanoDsxbPS4yFehUP6/oB1UwFKrefz563yOzyGGc6xk0x3PLx++0+PIHHiIb
	 7W1/RLbTAelujVNmWnvf6mu7eNxgcKPQ3Kwm2NH+ykUeaVwvBNk5IXcEgIvAqpUTp+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=psFy5LeOslKk09pdKDn8hHHNQXAqsu5PfmtFsVPi3k4=;
	b=GIdgDyeDV/CRSqTdY3ayNmh3guHdpukonssRzpnOxOo8P76frxt4N22gxu8MdDLgiXm/
	 lN/J2/XEB9pxpFqwIXEGvTVBZWZC5LpXoXcAb2D8SESqSQHG5ywI9Tl8jkpzEtPaXMD8S
	 E7ZEb9Ov/UNFXpaS1mlyD9XH3sebCMvRKr4M2b05YG5Ke/dD3LD47JcBHbTchbOobSiWF
	 ncz4j4TN4AM9W+3Xbh1rFHFjJw7ARnjfb5v9rnZH0kxgUS1bRcTuvEzT/GO9xl0dhphpO
	 JNg//BhHbguagkTY9nFhyc6DHB5XG4QlB8ilZdbzYsjc0U5nIhbWnpe7+sCul3CbfWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A17vlfOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61825606A330;
	Wed, 18 Nov 2026 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A17vlfOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF27A1F000C4;
	Wed, 18 Nov 2026 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018171;
	bh=psFy5LeOslKk09pdKDn8hHHNQXAqsu5PfmtFsVPi3k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A17vlfOD36BJ1LoSf5473+gb6SY5kSIcYhmqe/xdnIigH41G/Kbnrg8HiYB+9fCzd
	 QPGgf9zVMWGybJHgG3aKE7DAGwFYrDO069bQUvLRS2tlUi3MHGgGXIenC8wnq8zC+G
	 CmCf4kSvLfQNKMpZwe/BYrgsHm9SwqmPwGnzktbQ=
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
Subject: [PATCH 7.3 1146/2651] arm64: dts: ti: k3-am62p-verdin: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:39:46 +0100
Message-ID: <20261118150329.261883252@linuxfoundation.org>
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
index 7ee894d59113a..8a5ff5c457579 100644
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



