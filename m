Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867A812D746;
	Tue, 30 Apr 2024 11:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476392; cv=none; b=q8ObGHOB2ciQxVoDs5JR+ySgKHie8lV8ym6JwMTs5w2AtbfXhe/9DLCE0xfO2qiN9Av54rIMLgWWSuk2Q80+k3UCEpbS/8xiGSKPPEoJjY8v/WcKFl5xHJ/4iW4YVx1nzOsISjEJezRIqut/ZRr8/+UIaBWXW5H52DJXsneSVBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476392; c=relaxed/simple;
	bh=r2BZ/Lf8MgnQdX6usxndDLx2xXSuYA2z3cYEw5d/Veg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UHmGXOrllIyOUC/57COtt3Id8k9E2+aUgEtzodsmZRLhUwDDgYn2cvqWYU7NHn+3cK3lOOUk/Ud2/zIVQ3YybYYf8PbVQP54niPoceHnPz76cOMnsJOxF5K11+egftJgUUWRyyqL915n4jUNVtD0IZfBgeOsdiB2GC2NE7WCyZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LHKtOf7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LHKtOf7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A9BC2BBFC;
	Tue, 30 Apr 2024 11:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476390;
	bh=r2BZ/Lf8MgnQdX6usxndDLx2xXSuYA2z3cYEw5d/Veg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LHKtOf7ssIAs67cKmiIn3M5vcubBu0drVXVlNR8MUjj7uFQTtL9lJSlsFp4H4vDf/
	 q9j4LXb90FSsQbPg5Z49UnOrmYlGiO0XIcBiZH5Nzccm44SfIr8K//g5ALkMm4tjC+
	 Wm9xLBYJccDfwOS5cWooSHYHv+1Xo57SPdazm+54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/110] arm64: dts: mediatek: mt7622: fix ethernet controller "compatible"
Date: Tue, 30 Apr 2024 12:39:47 +0200
Message-ID: <20240430103048.109280656@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 208add29ce5b7291f6c466e4dfd9cbf61c72888e ]

Fix following validation error:
arch/arm64/boot/dts/mediatek/mt7622-rfb1.dtb: ethernet@1b100000: compatible: ['mediatek,mt7622-eth', 'mediatek,mt2701-eth', 'syscon'] is too long
        from schema $id: http://devicetree.org/schemas/net/mediatek,net.yaml#
(and other complains about wrong clocks).

Fixes: 5f599b3a0bb8 ("arm64: dts: mt7622: add ethernet device nodes")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240317221050.18595-4-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 87f692a041a24..5b7be71afa5c1 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -963,9 +963,7 @@
 	};
 
 	eth: ethernet@1b100000 {
-		compatible = "mediatek,mt7622-eth",
-			     "mediatek,mt2701-eth",
-			     "syscon";
+		compatible = "mediatek,mt7622-eth";
 		reg = <0 0x1b100000 0 0x20000>;
 		interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 224 IRQ_TYPE_LEVEL_LOW>,
-- 
2.43.0



