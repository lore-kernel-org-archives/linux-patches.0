Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8AD1B4F21;
	Wed, 19 Feb 2025 09:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956489; cv=none; b=g8AT78NzKVqkFmYo1yX2a0BKVkG2aa8md06UZT6EcTJHOoDzVez+yjbrYjJq9rLaUmE2PpQQTbRrUlOijFTB0SYFB6EaqUT4Puwz7V+41LzILWtAAqdcdul/TZ5v6IdvVPpSkmrV1r8kDBJJG1/1i77yTpwxvGja67CxaLYpOeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956489; c=relaxed/simple;
	bh=bNXq2+vzF83eG/w/8rSbr2DwAUdipB+8tPAPfBSsofs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etYa74J31B+fozLa4vxQiexGHnX1Gsi7V2Xe3zCLRHWFfVwc4CoNz49fo9at4nUtGALCcvJqOjR80Co0X94fSh9O3B6mHIqJjtDOBTzdqM7MFQT5oLu38K8O8Q+fJzp9pMAi+4LDfSya4FuG9hR3S/vUsfG5FAOYR29d3HtvymY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQLeypjK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQLeypjK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62549C4CED1;
	Wed, 19 Feb 2025 09:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956488;
	bh=bNXq2+vzF83eG/w/8rSbr2DwAUdipB+8tPAPfBSsofs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQLeypjK8iJ+s8EfsrYXeMmqmAy5LM+MqLMtwFJ9VQhy4q/0GEjl/1oat03TlBuJy
	 m7JA92cefbpJ9FEo329BopjkT9O0UZsrKS6GIN34UChUXaLJvpH1EMLcXyE1Q0Gjtv
	 mknwXftksgC2KPSrzOSEm5uuzV1Nncm6LefRHkcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 178/578] dts: arm64: mediatek: mt8195: Remove MT8183 compatible for OVL
Date: Wed, 19 Feb 2025 09:23:02 +0100
Message-ID: <20250219082659.968295870@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH.Lin <jason-jh.lin@mediatek.com>

[ Upstream commit ce3dbc46d7e30a84b8e99c730e3172dd5efbf094 ]

The OVL hardware capabilities have changed starting from MT8195,
making the MT8183 compatible no longer applicable.
Therefore, it is necessary to remove the MT8183 compatible for OVL.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Jason-JH.Lin <jason-jh.lin@mediatek.com>
Fixes: b852ee68fd72 ("arm64: dts: mt8195: Add display node for vdosys0")
Link: https://lore.kernel.org/r/20241219181531.4282-5-jason-jh.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index aa8fbaf15e629..274edce5d5e6e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -2000,7 +2000,7 @@
 		};
 
 		ovl0: ovl@1c000000 {
-			compatible = "mediatek,mt8195-disp-ovl", "mediatek,mt8183-disp-ovl";
+			compatible = "mediatek,mt8195-disp-ovl";
 			reg = <0 0x1c000000 0 0x1000>;
 			interrupts = <GIC_SPI 636 IRQ_TYPE_LEVEL_HIGH 0>;
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS0>;
-- 
2.39.5



