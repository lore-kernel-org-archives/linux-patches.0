Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018770;
	b=vFKtljnCit80n2FMbga4kDhrWTNgJkjcFRqh5laPpvSPmoLsSxVP/j+EQ3cXpZxkN7ai
	 1GB2dqsddH8TWLyUufGR2Q5MeQtUBGjYqX0imkJOYWshlnGVjGs3c0tlJisImQugep050
	 MLB3p6BRdQkobGonm8K3sTEq4kjaqRji4Nqy0IMlbVEWy3nEAmLwL3h13M8+m92W0Mkoy
	 UHcCZ2Uut+evNpaVKJvAy/Dgi9dvC3xs9b5CtWrFwMUS3isiDFOFmZ3Opo4I0iLuzK8qZ
	 k+VNLsuk/RBXK0OYzirSSsDFNoWX5rW3rK4awiusQmWfNlrjeEQb/CSQBH0II56HYdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018770;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V+mOUm+fR/6M6QwwmFsx9lEr4jyGevZwQfRM8qbPV+g=;
	b=J36pCqZanePCyuSU1Jasg7bv4NOxqBsbgs83pabjwfcMc1KFj5BgUphL3/xkJZsscb2t
	 MfUVlL2u9En87ZgpZ/V0UOY5KOO0F3r1wsvHBTLF35T+g/dEYirUYY/r8CG7m8+oVEgtj
	 FTA75j/aVPyEGxUT3MQKJCBx/Cz2Yg2dYplDWAMZ09uTHuNrEkAfeLQYqaMs+xoqaRtC+
	 nxQ3NxI2qMvFfefSzEmrkJR9T7wg04fePb5JMeAD/jGRT0PL+/gVkQf3LGvzHxr24VnYG
	 bC3YY9O6BcHVXmRe5TADAGINUWT/rYrm/BTbJR8c4kHAxEubY2tvNsZ2XTKxpgnfJUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDrZ3i+R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1233606A337;
	Wed, 18 Nov 2026 16:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDrZ3i+R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BB11F000CC;
	Wed, 18 Nov 2026 16:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018770;
	bh=V+mOUm+fR/6M6QwwmFsx9lEr4jyGevZwQfRM8qbPV+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDrZ3i+RKHFy/8kaPTaPBbZH7+oOFLq1G9goBJOvy/pioGhnTeiEHJpxRKW4a0/ih
	 gdltkD9PV686ywBe1wjtwm3CCxcIi2XUtCsp2anvKZRQNCh/L8L2ZrQEQnFhLD4IcG
	 CvfMwdfB5xsNGhTSrM+3HsapG45zMHTIcctc3Rxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1359/2651] arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine
Date: Wed, 18 Nov 2026 15:43:19 +0100
Message-ID: <20261118150336.949706044@linuxfoundation.org>
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
index 72ce1a75647bf..88c6e3e105c07 100644
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



