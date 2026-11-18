Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055957;
	b=Lb9WSZxzxTDO+S6wAgbv7IOEVR7AO98OJkZqQ5oANArCtda5z1N6t6tkmS0ZXrZ+XkXi
	 5pd5n88jW3mD3VLKw9JKXKabLAosyJmQ/WEluXo9xrlvtLZyHLv3fcVpS7WsZdza/vP5p
	 /C6pl9e/vQ837IGs75+9z3krw/7N9o69VZIaAkPbjsYwuFfczwOsMlpUF0vY8S4PMdaXj
	 F7m8D0/KID8BUMDtV45S2aJKQMtbxn06F2Q5R9iInkFtYLmfEEK59QdDYQbme0Ke6fHHH
	 M4wgSCkXJ2EEB7ssSSvfw7+zFjPk+Y2wrRbqFEAkMtJDn13S6uUWR2mXhRK7vTVRsUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BPqir95RMb2UrjLjAWfEj3a5P1qQJvpIzesq4r0tgnw=;
	b=HrShwZkrkW9rPC0G3AgbEIUhNuvqXIi2tfZov5ioCCtktUKHgxetAS2+MOr5x1rvlxn+
	 9JO22rEqFmkoKJ5LovH5UpkkUdaiRam6hUZO7FXH+sQOlrTZaKKJQuY/l8CW0x+ROsOxI
	 suz+rAR8Zw3tA/rZrk0+q9U9/4lWBpMyQEj1nImR9K4zea1u56tepnyQXK8apWFxtE4n2
	 +p9gRNfqRJ3Gs4vx2Eoa6x7XHPQxf6rtHHbDnJ38tcbR9sbJN3f6RLVFy7GzNo9z7EgZl
	 oAkJWBxjYtUVY4XXwYo82gbmoJ3EjZYSbcCuIprBKVyEWuL/t1AeiiYigD1EdsnKIRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wKRwCc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190E5606A320;
	Thu, 19 Nov 2026 02:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1wKRwCc7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234661F000C4;
	Thu, 19 Nov 2026 02:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055956;
	bh=BPqir95RMb2UrjLjAWfEj3a5P1qQJvpIzesq4r0tgnw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wKRwCc7C8Klg9WOBaCsj7NSDVsBwyBQmEiWaFSTaC65u7wsR9sUad2dmOggaY2oZ
	 T/TgI0s7Sp5UeCOERNdigPGl5okJDfmnfInVooaZ9K3+Hzv5zBNzLefds0/icIakxo
	 Q5/JjH01LTabrv/aXWbodfFERl5aKJIIlRBAXNUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1776/2214] arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
Date: Wed, 18 Nov 2026 15:57:32 +0100
Message-ID: <20261118150122.553323534@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@kernel.org>

[ Upstream commit 965a49fc413d996eba9bae2a3132f03f45a2ea1b ]

The video engine on the H6 actually has two IOMMU ports. The one already
listed is simply named "VE" in the user manual. The missing one is named
"VE_R" and is probably either read-only or used for reference frames.
Either way, it should be listed.

Add a reference to the "VE_R" IOMMU port to the video engine node.

Fixes: 62a8ccf3a248 ("arm64: dts: allwinner: h6: Fix Cedrus IOMMU usage")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260712030011.3778169-7-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 8c49dfef37c65..3cc477d2e3418 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -162,7 +162,7 @@ video-codec@1c0e000 {
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
 			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
-			iommus = <&iommu 3>;
+			iommus = <&iommu 3>, <&iommu 1>;
 		};
 
 		gpu: gpu@1800000 {
-- 
2.53.0



