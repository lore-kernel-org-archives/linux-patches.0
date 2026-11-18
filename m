Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049266;
	b=3EsJKkf/Q6XbiGVIcYYeuInj8v0Guebfckixd+yx24uFwdIq78U7kf+gUc3KpidQS7SP
	 W6dAt9v0KgcUzTjkACkfQqwXnOLJ/QM8PiDesc4/wbuFiHpG9M3gi8ovSsfXRdMxGcYBL
	 N+ojp/HR8xTjeNV4ya22pBxG2xqCWWVD4hiBXZm/IYb/4r16BC2z/AA8qtocfiqDwI0Tv
	 lsN29XhjHom+wfBQfZx7tyggGEhjAykdKY7DYM19VVOxhDUNl7igtT4tuxPjeETPLIk33
	 mJaVdx9MfGXu0ozriT3hFwF2txYlsxkEsZJ+c8IBrihRyI9BdXaVbadMVfD8/3z4sFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rkKGzaJXUitn05wH2pKsqhQpcjJRoOunP/ArtcQVS84=;
	b=Nw9vRPvquAc2Yr3rvrB7kR/tcT/uZT5ceKwIqvG4bIFEvWq3oR5UWPsL4YeUGuCMnIm4
	 H6cmG6p8rSByv3YVmYTCoKUl780hdQwHKReNeYhYOKvDIcm4b2iJLw4CRVNh0/h5wWmqX
	 9ZEs91980+1cDJ05w0B6Yrd0G5dTpqx7blwUG3sitrqKzb7j42YdlRYGR4QcUTInDaTsD
	 DA0fWVxLCjAmE8E0zo588XuNyDhdf94v5RXzTMDIq0CyXMDVRdCRAOoJXCjxJoqPLOguy
	 Ce6bgaqFIV/aJUiXyiSgbzlJEhoJurBMi8diTHtj4EsX5aKICyoCNzIx7A8k5w4rYbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPAGwYAi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C980606A31C;
	Thu, 19 Nov 2026 00:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPAGwYAi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632D41F000C4;
	Thu, 19 Nov 2026 00:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049265;
	bh=rkKGzaJXUitn05wH2pKsqhQpcjJRoOunP/ArtcQVS84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPAGwYAiXQEQ9wJKOO+jEbpT3zmC9eY5GzJxZo8R5E8GfGEbZ1gSt1wi8FOkMH15B
	 H7BOpdJ+SG/K37RyVVb6VtSWagDMz26smREA/ZdmC7WLzC35A/FP2uDUnnHt/uTVYI
	 2edON6HgxlFaS9TIyX2ogWQ3A+t2SmxeluirM2TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2273/2857] arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
Date: Wed, 18 Nov 2026 15:55:07 +0100
Message-ID: <20261118150323.293563603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f69304437862c..6bf8fc4ce8cab 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -173,7 +173,7 @@ video-codec@1c0e000 {
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
 			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
-			iommus = <&iommu 3>;
+			iommus = <&iommu 3>, <&iommu 1>;
 		};
 
 		gpu: gpu@1800000 {
-- 
2.53.0



