Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766BC28506F;
	Tue, 17 Jun 2025 16:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177422; cv=none; b=QJv0WFNxHhu4GkBicPh+ubMGMyxa4LHirUKsEz/Cmhj4k+qNotVIHjO2Wduatp13o7+Hi8Yf6KRVbcyKG5j0LfShx9Fr0yHj8We+hBej48Dr91dpsboJBJKVeLz+mN3xgnIys1YI6xLUUDNsmZWqigLYyxF/M3mnAvc8f19e0E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177422; c=relaxed/simple;
	bh=Sa5/wdjjxVNQOvojepxp1wWVKYWZlqyFWCMP0PsEotY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTp5fRhd/UEUKahzEQnH/OXazk5325KUmtZmMdUjSnZQQESN15Fga37AVcZhxJb65oqoEKg8gERx8OMsA8pBV/ZMX0UDyucnaMyEFqFlifBiPWY9FwH8lNP0liofOSb/99vptqHOOGC8xMzXMP5p6kVosR0EzXzgNN9R0dDJtC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZohlINP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZohlINP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76816C4CEE3;
	Tue, 17 Jun 2025 16:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177421;
	bh=Sa5/wdjjxVNQOvojepxp1wWVKYWZlqyFWCMP0PsEotY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZohlINP6dYjIajtgbOqS9bErgyHfI2nzgWYkBmJf9UGXCgsMMcuD4nqMLQwQm9J7h
	 UcOenzPBXynbEcYMeuT+b5ePH8KbuRduH/KW7yrTzf5hPmAqkB4XeLDkXkQchUfX4n
	 LtANAPgWbq8Ya/OiRlQB2yOyzqVKF6kDwFdBS37Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 281/780] pinctrl: mediatek: Fix the invalid conditions
Date: Tue, 17 Jun 2025 17:19:49 +0200
Message-ID: <20250617152502.916246971@linuxfoundation.org>
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
Stable-dep-of: 1c9977b26347 ("pinctrl: mediatek: eint: Fix invalid pointer dereference for v1 platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c              | 4 ++--
 drivers/pinctrl/mediatek/mtk-eint.h              | 2 +-
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 7 +++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index c516c34aaaf60..e235a98ae7ee5 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -506,7 +506,7 @@ EXPORT_SYMBOL_GPL(mtk_eint_find_irq);
 
 int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 {
-	unsigned int size, i, port, inst = 0;
+	unsigned int size, i, port, virq, inst = 0;
 
 	/* If clients don't assign a specific regs, let's use generic one */
 	if (!eint->regs)
@@ -580,7 +580,7 @@ int mtk_eint_do_init(struct mtk_eint *eint, struct mtk_eint_pin *eint_pin)
 		if (inst >= eint->nbase)
 			continue;
 		eint->pin_list[inst][eint->pins[i].index] = i;
-		int virq = irq_create_mapping(eint->domain, i);
+		virq = irq_create_mapping(eint->domain, i);
 		irq_set_chip_and_handler(virq, &mtk_eint_irq_chip,
 					 handle_level_irq);
 		irq_set_chip_data(virq, eint);
diff --git a/drivers/pinctrl/mediatek/mtk-eint.h b/drivers/pinctrl/mediatek/mtk-eint.h
index 23801d4b636f6..fc31a4c0c77bf 100644
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
index ba13558bfcd7b..4918d38abfc29 100644
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
2.39.5



