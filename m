Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212675;
	b=5Z8mYo4TPiOVjyQVhhWocPAcO1kRCA8idsZr8WgHtzisr43/L1CqwMeA0SyBzXXl09bd
	 RqN4N4gqT6FquNCv6B7/oWmk9cs7PD3laf/Doyhs7uXdIACm2GUOOYLGHUka/0Z7avCxz
	 oxkiIq9FwCwjssW2lwCRnOVV8rYxwCOmau3w1xHC9Jb6hTHbW4211ScNmGKZ4JV4+CuIl
	 dPHTJhLlJNXOKopratl/6A6UQr6JLLjBkuIp5Ehij4SYjfKjcw8f8s2hM9a/yF8i6j6a+
	 yblFSa6AuBqHAncMSaH6M0UQwFfajJsJ64+5HVTOhyIjpPah62iMLQLkjD8nBgk8N8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212675;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qfJVnSkeKTs9t8+Xde+mZdxK+P79UY2lv2nLrRse/AE=;
	b=G9f+UU+LorD9d26ISA204YkujFfe2BGmngRP/mJ31WujAHxfh7X+Tb61uIuE9gBJF1hN
	 LBsAHLTuxrekFh7LJB0mRxK2M8MyhANLIcUV6Smn90hJCjda8S00BRaoyXImzcfPOu12q
	 8vVOYZFmxjW6RB1H45BaDBlw7HV0q8r87/Zll+hAFhXrQb2FRUNCsbp1crd6hTmWnwpCW
	 NoMNT0geW2Q4Rp2R4flOu0K64Xxes+GN+v0GLmhsxMUKQV7XbG6fkpqMq8QeEvvG+W9FC
	 +nCOu874oC9I1A1c0pVd/dfhGLvUQ7f/eSX66Ni+CN7Ec3s64z/Hze4DSP87OA+KufA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s97p1X3f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB06606A324;
	Wed, 28 Oct 2026 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s97p1X3f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B3C1F031E2;
	Wed, 28 Oct 2026 18:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212675;
	bh=qfJVnSkeKTs9t8+Xde+mZdxK+P79UY2lv2nLrRse/AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s97p1X3fAWmEEIBl2GWK3ug0BAvRraNeP2bJ4vMdjtFHO6FWQgvkWtS26ewd7TtMT
	 P2lONLr8mwV22Cilf6tCUwZI41m3jTCr1dkmj1IGqTI9WHlhuJy3Fq65I9iQNxidSb
	 RAvv22SKo0elRk+8WoZUh1li6U2qWXIa9S4ikmOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0236/1887] tipc: prevent GCM nonce reuse on peer key changes
Date: Wed, 28 Oct 2026 17:38:52 +0100
Message-ID: <20261028170504.602697181@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 512ccd3d0e91e791fb37442aa0a2599aca19783d ]

TIPC can encrypt traffic between nodes using a different transmit key
for each node. In this mode, the AES-GCM nonce for a packet sent to a
known peer consists of a 32-bit prefix (a per-key salt XOR the peer's
address) followed by a 64-bit counter. That counter is stored in the
peer's RX crypto object. When the peer reports a change in which key
it uses to receive packets, TIPC resets this counter. The sender can
still be using the same TX key and salt, so subsequent packets reuse
earlier nonces. This nonce reuse breaks confidentiality and exposes
GCM's authentication key. This makes forgeries trivial: an attacker
can exploit CTR malleability to alter captured ciphertexts and use the
recovered authentication key to compute a valid tag for the modified
ciphertext, under the same key and nonce.

Use the TX key's existing aead->seqno counter instead. All encryptions
using that key object share the same atomic counter, so concurrent
encryptions get distinct nonce counter values. The counter survives
key activation and peer reconnection, and peer key-status reports
cannot reset it. This prevents those transitions from causing nonce
reuse while the same TX key remains installed.

The nonce format is unchanged, and receivers do not require consecutive
counter values, so sharing the counter across peers remains compatible
with existing receivers. A pre-existing check still invokes key
revocation in the unlikely event that the counter wraps to zero.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260924202105.3722778-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index d86b3a8f7078b..dc2239b2cf852 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -144,7 +144,7 @@ struct tipc_tfm {
  * @rcu: struct rcu_head
  * @key: the aead key
  * @gen: the key's generation
- * @seqno: the key seqno (cluster scope)
+ * @seqno: the per-key TX nonce counter
  * @refcnt: the key reference counter
  */
 struct tipc_aead {
@@ -190,7 +190,6 @@ struct tipc_crypto_stats {
  * @rekeying_intv: rekeying interval (in minutes)
  * @stats: the crypto statistics
  * @name: the crypto name
- * @sndnxt: the per-peer sndnxt (TX)
  * @timer1: general timer 1 (jiffies)
  * @timer2: general timer 2 (jiffies)
  * @working: the crypto is working or not
@@ -219,7 +218,6 @@ struct tipc_crypto {
 	struct tipc_crypto_stats __percpu *stats;
 	char name[48];
 
-	atomic64_t sndnxt ____cacheline_aligned;
 	unsigned long timer1;
 	unsigned long timer2;
 	union {
@@ -1060,14 +1058,11 @@ static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
 	WARN_ON(skb_headroom(skb) < ehsz);
 	ehdr = (struct tipc_ehdr *)skb_push(skb, ehsz);
 
-	/* Obtain a seqno first:
-	 * Use the key seqno (= cluster wise) if dest is unknown or we're in
-	 * cluster key mode, otherwise it's better for a per-peer seqno!
+	/*
+	 * Keep the nonce unique for the lifetime of the TX key,
+	 * including key state changes and peer reconnection.
 	 */
-	if (!__rx || aead->mode == CLUSTER_KEY)
-		seqno = atomic64_inc_return(&aead->seqno);
-	else
-		seqno = atomic64_inc_return(&__rx->sndnxt);
+	seqno = atomic64_inc_return(&aead->seqno);
 
 	/* Revoke the key if seqno is wrapped around */
 	if (unlikely(!seqno))
@@ -1246,7 +1241,6 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_crypto_key_detach(c->aead[k], &c->lock);
-	atomic64_set(&c->sndnxt, 0);
 	spin_unlock_bh(&c->lock);
 }
 
@@ -1393,8 +1387,6 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
  * It also considers if peer has no key, then we need to make own master key
  * (if any) taking over i.e. starting grace period and also trigger key
  * distributing process.
- *
- * The "per-peer" sndnxt is also reset when the peer key has switched.
  */
 static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 {
@@ -1445,7 +1437,6 @@ static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 		if (cur)
 			tipc_aead_users_dec(tx->aead[cur], 0);
 
-		atomic64_set(&rx->sndnxt, 0);
 		/* Mark the point TX key users changed */
 		tx->timer1 = jiffies;
 
@@ -1510,7 +1501,6 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	atomic_set(&c->key_distr, 0);
 	atomic_set(&c->peer_rx_active, 0);
-	atomic64_set(&c->sndnxt, 0);
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
 	c->rekeying_intv = TIPC_REKEYING_INTV_DEF;
-- 
2.53.0



