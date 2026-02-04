Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A2E285404;
	Wed,  4 Feb 2026 15:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217326; cv=none; b=pP4Lp3/Sk0yq4oIZ70kB5ZOte0A0d63BLlDVFQ3KTS9bOVW+BVc4e8nOtPqLg9Wr4mjQ9Buv3UAf0m2jSoBpH2KxrxetPZmpzhlOIm6Po/GrNmO6LrovJCSvmJf5lUHc/myCnzH2C8VcukVETMyakwv6aghVem7YiOAHJN/96aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217326; c=relaxed/simple;
	bh=P2BELcVbfinIBkMoEun56XN8FehbiMZ2mTp9yRwjOUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XEhwRYlzItwZwxY0pb6CBguGza6wqVxZku4F3sAnosTuM4HpC7nlY7qNhaXuhPQbGMT6//RV42sP0xdaT0yTD8hauZgCEKhxbtcH9T7cqztsBy71r1xldFaR0QKa7r5sNvXqpFWZ5ykGn/3iCAKm1QM59wiP9ZsliYEXxUzPS/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDA3/L7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDA3/L7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B0DC4CEF7;
	Wed,  4 Feb 2026 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217326;
	bh=P2BELcVbfinIBkMoEun56XN8FehbiMZ2mTp9yRwjOUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDA3/L7TmYlxI8ThXbfIXatX+Kn+yMKrByqWylkj6WPDBbu5xQIBrBfQFWLF5zE4Q
	 1IOECgEbBXmm6MKeOz338fFY5uYb/M4FJCKUdXXYTDysPWWNTeutbv69fcBCSineKj
	 bVrak61X5Y+x+vkbwNkdOag8y/rwcA1wgnaUvePA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Rahul Sharma <black.hawk@163.com>
Subject: [PATCH 5.15 190/206] genirq/irq_sim: Initialize work context pointers properly
Date: Wed,  4 Feb 2026 15:40:21 +0100
Message-ID: <20260204143905.067939066@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Gyeyoung Baek <gye976@gmail.com>

[ Upstream commit 8a2277a3c9e4cc5398f80821afe7ecbe9bdf2819 ]

Initialize `ops` member's pointers properly by using kzalloc() instead of
kmalloc() when allocating the simulation work context. Otherwise the
pointers contain random content leading to invalid dereferencing.

Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250612124827.63259-1-gye976@gmail.com
[ The context change is due to the commit 011f583781fa
("genirq/irq_sim: add an extended irq_sim initializer")
which is irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/irq/irq_sim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/irq/irq_sim.c
+++ b/kernel/irq/irq_sim.c
@@ -166,7 +166,7 @@ struct irq_domain *irq_domain_create_sim
 {
 	struct irq_sim_work_ctx *work_ctx;
 
-	work_ctx = kmalloc(sizeof(*work_ctx), GFP_KERNEL);
+	work_ctx = kzalloc(sizeof(*work_ctx), GFP_KERNEL);
 	if (!work_ctx)
 		goto err_out;
 


