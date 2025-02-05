Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B1218D65C;
	Wed,  5 Feb 2025 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766935; cv=none; b=GrMiY6zkb8alDAVBuFQ3mvPhKIFGwXdhq0u5Sg16d7kWi7xA46Uv/5BQWdDljtKdn0RaTOGU3c0yys0rESFzquC2tKPaEMbYBOPrTA5k511VFllzqEnxioZnUouMkhr3GajP7zrvBHfe+qCpbF9Zr1o9D9VT2JVuKapR+ZKiDN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766935; c=relaxed/simple;
	bh=k790IJ/DZ5IDEdtcyIHAWAcoAkHw/yKozuRr2iXbEgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyqfzMmz2rRTGsZ6CyTwpRwZrH3oEx1Ds0IcfmjtIJCpx6sRs/ptqLgoXm0t/VocnNVCcr/A0vPboJTaS+yDvOPdjFWp4BA2EW7QHSKblWXORXHBXMIPfItJ2c+i90o4MHSIapEMd0G611reA1/HLDJc9HIQAPb8bHZoPlhCI5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ac4o4YTK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ac4o4YTK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A0CC4CED1;
	Wed,  5 Feb 2025 14:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766935;
	bh=k790IJ/DZ5IDEdtcyIHAWAcoAkHw/yKozuRr2iXbEgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ac4o4YTKN3PSmtVyJK3OPlyZFjrtNbQzwSM2vCTxEwPdUdPsFb9mAhAiQE059arNn
	 t+tFRENmHnqYbcmFaWu2V2dUu2sf7P+5zyl+j8ePYCRpiXlHLQHo4K8003JbXrDEWY
	 eAj8aJgN7rA1WS8FnwkSQrCvwVTET1Ll152+YXxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 382/590] dts: arm64: mediatek: mt8195: Remove MT8183 compatible for OVL
Date: Wed,  5 Feb 2025 14:42:17 +0100
Message-ID: <20250205134509.882426814@linuxfoundation.org>
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
index 04e41b557d448..f013dbad9dc4e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -3135,7 +3135,7 @@
 		};
 
 		ovl0: ovl@1c000000 {
-			compatible = "mediatek,mt8195-disp-ovl", "mediatek,mt8183-disp-ovl";
+			compatible = "mediatek,mt8195-disp-ovl";
 			reg = <0 0x1c000000 0 0x1000>;
 			interrupts = <GIC_SPI 636 IRQ_TYPE_LEVEL_HIGH 0>;
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS0>;
-- 
2.39.5



