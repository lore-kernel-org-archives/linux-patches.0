Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061391;
	b=RQS3Ebqv6FOua3FpnPt1aECOeaHnwmMyAz6Le6r7vICy1NSDxsfPn4NRmHO53khfYGTH
	 q17Z3J65Mpml+Y2hyR100LNFiNQAKHzwCb7xjH5YkfLDC7a0cy5HyEYCd3N182Y8iOzAF
	 twUWylnglWZNZy1R/bvwMbxV6lCoYKQHcOIs84dx3T4D4+4H1S6Qsp81lGyBcxU+qreu3
	 xl/opjjTCxBNxTZcwuUOu9BBXw+H+1klr7oC9z1WizG47vSnPap9CqzXWKyATmW0uQT0E
	 9RJuIAZpXqEI+90B1WOtM4akQvo6LRKSCvrhwfoPNGBVgMdZUmIKUIAoG8boh0XCtbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SqjzRu8uMrY0EpUdWw3LNB8+9YwgU8ksHZ+U1nqWVvY=;
	b=p55LGomtqo64RyZMVDHdqhyN9NrZDaNmL8Gi8Xc9ekx2qVXmcnF85bx1gU3EpprD0vXW
	 s3SehqHV6/esByvwvGZD68GXR4vgWeDpeVVWlN6tbltJ3h3evYhBZz92yRuFBapSkPNsB
	 A3N8cjTsUIFWfz8JY3P5tWagQWUI+yxT2Xi70fx5wLTAMJGzEZ59mTB4UBZdXmL7v+mFE
	 hxc+fQhR7nte1yxh1v7Bgdmq/hGQwPnM6edsVNYx6jRsOVr4RKBpFUp77xz6wG4supLf6
	 Vd1WtRH5axoFfp79sq9lWj+2pBCYZNdeFV297pJ+oGGskk2yBdCJbeyKD/4uxLFNtUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uH0MhJKe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B98606A32F;
	Thu, 19 Nov 2026 04:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uH0MhJKe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD211F000C4;
	Thu, 19 Nov 2026 04:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061391;
	bh=SqjzRu8uMrY0EpUdWw3LNB8+9YwgU8ksHZ+U1nqWVvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uH0MhJKezLCiA1CPN7YTK62+KD8bG44cmO+QWaVE/PdR8uEPMUKnE0ZivavSmoEPC
	 oSnSrdswsbpfN2q0gONB8i2Fkdv9VbTso6SLvsnUAgvDSKmtfKPskpF+UuUTjsZMvC
	 fjnwySImMxgdJenbZbvzifKdLYdFytrdrpwqsqVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1509/1848] arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
Date: Wed, 18 Nov 2026 15:59:07 +0100
Message-ID: <20261118150022.490659559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 44b69c3dd77cb..9b059f7813573 100644
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



