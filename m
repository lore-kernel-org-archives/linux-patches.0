Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0348820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D35BC433D2;
	Fri, 10 Mar 2023 14:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460029;
	bh=oTSow6FCAKzLfUrmVjJtF59hjAUxCDXRS2TyAVf0SlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLWp6h2Ugj6WQGMMjMPJS7+LTOgyd5+D1iKYJNNuwBX5+MXuW0w5a0R1Y8125Oreh
	 z3Gl5BdxFtMMLbgEan/mhxYk7QjEBJtSQqiiHBaYJy/x+CIXy5+ww6D84w0q5XZIFn
	 VGDz8/hl/LOZ25J1dLwsdagaQ4YGdukiSbcrdWK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guodong Liu <Guodong.Liu@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/529] pinctrl: mediatek: Initialize variable pullen and pullup to zero
Date: Fri, 10 Mar 2023 14:35:25 +0100
Message-Id: <20230310133813.389849254@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guodong Liu <Guodong.Liu@mediatek.com>

[ Upstream commit a298c70a10c604a6b3df5a0aa56597b705ba0f6b ]

Coverity spotted that pullen and pullup is not initialized to zero in
mtk_pctrl_show_one_pin. The uninitialized variable pullen is used in
assignment statement "rsel = pullen;" in mtk_pctrl_show_one_pin, and
Uninitialized variable pullup is used when calling scnprintf. Fix this
coverity by initializing pullen and pullup as zero.

Fixes: 184d8e13f9b1 ("pinctrl: mediatek: Add support for pin configuration dump via debugfs.")
Signed-off-by: Guodong Liu <Guodong.Liu@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230118062036.26258-2-Guodong.Liu@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index d0a4ebbe1e7e6..2a9d2801388d7 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -574,7 +574,7 @@ static int mtk_hw_get_value_wrap(struct mtk_pinctrl *hw, unsigned int gpio, int
 ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 	unsigned int gpio, char *buf, unsigned int bufLen)
 {
-	int pinmux, pullup, pullen, len = 0, r1 = -1, r0 = -1;
+	int pinmux, pullup = 0, pullen = 0, len = 0, r1 = -1, r0 = -1;
 	const struct mtk_pin_desc *desc;
 
 	if (gpio >= hw->soc->npins)
-- 
2.39.2



