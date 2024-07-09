Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C166927713;
	Tue,  9 Jul 2024 11:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524562; cv=none; b=bLCsSTD2M8j7SKNkpVxqb6IzYp8W+sv/j+w5+XPwN6mmbsfTrvvljjlTNLjgfoKSe4x35GsK3G6oHdrHFP+yTu3atPaiXbcN06dmEkvxIZ9cMVIENZn2tBZ5vk1yVTo4jK7+PQuUa0an4DwTnZBqTixFTH6NxF2FxveVbnvArl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524562; c=relaxed/simple;
	bh=8yTBYYWe2AFnggXhYSjjkZB9j1RYlTz/C06v2fC6AIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol4cvpVKQSlvYaJTX0Ep90aLfBwKBEEUzyBd6Ct0DWnj6pV5cFTrY2r3wfGXqrKDxuBszj9mSWu7oeF4FY3UGo7+G17J4HIGXNC+uoNAzwbqo1HatJcXQs94oB5UnL5tHlJ2LpcDPIcGYUZswNMNDxz/TA7LpOfqKKm1cD8FT9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLbOE5/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLbOE5/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B2FC32786;
	Tue,  9 Jul 2024 11:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524562;
	bh=8yTBYYWe2AFnggXhYSjjkZB9j1RYlTz/C06v2fC6AIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLbOE5/vhumeVRwqjoJx9ldrLGbDqQcLhuQOWSceaWPr2Ysy7FJof+bdYLIYtIGjE
	 aY3g83mzy6Ml3PFqytKp5XVLyE2wPbT+ZONJLeyk2LyXeM9A6enHG9G5pWCOQhWhH8
	 5Z0RKcIiFPf5aZCuCLUdDgepgfiV044B4eApFR7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/102] irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc
Date: Tue,  9 Jul 2024 13:09:32 +0200
Message-ID: <20240709110651.723892970@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Guanrui Huang <guanrui.huang@linux.alibaba.com>

[ Upstream commit 382d2ffe86efb1e2fa803d2cf17e5bfc34e574f3 ]

This BUG_ON() is useless, because the same effect will be obtained
by letting the code run its course and vm being dereferenced,
triggering an exception.

So just remove this check.

Signed-off-by: Guanrui Huang <guanrui.huang@linux.alibaba.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20240418061053.96803-3-guanrui.huang@linux.alibaba.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 3620bdb5200f2..a7a952bbfdc28 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4476,8 +4476,6 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	struct page *vprop_page;
 	int base, nr_ids, i, err = 0;
 
-	BUG_ON(!vm);
-
 	bitmap = its_lpi_alloc(roundup_pow_of_two(nr_irqs), &base, &nr_ids);
 	if (!bitmap)
 		return -ENOMEM;
-- 
2.43.0



