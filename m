Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A02E369D71;
	Tue, 21 Jul 2026 17:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655666; cv=none; b=bz9rGtJu3FXl3u9l38UfwJqTvYVhwSa2C+SXgD0BRzkAnRTMogaKs5bWC5b7xeUQWhpHNshM3fjCUY36N6j7XDz2aO08bGQnrxmD/c/7ZTO9NcVSppXxXuc66Vcei2Sgzb89iQ6cxsIw0ZLbdAgpWSdAXlLWa9VIsA3Bdruum5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655666; c=relaxed/simple;
	bh=uquAGmklSyGZx/8PFtRl3GFZsaUp9/DNh/JYerrN9EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9h3v89laYlp65X92m0VjUr8qkkXg+eoM1UUJmjc0lzlpvWFfFQl8B7O2+ADs6NBOotvEgvvzKpUTYn7zbxNBKtcFqIkm9ljULjThw8hvqkc7Q2k3jF94Sjz4euHYXSjiVswX3LA5z3uZbVoNoBsUoc8zA/4X+UBqR5PBYPohaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzOi+fRh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzOi+fRh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EDE1F000E9;
	Tue, 21 Jul 2026 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655665;
	bh=f26d0ns/tdTY6NeY0Elpna+DD37k0bsG/K/W375RJEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzOi+fRhIeYpcGpEkXF7xyq3N2vmcq3FhcfFxXCB4oSHc/YKs32aTusWBytp5gl3l
	 UrXgnE2PfeeRMA/5A397PwKhkjJmh+/eEJRj/VNUXHx7WqNVdGVb4eKcjFyON8aEYO
	 ZbA3kKa0iLzQV0m7MiE8TsmDqXDEg1nai27NaaoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Chang <ot_chhao.chang@mediatek.com>,
	Qingliang Li <qingliang.li@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0093/1611] pinctrl: mediatek: eint: Drop base from mtk_eint_chip_write_mask()
Date: Tue, 21 Jul 2026 17:03:29 +0200
Message-ID: <20260721152516.937206417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2ea0902b4f6605..5f12af59a91b51 100644
--- a/drivers/pinctrl/mediatek/mtk-eint.c
+++ b/drivers/pinctrl/mediatek/mtk-eint.c
@@ -241,7 +241,7 @@ static int mtk_eint_irq_set_wake(struct irq_data *d, unsigned int on)
 }
 
 static void mtk_eint_chip_write_mask(const struct mtk_eint *eint,
-				     void __iomem *base, unsigned int **buf)
+				     unsigned int **buf)
 {
 	int inst, port, port_num;
 	void __iomem *reg;
@@ -420,7 +420,7 @@ static void mtk_eint_irq_handler(struct irq_desc *desc)
 
 int mtk_eint_do_suspend(struct mtk_eint *eint)
 {
-	mtk_eint_chip_write_mask(eint, eint->base, eint->wake_mask);
+	mtk_eint_chip_write_mask(eint, eint->wake_mask);
 
 	return 0;
 }
@@ -428,7 +428,7 @@ EXPORT_SYMBOL_GPL(mtk_eint_do_suspend);
 
 int mtk_eint_do_resume(struct mtk_eint *eint)
 {
-	mtk_eint_chip_write_mask(eint, eint->base, eint->cur_mask);
+	mtk_eint_chip_write_mask(eint, eint->cur_mask);
 
 	return 0;
 }
-- 
2.53.0



