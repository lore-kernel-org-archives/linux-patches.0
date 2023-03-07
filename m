Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2A2BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:11:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE48C433EF;
	Tue,  7 Mar 2023 17:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209069;
	bh=DTte6xl4Qkqb17569cuxG6114t01GyM5qw4MHyPOw9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PueTYOO1mUy6m0Y0aRVcgZiqzxpl3RjmMoBJgqbIJbcnJhNW4Ujk1HLNphptItYq0
	 oQjhtofawNTwfqnF+iS90j6sNXqTDKmTfk+ZVlA6GfbRNPvuEaDVUTTPGO+rsmTNuC
	 6luJZFFfOUGH1BEZYnnFy09/BwCnuHOir7x3sDjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Allen-KH Cheng <allen-kh.cheng@mediatek.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0101/1001] arm64: dts: mediatek: mt8186: Fix watchdog compatible
Date: Tue,  7 Mar 2023 17:47:53 +0100
Message-Id: <20230307170026.545294375@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit e5e961628d696237ddc3d53d9d5ac11f43e0bf67 ]

MT8186's watchdog embeds a reset controller and needs only the
mediatek,mt8186-wdt compatible string as the MT6589 one is there
for watchdogs that don't have any reset controller capability.

Fixes: 2e78620b1350 ("arm64: dts: Add MediaTek MT8186 dts and evaluation board and Makefile")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Co-developed-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Signed-off-by: Allen-KH Cheng <allen-kh.cheng@mediatek.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20221108033209.22751-2-allen-kh.cheng@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8186.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186.dtsi b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
index 0d8d2799d86d1..a02bf4ab1504d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186.dtsi
@@ -333,8 +333,7 @@ pio: pinctrl@10005000 {
 		};
 
 		watchdog: watchdog@10007000 {
-			compatible = "mediatek,mt8186-wdt",
-				     "mediatek,mt6589-wdt";
+			compatible = "mediatek,mt8186-wdt";
 			mediatek,disable-extrst;
 			reg = <0 0x10007000 0 0x1000>;
 			#reset-cells = <1>;
-- 
2.39.2



