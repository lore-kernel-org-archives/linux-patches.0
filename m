Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276328801;
	Tue, 30 Apr 2024 11:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476169; cv=none; b=KUOaROTnUt/nU/SqYHbaFypEB/WLUKYzxhXRJGLVbdp6Wz1wt70RT148WE9qQ/qR6yyigbxwY1W2LsVM7N+PNSA29s140b34HT+a/47gktYmzhFZQ9nXB0BF1PBVm+1QwNljrebXLV1LtKcGTzlx0UAR4dryr/FBW1NyqemCqz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476169; c=relaxed/simple;
	bh=VG2ix6MURrr6bYZav9XKvXLBrinHND+WibkzV4hAOa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdpyWwZVIkI0a3yrN3ui0fkPf6Y8tKmKyM5/W3c0bmHbrZL6wvGJWqT2xnxHj6Nok0UennFNQMRycM/64G45FF6UqYgufqu++24d2xiyB9aGZEWwhkmbDVqh7gAmh0fQuHQMLCHu9rfBuESmMZj1rNKv316SaH7qwAMMAgcBgns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htQFtdlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htQFtdlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523A3C2BBFC;
	Tue, 30 Apr 2024 11:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476168;
	bh=VG2ix6MURrr6bYZav9XKvXLBrinHND+WibkzV4hAOa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htQFtdlmK5EEd9OhgxbQw0SloXTmvgKetvNNrWiEsQDRBPaPcTxtwQUaXPp+A8Ahb
	 mWpDti4U96tTpueWObTnzrRZW8o3UVHTOPc4T8wbqH4u5UcgE5x0KJNGLAqUId4/tr
	 51KL3EOCGIv8E662+8fqZi31KfhLW7ShdnE355Ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/107] arm64: dts: mediatek: mt7622: fix ethernet controller "compatible"
Date: Tue, 30 Apr 2024 12:40:16 +0200
Message-ID: <20240430103046.310331255@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7f5ffbd2381fb..aa4593af576c7 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -901,9 +901,7 @@
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



