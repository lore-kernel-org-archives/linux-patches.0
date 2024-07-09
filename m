Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B09156F45;
	Tue,  9 Jul 2024 11:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523485; cv=none; b=QVnd1mKn37ZYj+gfoyL1HObplti6f0m08p1snyv5j21s+OQSyJFZuaTj6TbGDFP5m9SiVyevhI0p6xhkNtL6VsqXbmPF/PB2Fr2VJq0ycfhpoca0+jeX2jn0O0eO8I8dkqRkydnwbGummMW6OLro2gyWlmcTwVDbot0quPX36Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523485; c=relaxed/simple;
	bh=7Ys5frjz+GWz1YoPu4AS+8wAUUxAWIPY39k7ZasB3II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3hqQeMCTilomuvQ2hvf+1Pg4zxf4gZ+Gv3j+6PnUfokkNSyOYpek3XyqpaFbP48P93MHqjArtgVxzVOFEjMPp67sWh0Amspy5SUrV5U3gVpKk7fXVm+8nKZiqoCgvj9ArcARBNICZs/0z3tD152Ya4c02JeWRMNtGI1kFVKgf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YO+XDBqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YO+XDBqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20B1C3277B;
	Tue,  9 Jul 2024 11:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523485;
	bh=7Ys5frjz+GWz1YoPu4AS+8wAUUxAWIPY39k7ZasB3II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YO+XDBqhHkuVH9tN8oOHRiKnpmpZrd+j0plxBe75PXo+ZxO3Uh1LN3jnUCZi9kaJj
	 PGNzwKC1zxWB/ufMDQ5hHCqC2hPVbvjO+nKRv1ufIWW2fdIE9nVOUbQzXHdn4QorPJ
	 c5AYaF/r47J4MyblN7YNxHan/WhzDQ690nUzW5mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 010/139] irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc
Date: Tue,  9 Jul 2024 13:08:30 +0200
Message-ID: <20240709110658.550649595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c7d6e6987166f..350abbb36e04b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4501,8 +4501,6 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	struct page *vprop_page;
 	int base, nr_ids, i, err = 0;
 
-	BUG_ON(!vm);
-
 	bitmap = its_lpi_alloc(roundup_pow_of_two(nr_irqs), &base, &nr_ids);
 	if (!bitmap)
 		return -ENOMEM;
-- 
2.43.0



