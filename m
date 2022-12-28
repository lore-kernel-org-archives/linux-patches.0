Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC931863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3230DC433F0;
	Wed, 28 Dec 2022 15:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240007;
	bh=Nt2W1Bb9eNSNTdu6H9aoXChzhYFhLBLCJU/hO3SMFFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VNn/sTIOk3xqoJWm+/2cwP32vp/VkvSCdg/MqGVahbh4Q/RxycE3AKubZeJbBEV9J
	 6bKex72ToescoNRi33m52Cub6lAWPTC9c+FZIVfVJqy/E1GGGNcwoqZ+ZJViKEWFHJ
	 1PSPNLaYVLwkA+bsqMG2U69QQH85km5ER9VzDZTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0070/1146] arm64: dts: mt7896a: Fix unit_address_vs_reg warning for oscillator
Date: Wed, 28 Dec 2022 15:26:49 +0100
Message-Id: <20221228144332.058186139@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 7898d047b1eb2bec2622668cd70181442a580c6d ]

Rename the oscillator fixed-clock to oscillator-40m and remove
the unit address to fix warnings.

arch/arm64/boot/dts/mediatek/mt7986a.dtsi:17.23-22.4: Warning
(unit_address_vs_reg): /oscillator@0: node has a unit name,
but no reg or ranges property

Fixes: 1f9986b258c2 ("arm64: dts: mediatek: add clock support for mt7986a")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221013152212.416661-2-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 226648f48df2..14c91ded29e6 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -14,7 +14,7 @@ / {
 	#address-cells = <2>;
 	#size-cells = <2>;
 
-	clk40m: oscillator@0 {
+	clk40m: oscillator-40m {
 		compatible = "fixed-clock";
 		clock-frequency = <40000000>;
 		#clock-cells = <0>;
-- 
2.35.1



