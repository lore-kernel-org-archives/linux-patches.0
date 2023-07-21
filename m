Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F3F200A6
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB14C433C8;
	Fri, 21 Jul 2023 18:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965867;
	bh=/zozPttlSbLTRnrUj+5VfRZaVaDnvxjL4jrMe1l3sp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLFOsi2uQiEhzzvrIotEy3XHjdBH5qP7uu9WOvyovAB6m9YHO+hT1pYtUyfTDEruW
	 ICC2hDv8/MxGiK/DJbKSC7ibCOkF8obudOsoW+TRxGMHmShFi9SVHPtxT7JaPVInwK
	 Fvw5Qq4o9mYmi1mP9Th1hItXFCBeD0+oXRzHWjjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Werner <jwerner@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/532] arm64: dts: mediatek: mt8183: Add mediatek,broken-save-restore-fw to kukui
Date: Fri, 21 Jul 2023 18:00:47 +0200
Message-ID: <20230721160622.205400128@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 42127f578ebde652d1373e0233356fbd351675c4 ]

Firmware shipped on mt8183 Chromebooks is affected by the GICR
save/restore issue as described by the patch ("dt-bindings:
interrupt-controller: arm,gic-v3: Add quirk for Mediatek SoCs w/
broken FW"). Add the quirk property.

Fixes: cd894e274b74 ("arm64: dts: mt8183: Add krane-sku176 board")
Reviewed-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230515131353.v2.3.I525a2ed4260046d43c885ee1275e91707743df1c@changeid
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index 8e9cf36a9a41a..6529962edd4e9 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -281,6 +281,10 @@ dsi_out: endpoint {
 	};
 };
 
+&gic {
+	mediatek,broken-save-restore-fw;
+};
+
 &gpu {
 	mali-supply = <&mt6358_vgpu_reg>;
 	sram-supply = <&mt6358_vsram_gpu_reg>;
-- 
2.39.2



