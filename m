Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B662BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D69C433EF;
	Tue,  7 Mar 2023 18:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212210;
	bh=hBoVP1W2GMIwWk5T6bXZ7y17FxhaiGbcrGJDOJIw404=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWXIltCRkWAvbtnL2SkyVbVYnATcxfA/9EFSlwgh8NymgA+LPTHxcP6sr+/+oRxBP
	 k/FmDe7jVelBtyEB3mBiV0/Vsp/bU3z22ms/UlVau+JfziUV2U+ZpGi62474C2AyAn
	 jLyVeZoC9h3TbTg/1OqneHDB2JlMkwadTwbRwueI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/885] arm64: dts: mediatek: mt8195: Fix watchdog compatible
Date: Tue,  7 Mar 2023 17:50:16 +0100
Message-Id: <20230307170005.371228379@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

[ Upstream commit 02938f460cde0d360dde48056c4d1c0a4bd49230 ]

MT8195's watchdog embeds a reset controller and needs only the
mediatek,mt8195-wdt compatible string as the MT6589 one is there
for watchdogs that don't have any reset controller capability.

Fixes: 37f2582883be ("arm64: dts: Add mediatek SoC mt8195 and evaluation board")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Co-developed-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20221108033209.22751-3-allen-kh.cheng@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 774c2de1fd01e..2c2b946b614bf 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -690,8 +690,7 @@ power-domain@MT8195_POWER_DOMAIN_AUDIO {
 		};
 
 		watchdog: watchdog@10007000 {
-			compatible = "mediatek,mt8195-wdt",
-				     "mediatek,mt6589-wdt";
+			compatible = "mediatek,mt8195-wdt";
 			mediatek,disable-extrst;
 			reg = <0 0x10007000 0 0x100>;
 			#reset-cells = <1>;
-- 
2.39.2



