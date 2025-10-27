Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2668C326D74;
	Mon, 27 Oct 2025 18:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591076; cv=none; b=btnnoZ/D3iPI2NQgtWMA4f9QP2QhmDA8a5K/YLPZlHDhSXnTheuWl3WH4JW227iOQs1CTO1nVMzEw0YtaciU3PzGuCia+Hi1eC/bx5gGZjVuwg//zIBn2HWEGZhvz+PJ3art8b5FznGjeTOM+MqO8zMFjCO+KorNe60287teBHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591076; c=relaxed/simple;
	bh=nRX5R/GAaUoyKkuNdx20Rh3Z2Eke1h+8LNpOpLRGwgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSfQ0DJzh7TDXmmIad7A+CEncTDK08LuD7FOc8QO/gMuBbNCuqON76JxIiXpDa9i3KaOh/Snq67BjlDb4Ma7rmsA6mpIAeGknq6sfQlkSfz+V9LR8fQ12rIO6IJAOfTD+7Zk9BpRlFmwUziNL6fBkbWFnw8qseYhbAFnhvrFaOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z8CFSuxy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z8CFSuxy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7F8C4CEF1;
	Mon, 27 Oct 2025 18:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591076;
	bh=nRX5R/GAaUoyKkuNdx20Rh3Z2Eke1h+8LNpOpLRGwgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z8CFSuxydGBraVOwJ61q2LL9Rn2Z0Y9WKBxAbjX2zrZhhRgQf5zmkG9x346hkp76i
	 qkgB0MY6afnQoKbrAYe74L8/bV+yq3bRrOQe5RWVPkgWn984V40mWIzja4MB/qayMz
	 3HcZ4YpecfJ0QpiBafBuAWKna/oN7svWQO/jngvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/332] netfilter: ipset: Remove unused htable_bits in macro ahash_region
Date: Mon, 27 Oct 2025 19:31:51 +0100
Message-ID: <20251027183526.152900227@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Ni <zhen.ni@easystack.cn>

[ Upstream commit ba941796d7cd1e81f51eed145dad1b47240ff420 ]

Since the ahash_region() macro was redefined to calculate the region
index solely from HTABLE_REGION_BITS, the htable_bits parameter became
unused.

Remove the unused htable_bits argument and its call sites, simplifying
the code without changing semantics.

Fixes: 8478a729c046 ("netfilter: ipset: fix region locking in hash types")
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
Reviewed-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 636118b0f2ef4..bac75e3afa96b 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -87,7 +87,7 @@ struct hbucket {
 		: jhash_size((htable_bits) - HTABLE_REGION_BITS))
 #define ahash_sizeof_regions(htable_bits)		\
 	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
-#define ahash_region(n, htable_bits)		\
+#define ahash_region(n)		\
 	((n) / jhash_size(HTABLE_REGION_BITS))
 #define ahash_bucket_start(h,  htable_bits)	\
 	((htable_bits) < HTABLE_REGION_BITS ? 0	\
@@ -716,7 +716,7 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 				key = HKEY(data, h->initval, htable_bits);
 				m = __ipset_dereference(hbucket(t, key));
-				nr = ahash_region(key, htable_bits);
+				nr = ahash_region(key);
 				if (!m) {
 					m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
@@ -866,7 +866,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	elements = t->hregion[r].elements;
 	maxelem = t->maxelem;
@@ -1059,7 +1059,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	rcu_read_unlock_bh();
 
-- 
2.51.0



