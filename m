Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025613;
	b=1gBHB/9ceWBGLZjOqTBG0mssPHGqtCD4gzWIhmno7p3QTYi84h9+Gz6NGDUBRrSBjeKf
	 I049160xwvrcGBtVCxIDTixcxzZIl4SRyVSdNvDxZSaiKjt2kLmG9j1FDjgTy7RJ/VROq
	 cl7bCphdQx2jXaTxUTCwZ9SNqRGkLMqobSBNC/gZ/pq+JVkLLO5MMAF+eyH924XPpZwrc
	 YWMcU+4XOKsMu6OqkzL4ow3gmp6vhVpMzBvcRSZHTFm6UlUHfwGkITfUG69AHxY3Q2s4A
	 RH1EYuQ2QU4r6zezcql2e4WqJTN6mKIFRvnv8NNiBD4587XX2I20NeCiNKlNp5Arnzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=slV67mtf7M6izXe+Gca8RJMFQFMQGcBYj+0fX1FkvaQ=;
	b=Q8dxd1NNkcvCm0Qqj+hxDkbX+8M2exTtr80BPj2vAfDbmm1jtwx3dvmYZrhjRovqgIx7
	 dy9mvOmvO9ZrOuY5utw13mrCTPyfZCYfLJDz4ahk/7HbTBf01BApX8BI+W6/QZfmDAmIU
	 /d+Ccb1sSDJcuYthGKTq7dVzUhjdrgdi184jxvJZD2Hyj7hy7K9/yXWnkSqGS2ifuvfIl
	 v4T2AOuwhkwbsUHktfs81s1fQtp3kvm/UECEV0qGiaTLhb/FUkAKSi4Ad9bsYVE1lTF+/
	 aSiOJ7HTxvuTdoqvyGD7/F9BdxUBskJgt/CM3yR5jYoqHWfSSGf733arRKuBgcBOykw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07ZA2Coo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DA2606A320;
	Wed, 18 Nov 2026 18:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07ZA2Coo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946451F000C4;
	Wed, 18 Nov 2026 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025613;
	bh=slV67mtf7M6izXe+Gca8RJMFQFMQGcBYj+0fX1FkvaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07ZA2Coo3vEuKkFWFmxZVVoy42o1eelJeKrc3J4DQDTLCwhkDE1xdb4c0GiaxDpyU
	 8uIbb4SyTKz7j6mz7qftkQz5/G2uDGN+3YOTUjZVR3fA49/s65Ajxh1OeDvdjra2ff
	 +kvYuUO1Y1RjVEnuG1N2DRZG1cx0cL3TSWJJJ5oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1140/2151] arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
Date: Wed, 18 Nov 2026 15:47:55 +0100
Message-ID: <20261118150203.733669063@linuxfoundation.org>
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
index ce8d5953c22cb..310ef79271a19 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -206,7 +206,7 @@ video-codec@1c0e000 {
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
 			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
-			iommus = <&iommu 3>;
+			iommus = <&iommu 3>, <&iommu 1>;
 		};
 
 		gpu: gpu@1800000 {
-- 
2.53.0



