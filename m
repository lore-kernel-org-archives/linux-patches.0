Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049236;
	b=WEVzjrHZch1tgndfRbzyJyJpQLnE6X58s6INtBhhm6mZB4DwIAgGgVja0H+zHgqjC9HG
	 dxMIi37tk9wG37ONJmyIDP5i4jnUSoqOr2I9XJ74Wgy1EeTv825uw7mrCIY+cQp8+EdAq
	 MoF5ZXsdSabPKGaNKnt45gKYEhySh66NTgmDkxmhGwaCvgJ6dwLTKDmrmML64EcJ1NaP2
	 90Q/IM0GBm0KF6TbV4O6rysHVpr4pS7ZAp2DgnshEM2ZzxxD9nXqedB8PNzKe82KMaP/1
	 FLskVnrIZcXBkq2H56JrpDpPcLWePHWrM2BrXUUnvkKN6icvAElxjWQePntsM6bYKzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rs09Q7we9onqlUQsJAMexWbhcfB1yqVSTZv5yGfEkW0=;
	b=TMnbyQ497Hh4gWwcCyGK4W4ayw92FhsPeWlnefK/3Lu+U3mjKnqCzJg0KQbD2yo0UJbI
	 siKPbqkCG0fHbY6mh63/rMG9dsXVCBJRULq3/Te6YOUStPWbtLlC75t3AfdkT1go3x/3a
	 QJvX6MJ6bItD64buKLpERvt2oue+/QNxN4OxmiMav3GBpZ3FCj4WDol+1EzLJdUPK1Au8
	 b109e+rV+/EFzO0nNDekwZRfz986Oq+7MPRQb57Ry5eA2NM3N2soNQToAGLAq3whpvzgA
	 YNTBDYT59qlxUom2faaNQRHLssB0WR/DSqhLGJQBRDlzSnykN1fnQJdWyX/7RZrLnYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmWPOpdq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF829606A325;
	Thu, 19 Nov 2026 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lmWPOpdq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BCB1F000C4;
	Thu, 19 Nov 2026 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049235;
	bh=Rs09Q7we9onqlUQsJAMexWbhcfB1yqVSTZv5yGfEkW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lmWPOpdqS+LjRVZijrdnaU1Dal37xiSwtq+KqYYQvO7XFvFb8aGeveAhndDHV6xiK
	 mhOuZAQZ4GuIfxXjVssRoLx9Y7hv2/8QDtmWL/rU782G41+MtYP7m9sifyicFUvSF6
	 NFvTCMg0gbWI8Q3dZu0Vuz6AzQ30CsqADuXUszDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2272/2857] arm64: dts: allwinner: sun50i-h6: Add missing SRAM region for video engine
Date: Wed, 18 Nov 2026 15:55:06 +0100
Message-ID: <20261118150323.255887478@linuxfoundation.org>
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



