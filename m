Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875DC17DFFC;
	Sun,  1 Sep 2024 16:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208886; cv=none; b=Ho4U8N5zp5K7Y6iwCZR866ww83A0y6JVilPBRyuACf/rXfLsLWkQWnqdpwP/Z+Gc5PuGwdw3z2M50d88UM2VpAKeJdQsmfsJLA2ZhbdiV94tX8xAYZ3BmWH+84pzxTau6wssmh4Gjumtw1F4Z7Fv8E5c7PfYd9OLWhiTo0Ruug4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208886; c=relaxed/simple;
	bh=AsCzjra0bk2MpsIyrUu+IeY6yUeKyFSH80nuVeCH+N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuJ79d/5yX4ZmyWhzOkRsCcvQyW/Y5PzpRaOrQW/dI3FHXAFUIBZkJFyqxuag7AqBOob67Vs/lh2HbIa08OQESdqTzJn/Zj/3ppuvn5tYWjwENRz6Hsm/iA56i3ItJSCWQ06c1oeiTj44xGLPs2AJW0qkHINHagIvlQkiYTdV3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNtNw0QZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNtNw0QZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9D4C4CEC3;
	Sun,  1 Sep 2024 16:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208886;
	bh=AsCzjra0bk2MpsIyrUu+IeY6yUeKyFSH80nuVeCH+N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNtNw0QZ+PGiwvD+IaAjeflfIXbpfeX2Oo85GfTbrVZVn8qOeUs5mkpWoedhNvK3k
	 lFwpb0ZWOUWtuH1iL7B+Qz71MoFet0mFfn1JFm0VMGYNecn75EOVmB7HJcf0cif1ik
	 ZX4x2DtCfnyo6OxbrbGOuZtsTfhFAq+l1fZqAciw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 070/134] irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc
Date: Sun,  1 Sep 2024 18:16:56 +0200
Message-ID: <20240901160812.736512505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d16776c6dee7b..ae3378ef469b0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3085,8 +3085,6 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	struct page *vprop_page;
 	int base, nr_ids, i, err = 0;
 
-	BUG_ON(!vm);
-
 	bitmap = its_lpi_alloc(roundup_pow_of_two(nr_irqs), &base, &nr_ids);
 	if (!bitmap)
 		return -ENOMEM;
-- 
2.43.0



