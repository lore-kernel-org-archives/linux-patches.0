Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DFF146A7A;
	Wed,  5 Feb 2025 14:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767511; cv=none; b=GOF1ok2tmk+2tIBGmkaZ+ZTgBJdFSnNV0srE7lWBi37ej8Bn1WZalyh/a84IiIN9H24uuvFO40hcODavXYlisLmLeceNetMoaQIzIPvjH3BnGq0ldd2h9nsMmS1W7sbLK0JDWt5HywljIAuFgotGFvG1Z3kKIG1rY5vYBZS4168=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767511; c=relaxed/simple;
	bh=SUtrT8JEh81SP3FnXBNDaGdv8YB9BKt5eLyMXU+BRK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIQ1XH4y0CMxERcPIEQXnvGzetYZsGBhin3mwNK3ZDI9NexCeJ+JcElAh0YyrMzt7aP8rVvMwoNUluogGqw3/Qx1ZWJAOOcno8fMA2GK2OvQVrSq3AYMMx2Jt2NDuoglRr4yDyByeWfD9HRuT3QmAAKkD1Yji9UlVs3N1FteJ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZhFg6Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZhFg6Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C837C4CED1;
	Wed,  5 Feb 2025 14:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767511;
	bh=SUtrT8JEh81SP3FnXBNDaGdv8YB9BKt5eLyMXU+BRK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZhFg6Q+S6GCCWOiTCGa4mzHUAgKHYY5UKXCf+AI/nYw+f/Re8VPnpIn8kTlYtpEO
	 PlukS9iwqjwMqYX9wSieOFfmQ2j4RGIsIGDiRi1jFAO4ohVZYzt455wjLF2isKHzMX
	 R295m+tKeTYT8Ti7aVmWzt41U/qJU03Tt3Kpq/mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"Jason-JH.Lin" <jason-jh.lin@mediatek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 414/623] dts: arm64: mediatek: mt8195: Remove MT8183 compatible for OVL
Date: Wed,  5 Feb 2025 14:42:36 +0100
Message-ID: <20250205134512.062736313@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



