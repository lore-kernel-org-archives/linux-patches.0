Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018163;
	b=atGFn3ylecW5wQU85DPTGo0P0GJZfCC1HhzeKxZYYfLD14t9ugxXdmgTTzrqTqUMrJtK
	 4Jisua4zqyyOxI5h6xT1q/H633RiUHZEe2gwtjuSr9hrjLF7luVu7f+O3XHsBsQqXGGCM
	 zgVMzLSgYcERbac9JtaVw7mxtqoB2JdvhiJyWHM6lzyOv0BReF/KyjaUA5n23bcQfgMIQ
	 kgm/CjUtSXjz/ZJ4jvXFH5pomLd3bpUgJytbfWS2EdiplZCuwkqI6f6JRKf+j8FzYD37q
	 4YaFypf6CUPNI6tLcAfAp/wyTg2n/SqYONr6t40OeA+46dbcjRDHy1JpP2bFcPExIzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CxZDGPL/qqhhQkjrNOHhx827E8TE8Jj6MF1UNYSgoQ8=;
	b=0bQ5Ylm0d8/XwLECVKmrg0yT8TO1RmnjhSXjicg5sKbZ33Wp82PtsbBeD4jcimKeDQtR
	 D3dQZnjxJZt8SXNX3YwvHNMQx8+z1YdYbMTcBgbA5X+pFxa1Nf/XDUMFp6twbWuzzbP58
	 txj0RG1A6FwdjXzR34VZOC0+L673buWnEIuRH73qBCNRP2w8BMgcPA9vYCri+hDy/s+sM
	 flVApz+p2zNpAkj+/Ap9meiioETwLH1o8ie7Mi5T+DmUXViuZkqeN8TozjxFPM2Zg6LiW
	 dXLGaMh26qV4PKUiDx2zqbTCnYHD9gZeDeXBhRfSNviPJ2a1JJ1fsi+JYo4mZbEvmsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4uZuSu5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E462C606A31C;
	Wed, 18 Nov 2026 16:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i4uZuSu5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA3B1F000C8;
	Wed, 18 Nov 2026 16:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018162;
	bh=CxZDGPL/qqhhQkjrNOHhx827E8TE8Jj6MF1UNYSgoQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i4uZuSu5VfXNRZAIYVPuAccPD+hQZNEIgQ++JxmKS03t2VgyV1JnB6DDHglbTKjU5
	 WLWI3aJOlzA3FuhS3jN6aO+h3clfSlcN39HprvzXpfb7UAB0zqN3Q9bKt3UqApBB/s
	 kR5ryYQRLKo1aY19u2txJRQFfNd949GHMPLZEg84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1143/2651] arm64: dts: ti: k3-am62a-phycore-som: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:39:43 +0100
Message-ID: <20261118150329.153612097@linuxfoundation.org>
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

[ Upstream commit 3690b591d07a2e8863eb96e2aff740da47b8de03 ]

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
Fixes: 8dd0ac27fcd1 ("arm64: dts: ti: k3-am62a-phycore-som: Enable Co-processors")
Acked-by: Andrew Davis <afd@ti.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Reviewed-by: Kendall Willis <k-willis@ti.com>
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Reviewed-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260918-topic-am62a-ioddr-dt-v6-19-v9-1-40972ef1f663@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
index 5ad93be3d3363..9b1666cee80e8 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
@@ -67,7 +67,7 @@ wkup_r5fss0_core0_dma_memory_region: memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0xf00000>;
+			reg = <0x00 0x9c900000 0x00 0x1e00000>;
 			no-map;
 		};
 
-- 
2.53.0



