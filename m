Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018773;
	b=uQ1IvOBxkqdcmyHTs3XSAh7lS8C5ODbvzeXNLEURk1J6I2lo2FtxFy1JSVyasm/ZXj0e
	 3BPRootyzwhMKZI4YU1fMn1jLWA0peNUE3jmOAsDNSCwUGZ3GmlSOWg2fiNkr6q+IVK9w
	 dfLnFV4T4WnTAN2Ry2/V6+PY/LgFw+CYtVkzDZAYUt/zkqc3gRVCNLrejxarIe0HFW3EZ
	 yLDi5SIU+85ZbzJr6M51pPFs7bcYy0PPf1ios2xXX2CxQgCUBbP9V1Kd8Gwte0JV9tgpN
	 hk0L7p2cwhrPA+jy7jrT4lsG9W9jDGQWgDzY8XwsVPWfj9lagFiOmpQINCaWVPsgv9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018773;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZPhOOS1139ZHRWzYOYbHWK9G4zAneX+QuhWvQEC2Bks=;
	b=YiN1gc0I9i6+iqj/pRkoo95iKnDthAuo4JujepuXTwkXh/uKQ7urhT7GcCVd69SzhKQ7
	 k5TABwBw5djGcO47e6CRJepY9BRU/R8DB821pjQH1imx0SHj/5P/+ETxmeFtJryQFbV7O
	 pvTjTuQ0PJro/cDqMbvVPj0HrQng+fHqujpzMlgEi5es7aIFW1HsneF4FrfZy6oAIp7+I
	 Ev4X5Ms8cnU4fXHi6Z1yIfVSA9kZsrq7haQHjoX49H0kb0bN6FI/20SOHt6OAHxup4zSp
	 S8rJdhhWLqLRi5ApBUrQgsARB4uZ9Fmt37qkGn9VaVAkJ6dtHAaPQoe0Xjwz0p4b2bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCyUaDjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F38C606A330;
	Wed, 18 Nov 2026 16:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCyUaDjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DBA1F000C4;
	Wed, 18 Nov 2026 16:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018773;
	bh=ZPhOOS1139ZHRWzYOYbHWK9G4zAneX+QuhWvQEC2Bks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCyUaDjErdr0jN5OLw0tLeUzICCNxRSqVZEXl0fBhfTNO1ng+bfrOUZPksd+1c1vc
	 Iuv7yozd3r0Ftxdtt6uvRfpsP8YOh9vb7W99VLgDKVAORxgwamhAehHFr9x2rQJ5cF
	 Tz6EK1GW9akFz8hlznema/ZndIOXOgdp702fO2lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1360/2651] arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
Date: Wed, 18 Nov 2026 15:43:20 +0100
Message-ID: <20261118150336.986645733@linuxfoundation.org>
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
index 88c6e3e105c07..48c771223af4d 100644
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



