Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031006;
	b=1lufgt+RtY3kOdGbgT4Ug0RaBlL/zA8BhnPr40+rUU30X0IdldTsyIt9BhFlezXdoGZi
	 Zwr4we1srnJDVQGgUzy13DjLPfDaAnC0rkvyID3JZthikbnZkzIhZcgDDpaQD3jf9aJ89
	 FHp+JVTtnwrRu6CKcyEqdgB8qnlztR33plpB6+rVkD4k/uvgv/XMgStJLQA47HEelDqMG
	 V6s6kC8tGR0dWslBdqZdXPt+zyWZf1tZ+cr+bUW20P/BVAFqOuYSE9xcFBzLHb2Hwu7uq
	 8Lbl7IRYNp+T7tM5PUPTigcL3yXNvOQiFFH6praD0AUX52K3wZLdBeDI7M1qpCfuReQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031006;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YG4/S/pZcgWMbk8tdoJS9LwtnuWPxmOM7HSYc3GSfds=;
	b=pWket0/0bZm4Kwxiv5HZMMLgJPeUFJ7Xw4ciydMuQbxzgfJuZqRi+P7V9ZBJaqKZ7TGV
	 zsajhv0i+qRuIlRboNOCqnLwRcS5wB6KBze3hAhnmFYRtx2/aDEljh8lhbZOe1snMU/Uk
	 cr4j6lFXtG2uzPliCl4v3X9OcRrWFflkmQLfDbfaXf6ugzYUkcNm1le1OBuFkpJcVRDVd
	 W6wgB0ZmPAuLgV5qjKL+UKmsbn2L2bAdjqiIbt7/cNAKjF5lfsfDC3eLiPdXGtSMMvVyz
	 uXv4vPIaAwWvKgC3doiKb/aXsCh+D2sYsh4IvY8+RQTqYEUfhTN0F5wiOfcmnQAZ9mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFVzznxr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462A7606A320;
	Wed, 18 Nov 2026 19:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uFVzznxr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A051F000C7;
	Wed, 18 Nov 2026 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031006;
	bh=YG4/S/pZcgWMbk8tdoJS9LwtnuWPxmOM7HSYc3GSfds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uFVzznxr8fStL80lvUIFktM2Axy7J4uQWTwdQox62rQYOkmzmfe1O51BE4bzMs+j0
	 wydQATl7gqUUx5zeqoU4Xj2B8igcBEHVg1lLv2bneX/KcKPtGXFdFaEYDLHHXwW/vz
	 MKPQ0jYbFySxae4OhXjDpzp8J30XWBBEsfGl9Pvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0905/1756] arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
Date: Wed, 18 Nov 2026 15:50:32 +0100
Message-ID: <20261118150046.013059377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba9b026677665..a00cf51debd73 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -210,7 +210,7 @@ video-codec@1c0e000 {
 			resets = <&ccu RST_BUS_VE>;
 			interrupts = <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
 			allwinner,sram = <&ve_sram 1>, <&de2_sram 1>;
-			iommus = <&iommu 3>;
+			iommus = <&iommu 3>, <&iommu 1>;
 		};
 
 		gpu: gpu@1800000 {
-- 
2.53.0



