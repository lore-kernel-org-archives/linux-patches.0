Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025066;
	b=ETL6EoVKKN8TFjcxE4aRrD6MokfIhj+VkgGoKd5nM5V3taQ3RxORB5UgFupFoZn/9zpA
	 HMvCV+GWZ4ABHsOpvmQQsxwO2s1LACm4nLTx4J2BUXRWmT9k+R6aGFxhW6W/3yYmu5cd5
	 wai0lKlS11RQLxfD8s4HJdY66G8iMy/lCp+CslamdAsQsCLsEpez8/xbiyzQXzXMSBKCc
	 5rPP72Iv4UFYDjppnswQrSBWvBeOZvXS5keWfl0hN9Xh3pG8El+oNGXvKFvL4By0MqOlR
	 IJadWi0kyKEjidCkSLMGzvr9giMd55xQxqMbXQb5WCN5jrKgXt8h/YADWaqpKcQ4suA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eW7s3hhGMOFOK1rkSBPrw2sFkuqNva28iVGlc0/VIOk=;
	b=Gt5BOYF5h/0C3xayLvRqfd2tozfGhoPgpJ0O3TeV4dWbXCsJirnoxhhXRZmkVevvvG3+
	 ArWF3Ud+lx1CfGtMLa1CxpxdRwcU7jiBtd5f5GHK75xi7niHyEeRpfyxRcUYorHwnXv/B
	 Wm4VyPO34/uCxobI+qwSSaKe6qAqhnsd4f7XRdEqWk5s6XSjL3iKGYPi8ClImBinJ0FwT
	 JuEkO25grvabn7vpqDmFSSXvKWYa6D+U/sXtVHFwHlpIb+AYAuPSrCEX04x2i5xcV9xw3
	 1GgjLnFuUKQZ56+VBEZpzRa9b53FA/uNnF/t0KoI+0xbABxguf0cQZoDPlyIlKqtKkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzuLqPa5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77A7606A31C;
	Wed, 18 Nov 2026 18:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fzuLqPa5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FA21F000C4;
	Wed, 18 Nov 2026 18:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025066;
	bh=eW7s3hhGMOFOK1rkSBPrw2sFkuqNva28iVGlc0/VIOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fzuLqPa5c04zfRpr9wT13MAWYTL6pmGvY2Honn+noxfhgSehnLinX9/sInNvJhBXS
	 pzv2LlPCRsa819u51Yz2Yd+hMG5q97P2CVytHlmcmdv3VY+UFd/PQ14yukKEBi48eP
	 HuE8tH5OL9bjL9NcK18e49tpf1Cu4u3da2zSsenQ=
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
Subject: [PATCH 6.18 0948/2151] arm64: dts: ti: k3-am62a-phycore-som: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:44:43 +0100
Message-ID: <20261118150157.000746725@linuxfoundation.org>
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
index 9da48a54855e0..2d0cd4487c31d 100644
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



