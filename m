Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617665;
	b=4rKipGnR0AzScbkE8zLmkYdUEANbeCS8pJQz7h2sottyvFDwjnfDX+zv0GojMt+oAB9q
	 btwjxuI4D/aDH5hbgOIYuLDL8r4mhXqgsYnueG7vONi9g+I8FJXWlrD9m8qPwHcUialwJ
	 3G3FGiBAU5cU8TLC+2jNZ9OG0qnZLBGNO5fx8bRoZQiBKS+77hc9EtzT5xFN29rHTggTi
	 BKOFrVZ/DjPCxIygoanYgPi5crdOX1kDweOnqqxBOTD8yKwacLZ0aFl+twRqTXA5Tpri9
	 2cd6u6xxIg/ZZRaCUhfkz67toxRI7gJmqCutLeRe/mexVfBHUGdBJA1N2VYxxPZo5bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IEVGkvA4Fvbf4Op2/MJj/qziXBEcTiFQd1mJp5xHhCo=;
	b=Kp4h9HiKEuDzOsxGiwYOB/jmroWB+NDVG1KUVAfhWZDrBQV1dPq3q16xuvkEbWnHpa0H
	 n5MEIGC4eB9Bbfahr2KefdwmYw8zM6HcFelIb/QRK2RpAuHmn9o5GWxzhxEuBOWvZZl9R
	 5s4KV6owSpOjMwJjeqkBV/ZjusyesLiConeka99InTcTnIF3kx9g4osNfFtBBooIjKS43
	 7Kb9fL7xYxDCyP9tegu325xTseN5yf6jBgZ8Hm1t0D+mUIPM4TEc5vqj5668Vu2WUUlFB
	 PVRuKw1cvSHKlxjhBcmIupDC/jCbpmdeQxeU+O1k5nKB4YXcNFFiQV+OXQNvivtXorg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1JFAVpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1129B606A31E;
	Wed, 25 Nov 2026 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c1JFAVpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319BA1F000C0;
	Wed, 25 Nov 2026 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617664;
	bh=IEVGkvA4Fvbf4Op2/MJj/qziXBEcTiFQd1mJp5xHhCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1JFAVpFku6pn7eFG5vSrA/KBWPA/xrot7ZRF/4inU1hfsj9OF+Y2bbb+o28PWOxb
	 Xo2wABzWtJblTcwBV/DTH2wUGk6wEtS8dSxuKsr15vMeyvQlnRQ1B1xynlubo/UbDs
	 fcXafaDaEVI55H1BqRrO/zZtLv64bxlmkEos4klM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0037/1005] xfrm: include mark in MIGRATE_STATE SA collision check
Date: Wed, 25 Nov 2026 15:22:55 +0100
Message-ID: <20261125143822.609921697@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit a46232c697c809aaa2b0ad18157b49d66201fd7f ]

The SA lookup tuple is (daddr, spi, proto, family, mark), but the
EEXIST pre-check and the xfrm_state_insert() vs xfrm_state_add()
decision only considered daddr and family, ignoring mark.
A migration that only changes the mark inserts a duplicate SA tuple
into the hash tables.

The collision check is implemented as xfrm_state_mark_collides(),
which walks the SPI hash bucket for the target tuple and excludes the
state being migrated by pointer, rather than doing a separate
exact-match lookup followed by a wildcard lookup and comparing the
result against self.

Before:
root@west:~# ip xfrm state add src 10.1.1.1 dst 10.1.1.2 proto esp \
        spi 0x1000  reqid 100 mode tunnel aead "rfc4106(gcm(aes))" \
        0x1111111111111111111111111111111111111111 96 \
        mark 0x1 mask 0xff

root@west:~# ip xfrm state add src 10.1.1.1 dst 10.1.1.2 proto esp \
        spi 0x1000  reqid 100 mode tunnel aead "rfc4106(gcm(aes))" \
        0x1111111111111111111111111111111111111111 96 \
        mark 0x2 mask 0xff
root@west:~# ip xfrm state migrate dst 10.1.1.2 proto esp spi 0x1000 \
        mark 0x1 mask 0xff \
        new-dst 10.1.1.2 new-src 10.1.1.1 new-reqid 100 \
        new-mark 0x2 mask 0xff
ip x s
src 10.1.1.1 dst 10.1.1.2
    proto esp spi 0x00001000 reqid 100 mode tunnel
    replay-window 0
    mark 0x2/0xff
    aead rfc4106(gcm(aes)) 0x1111111111111111111111111111111111111111 96
    anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
src 10.1.1.1 dst 10.1.1.2
    proto esp spi 0x00001000 reqid 100 mode tunnel
    replay-window 0
    mark 0x2/0xff
    aead rfc4106(gcm(aes)) 0x1111111111111111111111111111111111111111 96
    anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
    sel src 0.0.0.0/0 dst 0.0.0.0/0

Notice two states with same mark 0x2/0xff.
After:

Error: New SA tuple already occupied.

Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migration")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h    |  4 ++++
 net/xfrm/xfrm_state.c | 40 +++++++++++++++++++++++++++++++++++++---
 net/xfrm/xfrm_user.c  | 17 ++++++++---------
 3 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 1cc76a0d73224..445223a8dc6f1 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1768,6 +1768,10 @@ struct xfrm_state *xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 struct xfrm_state *xfrm_state_lookup_exact(struct net *net, const struct xfrm_mark *mark,
 					   const xfrm_address_t *daddr, __be32 spi,
 					   u8 proto, unsigned short family);
+bool xfrm_state_mark_collides(struct net *net, u32 mark,
+			      const xfrm_address_t *daddr, __be32 spi,
+			      u8 proto, unsigned short family,
+			      const struct xfrm_state *self);
 #ifdef CONFIG_XFRM_SUB_POLICY
 void xfrm_tmpl_sort(struct xfrm_tmpl **dst, struct xfrm_tmpl **src, int n,
 		    unsigned short family);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 7c5724fab4894..d340dc9d73461 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2205,10 +2205,12 @@ int xfrm_state_migrate_install(const struct xfrm_state *x,
 			       struct netlink_ext_ack *extack)
 {
 	if (m->new_family == m->old_family &&
-	    xfrm_addr_equal(&x->id.daddr, &m->new_daddr, m->new_family)) {
+	    xfrm_addr_equal(&x->id.daddr, &m->new_daddr, m->new_family) &&
+	    xc->mark.v == x->mark.v && xc->mark.m == x->mark.m) {
 		/*
-		 * Care is needed when the destination address of the state is
-		 * to be updated as it is a part of triplet.
+		 * Care is needed when the destination address or mark of the
+		 * state is to be updated, as they are part of the lookup
+		 * triplet.
 		 */
 		xfrm_state_insert(xc);
 	} else {
@@ -2443,6 +2445,38 @@ xfrm_state_lookup_exact(struct net *net, const struct xfrm_mark *mark,
 }
 EXPORT_SYMBOL(xfrm_state_lookup_exact);
 
+/* True if some OTHER state at this tuple would wildcard-match "mark".
+ * Used by MIGRATE_STATE, which must exclude the state being migrated.
+ */
+bool xfrm_state_mark_collides(struct net *net, u32 mark,
+			      const xfrm_address_t *daddr, __be32 spi,
+			      u8 proto, unsigned short family,
+			      const struct xfrm_state *self)
+{
+	struct xfrm_hash_state_ptrs state_ptrs;
+	unsigned int h;
+	struct xfrm_state *x;
+	bool collides = false;
+
+	rcu_read_lock();
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+	h = __xfrm_spi_hash(daddr, spi, proto, family, state_ptrs.hmask);
+
+	hlist_for_each_entry_rcu(x, state_ptrs.byspi + h, byspi) {
+		if (x != self && x->props.family == family &&
+		    x->id.spi == spi && x->id.proto == proto &&
+		    xfrm_addr_equal(&x->id.daddr, daddr, family) &&
+		    (mark & x->mark.m) == x->mark.v) {
+			collides = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return collides;
+}
+EXPORT_SYMBOL(xfrm_state_mark_collides);
+
 struct xfrm_state *
 xfrm_find_acq(struct net *net, const struct xfrm_mark *mark, u8 mode, u32 reqid,
 	      u32 if_id, u32 pcpu_num, u8 proto, const xfrm_address_t *daddr,
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index aac12991d2ca8..f8c2b17c6f2b7 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3446,15 +3446,14 @@ static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *nlh,
 						       x->nat_keepalive_interval);
 
 	if (m.new_family != um->id.family ||
-	    !xfrm_addr_equal(&m.new_daddr, &um->id.daddr, um->id.family)) {
-		u32 new_mark_key = m.new_mark ? m.new_mark->v & m.new_mark->m :
-						m.old_mark.v & m.old_mark.m;
-		struct xfrm_state *x_new;
-
-		x_new = xfrm_state_lookup(net, new_mark_key, &m.new_daddr,
-					  um->id.spi, um->id.proto, m.new_family);
-		if (x_new) {
-			xfrm_state_put(x_new);
+	    !xfrm_addr_equal(&m.new_daddr, &um->id.daddr, um->id.family) ||
+	    (m.new_mark && (m.new_mark->v != x->mark.v ||
+			   m.new_mark->m != x->mark.m))) {
+		const struct xfrm_mark *new_mark = m.new_mark ? m.new_mark : &x->mark;
+
+		if (xfrm_state_mark_collides(net, new_mark->v & new_mark->m,
+					     &m.new_daddr, um->id.spi,
+					     um->id.proto, m.new_family, x)) {
 			NL_SET_ERR_MSG(extack, "New SA tuple already occupied");
 			err = -EEXIST;
 			goto out;
-- 
2.53.0



