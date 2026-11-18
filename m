Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035953;
	b=nHx29AkLPTQSNp1ekWCA3qm/uxwttOVJ9aDFnLdmeHYl2qJePVnJvAF5ihv/Bq3yjSfH
	 5u/6mq4/oQy8z9R59dFp4NoTJB19FlVDdBqfbmiAaOmQOP+oj+GGC+NgU5VneP6kessDR
	 uVP/UEv4BAMQgSG88SpjDqySbAN4J09XM4SHFvSPaUCcv5mR/gHYcOVfs6sKzQuQmSTGV
	 aalv3WoyB1nOphS0dpkapMkgQJt+PLocTMl9wQim5Wd+bPlECgLdcyZv8ZnZ8JkW+IBnf
	 0ryJHo8s1IeP7cae3Zw18dJDRxBgxUtVSP5pcFrDhQx27FZ7MmQ2gvSBzyaTH9HbxBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pVzAY/ndg3fe6czQnfh1AGQoJYsw5A6JRTUYGvLDRTg=;
	b=wj1DXZBsPZawuID/js6AbHp/h8iXs9xAe0kzr3VtZ92+gv29hC+yEIuUCE6Kb/fNNcvI
	 ihCKTbff1MIXNHaMQxVeixBHHvEnFvQgxzIRDKXm07BWJVfO1VCugNjMwsTiu6nS0Q5VA
	 SFDkhOMkPyPFMR2NgUC+FFKbf1RIGZkI1CaVLx5eZBpIvglcsuoI/87QPr2iI9yD7vwds
	 eXmPcLW1ImQa4V7d/jgQzAEj9T0gybU0u9I1TwQxv2YUcG3ndyezEoWfrnGH25PrdNLj+
	 qSDQQaso7Uf41o+yJQQK3DXxT9qn+1ith9yzVynnNIL1v1gQMjXYyLeBTgP67B6WV8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lw4rLNsa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CF6606A334;
	Wed, 18 Nov 2026 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lw4rLNsa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C09F1F000C4;
	Wed, 18 Nov 2026 21:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035953;
	bh=pVzAY/ndg3fe6czQnfh1AGQoJYsw5A6JRTUYGvLDRTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lw4rLNsaaYNZJGX/s5xJuvXpjLoI9+m/isgcfOAOWwf8x1FVCPFEVLylDEdQkiER2
	 8sw9W8ELdDMgvJQVvNGxU0om+9Y+bHyHzQI330PgfOyAeddCJ0PB/sO3k9Ode0/3M4
	 JPNlfEoFls9vpQ2bt/A+pZpNmVpxOH9ojohkUXpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0887/3318] md/raid5: fix NULL pointer dereference in raid5_free_percpu
Date: Wed, 18 Nov 2026 15:25:09 +0100
Message-ID: <20261118150346.011884511@linuxfoundation.org>
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

From: Cao Guanghui <caoguanghui@kylinos.cn>

[ Upstream commit 41742e35268d6a45161b187f51f42bc2ade14d0d ]

If cpuhp_state_add_instance() fails in raid5_alloc_percpu() (e.g., the
startup callback raid456_cpu_up_prepare fails due to an allocation
failure), conf->node is never added to the cpuhp instance list and
its pprev remains NULL (from kzalloc initialization).

When setup_conf() then jumps to abort, free_conf() calls
raid5_free_percpu(), which checks conf->percpu (non-NULL, since it was
allocated before the cpuhp failure) and proceeds to call
cpuhp_state_remove_instance().  This calls hlist_del() on the unhashed
node, which dereferences node->pprev (NULL), causing a kernel panic.

Guard the removal with hlist_unhashed_lockless() so that the cpuhp
instance is only removed if it was actually added.  The lockless variant
uses READ_ONCE() for the pprev read, which is safe here because the
actual removal is synchronized by cpuhp_state_mutex inside
cpuhp_state_remove_instance().

Fixes: 29c6d1bbd7a2 ("md/raid5: Convert to hotplug state machine")
Cc: stable@vger.kernel.org
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
Link: https://patch.msgid.link/20260827080341.112296-2-ghuicao@163.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 747da5fb96254..bfe815ffba765 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7441,7 +7441,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	if (!conf->percpu)
 		return;
 
-	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
+	if (!hlist_unhashed_lockless(&conf->node))
+		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
-- 
2.53.0



