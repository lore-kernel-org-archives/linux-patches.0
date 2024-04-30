Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C20D1292C8;
	Tue, 30 Apr 2024 10:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474120; cv=none; b=qkejGF8YIiVaaccq9Yp4I6JD4176OBFEkPOoWJeMNTQl+fpqvlIg0AuLwXUXqt4Q9SMEG53n5eQxglNTsMYfKZmmrTeoVBseoYuxXbx3cB2LW6ItcvSkU4XbvK/wHhWj4QihD37WdnCyUC6TyBp1shhQ/fipue/BrZHCAb8nkjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474120; c=relaxed/simple;
	bh=XbrkE2ZmkkvZbk2pqJ+9I4hX+cX6RS8o9F3CEfTEw50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aY1kFHWL5V67c3kVVn1j5OvX7GZWHBhwP+O+T6HP4EFvknWUpeEPsOGurhTs8EPzNbFarsT4NPzpv2wiaAoA7iy6szJS9UM+Ybyff71Lhu/6+TcGx5s4dgUr/SLg1dODj796JuhZD8MIdK7n7iXfR51sqVY7SlzjzELu+iJICTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bjfuK4nU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bjfuK4nU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25989C2BBFC;
	Tue, 30 Apr 2024 10:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474120;
	bh=XbrkE2ZmkkvZbk2pqJ+9I4hX+cX6RS8o9F3CEfTEw50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bjfuK4nU2bX59NTMhZ4V+Ba4aqfuI9l2/da7Dli7+tjG6E+5ZW+vlI69T7146AiaL
	 0ldgbBI+OVZJmghf/Qxs2v8oufNLm6DI98xzJNsPrV6N+kdxTEcod6o4Qx/7MKkuGh
	 fK/tWlNcrYCu4zN1AfPRG1dwFuUL3ReLA/sdyw7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 023/228] arm64: dts: mediatek: mt7622: fix ethernet controller "compatible"
Date: Tue, 30 Apr 2024 12:36:41 +0200
Message-ID: <20240430103104.483849250@linuxfoundation.org>
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
index 4c8a71c8184b7..8e46480b5364b 100644
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



