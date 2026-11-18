Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056458;
	b=BCHU1FMA11at3mfiLSDeicXGHSOZSUQ+oiUE+9a3iQHocHb3y80TfUaaVu4zXpb/QlNW
	 jHauPPyrBWSberHjPQSqHF/QoW1/wQBgC4UC9I6/BBs5oJbELc7bUX0JN6TBMZVVrUFbf
	 U6zYOfQN5rs/PP2+suiTlq0sv77AFoe6KZE+OgB0AvfZexs8c0HRAwniEdILhxf7GUQJN
	 cB/fHUZ15aECZV9/rHQl25SP5R0f9yZ0T1riZ/VLFE5BtrerixsJ/OtOCeTE+vhOOlHOu
	 aQKaZ3qznwBRmJBKvWjQtkopCLJ2AuJGmhXk6rhgoys86JWvMVieQvwlP0Z5Lmt0duQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W/iwFxvmy+4+Sc1r8dhSGnKUTvITHKDD4LSGwwtfE/Y=;
	b=numh72WhEtoPmjZPAJbZEK5v6SLX8G+GX4TORxYBJxgWEiLc1WUwcfu9lrmB6olqR3QC
	 uc2CJF2RRP/ZvF3PS+AsovqRxGV3VDzj8lfd9VOB2COMqxEOgd4jPDYEs3ewwXkjoTg/J
	 XoMteBr/i0ZvFqVzG8sHGuzhb2uQ8FQpUK2851Ixc6WMbShMBQABMJvkjhUmVqFdGqhKk
	 jm+ovm9CLf/IazUHkSPbf09PrBh3u7K4r81XXpIsH2hH0dpPBOE1qCPW6XiTp2bBzrHxm
	 8ElidGpNj074ewM4Fzgd3iRbEEoxlV5XK9B64Nf44NVBY6o5Ej4OOMNZsZyy4yKoxeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RwaODriY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C44606A325;
	Thu, 19 Nov 2026 02:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RwaODriY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E37B1F000C4;
	Thu, 19 Nov 2026 02:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056457;
	bh=W/iwFxvmy+4+Sc1r8dhSGnKUTvITHKDD4LSGwwtfE/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwaODriYPqW9uKLhTgVdNqLQWkIHaFGqFwPcB3FLH9e2DPgOdrfx26Lpvpc7XFjFL
	 IZE8Jh6mMKMWzoxN4rWUDgUI9n/viCkSKqBS/ySLm/7eyxqqkV3zU/CaaZp7N91+IR
	 Kr+WvUAiLndA33ZJ1bnZuHrbjLfPprL+fpmjiUnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Yi Wang <hsinyi@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1954/2214] irqchip/gic-v3-its: Use irq_domain_create_hierarchy()
Date: Wed, 18 Nov 2026 16:00:30 +0100
Message-ID: <20261118150129.137650810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7178465188f34..defc92a65efbc 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -4946,18 +4946,19 @@ static int its_init_domain(struct fwnode_handle *handle, struct its_node *its)
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



