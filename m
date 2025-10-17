Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C666D330B3C;
	Fri, 17 Oct 2025 15:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716120; cv=none; b=agXr1ECEYkFraMmT+GyVdbbOpMYphzJyglLcwWYuZf2rFYtQtqKQMO2vCINuUiJTnUwjgCZcCah5zUxtKSEy0BmJ/sYYY2F+ZXJCEfUIgOjG7Yx1xO+f9mAo3EvX6m4d4V06Y1o6iy2seifGWwaiEtV6hnfQCpnAgTZovcMKhNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716120; c=relaxed/simple;
	bh=G9020WmRMhMXZ57B6KETNoM9dpN4UDlJfQi2hREkCPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhOnz8ptpew3BYc1Y5ZUuRTsS+vtUKBBfsEPs+BwgH9Zx5qL+x6az+L1wh748REJNdlWSrfzYy5pJaNNaV0YESY/F6F4poGMOpz8w9M9Ua+p2q7+5uhchZVRkRtuJLSMwmf0ymP/YLFs1BE432/8BBoouu7Np1+xq5i7efTw2qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5hqIZFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5hqIZFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B936C4CEE7;
	Fri, 17 Oct 2025 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716120;
	bh=G9020WmRMhMXZ57B6KETNoM9dpN4UDlJfQi2hREkCPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5hqIZFkYI/3WTg50YQ+Lk+xiTCCjPChAcpGv0hG0CFXmy7/Uy6mFNWPMX0prWL4R
	 mhZuoWKbn/nHKc2+YtK3ue1R3ee/1mSLdyDXeaZwdU/9l22nrq2D4erWEw5hBYEjbW
	 45vKc7Ho1f4ozpfPXrjjiWxiBMKTbotqbG9e8UFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Ni <zhen.ni@easystack.cn>,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 073/276] netfilter: ipset: Remove unused htable_bits in macro ahash_region
Date: Fri, 17 Oct 2025 16:52:46 +0200
Message-ID: <20251017145145.151888720@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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
index 0bd6bf46f05f3..1f9ca5040982d 100644
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
@@ -689,7 +689,7 @@ mtype_resize(struct ip_set *set, bool retried)
 #endif
 				key = HKEY(data, h->initval, htable_bits);
 				m = __ipset_dereference(hbucket(t, key));
-				nr = ahash_region(key, htable_bits);
+				nr = ahash_region(key);
 				if (!m) {
 					m = kzalloc(sizeof(*m) +
 					    AHASH_INIT_SIZE * dsize,
@@ -839,7 +839,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	elements = t->hregion[r].elements;
 	maxelem = t->maxelem;
@@ -1037,7 +1037,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
 	key = HKEY(value, h->initval, t->htable_bits);
-	r = ahash_region(key, t->htable_bits);
+	r = ahash_region(key);
 	atomic_inc(&t->uref);
 	rcu_read_unlock_bh();
 
-- 
2.51.0



