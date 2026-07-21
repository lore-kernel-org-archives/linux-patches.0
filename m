Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280AE46AA89;
	Tue, 21 Jul 2026 15:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649107; cv=none; b=Ru416gKp02UMCrFQqCBLj0/LNK20YclLlbXmLvEumMnwL7PNiFox+lobW+iS9FKWBXCnQXP+Z22mOJekwruInnaPU05sn2iBAqlz6mwiySW4MrNwXExqvP4gBJiWHtprHUduJbdeGTd2EC7uVLiVFTd1NIISvU7QKdXRbSQPcSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649107; c=relaxed/simple;
	bh=3QBq5Mu3+lMkoBCd9M8c8dDVO8lDhP4QneP7M2IVfhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oo4BZG++apvkLcjLrCUQdw0THH8hEnoMIeDjnsCtqs7OkHJXl66p9PnBRvb59Bxr6hA/xl4QVsKQrZBr8rB+OgeXOKD/WmkIw1HIDCyWunlfl6iUouVzs4btq3M5agO60nrneNXAwrGA3pkxOcxYwnGM0k8cNJSKiO+FnT6Hf2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdGzpjJN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdGzpjJN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CB61F00A3D;
	Tue, 21 Jul 2026 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649105;
	bh=T7f1zNhSXd/zl04oMjsaG8tbIrFzJuN1ml9RlfpMfX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdGzpjJNUJZSdSL6M29uo/46lmFzQWjVPJoCpXOk7FEQYWPsz8NoxaR7YndhrGAQM
	 2QtuxwE7AuWLNdPZomE5C2OSjxcPYBHeAnrWIBcn2XshKQ9lwRfE2WfkPaZ5xKfK/n
	 GMBaLFAI95qCikSLipqNnwvZ8ePnX+pXS25LvDBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0450/2077] irqchip/exynos-combiner: Remove useless spinlock
Date: Tue, 21 Jul 2026 17:02:03 +0200
Message-ID: <20260721152603.393973262@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 6fe450074626eaab3def4b3e8c1819d46d2d682c ]

irq_controller_lock doesn't protect anything, it is a leftover from early
development or copy/paste. Remove it completely.

Fixes: 96031b31a4b3 ("irqchip/exynos-combiner: Switch to raw_spinlock")
Suggested-by: Thomas Gleixner <tglx@kernel.org>
Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/all/20260521090453.bbUZ00tS@linutronix.de
Link: https://patch.msgid.link/20260522061012.2687122-1-m.szyprowski@samsung.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/exynos-combiner.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/irqchip/exynos-combiner.c b/drivers/irqchip/exynos-combiner.c
index 03cafcc5c8355d..d9d408cb4711e8 100644
--- a/drivers/irqchip/exynos-combiner.c
+++ b/drivers/irqchip/exynos-combiner.c
@@ -24,8 +24,6 @@
 
 #define IRQ_IN_COMBINER		8
 
-static DEFINE_RAW_SPINLOCK(irq_controller_lock);
-
 struct combiner_chip_data {
 	unsigned int hwirq_offset;
 	unsigned int irq_mask;
@@ -72,9 +70,7 @@ static void combiner_handle_cascade_irq(struct irq_desc *desc)
 
 	chained_irq_enter(chip, desc);
 
-	raw_spin_lock(&irq_controller_lock);
 	status = readl_relaxed(chip_data->base + COMBINER_INT_STATUS);
-	raw_spin_unlock(&irq_controller_lock);
 	status &= chip_data->irq_mask;
 
 	if (status == 0)
-- 
2.53.0



