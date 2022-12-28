Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B621863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD89C433D2;
	Wed, 28 Dec 2022 15:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241628;
	bh=ptffwuaA57EY8zsI0ZUWLwXpBGS5u+bwEF4PydWOXxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1aMR3SC4LFgAnaqg7AGjV/88Xkk150B90OggHHctqQ6yicsQhMlcJA5RfIpYQvYC
	 +dEbMmc6uXWWYI2pnWz38RGW2p52hGLVyoTiTvGSBm350LBRVG2andIesiXhxSNvWg
	 54//flI1zaZsndGc+Okut2LbJC4zy8+jeh65FuF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Shih <sam.shih@mediatek.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0309/1073] pinctrl: mediatek: fix the pinconf register offset of some pins
Date: Wed, 28 Dec 2022 15:31:37 +0100
Message-Id: <20221228144336.399765371@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sam Shih <sam.shih@mediatek.com>

[ Upstream commit 3476b354c65db442580ef355885c69e60c546ef0 ]

Correct the bias-pull-up, bias-pull-down and bias-disable register
offset of mt7986 pin-42 to pin-49, in the original driver, the
relative offset value was erroneously decremented by 1.

Fixes: 360de6728064 ("pinctrl: mediatek: add support for MT7986 SoC")
Signed-off-by: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20221106080114.7426-5-linux@fw-web.de
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt7986.c | 24 +++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7986.c b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
index f26869f1a367..5cb255455a54 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7986.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7986.c
@@ -316,10 +316,10 @@ static const struct mtk_pin_field_calc mt7986_pin_pupd_range[] = {
 	PIN_FIELD_BASE(38, 38, IOCFG_LT_BASE, 0x30, 0x10, 9, 1),
 	PIN_FIELD_BASE(39, 40, IOCFG_RB_BASE, 0x60, 0x10, 18, 1),
 	PIN_FIELD_BASE(41, 41, IOCFG_RB_BASE, 0x60, 0x10, 12, 1),
-	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x60, 0x10, 22, 1),
-	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x60, 0x10, 20, 1),
-	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x60, 0x10, 26, 1),
-	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x60, 0x10, 24, 1),
+	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x60, 0x10, 23, 1),
+	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x60, 0x10, 21, 1),
+	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x60, 0x10, 27, 1),
+	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x60, 0x10, 25, 1),
 	PIN_FIELD_BASE(50, 57, IOCFG_RT_BASE, 0x40, 0x10, 2, 1),
 	PIN_FIELD_BASE(58, 58, IOCFG_RT_BASE, 0x40, 0x10, 1, 1),
 	PIN_FIELD_BASE(59, 59, IOCFG_RT_BASE, 0x40, 0x10, 0, 1),
@@ -354,10 +354,10 @@ static const struct mtk_pin_field_calc mt7986_pin_r0_range[] = {
 	PIN_FIELD_BASE(38, 38, IOCFG_LT_BASE, 0x40, 0x10, 9, 1),
 	PIN_FIELD_BASE(39, 40, IOCFG_RB_BASE, 0x70, 0x10, 18, 1),
 	PIN_FIELD_BASE(41, 41, IOCFG_RB_BASE, 0x70, 0x10, 12, 1),
-	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x70, 0x10, 22, 1),
-	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x70, 0x10, 20, 1),
-	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x70, 0x10, 26, 1),
-	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x70, 0x10, 24, 1),
+	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x70, 0x10, 23, 1),
+	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x70, 0x10, 21, 1),
+	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x70, 0x10, 27, 1),
+	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x70, 0x10, 25, 1),
 	PIN_FIELD_BASE(50, 57, IOCFG_RT_BASE, 0x50, 0x10, 2, 1),
 	PIN_FIELD_BASE(58, 58, IOCFG_RT_BASE, 0x50, 0x10, 1, 1),
 	PIN_FIELD_BASE(59, 59, IOCFG_RT_BASE, 0x50, 0x10, 0, 1),
@@ -392,10 +392,10 @@ static const struct mtk_pin_field_calc mt7986_pin_r1_range[] = {
 	PIN_FIELD_BASE(38, 38, IOCFG_LT_BASE, 0x50, 0x10, 9, 1),
 	PIN_FIELD_BASE(39, 40, IOCFG_RB_BASE, 0x80, 0x10, 18, 1),
 	PIN_FIELD_BASE(41, 41, IOCFG_RB_BASE, 0x80, 0x10, 12, 1),
-	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x80, 0x10, 22, 1),
-	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x80, 0x10, 20, 1),
-	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x80, 0x10, 26, 1),
-	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x80, 0x10, 24, 1),
+	PIN_FIELD_BASE(42, 43, IOCFG_RB_BASE, 0x80, 0x10, 23, 1),
+	PIN_FIELD_BASE(44, 45, IOCFG_RB_BASE, 0x80, 0x10, 21, 1),
+	PIN_FIELD_BASE(46, 47, IOCFG_RB_BASE, 0x80, 0x10, 27, 1),
+	PIN_FIELD_BASE(48, 49, IOCFG_RB_BASE, 0x80, 0x10, 25, 1),
 	PIN_FIELD_BASE(50, 57, IOCFG_RT_BASE, 0x60, 0x10, 2, 1),
 	PIN_FIELD_BASE(58, 58, IOCFG_RT_BASE, 0x60, 0x10, 1, 1),
 	PIN_FIELD_BASE(59, 59, IOCFG_RT_BASE, 0x60, 0x10, 0, 1),
-- 
2.35.1



