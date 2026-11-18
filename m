Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018174;
	b=ddBqCzSqjILEPy4tO4XPfTOCP8DzJKoqjq6wgtpdPKPgTFidF37pWOK/BwbWEqkrzN0X
	 CoHV89WBQplX0/JLIMAISdwpcEDDZdl/G7kkfdB9TZ8JIlVbwncKgcB9XEV+q5bYKPsdw
	 sQHKdtoyQQYYDEDMcQskJetUeSB0edqyet/iasIn0sKCwq4STP61MHCI0Api1qDa2Z0xP
	 DSIiTkaeNMj/yOmRSowHk1VZrBrrcWMrosObY5Si5VTirf5vdCHtg06E6VXNNFyKWb22w
	 JPIH+Uqv/nbLwO3DPj36EKSbu4TK8IKX2ITXQAJCLK0WWb/TGBBLOAcL7bTNvNVo+QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N5a1cgFH23Ap496N3s8u3/xUCgY5py/fuPdO4cqNYZo=;
	b=1pHbkvZzt0Fz12XmWd24fJF2N2O38+atKFOqR8rCRgXmz3YAS4Bu1yK4mXMxGoyeNGZ4
	 46PybVZJ/5xjlhPrFWA/wrK3pFypJ6FB2R8oQW5CV9Vl8hKEdONgmZwTE1NO3A3F9xEIa
	 XXJBW8N/hev0UflR/39QHODrhGy43uC6Bg9j3dp5ARqTpbk4bLpfMDT25eR4bhJdpxtsV
	 U/fC0PvOVftPVzRRiUpq5akM1T/LECawVcbERTlQIqPUVfyoLCKyZieSaON8taPNs0xIK
	 dTdc2UIlV2ThJW4MA1T+Qvg9nVl4CjKScSKHumGD7C7pOhnsgGv4rVfVNYD+JR/nqUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQopj0Yf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDF2606A33A;
	Wed, 18 Nov 2026 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQopj0Yf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB7C1F000C6;
	Wed, 18 Nov 2026 16:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018174;
	bh=N5a1cgFH23Ap496N3s8u3/xUCgY5py/fuPdO4cqNYZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQopj0YfD4QW3I+jJr0shTkK2MBNYXAWwCpqQuKnmqj8m7dzkW+G+dFge3paMZP6F
	 3dvURh+v/2yNvhSRzGfUUhocEe0Uq7q8Pxzi0YfZh3/Do1yGOKjd2BmZHXay/Ahlq/
	 pssYbCSeEdPgixQSCoGEc2OwuRAlvgquh+kegYDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1147/2651] arm64: dts: ti: k3-am62p5-sk: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:39:47 +0100
Message-ID: <20261118150329.299802434@linuxfoundation.org>
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
index b770ed82be9d8..b8af9ec81b0c6 100644
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



