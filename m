Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021542F19A0;
	Tue, 17 Jun 2025 16:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177816; cv=none; b=kCzjklLmaal5CV7Y/2k+a9gHGcmfBlWudNuB/EbvlBORP9v40EnHoGpaYoUqShZRqLBTL21OeEq7v4Xt1oibek6/hiZ2e1lciQN37yqqIoFcx265hRe4Hebpi9t0i901JMaD3etrLgLQWOJxGNdCfNKOcamJzbc4PrgWNQhypBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177816; c=relaxed/simple;
	bh=TyN3ys2Dlidln4QxL7t5IDeINumH94fY94Q4cBzsyQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD51eCIQ/cAem1uA1U6TJlWr/ALe22ecpPTZtFQtP7LxbRs9sGzB/3+NEqFPASESJuGMV6FSTk52x3darXnODpgxpBedfRqYJ1C3199sFt65Zxv1rUAFYQal2dED157cnn99+eo97AmmFNmTIImLSxqrEwDU/jUgumgyslGSJKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cli885Gt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cli885Gt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B1AC4CEE3;
	Tue, 17 Jun 2025 16:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177815;
	bh=TyN3ys2Dlidln4QxL7t5IDeINumH94fY94Q4cBzsyQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cli885Gt3kfKoeZzhxpvT30dYCODpZXfFqI6EFUeIrCuQIYu0XN9cVBQfu3nPbKGL
	 6WZCccnto2EgN4H12WL8xDRD0oSR36Pdn7jPJi9oN2OwoR78YRxBfhUVDl/JyMEHA5
	 iLBwPNA2NmIjJL6X0ZT8xg2xVWqY3UOQKi1ey1zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 367/780] arm64: dts: mediatek: mt8195: Reparent vdec1/2 and venc1 power domains
Date: Tue, 17 Jun 2025 17:21:15 +0200
Message-ID: <20250617152506.397955632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4f2dc0a755661..1ded4b3f87605 100644
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



