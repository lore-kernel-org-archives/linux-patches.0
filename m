Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018168;
	b=XIJWvBk4ez9dekFqXwhkTXPIwSiMT8NepAh/JVlB3OYD7QAS3iH+pHNWzbTCBKoc9/4F
	 ZxRY1G8GYFq5tta8eVP0uvgPwmu0IqLQyeVwHSY30tYTZ3ecDtZyVGWHnoUo4bxOoR/DQ
	 0r8cT+i13Zu/4UdmRKwZjI9ZZyPqaTZw4ndo/RmXBJWh2xUXmbfForj7VlscNjJ6xnHFM
	 bQufABmrH9n2E8UB2T5Kq/JkTaFh1UUKVd+uP9i8kC07nfpf4vSGfEGBxqr3G7bFBNmp2
	 byIjGQ1O2RqamltvB0sg9ZvzcP4al3j+Pvx0qgaU+ocxpYhVvEr8wNEXk1TWir1iTvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5fGD3vzK5GYxlYVAHUK5RpYz0FRVLiKW0UUv05HJjzw=;
	b=RZ37m7diPbz3if23B9RBbY0rZToTjAtqiXA0XDs+CwCdG5/TL+ZIC7recTfkGrDus/y1
	 l+5RcOX7/04tUp0O73hldfw2gmcXDhZ5bd4svrt8gYzr+9FhRLyg9YF50qKYnpWAKzzpM
	 naruNvCm9SQT4w3DzC4b0Gm2atTQfqipMUxpwQnCTY37bEJjtI63I0w05peLayx/zhdXr
	 OGKIiilFwd3tkXqxTT/SseGKFZHTaQzckE1lzJA5jULmzltc3imw/gX0iXJ0fT7F3BdT2
	 FCwQNQ2cIxh3qek1E1PfB1f1PZ5ZALL1NCPV7M9rffviKucZeHeZIwNjPz/mwnO7jNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdJ+LKXE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2286606A31C;
	Wed, 18 Nov 2026 16:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fdJ+LKXE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011DA1F000C4;
	Wed, 18 Nov 2026 16:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018168;
	bh=5fGD3vzK5GYxlYVAHUK5RpYz0FRVLiKW0UUv05HJjzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fdJ+LKXEJRnDz9sn0DlLRhGw/2YpKZBe6386L6/Zv7UvaRepvBG0hKsTD8aPstQr1
	 OatxKV5vGHu9JuvyJbYjJ6lNGkzhIW7oFMjdyGQBsMd3SEdTLc+vdCkx0rQB3VgVAt
	 EyKrgMg28DImhAfg2MH+fXR5xKmnaVHBQWkcCYzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan Brattlof <bb@ti.com>,
	Kendall Willis <k-willis@ti.com>,
	"Markus Schneider-Pargmann (TI)" <msp@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1145/2651] arm64: dts: ti: k3-am62a7-sk: Fix wkup R5F memory region size
Date: Wed, 18 Nov 2026 15:39:45 +0100
Message-ID: <20261118150329.225804553@linuxfoundation.org>
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

[ Upstream commit 8d36eb58c06b867f29a8df2f39f7fe6718c726af ]

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
Fixes: 77c29ebe76d8 ("arm64: dts: ti: k3-am62a7-sk: Enable IPC with remote processors")
Reviewed-by: Bryan Brattlof <bb@ti.com>
Reviewed-by: Kendall Willis <k-willis@ti.com>
Signed-off-by: Markus Schneider-Pargmann (TI) <msp@baylibre.com>
Link: https://patch.msgid.link/20260918-topic-am62a-ioddr-dt-v6-19-v9-3-40972ef1f663@baylibre.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index e63c5200a2370..42aa9bbc6831b 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -61,7 +61,7 @@ wkup_r5fss0_core0_dma_memory_region: memory@9c800000 {
 
 		wkup_r5fss0_core0_memory_region: memory@9c900000 {
 			compatible = "shared-dma-pool";
-			reg = <0x00 0x9c900000 0x00 0xf00000>;
+			reg = <0x00 0x9c900000 0x00 0x1e00000>;
 			no-map;
 		};
 
-- 
2.53.0



