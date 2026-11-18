Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052266;
	b=cmtdgekDr3jb4va2OWa+aPCPARd3IFhSRgSeQJVjp/yYwY8pdCH6/n+b3IJvRqWzHhYT
	 Rejd3K44O1l5iL0m45cYbEsjBqxQYO8Y42amxQY8xE5t+11q4SnTdzxpwMlvHsR2HKSBB
	 dymmVr0xhsq+eYuSAZGNVoykGHIhNAzl+818tVSvyl0utP2P+0mfIv80D4GGYp1EOiDdO
	 K9YCRjkzs4ibSE6ayNAssRNW8xlo1Rj07PuQk8q06rPqYV9REzdAtlRelLeLkZczfpQJP
	 qmm9KE9RRptZc7OUIIwwcbveFgACs7TVqYOQiNtTPRiOB058gkz2rqhArXXkIXicMkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=amO2nfnBpdtZXzIO0cXNpkdZi4WFgT6MpVGDHVf6ZxM=;
	b=Cxydg/Rmf6DTr+MmftBwtmErClf11GG3xJ/5+Lqt+oz7REr3E+E0bN8ZoGI1UDhVCzpd
	 VZ1i5WK8i3S9b14tavfNcw4VPpJaKSn8hPrSWzaEIj5UV7JPM+6A0yG8t6UETq4+xP5Zl
	 mKITgXUYSj8tQFmqZaKWH4aKLD0Fkc3xL6vTGI3QVfWz20D7kmvftzRb4gMw5duzKH+g0
	 djXGmGmQY4iec7m3yZk3feoWNfrhUP+pr6qe+jUQEdYCCr/RZRMmgdgizOGSEU9n5HfPL
	 0vil14f/2G5VZE42wKT0jkl0rmBwO7O3DeAlTM/gIkE5pf8Y8p/ndPcInxhnOLC2F8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aq67EcG9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8976F606A320;
	Thu, 19 Nov 2026 01:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aq67EcG9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3871F000C4;
	Thu, 19 Nov 2026 01:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052266;
	bh=amO2nfnBpdtZXzIO0cXNpkdZi4WFgT6MpVGDHVf6ZxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aq67EcG9E+uPxgsjC1t7f9s0rg+hhOqCtvlfdBS4FHyUwH51x8Dp8OBl/+eQ70Fa4
	 7kWEEiJtgr4cRS8ji4PrCLRkp/nGpv7fYmMfTarABHqowbqoBM+VPRdOQOu75iOncB
	 Y6Z3f6dRhyjFV+21SDVku1G2qNuOREfxdvaU+awI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0501/2214] md/raid5: fix NULL pointer dereference in raid5_free_percpu
Date: Wed, 18 Nov 2026 15:36:17 +0100
Message-ID: <20261118150031.197446269@linuxfoundation.org>
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
index 67002e38e70f7..943bbe0526542 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7093,7 +7093,8 @@ static void raid5_free_percpu(struct r5conf *conf)
 	if (!conf->percpu)
 		return;
 
-	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
+	if (!hlist_unhashed_lockless(&conf->node))
+		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
 	free_percpu(conf->percpu);
 }
 
-- 
2.53.0



