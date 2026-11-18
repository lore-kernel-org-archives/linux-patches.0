Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025610;
	b=XhnjPI5xv1jgmTkNPAstDgT7u6+y5Ffal2l2PzdwWGJvbWQ86ZM6jTua2ccY/PrHB3fW
	 9AekuOuHlhPnpsAy6AYrbpim+bNEbCBJhWsya3qWXHKW9QVVRhccWVE9eTlssju58tmdW
	 P26mnVeQn1uGUKoaQqhAeUqfnAnoTbVCqgClKfjQZIC6aTRfcoScgmL/GbgulyIpkfQok
	 9qg6zZnDo4xxnFf5/CpiqGW4Tc7hyDbxayk/U8GlStwxAejJp65p19rGNnzVtKUJk2McQ
	 2aDb4tys8mI210mVy9+1FEvoKO9NT4HsnjKG/XzWrR3OgVsoTg3/e84pjrAVx6t8LYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUdl9EJobsk2gnY7Q8AwB7MjSWawyr2T3onijO61Ksg=;
	b=lPydtRD+oR8hbqB/Q7NcgahbjLTv0QvS0DiZUSz/MqxeonKHEhChOJPMSfjwG3bfpuNE
	 9kYvklNCOG3+szv/PcXvJFiZxX2YV6gI717AF3j4JVZFyCFasnDZqfNQiNzVSUL2KpIgx
	 Sw7kdfyuExwI2PWBQCIM4FvJhQogLZJZ4QEhVjdAWtk2dtka45EIMGpnePzvbU63SA3HS
	 pjr1vloecz+5XYQYTXz2p+cHGIqhktVL5FG55GZlrDJomQUS54d73tSbWzLbAXQ/cKJBN
	 VnGtfulo3u2l22UA96ZnLGHpvcdxBgVCuygMoS+wUm8kDeWj0YJtjFhTJerAljPwAGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhTzaPXq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548AD606A31C;
	Wed, 18 Nov 2026 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhTzaPXq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DF11F000C4;
	Wed, 18 Nov 2026 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025610;
	bh=HUdl9EJobsk2gnY7Q8AwB7MjSWawyr2T3onijO61Ksg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhTzaPXqPOyy7UHpKSW6Lq1P9riVl8+VFVWCyQ+5tOGK1VsxTV8bTYZh9X3G1JM+u
	 HtSDj82s+2xLhHsL4wlsyBjHl9nFo9WgElPqCzGCl5VhZxQlUs5GO7K49nyW7tpNHY
	 mY0rOFWUmQI2Ts0zhxrpi9MkDrhwLAwkt2IiTmXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1139/2151] arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine
Date: Wed, 18 Nov 2026 15:47:54 +0100
Message-ID: <20261118150203.702493373@linuxfoundation.org>
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
index 73e8604315c51..ce8d5953c22cb 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -205,7 +205,7 @@ video-codec@1c0e000 {
 			clock-names = "ahb", "mod", "ram";
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
-			allwinner,sram = <&ve_sram 1>;
+			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
 			iommus = <&iommu 3>;
 		};
 
-- 
2.53.0



