Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9DA46AA92;
	Tue, 21 Jul 2026 15:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648197; cv=none; b=H8tfckTs+NPGq4vlmMD516TfpWX5GC1ZOeB77G3XkCGenv4Kdr1de4xRbR5PRVY59rcVipxzU86imX9ItBwLRZJUzrpjcmfW7rSCdz4XehSJMnuUKe77NiDrgj/JhBaBwZBTndjHxdJGHUn1D0pDkGyAIZExcsrniYWvXy/eSJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648197; c=relaxed/simple;
	bh=bw2qr2XSw9Ixoy7Wai9Fr+5n4EdCHCk3m3VOfNe0GQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJtCxyGLJiUg6ZEmW+mrdmsvZVZwOm/wzFfBljJzwseLsL7pOMdKfRmxqi/GYENcvq5gMjdWcqA5KD1EnjOwRtAZ+UcoHvUxrOi5fUg0UGwmevFrFFXXlNbxdHWLWPSHwRzwpcBik0ZGBjqUTT3Ux0NvD6E8FjzRcvPcNZWt1eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItODiH4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItODiH4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8A61F000E9;
	Tue, 21 Jul 2026 15:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648195;
	bh=CdZfOBftp3VcoVg24jV8khcqGvUKeXjWfd7fenYQ/+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItODiH4fVj3gz7Fldig63dI6Uxo7KzURdvU+qSncyOrRQrr+eqFeEY2Gtz7vZZXKZ
	 mgdqJEWZOCRF64Ulh8J5B6I9Je0ZiHZPSM9KfceLzbspOXrYbWPIZOdTjewD9sABCA
	 SGm8SXYQxUERUAQs9tRRSOYWfZD0bs0ZTrITs9G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0108/2077] pinctrl: mediatek: eint: Drop base from mtk_eint_chip_write_mask()
Date: Tue, 21 Jul 2026 16:56:21 +0200
Message-ID: <20260721152555.242055623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 3ca99eed042620d12315e9272ed3ef260ca29877 ]

When support for multiple EINT base addresses was added in commit
3ef9f710efcb ("pinctrl: mediatek: Add EINT support for multiple
addresses"), mtk_eint_chip_write_mask() was changed to write interrupt
masks for all base addresses in one call. However the "base" parameter
was left around and now causes sparse warnings:

    mtk-eint.c:428:44: warning: incorrect type in argument 2 (different address spaces)
    mtk-eint.c:428:44:    expected void [noderef] __iomem *base
    mtk-eint.c:428:44:    got void [noderef] __iomem **base
    mtk-eint.c:436:44: warning: incorrect type in argument 2 (different address spaces)
    mtk-eint.c:436:44:    expected void [noderef] __iomem *base
    mtk-eint.c:436:44:    got void [noderef] __iomem **base

Since the "base" parameter is no longer needed, just drop it.

Fixes: 3ef9f710efcb ("pinctrl: mediatek: Add EINT support for multiple addresses")
Cc: Hao Chang <ot_chhao.chang@mediatek.com>
Cc: Qingliang Li <qingliang.li@mediatek.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/mtk-eint.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/mtk-eint.c b/drivers/pinctrl/mediatek/mtk-eint.c
index 2a3c04eedc5f38..47ac92ea98c2c5 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -246,7 +246,7 @@ static int mtk_eint_irq_set_wake(struct irq_data *d, unsigned int on)
 }
 
 static void mtk_eint_chip_write_mask(const struct mtk_eint *eint,
-				     void __iomem *base, unsigned int **buf)
+				     unsigned int **buf)
 {
 	int inst, port, port_num;
 	void __iomem *reg;
@@ -425,7 +425,7 @@ static void mtk_eint_irq_handler(struct irq_desc *desc)
 
 int mtk_eint_do_suspend(struct mtk_eint *eint)
 {
-	mtk_eint_chip_write_mask(eint, eint->base, eint->wake_mask);
+	mtk_eint_chip_write_mask(eint, eint->wake_mask);
 
 	return 0;
 }
@@ -433,7 +433,7 @@ EXPORT_SYMBOL_GPL(mtk_eint_do_suspend);
 
 int mtk_eint_do_resume(struct mtk_eint *eint)
 {
-	mtk_eint_chip_write_mask(eint, eint->base, eint->cur_mask);
+	mtk_eint_chip_write_mask(eint, eint->cur_mask);
 
 	return 0;
 }
-- 
2.53.0



