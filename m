Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040916;
	b=xuAFslK5L1FBa9wPpwjIZrvaQpCVGsIvarY+fnai+wLo6oVUAQIRAe7dBUpJ4bi4qJYl
	 AMjZJmwxXx69P54IHgkHs/vZ2a0sz1x55kbCjsCz4id6m+vfNOHBF2sPYgPJEMJYteyAt
	 urrysRHFtFNCCWOvwAz4pC9t/OQ9P2/rwOG8cmkMW34ne2+BchHwea+2hZJ/UoZPuH9Vw
	 ObgfXcGw6cnrMq8KFUq5zVEVPEYHhqzpJOqJcpnrbhNaEoELX1/7XuV70Siyl320UbXo/
	 vJJj/TQhICBSi9kJ8fSI4iqXqnU8MmEMcCuRi8Nd69Vyiimh3lntHPeeF7OZR+kDqyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mlq2MwUUW5Q5OnUEBB8iGAPDDpac9ZW+0havcCWpj2o=;
	b=ODmaas1GnLqekoJI3aXQItXkgmJikIRDJ/sXUCqtcqUTKmnA2on/uYfACjnrYV1hgCN4
	 F398DoAb0l4edE6ddRKfQYEybquqNc7jo0Q9xxrOiXkF+PMsmimaLBNCaCummo/gYbnDu
	 UkGNKkPeuCBezJS8MFbkeDEQryopZZfu1EB0IP6HUMJdjUxcLxzKd5LiAvo1n7CNK3CZh
	 oMy2HuGmkDlOkVo3n95T8vErzRcWgr+D685loccHDIUNM0D27aLH3l0i1r3FXJvXkGZyV
	 LspLtrEQOqNPPe3nPF8K8bmIgYy8b8yXpA7wms3JNXOwG8dIklZDi4EGPTwN9BY0OdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsigQ4Q6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A35606A31C;
	Wed, 18 Nov 2026 22:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsigQ4Q6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D801F000C4;
	Wed, 18 Nov 2026 22:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040916;
	bh=Mlq2MwUUW5Q5OnUEBB8iGAPDDpac9ZW+0havcCWpj2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsigQ4Q6NrdWJnlptJzOQA3V8KvX/JKZWEM69DeNqBGnPgrmTK9Zy8TUKf0g93T8T
	 nopLhFmYPUQCHBCVhD1yRVGjzsGoEpIF1pxl6xpuQj+XrfisXutQVc/TNw47amSvLI
	 z56xHP1ZXijhVuUc1pfTMobEorhRonYJXzqKgvZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2625/3318] arm64: dts: allwinner: sun50i-h6: Add missing IOMMU for video engine
Date: Wed, 18 Nov 2026 15:54:07 +0100
Message-ID: <20261118150439.850612023@linuxfoundation.org>
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



