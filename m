Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71FB1C57B1;
	Tue, 27 Aug 2024 14:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770372; cv=none; b=uxnjQ9INfYeK9jIRPcPtKWgeItGy50sPHdwvF+JvBfIpzpVF20Zl57wjr3o6P1HJ7k3+nKhXFq5oGYzyN4bFJK3luITzKSRQHfnrERzine5cYFXlkN2KXH2AirEVlBFLIsnwWV0ydet51hXqhszPUSQSNGqWsnvj6NKZDTY5FHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770372; c=relaxed/simple;
	bh=7Ys5frjz+GWz1YoPu4AS+8wAUUxAWIPY39k7ZasB3II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnwOaQQW20z/cf6fXo8BuAjiBrhuPT2/Pml9H013KWiTe/Z+nWr3iYuPwOhdL0bFNC2Jf0voTv1aI0l2ulVY79t6d4eb+rNNTcDSDt8gd443UMwzCzODY/C40Q0wE7apzjy5vRFVGIvPGUPuRNNrZueC48I3AFfD7DCmyWzONd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wwd1/ZEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wwd1/ZEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFA1C61042;
	Tue, 27 Aug 2024 14:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770372;
	bh=7Ys5frjz+GWz1YoPu4AS+8wAUUxAWIPY39k7ZasB3II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wwd1/ZEvOF6i+68//OtVeG4l6cy/TAfWn1tnJCCRQYK9RDFQ3/gZdeF00wYtO9pvs
	 XXlfXEkO0eRPUxsj3E0gelWlAmoP8Kqu+PYAGXs3gucqRGWzOQAViY4gRhD7IiRdBi
	 Hv2dTVjqkdh3BoA5ToXwgdfNU0HGoXsBwHQeMrs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanrui Huang <guanrui.huang@linux.alibaba.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/341] irqchip/gic-v3-its: Remove BUG_ON in its_vpe_irq_domain_alloc
Date: Tue, 27 Aug 2024 16:37:20 +0200
Message-ID: <20240827143851.365927061@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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



