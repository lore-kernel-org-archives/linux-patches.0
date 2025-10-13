Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B6C30EF71;
	Mon, 13 Oct 2025 15:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367812; cv=none; b=QIyVWO4njWx8M4dGE0lzefkFzD0UXtuxJSlcPPrWy7uvJehmjmmpGdE767k1mWniWDuXjYfGNu9D2SkZ8qSS7ZsN4nXXepWwIsICypBuUfWAHYXiwH+1Q5x2uXgAG7+ImzocouDhKtDalJg47SiCVIgbZmEY8TveIcscL9VxI8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367812; c=relaxed/simple;
	bh=kIrLs1rb8KT4NZIEUsy8efqo/hedApX1DqMkQHXtX+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3zFR2y9MQHds+Rsm03044qjrbw54nS2npVFcDAT41AaE6aGXJIAO774gfZRqfw1eo370wJSQdW8fa2fspfEIj2uwD1zta8Y9YcPwPEhDUObvO1rm/aAFuk8j3AxrvFmrHvhyssE9zZZdiuet7oDtUFUQIotAMXxZ+C/OpvoY8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fczdiZ3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fczdiZ3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C97C4CEFE;
	Mon, 13 Oct 2025 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367812;
	bh=kIrLs1rb8KT4NZIEUsy8efqo/hedApX1DqMkQHXtX+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fczdiZ3p4qp3ZKJL95el4LRTy+Qh0tVTgGJ4VbSijB7dKWoowuz/EFDxbHmpprgyj
	 BwFz1fvjcaNLUYZtW+lxW2j2qMxI/DSKGFxqxkITTEFCr5D2qBEf2RdL3gU0wppeZ8
	 9ACdZQOqQryNB3Ekege7sPL694Qvv9S9glCFYyiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/196] netfilter: ipset: Remove unused htable_bits in macro ahash_region
Date: Mon, 13 Oct 2025 16:45:00 +0200
Message-ID: <20251013144319.256192017@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c2d88b1b06b87..20b223e6e93b9 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -62,7 +62,7 @@ struct hbucket {
 		: jhash_size((htable_bits) - HTABLE_REGION_BITS))
 #define ahash_sizeof_regions(htable_bits)		\
 	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
-#define ahash_region(n, htable_bits)		\
+#define ahash_region(n)		\
 	((n) / jhash_size(HTABLE_REGION_BITS))
 #define ahash_bucket_start(h,  htable_bits)	\
 	((htable_bits) < HTABLE_REGION_BITS ? 0	\
@@ -701,7 +701,7 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 				key = HKEY(data, h->initval, htable_bits);
 				m = __ipset_dereference(hbucket(t, key));
-				nr = ahash_region(key, htable_bits);
+				nr = ahash_region(key);
 				if (!m) {
 					m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
@@ -851,7 +851,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	elements = t->hregion[r].elements;
 	maxelem = t->maxelem;
@@ -1049,7 +1049,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	rcu_read_unlock_bh();
 
-- 
2.51.0



