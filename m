Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214060;
	b=BXzOKaVdqasuuDjZ706/f/4pXbC0F1kRs/m3eyjZMkJZn53dXV9b7cpSaE7Xab2lz3BS
	 F5lDAia+vs75YwUrFRqiarMc1yZDB5MbP9SMubyJBG8vm65Mr0i0Xjw/2CZfo3xeD9i4Q
	 lXOf9BtbpeeliyP98q9u5JNbESPZbY3hudSfGY4YmTMqs0UkOLV/i6HK7zPWHMkEPFV4L
	 XJ/HYLi5ZPadD4VJyjY95YSJHgGSd/LpoKVNXBpL/qpRz9kJ1YxC6c2h4xG97fM+C+hp9
	 5mvqEDq3MEYj2JfYdmMXe2Bg4CzqDQG184NB0fb8Zuv7WLyztYd3TIUBjHQXXwLOnmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bw1HiPdsYQfqAXNNp/lMMlIoSaFQKggUaxtQ6SXkgJU=;
	b=l48TiARpgWr/Kzlaf9HwXhZU9szXpsAg60wPE1nSglY6211Lg6Z+VkcYnKcKxB2jGFW8
	 XTBruAbJKLY0EqaKvKZO5ed+Yvt9hMJqnyOJaPBi2s8fWsj+Pt9ilZP/BxLfoP7iDQlUR
	 WYKJoHJTUsa5RGOi+Lvh0zD1jZzxF9mW7k2AyARwhgATJ6ARCJAZMqzHOMsrLPd7yDWGO
	 X7JHmazXO/VvvUpBeqEOg4+aXC0DxrrUbv9MTcaX+W3uCNoWFyRrw1XLzsVNI7MkHWWor
	 /R0HBNCS6j8f9jjMgUkpSo5TJngSfBH8hMR/LLRNr8MWlHU4XTR+8e3CH3jHykMv28Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OAUiOOZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8E5606A332;
	Wed, 28 Oct 2026 19:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OAUiOOZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3101F01825;
	Wed, 28 Oct 2026 19:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214059;
	bh=Bw1HiPdsYQfqAXNNp/lMMlIoSaFQKggUaxtQ6SXkgJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OAUiOOZEbQ1GUYgT47mfW5amchXrNR1YPS+NpiFBXOTo/WrpwcO12JlqF4KjeKAeS
	 89o8G6sMFB6FmPoOmhBhiwHGeUsDABmWNb5D69wZYlNaRbk2vTK+j+YQcbo3qEkPW5
	 IcvuWOXxFCEvn3pa9CJbfRo59uj5oXKHH5UT1DGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f9f31cb7d985f584d8e@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH 6.1 0726/1887] xfrm: state: fix out-of-bounds read during lookup
Date: Wed, 28 Oct 2026 17:47:02 +0100
Message-ID: <20261028170515.969653793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e952837f3ddb0ff726d5b582aa1aad9aa38d024d ]

lookup and resize can run in parallel.

The xfrm_state_hash_generation seqlock ensures a retry, but the hash
functions can observe a hmask value that is too large for the new hlist
array.

rehash does:
  rcu_assign_pointer(net->xfrm.state_bydst, ndst) [..]
  net->xfrm.state_hmask = nhashmask;

While state lookup does:
  h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
  hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {

This is only safe in case the update to state_bydst is larger than
net->xfrm.xfrm_state_hmask (or if the lookup function gets
serialized via state spinlock again).

Fix this by prefetching state_hmask and the associated pointers.
The xfrm_state_hash_generation seqlock retry will ensure that the pointer
and the hmask will be consistent.

The existing helpers, like xfrm_dst_hash(), are now unsafe for RCU side,
add lockdep assertions to document that they are only safe for insert
side.

xfrm_state_lookup_byaddr() uses the spinlock rather than RCU.
AFAICS this is an oversight from back when state lookup was converted to
RCU, this lock should be replaced with RCU in a future patch.

Reported-by: syzbot+5f9f31cb7d985f584d8e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/CACT4Y+azwfrE3uz6A5ZErov5YN2LYBN5KrsymBerT36VU8qzBA@mail.gmail.com/
Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: c2f672fc9464 ("xfrm: state lookup can be lockless")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 77 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 62 insertions(+), 15 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 4b0835cb58f5d..ecafa6950139f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -34,6 +34,8 @@
 
 #define xfrm_state_deref_prot(table, net) \
 	rcu_dereference_protected((table), lockdep_is_held(&(net)->xfrm.xfrm_state_lock))
+#define xfrm_state_deref_check(table, net) \
+	rcu_dereference_check((table), lockdep_is_held(&(net)->xfrm.xfrm_state_lock))
 
 static void xfrm_state_gc_task(struct work_struct *work);
 
@@ -61,6 +63,8 @@ static inline unsigned int xfrm_dst_hash(struct net *net,
 					 u32 reqid,
 					 unsigned short family)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_dst_hash(daddr, saddr, reqid, family, net->xfrm.state_hmask);
 }
 
@@ -69,6 +73,8 @@ static inline unsigned int xfrm_src_hash(struct net *net,
 					 const xfrm_address_t *saddr,
 					 unsigned short family)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_src_hash(daddr, saddr, family, net->xfrm.state_hmask);
 }
 
@@ -76,11 +82,15 @@ static inline unsigned int
 xfrm_spi_hash(struct net *net, const xfrm_address_t *daddr,
 	      __be32 spi, u8 proto, unsigned short family)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_spi_hash(daddr, spi, proto, family, net->xfrm.state_hmask);
 }
 
 static unsigned int xfrm_seq_hash(struct net *net, u32 seq)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_seq_hash(seq, net->xfrm.state_hmask);
 }
 
@@ -944,15 +954,37 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 	x->props.family = tmpl->encap_family;
 }
 
-static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
+struct xfrm_hash_state_ptrs {
+	const struct hlist_head *bydst;
+	const struct hlist_head *bysrc;
+	const struct hlist_head *byspi;
+	unsigned int hmask;
+};
+
+static void xfrm_hash_ptrs_get(const struct net *net, struct xfrm_hash_state_ptrs *ptrs)
+{
+	unsigned int sequence;
+
+	do {
+		sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
+
+		ptrs->bydst = xfrm_state_deref_check(net->xfrm.state_bydst, net);
+		ptrs->bysrc = xfrm_state_deref_check(net->xfrm.state_bysrc, net);
+		ptrs->byspi = xfrm_state_deref_check(net->xfrm.state_byspi, net);
+		ptrs->hmask = net->xfrm.state_hmask;
+	} while (read_seqcount_retry(&net->xfrm.xfrm_state_hash_generation, sequence));
+}
+
+static struct xfrm_state *__xfrm_state_lookup(const struct xfrm_hash_state_ptrs *state_ptrs,
+					      u32 mark,
 					      const xfrm_address_t *daddr,
 					      __be32 spi, u8 proto,
 					      unsigned short family)
 {
-	unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
+	unsigned int h = __xfrm_spi_hash(daddr, spi, proto, family, state_ptrs->hmask);
 	struct xfrm_state *x;
 
-	hlist_for_each_entry_rcu(x, net->xfrm.state_byspi + h, byspi) {
+	hlist_for_each_entry_rcu(x, state_ptrs->byspi + h, byspi) {
 		if (x->props.family != family ||
 		    x->id.spi       != spi ||
 		    x->id.proto     != proto ||
@@ -969,15 +1001,16 @@ static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
 	return NULL;
 }
 
-static struct xfrm_state *__xfrm_state_lookup_byaddr(struct net *net, u32 mark,
+static struct xfrm_state *__xfrm_state_lookup_byaddr(const struct xfrm_hash_state_ptrs *state_ptrs,
+						     u32 mark,
 						     const xfrm_address_t *daddr,
 						     const xfrm_address_t *saddr,
 						     u8 proto, unsigned short family)
 {
-	unsigned int h = xfrm_src_hash(net, daddr, saddr, family);
+	unsigned int h = __xfrm_src_hash(daddr, saddr, family, state_ptrs->hmask);
 	struct xfrm_state *x;
 
-	hlist_for_each_entry_rcu(x, net->xfrm.state_bysrc + h, bysrc) {
+	hlist_for_each_entry_rcu(x, state_ptrs->bysrc + h, bysrc) {
 		if (x->props.family != family ||
 		    x->id.proto     != proto ||
 		    !xfrm_addr_equal(&x->id.daddr, daddr, family) ||
@@ -997,14 +1030,17 @@ static struct xfrm_state *__xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 static inline struct xfrm_state *
 __xfrm_state_locate(struct xfrm_state *x, int use_spi, int family)
 {
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct net *net = xs_net(x);
 	u32 mark = x->mark.v & x->mark.m;
 
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
 	if (use_spi)
-		return __xfrm_state_lookup(net, mark, &x->id.daddr,
+		return __xfrm_state_lookup(&state_ptrs, mark, &x->id.daddr,
 					   x->id.spi, x->id.proto, family);
 	else
-		return __xfrm_state_lookup_byaddr(net, mark,
+		return __xfrm_state_lookup_byaddr(&state_ptrs, mark,
 						  &x->id.daddr,
 						  &x->props.saddr,
 						  x->id.proto, family);
@@ -1067,6 +1103,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		unsigned short family, u32 if_id)
 {
 	static xfrm_address_t saddr_wildcard = { };
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct net *net = xp_net(pol);
 	unsigned int h, h_wildcard;
 	struct xfrm_state *x, *x0, *to_put;
@@ -1083,8 +1120,10 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	rcu_read_lock();
-	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
-	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
+	h = __xfrm_dst_hash(daddr, saddr, tmpl->reqid, encap_family, state_ptrs.hmask);
+	hlist_for_each_entry_rcu(x, state_ptrs.bydst + h, bydst) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -1100,8 +1139,9 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	if (best || acquire_in_progress)
 		goto found;
 
-	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, encap_family);
-	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
+	h_wildcard = __xfrm_dst_hash(daddr, &saddr_wildcard, tmpl->reqid,
+				     encap_family, state_ptrs.hmask);
+	hlist_for_each_entry_rcu(x, state_ptrs.bydst + h_wildcard, bydst) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
 		    (mark & x->mark.m) == x->mark.v &&
@@ -1119,7 +1159,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	x = best;
 	if (!x && !error && !acquire_in_progress) {
 		if (tmpl->id.spi &&
-		    (x0 = __xfrm_state_lookup(net, mark, daddr, tmpl->id.spi,
+		    (x0 = __xfrm_state_lookup(&state_ptrs, mark, daddr, tmpl->id.spi,
 					      tmpl->id.proto, encap_family)) != NULL) {
 			to_put = x0;
 			error = -EEXIST;
@@ -1807,10 +1847,13 @@ struct xfrm_state *
 xfrm_state_lookup(struct net *net, u32 mark, const xfrm_address_t *daddr, __be32 spi,
 		  u8 proto, unsigned short family)
 {
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct xfrm_state *x;
 
 	rcu_read_lock();
-	x = __xfrm_state_lookup(net, mark, daddr, spi, proto, family);
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
+	x = __xfrm_state_lookup(&state_ptrs, mark, daddr, spi, proto, family);
 	rcu_read_unlock();
 	return x;
 }
@@ -1821,10 +1864,14 @@ xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 			 const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			 u8 proto, unsigned short family)
 {
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct xfrm_state *x;
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
-	x = __xfrm_state_lookup_byaddr(net, mark, daddr, saddr, proto, family);
+
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
+	x = __xfrm_state_lookup_byaddr(&state_ptrs, mark, daddr, saddr, proto, family);
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 	return x;
 }
-- 
2.53.0



