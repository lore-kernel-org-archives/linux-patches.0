Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B611427ECC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rhYOrhLB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A03C433CD;
	Mon, 16 Oct 2023 14:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467715;
	bh=rSHCW4N0CICKP1brysO+tJGaBHlunVhRhj3JgVlgHIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhYOrhLBp/zuo+AgzFwb/ggHLDJyzXcXErKrRh64TmJh8QvaBjX9TAJjuiMSxsHjV
	 KRPn/MckaZnsaWlemFDyAoSxlve2QScnuxRprA9prKHyj4J4ipqoCf4ASmLloc4kJU
	 IwH5+vOgKQhVIYeN5D6gfsauWT5QyQF3KD+QVffI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 057/191] arm64: dts: mediatek: fix t-phy unit name
Date: Mon, 16 Oct 2023 10:40:42 +0200
Message-ID: <20231016084016.735161237@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <eugen.hristev@collabora.com>

[ Upstream commit 963c3b0c47ec29b4c49c9f45965cd066f419d17f ]

dtbs_check throws a warning at t-phy nodes:
Warning (unit_address_vs_reg): /t-phy@1a243000: node has a unit name, but no reg or ranges property
Warning (unit_address_vs_reg): /soc/t-phy@11c00000: node has a unit name, but no reg or ranges property

The ranges is empty thus removing the `@1a243000`, `@11c00000` from
the node name.

Fixes: 6029cae696c8 ("arm64: dts: mediatek: mt7622: harmonize node names and compatibles")
Fixes: 918aed7abd2d ("arm64: dts: mt7986: add pcie related device nodes")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230814093931.9298-2-eugen.hristev@collabora.com
Link: https://lore.kernel.org/r/20231003-mediatek-fixes-v6-7-v1-4-dad7cd62a8ff@collabora.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi  | 2 +-
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 36ef2dbe8add4..3ee9266fa8e98 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -905,7 +905,7 @@ sata: sata@1a200000 {
 		status = "disabled";
 	};
 
-	sata_phy: t-phy@1a243000 {
+	sata_phy: t-phy {
 		compatible = "mediatek,mt7622-tphy",
 			     "mediatek,generic-tphy-v1";
 		#address-cells = <2>;
diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 68539ea788dfc..24eda00e320d3 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -434,7 +434,7 @@ pcie_intc: interrupt-controller {
 			};
 		};
 
-		pcie_phy: t-phy@11c00000 {
+		pcie_phy: t-phy {
 			compatible = "mediatek,mt7986-tphy",
 				     "mediatek,generic-tphy-v2";
 			#address-cells = <2>;
-- 
2.40.1



