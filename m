Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B1533F8A6;
	Sat, 12 Sep 2026 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223887; cv=none; b=OQjV/7hOWzyIUNZ/gVcdwQMAfgpSqXDeMh6y8NNA/JV9dKNh6LDsmopqaWfXOCsXaVtBoQMHqlpuGudFQg4fDbp1qHHS9O8Bt6y9wkmtjoLCMEBlZibfIn7hVJjVU96umCTOap9FteTc8QQbCzKpCDWf5fnJMrqUuQ6Dy7Rufck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223887; c=relaxed/simple;
	bh=TTN+eKC8ZSzdZkoYfD3QB+uyYkSzIM0hHvT/JVE3uNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXOlLyn0c3tANtBGrkL6dTE6S3P2jmE6zFg59lDDCZTg1Qr5eVHFvHcS5YBimsmzkA22p8U/RkYoODT5FunuEhtOy8wwBPMVc5awqEvtFOnkhRw60TZ4htppNcNsHeiOuwZVKly2vbQSgFujY+67grhMeicWNdqumYSUc3glxWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=br8RQaIe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="br8RQaIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EE71F00899;
	Sat, 12 Sep 2026 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223884;
	bh=wLz5t6tnN+1U/dqIL4MCozHemQ6MXuYYDneoRexKVbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=br8RQaIeDFL/oxO/ddyEOa9cPm0m/0F+pzaTMVGFsz9K8qmuTpZhjDnRKsXrzbMoI
	 teuqRlIRNf61v+aOq+Vsn606WsfYvTSUsyQJIPP++I0WkC/xDi9VFBMPVmR6HlwCC6
	 CIjBXjD993q+V3nQJcCMqhR5VWPONh7TPCmOefV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0880/1424] pinctrl: mediatek: Fix the invalid conditions
Date: Sat, 12 Sep 2026 08:55:12 +0200
Message-ID: <20260912065627.028315511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



