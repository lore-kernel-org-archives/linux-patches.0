Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061752;
	b=CN4sRwdZhvpDETRW7axVB+MfKnisaq3h9OB5tclThJXmSy/3rQKnrgH8F3S+GXcCWrBb
	 rKiCB5ZYIjhfipWChoJ2m/1qRuF+cXqeRCBAb1KIxnBsa6FGTTCEpV8Xqg1QYdH4eJjK6
	 xnnWV51Kx0arbB/LeAXQMmzSmxcLXaC/Qfq5WY9S3bATl5fkTQqAUOFgTR4JElLN6Xrjq
	 hnFMbOMIaJlwOAf/nr8202HnWsMCMeVTqHJ1YfHS85MP3+iiCSkRjD2jYCFjO3jiqYoHV
	 5UZBltx3scOIZNAlyVxUsL64VM2EZ5ACmCm5oLoiGgFKI6Kpt1NButf+jEts29f3pPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8S+g1Aw7R7ECUx+4DveYW+VzsxMQJi88D3yr/JUMv8Q=;
	b=4S0MES5q8AVFmJ01pIZn/FhSqrW/1MJZimHCIL0vJXceiWXoOGvKDoMhJfZzaptpJo/+
	 aXczSbn/rKTVpcVhfCZ+pC1DPW7PJYbt9rg73pew3VfRWvQmXCZKzJ37DJ+QBmFD69vH5
	 MqnuCOAymsoP6tdGD+KNfnxEUOEr0Ak19izKvECGHfJoNnLfOtQZwLjx2Zyl04TquaDVJ
	 foFnETfUN5Ya6YWwwBW/V8MyHV25ER4r0K0rFZLc/jpgdSj3aMfjbwy5dTUElrKDieaA3
	 AbQV3sqIpJNhpqtGXAMuBfnFYEQLMAXnwlQp7xQKFwT9vG257EAeVo88BbjvvjkaNig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1Ge/8Z6W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B950B606A32C;
	Thu, 19 Nov 2026 04:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Ge/8Z6W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2B01F000C4;
	Thu, 19 Nov 2026 04:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061752;
	bh=8S+g1Aw7R7ECUx+4DveYW+VzsxMQJi88D3yr/JUMv8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Ge/8Z6Wi5+6JhxnLTyR0dCox3ZXbMjQZWFPmFr4MrgdBwfr75opSxfuBRaWVbM/f
	 bIP246gxlNdrIIbIiZqugRjjsqZch0U/pqfqX2Kr+2ITUFU8iRUUJmBuRS93SXrQi5
	 B0/2AmKUyW+bkx7tiDlLY+kANlmo2qnugHOuWtCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1665/1848] irqchip/gic-v3-its: Use irq_domain_create_hierarchy()
Date: Wed, 18 Nov 2026 16:01:43 +0100
Message-ID: <20261118150029.553902096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 66cc9786244da..620a446d4e435 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4917,18 +4917,19 @@ static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
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



