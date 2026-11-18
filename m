Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033580;
	b=SMv5Lb2Y3jsVJUZG+tQKOxa1Loafh2SZF1kR1VTLIqe3m0/XpX0ZErCxyToVQtdeUklG
	 ZVO9ZqLjTpbyok9kbIFHoG/1T0BvSHZcm69/RP2/E/pMkGteN9x6nUG7PysqkS+BAe0u+
	 dXaYS91LgkuwILwzaMCEfeRM/kWqO37tnjiLLcV04EH1PQMRwCSLfu0TnOnbgEWh4Y3eH
	 22GTXj4i6UGF6hfk89O3+PDbI7HJ6p/veIydTc41U6yRLvNTsrlmY1U/qUBuRvxUrbmSX
	 nW06+QI56sfmTOphw7PlAHHTzei9V0yle0PJ9WP/ReeRXHCZsM0tPXQBAZW2rGab1LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h2zSTV/0O1GKnro4yPjNtngnAdtp95Bsn8SqitWFiHk=;
	b=ajybqnLu5ROrRmBvRP6/4xR90enlEv9q7Pwh8j7Hz/U+piPyYhLHRqAT63rCnC6E//of
	 YLUszHu+soCjSMs0brHtDfKQWVUPKONEnbbH6b11IccNsJTvRg/y4IFoMMFUGqx3qB9xv
	 EEcaE/tLCtaCkuJzpVJLI0czcv4ryn5ZjejgDZJFBbSeDj3pIgSMjtWOfO0BbI1oDayAj
	 GmTC8QHqjwFpMC03vNzFjFHp6FFHxOt7KRgOm127PobjRxOPPSHYcR1+TwXnXBQUL0PsH
	 Pxe4E/2NnOKNSgspFUotRUg8O+BXqdIc/vcyUL/Jfx32o1ymtk3KWFzh2JNu67H0gSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ygOl/4o5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE62606A325;
	Wed, 18 Nov 2026 20:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ygOl/4o5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425A91F000C6;
	Wed, 18 Nov 2026 20:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033580;
	bh=h2zSTV/0O1GKnro4yPjNtngnAdtp95Bsn8SqitWFiHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ygOl/4o5dMMi9lKckmYVEwX82YQebxwKa845oq/vp8JQfHIlXYiXEVIa0cbxsY9mB
	 4sWQDWW7tca1BkTZLMLnlMrAzCcyb236oJ/LchB+tkPSti2h5DrssUblIhIyfDiZDL
	 /M2fXRcZBhIZ1BsOxxLckGxlH3CSzMCg1RkAMBTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0028/3318] irqdomain: Plug leak in irq_domain_alloc_irqs_locked() error path
Date: Wed, 18 Nov 2026 15:10:50 +0100
Message-ID: <20261118150314.622923316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 11af2877e7523..efe08ef8371d2 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -1558,7 +1558,7 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 	for (i = 0; i < nr_irqs; i++) {
 		ret = irq_domain_trim_hierarchy(virq + i);
 		if (ret)
-			goto out_free_irq_data;
+			goto out_free_irqs;
 	}
 
 	for (i = 0; i < nr_irqs; i++)
@@ -1566,6 +1566,8 @@ static int irq_domain_alloc_irqs_locked(struct irq_domain *domain, int irq_base,
 
 	return virq;
 
+out_free_irqs:
+	irq_domain_free_irqs_hierarchy(domain, virq, nr_irqs);
 out_free_irq_data:
 	irq_domain_free_irq_data(virq, nr_irqs);
 out_free_desc:
-- 
2.53.0



