Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EBB81DFD1;
	Sun,  1 Sep 2024 16:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209570; cv=none; b=do7qczVB7itCPsxSZXbrKn4e1FDAp275G5PxovRW0SlNmnEKm92Dcpu2efzUR/Gwzy9UFTTqt0F0OJZvpDd7lEF1NIOiUExXr8GsBwsP+alMBixnAu/bGl9o1BbJ0JzmDApDBj8WN5Ew6fhBOzrZ8gTMCuNs4lZWROnwfgA9DPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209570; c=relaxed/simple;
	bh=uLjc/vPmjUCGAw+f62FNFo8A/TTv1Xd7GWQaJQahDN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRWylJpKQd2O2N+sCoaDVQ+EHxFmVOeRACnFmWtVSk2wYrYn7mfSL4j/07Jo8rMqxiky8o+1wbExnbVmZPV+Eoeq5QPeD3iBT//st9lOTyx6Nz053xGx5rk8sfc8/Zaru7XFq7+cTBeq9MwU2UnmyF1Xj9mvXCAFCeKrs7aAVPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u9W71Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u9W71Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B8AC4CEC3;
	Sun,  1 Sep 2024 16:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209569;
	bh=uLjc/vPmjUCGAw+f62FNFo8A/TTv1Xd7GWQaJQahDN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u9W71HnmL4+CWfwclSVYKpE62XL1v1unuPisETb2bUedQe0/ybig2N4Jznrrxgns
	 itrlqYeCUStvBk8PkUZyv3b231dKKS9AE+Eh2XkO91HPp54aFgdtwv3NXQT1/jYJlj
	 oA0gvHbUPLw/nlUWFYHDxgRdYW31SY/yQz/fD0nE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/151] irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc
Date: Sun,  1 Sep 2024 18:17:18 +0200
Message-ID: <20240901160817.054666138@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4e486cccc4cc6..a9469751720cc 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4469,8 +4469,6 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 	struct page *vprop_page;
 	int base, nr_ids, i, err = 0;
 
-	BUG_ON(!vm);
-
 	bitmap = its_lpi_alloc(roundup_pow_of_two(nr_irqs), &base, &nr_ids);
 	if (!bitmap)
 		return -ENOMEM;
-- 
2.43.0



