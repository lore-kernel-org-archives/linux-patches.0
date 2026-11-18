Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018165;
	b=0DToR/et67m8GQLLVj04FgsUcl244rGNVomi0anH1TOjJp4CrcJELoVWlLsZNpY+EXcA
	 wSU1e4PXcPJbUIKTU7q55/4CuvTvxpFpnQfU78wlNtLYMRUycvCuS2SkANHA12cFHjYIh
	 IzdBJB9Ov61tzBT9ZCKs32a+JFE9WwL6GnV5iTw5BFvQGwws5pOYBuElN98xohjsvXAkU
	 Nqy9E16t6EWkn6HN+Y2I62xKjRGaw1LZDvKDSod5R6pv9bIPMnPK7hCsl2t2rc1rV31xt
	 1bQXfeZA75Vk32jVGTVAl/E6WqJRraz8vAf63VwcAxUQ8SlyWQcowcdsAHcWIlZsQrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018165;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z++i/2B7prJsHdK3QsGLmVOZ6DFkF5zItgEAaYUNT3Q=;
	b=t62Z782NAam12EaSHTz60tPy7qv8E82vDpwc8pMyBbrgUX/aNj7yDH8lhboY62XY1eO1
	 9mgO4x4TJ4IMEmO65j8PvRVGoivN2InAxFvFFULksTWEs0iiPljRYZ0Vz+L0WeBUN59br
	 EiZY/ctS0lrlDX3M2VhNpX5/PLkLbF7FrLi8N9lKMKEXuaXV6rlpLugkAUZfVlYExpKPQ
	 gVohzGsiOelhnGG0n/sO1fLBzRmFNSjmDl9YYfocY3xHDgZWuS7NouVIwKWhmTtyQ/CWv
	 iUv9qtaoI8NtZTPnb4CpQd5WAZ7g06plJce4N3ojbqfETzyYjG/G9Hxy3PjstB8hOZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fJ8kod/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C916B606A33B;
	Wed, 18 Nov 2026 16:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fJ8kod/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E171F000CB;
	Wed, 18 Nov 2026 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018165;
	bh=Z++i/2B7prJsHdK3QsGLmVOZ6DFkF5zItgEAaYUNT3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJ8kod/V90n3WOUzOd1SkFzaMcHsIz+UcsRwdde3vkMt0nMK3zpVGOqYvyQm3rnVE
	 t2Aml4mVhw+w+4C7hXQ527eesDfylwXr24accheZD9KdPm9DPLn1oojQk9UhMCbgfr
	 cf9SuqQyXXMluX0hzQoyVBA3W4yVRqOfWByaE7Kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1144/2651] arm64: dts: ti: k3-am62d2-evm: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:39:44 +0100
Message-ID: <20261118150329.189345548@linuxfoundation.org>
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
index f5ceb6a1b5deb..a8c794d073431 100644
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



