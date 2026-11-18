Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025069;
	b=CLp6nYDu+PhPp8SaOG15ZSEQVY77TZy03rEyktE/h4UJA7OpMU3OV2eWSbSC4qPzNfN7
	 wqBijO6XamNzW781YFkEmcZiC7gtO12iz7mm3mZbJrE+cVKXQ0GvZsGykX55XCXNjhTI6
	 eWlHh50VQ+B+idEN6ZTPLMm8OxVBXQBRrQ7Zo7HWCM/yvvwqnAA/zTK0sKR86MWWkosAC
	 E0kC1qjBD/ZLtsKLi/RjvBG9mSDD3kQKJYG1nu9Td5Nr7sobjzbzYnyGBE23hJZAJM5gb
	 iG8pladqVj3mai5eITR/QIefeCG2MDOWwQtxTN7amrhkHIFboPLCBM7yQZAuGgSKKRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P16k+frDzJxuv+jTZhPT9RWWIzf/bI/Yi5+1AJXmtiE=;
	b=4HNc4/fOSieeI2lEP2aD/+AgtXqwJa06UlNjXXyfFbIDbYu1kj9lOuu+0e1eBBEMriD7
	 goUtkmwkF3gYjVLC1vJuf05maztzSVd12ipJZubFmguPHGKGXKl4SR+KXQ0Hnw3kOfLdE
	 1hjpKU3xyaGMIED3vefKvop31EkrSpNTyygRkc1FtzuzIhPuCrPn8RcDAfp/7pKp2N1V0
	 gDhqoOZCs15IiyX/9fa64VrtUBTjWP668zFlVwExUgWSdrbsYp81loLm7Y5JI1wQa1L3n
	 pCoIbUvo8UWxcZJkkv82klelci1mlknV4kjQD2zVpGzy/O9I+81jTpFg7KzPaI/Wh5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VG243IZH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A456606A334;
	Wed, 18 Nov 2026 18:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VG243IZH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34A71F000C4;
	Wed, 18 Nov 2026 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025069;
	bh=P16k+frDzJxuv+jTZhPT9RWWIzf/bI/Yi5+1AJXmtiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VG243IZHfSE9CvUC/DNzrXo9mPbhqA5wytlz7C6pknPRoHIKP1Fqy8FDOJKqTwhhq
	 KUz7qWiMsRvTwp9APq9qhBXwYOpR+kHMkS3DFqafWttNaOAv2brMmyPxomvUe1HTVJ
	 q1DFUVJzrs80e6E9PRa/Px9R6yffr4cr+EKgEeu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0949/2151] arm64: dts: ti: k3-am62d2-evm: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:44:44 +0100
Message-ID: <20261118150157.036761336@linuxfoundation.org>
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

[ Upstream commit 5dd0e5b9d5f67276ff291f30da9bf5a17a46c48e ]

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
Fixes: 1544bca2f188 ("arm64: dts: ti: Add support for AM62D2-EVM")
Reviewed-by: Bryan Brattlof <bb@ti.com>
Reviewed-by: Kendall Willis <k-willis@ti.com>
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Link: https://patch.msgid.link/20260918-topic-am62a-ioddr-dt-v6-19-v9-2-40972ef1f663@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62d2-evm.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts b/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
index 9a74df221f2ad..f8df5e2d767fd 100644
--- a/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
@@ -67,7 +67,7 @@ wkup_r5fss0_core0_dma_memory_region: memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0xf00000>;
+			reg = <0x00 0x9c900000 0x00 0x1e00000>;
 			no-map;
 			bootph-pre-ram;
 		};
-- 
2.53.0



