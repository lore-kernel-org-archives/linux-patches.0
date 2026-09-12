Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08F04BEE38;
	Sat, 12 Sep 2026 16:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230063; cv=none; b=mMaYvKQ4wmjVddUTP7UZMGu8fvdglGOVLM2E+OejNibh68AgVPWwcweieH5nH54v5XnuvpDTBH/B+d2uKgcxqKDPrby8endWnlHfaUoWaxuRL04LM5miE2L+B2c4t5ukT9CXgk67fb5o92yTeB9V4/EQt7qJwjrnDM9TZF6lSuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230063; c=relaxed/simple;
	bh=kiMfjBiQDI7aAC7nrofyEP0pBatTjMuQJ2QUceDBr38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1MIRJ9HyLf/ggk2bjTOBzrfxk0vmmn2DJSPaqaxNGslZCDpOJUDr3e4grCFfeFQiB8elEKjzs3R8T5eZIBKXknlsAd4KAm94BCrCk/Ctt54xTSpZUlDnELYxRzHlaWlXxFAzqiuYVhWHlnnYDnTefhMnSk6FUj3CtDmPQf+UIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Up8ZNEhD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Up8ZNEhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27891F000FF;
	Sat, 12 Sep 2026 16:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230061;
	bh=a+a6NYW+FjEm3s1iSTRLFk8ih3C1sEHMofRCWJaT8Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Up8ZNEhDHQ2vQWflwCuAayydmLfHTVeJGII7/bOd0iUHKAz1/Lnu3mar6cZ/N4JG9
	 m8MDEH88Yy7GU1weWWBV+kFp6FmTNH/AExmlrUSi/NOvYhdOpu/ZlwtHwQH3VZelGw
	 YZVO/S4C6PEPOvVsWElLuQYeDgSzu+DhW4R57D9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0717/1191] pinctrl: mediatek: Fix the invalid conditions
Date: Sat, 12 Sep 2026 08:57:25 +0200
Message-ID: <20260912065604.383582590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Chang <ot_chhao.chang@mediatek.com>

[ Upstream commit 86dee87f4b2e6ac119b03810e58723d0b27787a4 ]

The variable count_reg_names is defined as an int type and cannot be
directly compared to an unsigned int. To resolve this issue,
first verify the correctness of count_reg_names.

Link: https://lore.kernel.org/all/5ae93d42e4c4e70fb33bf35dcc37caebf324c8d3.camel@mediatek.com/T/
Signed-off-by: Hao Chang <ot_chhao.chang@mediatek.com>
Signed-off-by: Qingliang Li <qingliang.li@mediatek.com>
Link: https://lore.kernel.org/20250329024533.5279-1-ot_chhao.chang@mediatek.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: 88292b7103d2 ("pinctrl: mediatek: free EINT resources on unbind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c              | 4 ++--
 drivers/pinctrl/mediatek/mtk-eint.h              | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 7 +++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index ced4ee509b5b6..557dec75fa031 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -507,7 +507,7 @@ EXPORT_SYMBOL_GPL(mtk_eint_find_irq);
 
 int mtk_eint_do_init(struct mtk_eint *eint)
 {
-	unsigned int size, i, port, inst = 0;
+	unsigned int size, i, port, virq, inst = 0;
 	struct mtk_pinctrl *hw = (struct mtk_pinctrl *)eint->pctl;
 
 	/* If clients don't assign a specific regs, let's use generic one */
@@ -584,7 +584,7 @@ int mtk_eint_do_init(struct mtk_eint *eint)
 		if (inst >= eint->nbase)
 			continue;
 		eint->pin_list[inst][eint->pins[i].index] = i;
-		int virq = irq_create_mapping(eint->domain, i);
+		virq = irq_create_mapping(eint->domain, i);
 		irq_set_chip_and_handler(virq, &mtk_eint_irq_chip,
 					 handle_level_irq);
 		irq_set_chip_data(virq, eint);
diff --git a/drivers/pinctrl/mediatek/mtk-eint.h b/drivers/pinctrl/mediatek/mtk-eint.h
index f7f58cca0d5e3..0c6bf7cbdc3a4 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.h
+++ b/drivers/pinctrl/mediatek/mtk-eint.h
@@ -66,7 +66,7 @@ struct mtk_eint_xt {
 struct mtk_eint {
 	struct device *dev;
 	void __iomem **base;
-	u8 nbase;
+	int nbase;
 	u16 *base_pin_num;
 	struct irq_domain *domain;
 	int irq;
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index d220d8c0aa654..26fe53d9a53fb 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -381,10 +381,13 @@ int mtk_build_eint(struct mtk_pinctrl *hw, struct platform_device *pdev)
 		return -ENOMEM;
 
 	count_reg_names = of_property_count_strings(np, "reg-names");
-	if (count_reg_names < hw->soc->nbase_names)
+	if (count_reg_names < 0)
+		return -EINVAL;
+
+	hw->eint->nbase = count_reg_names - (int)hw->soc->nbase_names;
+	if (hw->eint->nbase <= 0)
 		return -EINVAL;
 
-	hw->eint->nbase = count_reg_names - hw->soc->nbase_names;
 	hw->eint->base = devm_kmalloc_array(&pdev->dev, hw->eint->nbase,
 					    sizeof(*hw->eint->base), GFP_KERNEL | __GFP_ZERO);
 	if (!hw->eint->base) {
-- 
2.53.0



