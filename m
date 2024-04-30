Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0B21292C8;
	Tue, 30 Apr 2024 10:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474112; cv=none; b=NKeDNToTgOQinZtIwrFX2ojN4qaZqB7HxPgGBKz8IGFsnOSkDVMRP4DUEVJimf+9mOAnuWF5pR3XZK0ZFqreEhfqA3bU9WRB63KaJYtAf6wBUmQ/hvRafGEnBHXeqlrZizPCw6a2x4BRZevtFx0ZKb2P26qHO+Lstr77b3BLS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474112; c=relaxed/simple;
	bh=8XLHConnbyAr7BNhN7X37WUEKNbD3R+J5UmUni1jgoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y00BbQ5usMpoaXYQ4l0x9FiT7BVxbmFP9oZNrLJD0p/jRbINos2eYJxMC8WXtIpCAqp511KOuuB4OtNlQ1PeAWJFDghTjAamXW7hH6juBwtE1tgAAl384EkBEGJfaeYMFa/zC2nxtFF5FJINLGTILwQ4cL1vlmcNjq7MY1p9Kcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HN2d4WnM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HN2d4WnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD2AC2BBFC;
	Tue, 30 Apr 2024 10:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474112;
	bh=8XLHConnbyAr7BNhN7X37WUEKNbD3R+J5UmUni1jgoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HN2d4WnM/k1VhgrpcyU8Z4EIWGo84B+Mz1UGN+hcx3yA+XrsQnMMH326GsYL/Yh0n
	 mqkZ0/jKoMdRj8iaUu7t3SQVOCrt+YmQuktQ+fdvk7A/6AIy6lA0XQXA9zpVjBYiDk
	 dzd3UBHdlmWlSQ7zR8yo8GhRGNbU7MenoKmK0yKY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 022/228] arm64: dts: mediatek: mt7622: fix IR nodename
Date: Tue, 30 Apr 2024 12:36:40 +0200
Message-ID: <20240430103104.455375437@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 800dc93c3941e372c94278bf4059e6e82f60bd66 ]

Fix following validation error:
arch/arm64/boot/dts/mediatek/mt7622-rfb1.dtb: cir@10009000: $nodename:0: 'cir@10009000' does not match '^ir(-receiver)?(@[a-f0-9]+)?$'
        from schema $id: http://devicetree.org/schemas/media/mediatek,mt7622-cir.yaml#

Fixes: ae457b7679c4 ("arm64: dts: mt7622: add SoC and peripheral related device nodes")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240317221050.18595-3-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 283fdf7d2d8b9..4c8a71c8184b7 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -252,7 +252,7 @@
 		clock-names = "hif_sel";
 	};
 
-	cir: cir@10009000 {
+	cir: ir-receiver@10009000 {
 		compatible = "mediatek,mt7622-cir";
 		reg = <0 0x10009000 0 0x1000>;
 		interrupts = <GIC_SPI 175 IRQ_TYPE_LEVEL_LOW>;
-- 
2.43.0



