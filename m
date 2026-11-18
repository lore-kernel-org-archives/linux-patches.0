Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055954;
	b=fudNSS0zK5ntnXVW7M6ZzqN7tX0Cax5/SJT9c6F7VDwmf/HPJ+VqfVjse4XXQG8qO/ch
	 /o6m9+vGH2bo8Wav9lVON0ruJp0s16DMwaxCd8S2Fq1DHWFFTHFC3nWcYG2LKgXCVfkZD
	 av/xHwXFnG3zlcCYOQxHtWaSBvXGRBL6OVuHggzTh+NSgALuOzyHp9vpSfpaSequIP7q8
	 vlPTQGCqC045N88UvX673nfdOeRh3ydLy5Nw8w5g8EryXQyOfgk9Cx9Zi7Zhm9Fp+et1C
	 jM3Kyrie6wRPKa++FRYYnhdr542B3UK07/JR9KSObbM1I1fkPw4/K4uxixcs24BUwOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SeiWj+iAH1FFs0T/t/JCj9bOqUtf97xhGI4hZ99tPV0=;
	b=3b6GmC3/tunTn+jYbnzD/Kp7oFxDRP8ZuKR7rWORj7nnzTCu19OOmjE0e+mqHzHxbWNX
	 uN9B0XdZ50b/zhbiM7Y6a8M6LYhuzcK780Cd/tcOcZH2PtKcMv63fw/QMZPULoCR6Z9ne
	 y/lEh8q7v+iom2RGfQ5Wfntww8Nfs62lujLltKdQaNxG3rEsQ9NWfEZ58qrr1kOztd3hK
	 iJxcA78spcw7++56tFbW3h/GoEok6dlR7EULVbRIIIJU9fuwNydbc4wAW9nFb0ptahcDu
	 /4zX4wJfFzjPHWXXarsr38dgPcYa9lnuep4JsA20OSBbG0YhswfuEAu57uFPBLJ6jRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ID/fFmno";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF51606A320;
	Thu, 19 Nov 2026 02:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ID/fFmno
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BE3F1F000C4;
	Thu, 19 Nov 2026 02:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055953;
	bh=SeiWj+iAH1FFs0T/t/JCj9bOqUtf97xhGI4hZ99tPV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ID/fFmnoPDvbR8IptorUBAGw8M3WHneS7fY6XnVgCL9J6GRSZEfX92BF/OLtzRDC0
	 22s9/rQl7KfZbaueufJwnjr5t/ji4LwwZjldm3tWpfyaROi8QiJOt51gtGfJTrfZYS
	 1QHM7ofkXF5yHaO1YDaS4GGwubEcBx1oPVL7uqfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1775/2214] arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine
Date: Wed, 18 Nov 2026 15:57:31 +0100
Message-ID: <20261118150122.516621190@linuxfoundation.org>
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

[ Upstream commit d7287d940f3cd8d5945009076058a8120281744b ]

The SRAM C region contains a partial alias to the VE SRAM already
referenced by the video engine. To avoid access through this alias
window, the region should also be claimed by the video engine.

Add a reference to the SRAM C region to the video engine node.

Fixes: b542570e5605 ("arm64: dts: allwinner: h6: Add Video Engine node")
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260712030011.3778169-6-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 30d396e8c7629..8c49dfef37c65 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -161,7 +161,7 @@ video-codec@1c0e000 {
 			clock-names = "ahb", "mod", "ram";
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
-			allwinner,sram = <&ve_sram 1>;
+			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
 			iommus = <&iommu 3>;
 		};
 
-- 
2.53.0



