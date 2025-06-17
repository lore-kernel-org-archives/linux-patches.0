Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4C72F2343;
	Tue, 17 Jun 2025 16:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176473; cv=none; b=oX8oBiEgjl0xgcdOAKHOBr3NwQxRoxUZo675bXNy5wG286T9zFh7qGIXOqIvnZ2cdhY7bLZ5CVHDb810Vnpnr/FS+3TloeZVcLVG0fji2/lOAr8xw0lS1W0DY7ZLO9dPgdZB2T3X10Siww00jf9tzJeqyjM5AkXWMWr6d0XNtX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176473; c=relaxed/simple;
	bh=vVL+Yd5fUxSrXTOpHYIv7kO/SV0HNiuAUGdgcIYgUfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjTpycK+yjZ4eszRWzaQEz7uJrva5Fo63QODm0FXfHg4brw5qLYn2CAQSM9/BzVvzDbTIh4RhT3g4mmb4P7y4416K1IoOYiDwhfe22IhBj4kRzoHunZUC71P5NP8Rcr1TgE2Knz+q6Hrkmc1Nveou9RyX4zOpl6++yB3tDmos9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYiJs1kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYiJs1kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81864C4CEE3;
	Tue, 17 Jun 2025 16:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176473;
	bh=vVL+Yd5fUxSrXTOpHYIv7kO/SV0HNiuAUGdgcIYgUfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYiJs1kPo0+r0pKo3FwE4vrxnahkeA6zfEjlFa+A2EvH5tg6EqYpLREYqUdTxmons
	 0Ilr7+TJfrPmBx72DV7tluP5lWLWYCRr/7W/r0juTuf5gYZ1hSJsd73dr/3CFM1YPC
	 mP6EYXzhIv7XQWrVw+wzflRzDRQLJuwkHnzIg3V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/512] arm64: dts: mediatek: mt8195: Reparent vdec1/2 and venc1 power domains
Date: Tue, 17 Jun 2025 17:23:19 +0200
Message-ID: <20250617152429.067790465@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 394f29033324e2317bfd6a7ed99b9a60832b36a2 ]

By hardware, the first and second core of the video decoder IP
need the VDEC_SOC to be powered up in order to be able to be
accessed (both internally, by firmware, and externally, by the
kernel).
Similarly, for the video encoder IP, the second core needs the
first core to be powered up in order to be accessible.

Fix that by reparenting the VDEC1/2 power domains to be children
of VDEC0 (VDEC_SOC), and the VENC1 to be a child of VENC0.

Fixes: 2b515194bf0c ("arm64: dts: mt8195: Add power domains controller")
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/20250402090615.25871-3-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 50 +++++++++++++-----------
 1 file changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index f013dbad9dc4e..2e138b54f5563 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -617,22 +617,6 @@
 					#size-cells = <0>;
 					#power-domain-cells = <1>;
 
-					power-domain@MT8195_POWER_DOMAIN_VDEC1 {
-						reg = <MT8195_POWER_DOMAIN_VDEC1>;
-						clocks = <&vdecsys CLK_VDEC_LARB1>;
-						clock-names = "vdec1-0";
-						mediatek,infracfg = <&infracfg_ao>;
-						#power-domain-cells = <0>;
-					};
-
-					power-domain@MT8195_POWER_DOMAIN_VENC_CORE1 {
-						reg = <MT8195_POWER_DOMAIN_VENC_CORE1>;
-						clocks = <&vencsys_core1 CLK_VENC_CORE1_LARB>;
-						clock-names = "venc1-larb";
-						mediatek,infracfg = <&infracfg_ao>;
-						#power-domain-cells = <0>;
-					};
-
 					power-domain@MT8195_POWER_DOMAIN_VDOSYS0 {
 						reg = <MT8195_POWER_DOMAIN_VDOSYS0>;
 						clocks = <&topckgen CLK_TOP_CFG_VDO0>,
@@ -678,15 +662,25 @@
 							clocks = <&vdecsys_soc CLK_VDEC_SOC_LARB1>;
 							clock-names = "vdec0-0";
 							mediatek,infracfg = <&infracfg_ao>;
+							#address-cells = <1>;
+							#size-cells = <0>;
 							#power-domain-cells = <0>;
-						};
 
-						power-domain@MT8195_POWER_DOMAIN_VDEC2 {
-							reg = <MT8195_POWER_DOMAIN_VDEC2>;
-							clocks = <&vdecsys_core1 CLK_VDEC_CORE1_LARB1>;
-							clock-names = "vdec2-0";
-							mediatek,infracfg = <&infracfg_ao>;
-							#power-domain-cells = <0>;
+							power-domain@MT8195_POWER_DOMAIN_VDEC1 {
+								reg = <MT8195_POWER_DOMAIN_VDEC1>;
+								clocks = <&vdecsys CLK_VDEC_LARB1>;
+								clock-names = "vdec1-0";
+								mediatek,infracfg = <&infracfg_ao>;
+								#power-domain-cells = <0>;
+							};
+
+							power-domain@MT8195_POWER_DOMAIN_VDEC2 {
+								reg = <MT8195_POWER_DOMAIN_VDEC2>;
+								clocks = <&vdecsys_core1 CLK_VDEC_CORE1_LARB1>;
+								clock-names = "vdec2-0";
+								mediatek,infracfg = <&infracfg_ao>;
+								#power-domain-cells = <0>;
+							};
 						};
 
 						power-domain@MT8195_POWER_DOMAIN_VENC {
@@ -694,7 +688,17 @@
 							clocks = <&vencsys CLK_VENC_LARB>;
 							clock-names = "venc0-larb";
 							mediatek,infracfg = <&infracfg_ao>;
+							#address-cells = <1>;
+							#size-cells = <0>;
 							#power-domain-cells = <0>;
+
+							power-domain@MT8195_POWER_DOMAIN_VENC_CORE1 {
+								reg = <MT8195_POWER_DOMAIN_VENC_CORE1>;
+								clocks = <&vencsys_core1 CLK_VENC_CORE1_LARB>;
+								clock-names = "venc1-larb";
+								mediatek,infracfg = <&infracfg_ao>;
+								#power-domain-cells = <0>;
+							};
 						};
 
 						power-domain@MT8195_POWER_DOMAIN_VDOSYS1 {
-- 
2.39.5



