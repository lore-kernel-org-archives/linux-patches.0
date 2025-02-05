Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16AB8634E;
	Wed,  5 Feb 2025 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766285; cv=none; b=M9DK7NxSAvBROyBwbENfaoUvvPgQEX58HNraupgFuUyzioUsprW6/5ZyvPYLOZTei9pW/boYdyVoaDF0/oo3I0/oPoTeGBhKqtOaY5Dbdk1zWm22U4NhWLVYRJWS0HlvEHRu2yxZ2hydoll1U+RtIkm62WLu+lbT/4XwBvK7dAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766285; c=relaxed/simple;
	bh=glBo92eN7mwWWQ+JPKHmkBV3Pm3WuEVAax0R2tXUC5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKQgdX46nTCzFCtsfj0Oo9fZRLiflaT3jIvtgSpyOXji0ik/gTlLatZwXLiZ5S927Yo1YrNdBt01xowSnKBF31UO0A5G5FkuTaFv4i9QJfZOeDvhlLDpKXM04dU20GrJkl/HMz/Bxtvb51ujjoRdNWpdjuKDqtA7+vXOODdUcjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DBnKdgof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DBnKdgof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E54AC4CED1;
	Wed,  5 Feb 2025 14:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766285;
	bh=glBo92eN7mwWWQ+JPKHmkBV3Pm3WuEVAax0R2tXUC5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DBnKdgofSXqCo+7MfqmkYAv6mOB6prbolC5+FTDKYbzccNERATAopBGGWi9s2OjSb
	 hAOcOy43tIfp+Dc3UhyWAJPk1xOrJytD43Hy3SdhoJyLO9EBream2HXelws6NZ+r6O
	 +XX+xCOofwMtViDpHCvb+xt38FBGEGKQ9QBO+L9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 307/590] arm64: dts: mediatek: mt8516: fix wdt irq type
Date: Wed,  5 Feb 2025 14:41:02 +0100
Message-ID: <20250205134507.021779348@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 03a80442030e7147391738fb6cbe5fa0b3b91bb1 ]

The GICv2 does not support EDGE_FALLING interrupts, so the watchdog
would refuse to attach due to a failing check coming from the GIC driver.

Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-3-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 4444293413023..098c32ebf6788 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -206,7 +206,7 @@
 			compatible = "mediatek,mt8516-wdt",
 				     "mediatek,mt6589-wdt";
 			reg = <0 0x10007000 0 0x1000>;
-			interrupts = <GIC_SPI 198 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>;
 			#reset-cells = <1>;
 		};
 
-- 
2.39.5



