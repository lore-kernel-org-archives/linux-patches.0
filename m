Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044317;
	b=l1h14XpiybSKTXCxkdHNHADVkfJfgFkxMW6mU29L9yKHvZXLhidPYqKtvQI4tM+SDriF
	 1E4Uc8QtcT/metO+X3+Tk+HxzMQ7UuMFb1RSEIaEWMId7aJ59TQMTG4VVguNTS+1FdB4l
	 q+gY91XXjVmtTqPO7HVSO6TJy3dnqCP9ps8ykoUv6HXqqHpbIdtefR+OxX080U4+ZQ7Lx
	 yaDhj8mP5n7M1Z1CZ/F5bgzffWrhYDWSSvAhUM0f67Fj4bESkKCQnV6dhjeJDMnxe6G89
	 +aJ7c0wAITzMVVA8LeGcTMkD04QyxSDG7UE9jny21Ig4lghABkMxkuIEhTPN1Z67PHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5Ih7v+Wi8jdKygeCSrLXfv8MgwOrYWOPZUuETDB2Es=;
	b=bvyVcStN9z4oyFQaAF/ZTBu8rQffwW+C5nlbAyFZX3MwFXGk7YWD4HPYoWA7ISjaosLE
	 PU9EUu4T2Nr4/gMg9svBet2IrKl9jlubtEnszseaQJlvue5H7GCyANb8q7yb2m7VfW3YU
	 JcHpk8ziQp4twAdxykKEvHAGljXbxSjxDC1LU6mdLdc/aNmwH35HglJzpgGH8A+tvQweD
	 OqMhit2/PcqvTNny5bbbHQKzkASVk4Gyvhhzi1eZw8aNc2Dd9C+TnbkZDQsG3jjXFvog3
	 u+Dfrezgd5G0QErLhwohNvCsx6tGLQlkN4+sj67T/pLYyUDa4uEoLMUGL/B3RfUbjQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2StZq6FA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7554B606A320;
	Wed, 18 Nov 2026 23:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2StZq6FA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A83D1F000C7;
	Wed, 18 Nov 2026 23:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044317;
	bh=d5Ih7v+Wi8jdKygeCSrLXfv8MgwOrYWOPZUuETDB2Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2StZq6FANyVvIEedUEIu1qKfGSfCz9u3GaYsq6lZGNVujl8nt9AvE7jL4O15lLkYl
	 UCc+L+0/oo7r7Yax761po26wOEUeZt24p/njNmYWnPVjhpCBhFBXs87pzzuExFeyn/
	 Q2iXLp1NcqwpMHgbWI3GO6G/ix4Zk87MvCNgrtw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0463/2857] net: mctp: separate key correlation across nets
Date: Wed, 18 Nov 2026 15:24:57 +0100
Message-ID: <20261118150218.112863932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit 43e6795574f5d75284a3cb21f5b76a5ffb98e8e6 ]

Currently, we lookup sk_keys from the entire struct net_namespace, which
may contain multiple MCTP net IDs. In those cases we want to distinguish
between endpoints with the same EID but different net ID.

Add the net ID data to the struct mctp_sk_key, populate on add and
filter on this during route lookup.

For the ioctl interface, we use a default net of
MCTP_INITIAL_DEFAULT_NET (ie., what will be in use for single-net
configurations), but we'll extend the ioctl interface to provide
net-specific tag allocation in an upcoming change.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 26cc0e69cce0 ("mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mctp.h         |  2 ++
 net/mctp/af_mctp.c         |  4 ++--
 net/mctp/route.c           | 43 +++++++++++++++++++++++++++-----------
 net/mctp/test/route-test.c |  7 +++++--
 4 files changed, 40 insertions(+), 16 deletions(-)

diff --git a/include/net/mctp.h b/include/net/mctp.h
index 357f1cda11e45..84dd6e6ecfc40 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -136,6 +136,7 @@ struct mctp_sock {
  *    - through an expiry timeout, on a per-socket timer
  */
 struct mctp_sk_key {
+	unsigned int	net;
 	mctp_eid_t	peer_addr;
 	mctp_eid_t	local_addr; /* MCTP_ADDR_ANY for local owned tags */
 	__u8		tag; /* incoming tag match; invert TO for local */
@@ -258,6 +259,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 
 void mctp_key_unref(struct mctp_sk_key *key);
 struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
+					 unsigned int netid,
 					 mctp_eid_t local, mctp_eid_t peer,
 					 bool manual, u8 *tagp);
 
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 609e67210e454..844ab1fcc3558 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -366,8 +366,8 @@ static int mctp_ioctl_alloctag(struct mctp_sock *msk, unsigned long arg)
 	if (ctl.flags)
 		return -EINVAL;
 
-	key = mctp_alloc_local_tag(msk, MCTP_ADDR_ANY, ctl.peer_addr,
-				   true, &tag);
+	key = mctp_alloc_local_tag(msk, MCTP_INITIAL_DEFAULT_NET,
+				   MCTP_ADDR_ANY, ctl.peer_addr, true, &tag);
 	if (IS_ERR(key))
 		return PTR_ERR(key);
 
diff --git a/net/mctp/route.c b/net/mctp/route.c
index 7235467f11021..219ef18c596e7 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -107,9 +107,12 @@ static struct mctp_sock *mctp_lookup_bind(struct net *net, struct sk_buff *skb)
  * and peer addresses, or either being ANY.
  */
 
-static bool mctp_key_match(struct mctp_sk_key *key, mctp_eid_t local,
-			   mctp_eid_t peer, u8 tag)
+static bool mctp_key_match(struct mctp_sk_key *key, unsigned int net,
+			   mctp_eid_t local, mctp_eid_t peer, u8 tag)
 {
+	if (key->net != net)
+		return false;
+
 	if (!mctp_address_matches(key->local_addr, local))
 		return false;
 
@@ -126,7 +129,7 @@ static bool mctp_key_match(struct mctp_sk_key *key, mctp_eid_t local,
  * key exists.
  */
 static struct mctp_sk_key *mctp_lookup_key(struct net *net, struct sk_buff *skb,
-					   mctp_eid_t peer,
+					   unsigned int netid, mctp_eid_t peer,
 					   unsigned long *irqflags)
 	__acquires(&key->lock)
 {
@@ -142,7 +145,7 @@ static struct mctp_sk_key *mctp_lookup_key(struct net *net, struct sk_buff *skb,
 	spin_lock_irqsave(&net->mctp.keys_lock, flags);
 
 	hlist_for_each_entry(key, &net->mctp.keys, hlist) {
-		if (!mctp_key_match(key, mh->dest, peer, tag))
+		if (!mctp_key_match(key, netid, mh->dest, peer, tag))
 			continue;
 
 		spin_lock(&key->lock);
@@ -165,6 +168,7 @@ static struct mctp_sk_key *mctp_lookup_key(struct net *net, struct sk_buff *skb,
 }
 
 static struct mctp_sk_key *mctp_key_alloc(struct mctp_sock *msk,
+					  unsigned int net,
 					  mctp_eid_t local, mctp_eid_t peer,
 					  u8 tag, gfp_t gfp)
 {
@@ -174,6 +178,7 @@ static struct mctp_sk_key *mctp_key_alloc(struct mctp_sock *msk,
 	if (!key)
 		return NULL;
 
+	key->net = net;
 	key->peer_addr = peer;
 	key->local_addr = local;
 	key->tag = tag;
@@ -219,8 +224,8 @@ static int mctp_key_add(struct mctp_sk_key *key, struct mctp_sock *msk)
 	}
 
 	hlist_for_each_entry(tmp, &net->mctp.keys, hlist) {
-		if (mctp_key_match(tmp, key->local_addr, key->peer_addr,
-				   key->tag)) {
+		if (mctp_key_match(tmp, key->net, key->local_addr,
+				   key->peer_addr, key->tag)) {
 			spin_lock(&tmp->lock);
 			if (tmp->valid)
 				rc = -EEXIST;
@@ -372,6 +377,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 	struct net *net = dev_net(skb->dev);
 	struct mctp_sock *msk;
 	struct mctp_hdr *mh;
+	unsigned int netid;
 	unsigned long f;
 	u8 tag, flags;
 	int rc;
@@ -396,6 +402,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 
 	/* grab header, advance data ptr */
 	mh = mctp_hdr(skb);
+	netid = mctp_cb(skb)->net;
 	skb_pull(skb, sizeof(struct mctp_hdr));
 
 	ver = mh->ver & MCTP_HDR_VER_MASK;
@@ -410,7 +417,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 	/* lookup socket / reasm context, exactly matching (src,dest,tag).
 	 * we hold a ref on the key, and key->lock held.
 	 */
-	key = mctp_lookup_key(net, skb, mh->src, &f);
+	key = mctp_lookup_key(net, skb, netid, mh->src, &f);
 
 	if (flags & MCTP_HDR_FLAG_SOM) {
 		if (key) {
@@ -424,7 +431,8 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			 * this lookup requires key->peer to be MCTP_ADDR_ANY,
 			 * it doesn't match just any key->peer.
 			 */
-			any_key = mctp_lookup_key(net, skb, MCTP_ADDR_ANY, &f);
+			any_key = mctp_lookup_key(net, skb, netid,
+						  MCTP_ADDR_ANY, &f);
 			if (any_key) {
 				msk = container_of(any_key->sk,
 						   struct mctp_sock, sk);
@@ -462,7 +470,7 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 		 * packets for this message
 		 */
 		if (!key) {
-			key = mctp_key_alloc(msk, mh->dest, mh->src,
+			key = mctp_key_alloc(msk, netid, mh->dest, mh->src,
 					     tag, GFP_ATOMIC);
 			if (!key) {
 				rc = -ENOMEM;
@@ -675,6 +683,7 @@ static void mctp_reserve_tag(struct net *net, struct mctp_sk_key *key,
  * it for the socket msk
  */
 struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
+					 unsigned int netid,
 					 mctp_eid_t local, mctp_eid_t peer,
 					 bool manual, u8 *tagp)
 {
@@ -689,7 +698,7 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 		peer = MCTP_ADDR_ANY;
 
 	/* be optimistic, alloc now */
-	key = mctp_key_alloc(msk, local, peer, 0, GFP_KERNEL);
+	key = mctp_key_alloc(msk, netid, local, peer, 0, GFP_KERNEL);
 	if (!key)
 		return ERR_PTR(-ENOMEM);
 
@@ -706,6 +715,10 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 		 * lock held, they don't change over the lifetime of the key.
 		 */
 
+		/* tags are net-specific */
+		if (tmp->net != netid)
+			continue;
+
 		/* if we don't own the tag, it can't conflict */
 		if (tmp->tag & MCTP_HDR_FLAG_TO)
 			continue;
@@ -746,6 +759,7 @@ struct mctp_sk_key *mctp_alloc_local_tag(struct mctp_sock *msk,
 }
 
 static struct mctp_sk_key *mctp_lookup_prealloc_tag(struct mctp_sock *msk,
+						    unsigned int netid,
 						    mctp_eid_t daddr,
 						    u8 req_tag, u8 *tagp)
 {
@@ -760,6 +774,9 @@ static struct mctp_sk_key *mctp_lookup_prealloc_tag(struct mctp_sock *msk,
 	spin_lock_irqsave(&mns->keys_lock, flags);
 
 	hlist_for_each_entry(tmp, &mns->keys, hlist) {
+		if (tmp->net != netid)
+			continue;
+
 		if (tmp->tag != req_tag)
 			continue;
 
@@ -943,6 +960,7 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 	struct mctp_sk_key *key;
 	struct mctp_hdr *hdr;
 	unsigned long flags;
+	unsigned int netid;
 	unsigned int mtu;
 	mctp_eid_t saddr;
 	bool ext_rt;
@@ -994,16 +1012,17 @@ int mctp_local_output(struct sock *sk, struct mctp_route *rt,
 		rc = 0;
 	}
 	spin_unlock_irqrestore(&rt->dev->addrs_lock, flags);
+	netid = READ_ONCE(rt->dev->net);
 
 	if (rc)
 		goto out_release;
 
 	if (req_tag & MCTP_TAG_OWNER) {
 		if (req_tag & MCTP_TAG_PREALLOC)
-			key = mctp_lookup_prealloc_tag(msk, daddr,
+			key = mctp_lookup_prealloc_tag(msk, netid, daddr,
 						       req_tag, &tag);
 		else
-			key = mctp_alloc_local_tag(msk, saddr, daddr,
+			key = mctp_alloc_local_tag(msk, netid, saddr, daddr,
 						   false, &tag);
 
 		if (IS_ERR(key)) {
diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index a944490a724d3..a29bb605ee394 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -544,6 +544,7 @@ static void mctp_test_route_input_sk_keys(struct kunit *test)
 	struct mctp_sock *msk;
 	struct socket *sock;
 	unsigned long flags;
+	unsigned int net;
 	int rc;
 	u8 c;
 
@@ -551,6 +552,7 @@ static void mctp_test_route_input_sk_keys(struct kunit *test)
 
 	dev = mctp_test_create_dev();
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+	net = READ_ONCE(dev->mdev->net);
 
 	rt = mctp_test_create_route(&init_net, dev->mdev, 8, 68);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, rt);
@@ -562,8 +564,9 @@ static void mctp_test_route_input_sk_keys(struct kunit *test)
 	mns = &sock_net(sock->sk)->mctp;
 
 	/* set the incoming tag according to test params */
-	key = mctp_key_alloc(msk, params->key_local_addr, params->key_peer_addr,
-			     params->key_tag, GFP_KERNEL);
+	key = mctp_key_alloc(msk, net, params->key_local_addr,
+			     params->key_peer_addr, params->key_tag,
+			     GFP_KERNEL);
 
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, key);
 
-- 
2.53.0



