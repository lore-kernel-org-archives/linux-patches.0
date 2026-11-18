Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040913;
	b=Z9fJhJPuHS8Ctcf2DaorlFQpPkexC2Wtse2krh+D4MF4PNBGJIBg1gKpUV36dnJyo7+u
	 xUhNB4TjJ6AUkWbdWtfsP16xV0fonbyYX7Ya5xkY4bX/Qt0Fu2AKQmqjAM0YNTwzV6oYl
	 viy9KQ5WDp557+R/KQLioadQP7yW/C8QJ+NxRYo8alUjzwPFv9ox54gDg5uUkfe2OSVch
	 3heKekib9MwfcxYe0oB9SkD+ogwEIf8/q2115XbPFUqP4khttQjr+2N5Qf7Ivs4y2VKMj
	 daSrAGwaFixwGknopMkOzPYzKsvvLjb1nxI8YphmOlcyHTNSO4c/pF1/4kasNOJ5ywg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TqEJNzDTSEhSrVRHgnq5vOof7e3giM3ZuExLUlLHfnE=;
	b=nvWoTXQA9SSUgYdD5K2VSj6pQ4cA/PCFxDDXy5kHAcN+IWOQSYKomgySrLDyu2Ft+wad
	 DbGs7enz9u2hVB7LgBICgYRqLq7FMr697LRN2+cA6T00LbFgc9bw7p7MmSEXC40VA/5V0
	 pTxyIc3AlqQdaONr3dOyk36C7nS0QDFPzVuL6EHQUWQlZJcOyqT6wcp2XeqAcQ3cG1MNo
	 yEeqSnouXe0UD5QTh0HKV3lu6OGyuc0lQOaRwm7Bf10S1pp81ahi8Xzxv4jjZuwzvUkGM
	 8wXiEvgdhhYHtOg9flOxhCC9MWQ8tICWKdx1t3ICeYTfNPjZ4GcqWy/UVfAeh1i+TOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odvOQKU2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6F6606A325;
	Wed, 18 Nov 2026 22:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=odvOQKU2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F17101F000C4;
	Wed, 18 Nov 2026 22:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040913;
	bh=TqEJNzDTSEhSrVRHgnq5vOof7e3giM3ZuExLUlLHfnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odvOQKU27ruDFZWOVxWeK0AmOMVp0W1Ec6TTsMvW3OgDV6n1yyk3HruUM5yKE7FCf
	 eLklvVGS8JRB10sLVUETv9+KFKpuFPfGIJWzrN600RvDdwZnyORM9J2aUwekKxExfH
	 2JVGZyZzPMqxTvI9+T9EVePqkpHk9gSKj1KEeEus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2624/3318] arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine
Date: Wed, 18 Nov 2026 15:54:06 +0100
Message-ID: <20261118150439.824434995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d11e5041bae9a..f69304437862c 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -172,7 +172,7 @@ video-codec@1c0e000 {
 			clock-names = "ahb", "mod", "ram";
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
-			allwinner,sram = <&ve_sram 1>;
+			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
 			iommus = <&iommu 3>;
 		};
 
-- 
2.53.0



