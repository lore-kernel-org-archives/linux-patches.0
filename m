Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F782DE702;
	Sat, 12 Sep 2026 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219422; cv=none; b=UgOS4sdM7wqv3l6wZY7fkS+ZNY/o6oK2rsveCCNXR214RJjbV/zCn+ML1AGjouDsM0YlrLbTZ22vCnUTyGuyWPr7gz2YsZYLGHK9V6UBuBr7YeWjYEznYH5nJCaEXBcEi70ihfZ9e/mdwdsRpgqzI3i0JmnUQ4Xqis8OePTXgX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219422; c=relaxed/simple;
	bh=Qo69SCgujbY9nWYsFxH5hosHQPo4zey2C+y9hjej3dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao1PesbjhbPCXzXh9J4lxX28ExM6g7mDxcxlLeVyqZvGP93RQzziHV90vb4kjk8pexkpnN7GoXrei6bbken01fM2VFVw7wTMPjNGYSshhwOdvurkx/oqCY6rJQTn1OF+8Nw0kOMgfjKf3COErpLROzyZpzjDTY2+L4hOzBUW/zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxcpL6AJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxcpL6AJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA411F000FF;
	Sat, 12 Sep 2026 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219420;
	bh=nGFzC/pO/vNsT6LBsSX5og/8bZ7uCK07U9Db7ULNPC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gxcpL6AJMJ+epxVDFnSBxvHMitfzmfQm6mwu4JES3rw4/dG/Hsy+ncW51HGgd1Kuw
	 0gywdZnkDam4XwhqFaH4SBnhOPsf1PeqnP5Urkle1I+Wh/pmHwiaAbu2ZQ2pxKHzbs
	 JibEwJgmQZNkg7GoI/qnfpeLl5QIVDxmAqm9HLE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1340/1376] pinctrl: mediatek: eint: Drop base from mtk_eint_chip_write_mask()
Date: Sat, 12 Sep 2026 09:02:46 +0200
Message-ID: <20260912065637.395800428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6787596167b92..85a4f2d3701f5 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -243,7 +243,7 @@ static int mtk_eint_irq_set_wake(struct irq_data *d, unsigned int on)
 }
 
 static void mtk_eint_chip_write_mask(const struct mtk_eint *eint,
-				     void __iomem *base, unsigned int **buf)
+				     unsigned int **buf)
 {
 	int inst, port, port_num;
 	void __iomem *reg;
@@ -422,7 +422,7 @@ static void mtk_eint_irq_handler(struct irq_desc *desc)
 
 int mtk_eint_do_suspend(struct mtk_eint *eint)
 {
-	mtk_eint_chip_write_mask(eint, eint->base, eint->wake_mask);
+	mtk_eint_chip_write_mask(eint, eint->wake_mask);
 
 	return 0;
 }
@@ -430,7 +430,7 @@ EXPORT_SYMBOL_GPL(mtk_eint_do_suspend);
 
 int mtk_eint_do_resume(struct mtk_eint *eint)
 {
-	mtk_eint_chip_write_mask(eint, eint->base, eint->cur_mask);
+	mtk_eint_chip_write_mask(eint, eint->cur_mask);
 
 	return 0;
 }
-- 
2.53.0



