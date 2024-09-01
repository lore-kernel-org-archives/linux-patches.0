Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A32C6AF;
	Sun,  1 Sep 2024 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210243; cv=none; b=IrBKvo9aKh8d/FW6YTd9sf1cVJlDnQTqCTB1ZbNyRKqziH9+fEbQb3Tz9DNmodEbDc+RlsKLckhsdHwj7LZqWg5PslUgGJ1XGbaTcWmPs+t7ZvVLBohdDfT9x5/NtQn+WmdziPC8jX/OGlguNm7/n5WQnUcl9J0d4RcmwWzQtIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210243; c=relaxed/simple;
	bh=oiOHvVKFcw0yO/IuIY4KEij8pNnRQ/mYJkw6bf3md3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlWKe01MC7ETKXGVw6mJhOQVpmnn6AH9prk7GjGTiYV5oxyYuig+JG5jjXDQ4BPQP7IXCcmXGUEZ9OC9LGr5KzhJdzFmBxhPn1bQcvUJDSg9HOClAwqzktsR2uX2w7du8gxEXD10chEhVnnCKK+/UdU1ZrmlyKYVS+j9P/OmKg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZfyqCHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZfyqCHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBDB7C4CEC3;
	Sun,  1 Sep 2024 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210243;
	bh=oiOHvVKFcw0yO/IuIY4KEij8pNnRQ/mYJkw6bf3md3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZfyqCHXkiaLY4BKIxKsv/V+fwkyGHCS5sBGu49dg98pCQ0sF2HRJZe9YCj9OtcwX
	 i/gatmI+syequizdx0xoHQXBZtUjvL9FGkL40clnYiyc3CfASgucxtGFjarVx9Lgsr
	 de6Wbhllgv+Fjt+yGaNSbl6CWxVDlq9+FgSRVPR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/215] irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc
Date: Sun,  1 Sep 2024 18:16:56 +0200
Message-ID: <20240901160827.278814989@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fa89e590c1333..3fa6c71843261 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4491,8 +4491,6 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	struct page *vprop_page;
 	int base, nr_ids, i, err = 0;
 
-	BUG_ON(!vm);
-
 	bitmap = its_lpi_alloc(roundup_pow_of_two(nr_irqs), &base, &nr_ids);
 	if (!bitmap)
 		return -ENOMEM;
-- 
2.43.0



