Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829292;
	b=syL4+MTMk0YhKkIu8P/2xR/rEEGZIxy1rEVofoUR35t6NWFliv/tO4g68+cHT6ei14Cb
	 jyPl1Y7EmDG0kXbaIkqzNIRzMWoS0zs/LCKBxirYmO/TeqG+AZ1Yo8LP/2njvTLZczaMx
	 HnOcAfuXBc7NHQEYUcchEOI6DGszkDVcwJenAZE6ebbvJbTa1vQ5kZUVuhZBZXYC2B6yZ
	 6rS9fpnTpBwqBHb7H5AvaUdYZ5D5RZfPnzKhaMKXpsJ+l+lp9dVEXRQ6uVKu272k7xUur
	 ZCaO1qPGTcZ22DKgFvGATT89fd6ROpmZfBqX4hFP/BhUNfjXhfehIShN2TAxncF6pmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gzG+m0ML+xSp0NBxQBW9ahDPd3cstH0Dtwy7Pl7OYuk=;
	b=Qdzdu7D4WfWhNF+p5MRcHsBTkU8ngKwYSU6JcsCQsJCzfO8qsKSBplOpPF9Pm0svtY0c
	 TU1rKYpfmIWatabZxiZgDA7tDvZKCaLGkDfAtY9m/mroaR/ecQUm9i5lVfG5XLAVZX1nr
	 h4pfgVijVWjgSwSTX8yUyCuRduKq6v3lcVh3ZbyXl+c+yRBuRBMCeTokuhte31ZZPEb8f
	 G7pv1v9kZinjCk0M9X7Md248x6D+ZNE2Jh31gzuZYZG9EhVtLqfbIcj+gVyiV51xuszE+
	 fPfLevQ+UzcZz4SBQ0qnE1xw8phXvmRNQBuJz+q4q9IP2ghwOGY0KHuCJWm4RLk+j9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xjbYgc+K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FCC607353D;
	Wed,  4 Nov 2026 21:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xjbYgc+K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8573D1F00919;
	Wed,  4 Nov 2026 21:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829291;
	bh=gzG+m0ML+xSp0NBxQBW9ahDPd3cstH0Dtwy7Pl7OYuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xjbYgc+K1K8F+0Uvbx0MZquDn3d+/3iM4me3+8YWX4YJgZTawebiE/7wvsc6RhHLx
	 TFTW7aunpnaoZvJS4872dF4Ey2fvuCLE8Xz7amaGiEk3txkNi3Kh26FlfFIE91x8PA
	 bp4hK+3S9++bnzWWPSZFPDbkpz7TTgIqZao3WGpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0033/1005] irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path
Date: Wed,  4 Nov 2026 15:56:06 -0500
Message-ID: <20261104211044.488375158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 13856e22217fbf7c1200633716ff87ccb50fd89a ]

When irq_domain_trim_hierarchy() fails in irq_domain_alloc_irqs_locked(),
the error handling path fails to undo the hierarchy allocations.

Add the missing cleanup.

[ tglx: Massage change log ]

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260623075134.4432-2-shikemeng@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/irq/irqdomain.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index dc473faadcc81..cca2f01115aa0 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1621,7 +1621,7 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
 		if (ret)
-			goto out_free_irq_data;
+			goto out_free_irqs;
 	}
 
 	for (i = 0; i < nr_irqs; i++)
@@ -1629,6 +1629,8 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 
 	return virq;
 
+out_free_irqs:
+	irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs);
 out_free_irq_data:
 	irq_domain_free_irq_data(virq, nr_irqs);
 out_free_desc:
-- 
2.53.0



