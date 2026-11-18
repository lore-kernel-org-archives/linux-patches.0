Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049905;
	b=TRmoVYBuLk22dZKxlfn8sMovOIfIJOa4Q+uCBF6qogKjp5tZZ5z4OeG+vGT3FlpU4AdT
	 /4ifR1bHb6TDA/EseBPdjwUugvjh57Vzt81WBzV+2YODXpHn7QGVqHgdJZLTXwpu6QyPe
	 kO3M+Ibb1NEsGRCJ13N4Myv3yEmp8oHknSD/6H28ov6Mc1Hnx4mDWRFHBglQnSo3IMA+9
	 tKzTb/GNiYRAvjpDXx+s0ZfpYxbqwfgF8GWKW3nS3IR/iMy98PV3RUZtXDPop1bP2ggOH
	 1AfuGnhTkT8vbbGlQdPmPcJS/3off2tKHDp/lOCbm/+eyoOMA4kNjepI7WE5ywJCElQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3zIdIxjmqqxWF17vHmF834PZ54f2RptRh1Ky5Mgfe8=;
	b=o01ZtAi3URvCt7imLXZMinKClyN2WJyDy9FJiEHpoo14+JBybteND+W39IQYNf7PU4bn
	 37O+t1e4nYBHSWvXZsyh/WQsd0VZ/XYUtJofiwNgHhpUM1S1UaDB1jqOf5d3IQ4mwLrgC
	 e3KGmAqjj16XbgO2kEMHyQ0+T59AmedNRzm5iBrdxftlugQSZWLuP5vYVRM9SnzD7SFhq
	 IVaMDCeE8vaEsIKKXR6CNVkpxvdKcUHXp0kkjV9fgv8vfRx0o9B4evUTGrUV1YPrWAoKu
	 Z090RdhyohG9hwYWpcjb79SILTD2cKopQ+kkFs84mnSAat8aO4geF57FH/IfRlJbtOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMwR6WzB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0883606A32A;
	Thu, 19 Nov 2026 00:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bMwR6WzB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA721F000C4;
	Thu, 19 Nov 2026 00:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049904;
	bh=Q3zIdIxjmqqxWF17vHmF834PZ54f2RptRh1Ky5Mgfe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMwR6WzB+6TY5d+BJqs2/8ngjCN5RncJICCaaB9u6CmaQSaegu3rC8Oyt+nijAnDc
	 TuxbAnp4udSQ38AgwbzoozYtIwwW7Ka98gWdGYK0KhCT82Qad672Lv3+/i3COIQ+Xg
	 h8LrU0+/pB5TAvjIM2LReFON5LOsK9qKkhYIXXH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2518/2857] irqchip/gic-v3-its: Use irq_domain_create_hierarchy()
Date: Wed, 18 Nov 2026 15:59:12 +0100
Message-ID: <20261118150332.207439651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 1e46e040decede1723a5b11f0689942134c29d9a ]

Use the irq_domain_create_hierarchy() helper to create the hierarchical
domain, which both serves as documentation and avoids poking at
irqdomain internals.

Note that the domain host_data was first set to the struct its_node
during allocation only to immediately be overwritten with the struct
msi_domain_info.

Tested-by: Hsin-Yi Wang <hsinyi@chromium.org>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20230213104302.17307-17-johan+linaro@kernel.org
Stable-dep-of: 32e056cc1d15 ("irqchip/gic-v3-its: Don't free a vPE table shared with another ITS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 63ae7ab1ab975..3131c44fd8fd3 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4928,18 +4928,19 @@ static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
 	if (!info)
 		return -ENOMEM;
 
-	inner_domain = irq_domain_create_tree(handle, &its_domain_ops, its);
+	info->ops = &its_msi_domain_ops;
+	info->data = its;
+
+	inner_domain = irq_domain_create_hierarchy(its_parent,
+						   its->msi_domain_flags, 0,
+						   handle, &its_domain_ops,
+						   info);
 	if (!inner_domain) {
 		kfree(info);
 		return -ENOMEM;
 	}
 
-	inner_domain->parent = its_parent;
 	irq_domain_update_bus_token(inner_domain, DOMAIN_BUS_NEXUS);
-	inner_domain->flags |= its->msi_domain_flags;
-	info->ops = &its_msi_domain_ops;
-	info->data = its;
-	inner_domain->host_data = info;
 
 	return 0;
 }
-- 
2.53.0



