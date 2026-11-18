Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036897;
	b=NyRcil3DfhT7AIYdcdxQhTcbl2kv0bGvApqLTaPGQkknf0FJ5CC3g4j12QN74Yl2l2Bl
	 /0HBns2vi5yHfVF+D52hvvZ9hr10nVUrZSI62acqlHgCXti2Zq4ygDZSzOtBoeFhHSMBT
	 pmkbX0xq+A4JC1nOBpF9jE5lw6bYfWLyultvFXXaqH1xOe5gFIUkqn2e46grGuQtp3bXu
	 qneQKMMQPjHgVW7V4uQANQLrqOPaR51GQ1OTSQ3OIbsD0LL6Ws+w+VUPJehjDbE1jO6aR
	 /1wUI7ILCGgZksk/3ayajUYNH88ogFKDyipAkSaAwKNT1BPY0ohxNk3lRfeFJwpBX+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IaMXBMjIgh88YtfBJNgun8ExwH/Ta56iZGR6Ex36S00=;
	b=c4RFFHhT/zd5aYXoanqzWMowD/fnorr6SOfJ0A0hxO0eiUfxG1IhXhOIb5xui6HtKdNQ
	 6TZoAbM3uGRVOzDEpyluo1n1ZWKqvQk7/QJ0mDoQxh39havPLX6mrWU2Ld5TOxgNPEqX3
	 uG1z3JRKXXdctFX1GKNGRswgcsIb07Lwa2OP2Es+eGYlS6w76oBtdwQT+yPZP4NmGnWjb
	 P09XjJkj+69tpdVqBlX7iBPFN1aoU8lZgbv631slZ2fzDISLIW3MeV9ZkI7r731xp8MqT
	 8ei70XYuVvjvQixoswXWQ9KamlB+bg94/qLN9Q0HZzKA2V85MfOnXeOLpzZz2czoDxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgog1M77;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5624606A320;
	Wed, 18 Nov 2026 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgog1M77
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45EF1F000C4;
	Wed, 18 Nov 2026 21:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036897;
	bh=IaMXBMjIgh88YtfBJNgun8ExwH/Ta56iZGR6Ex36S00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgog1M77ky7QovZC0RZzxaWbSCuayOIAptYy4NxH21JcdLnYWUyxtVqGwJRwmnL46
	 A+vmj2GLzVmUSVGdxgmC/juP+fUMg5LwKdQINK/tviavGWlQlYMRG/pnOJysn/epT3
	 +ibQW2i2eiY3ebmGPjT85YhqO2oDGwX4mruHxik0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Yu Zhao <yuzhao@google.com>,
	apais@microsoft.com,
	rlmenge@gmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1222/3318] mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cmdline
Date: Wed, 18 Nov 2026 15:30:44 +0100
Message-ID: <20261118150356.840142611@linuxfoundation.org>
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

From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>

[ Upstream commit 183895979c441e52dbd651b388553b09eaa35cfa ]

When CONFIG_MEMCG=y, lruvec_pgdat() returns lruvec->pgdat, which for the
per-node pgdat->__lruvec is left NULL by lruvec_init() and only filled in
lazily by mem_cgroup_lruvec(). Normally that happens early, e.g. on the
first folio_add_lru().

With cgroup_disable=memory, lru_gen_shrink_node() passes &pgdat->__lruvec
directly to shrink_one(). If direct reclaim runs before anything has
called mem_cgroup_lruvec() for the node, which can happen during early
boot under memory pressure (e.g. a kdump kernel), get_swappiness() ends
up dereferencing a NULL pgdat:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
  pc : get_swappiness+0x68/0xb0
  lr : try_to_shrink_lruvec+0x54/0x2c0
  Call trace:
   get_swappiness+0x68/0xb0 (P)
   try_to_shrink_lruvec+0x54/0x2c0
   shrink_one+0x8c/0x240
   shrink_node+0xc6c/0xe08
   do_try_to_free_pages+0xdc/0x570
   try_to_free_pages+0x124/0x278
   __alloc_frozen_pages_noprof+0x6e8/0xf78
   alloc_pages_mpol+0xc4/0x1c0
   alloc_frozen_pages_noprof+0x54/0xe8
   alloc_pages_noprof+0x1c/0x40
   atomic_pool_expand+0x98/0x300
   __dma_atomic_pool_init+0x58/0xd8
   dma_atomic_pool_init+0x154/0x170
   do_one_initcall+0x64/0x350
   kernel_init_freeable+0x214/0x430
   kernel_init+0x2c/0x208
   ret_from_fork+0x10/0x20

The classic LRU path and MGLRU before per-node lru_gen_folio lists
obtained the lruvec through mem_cgroup_lruvec(), which sets
lruvec->pgdat.

The above was hit on an arm64 kdump kernel (6.18-based) booted with
cgroup_disable=memory nr_cpus=4. It also reproduces on mainline on an
arm64 VM with CONFIG_ARM64_64K_PAGES=y, CONFIG_MEMCG=y,
CONFIG_LRU_GEN_ENABLED=y and:

  mem=160M nr_cpus=4 coherent_pool=512M cgroup_disable=memory

These options only serve to force direct reclaim early in boot; with
160M the boot eventually ends in OOM regardless. On mainline the first
LRU reclaim happens while unpacking the initramfs, and faults the same
way:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
  pc : get_swappiness+0xd4/0x150
  Call trace:
   get_swappiness+0xd4/0x150 (P)
   try_to_shrink_lruvec+0x44/0x2b8
   shrink_one+0x80/0x1a0
   shrink_node+0xd98/0xea8
   do_try_to_free_pages+0xf4/0x4b0
   try_to_free_pages+0x110/0x360
   __alloc_frozen_pages_noprof+0x8b0/0x1718
   ...
   __filemap_get_folio_mpol+0x2ac/0x548
   simple_write_begin+0x44/0xf8
   page_symlink+0x178/0x198
   ...
   do_populate_rootfs+0x13c/0x200

Link: https://lore.kernel.org/20261017050928.128582-1-sidchintamaneni@gmail.com
Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: <apais@microsoft.com>
Cc: <rlmenge@gmail.com>
Cc: <stable@vger.kernel.org> # 6.3+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 873d7a8ce2731..d5ab35610ecdb 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5626,7 +5626,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 		sc->nr_reclaimed = 0;
 
 	if (mem_cgroup_disabled())
-		shrink_one(&pgdat->__lruvec, sc);
+		shrink_one(mem_cgroup_lruvec(NULL, pgdat), sc);
 	else
 		shrink_many(pgdat, sc);
 
-- 
2.53.0



