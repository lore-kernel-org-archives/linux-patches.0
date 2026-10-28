Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210976;
	b=MLsKZ0D7HjjeRjlgHtR0H8miEJywjqqQuipr0MrQfDu69N2X2rIw8wfTZVmOCBNT2Rk0
	 3xDvvjZcENJzrdEIZONEHy8wD00+hlEpRXFkX5VW9FF2F6N+oiUyr8e6R0R+zwKUarIvJ
	 W0isvTVVhkGbuf0hFj/+1/AFahppkcgGBl/u7UmWQkW8IKOFtSIjVh2VRuupi8KyqypPt
	 IWlgdXHkON8Lghwx3YeqgUqen9m6v9D7LDEm7d5G6ogbus5/kdbG1215GJT79RPyXTPBG
	 NJgWCUdyy0ox9PTLRmxZi3dxrp7+VtzJ5Zx4T8dkEmGZZdolFzfOYsKfTYzwJklhNvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9jQMZlaDswvE+YJxXuCPorYEynWui0i5Heh+cu1pHwI=;
	b=ytd5AG9X76jnkNeRkbHeBqhDdhIK3flOz+03QlVb+5x/OFLa2r8/lW9T3H+ZDidE4v9h
	 IcO5YbYxiXUUsJCDhcZawLBhhWMaodZe9+ez60hulHOg1h7Uh58ZHWCVvNaz0dRRS9GsE
	 gVzT2F0hOApDhW+BtDP1zIjZTNTt2Um1lSdMrZC+rA5Sky8Fgsy6nQUW0ZipWrKZHNgYM
	 GqxGRUmhTigAaRuF2mXVxL8Bi/DQxIyzH7ARIvH0omLgyVufSNn9Yzqdu/By17l4tkVfv
	 D9a0TRTyJIFheImGUZkBFbqJlgRXhvBiDE/CXhqiJCU5aFgkv5uTysXok42ASz//N2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8IPo9gG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1840F606A339;
	Wed, 28 Oct 2026 18:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P8IPo9gG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69BDE1F01829;
	Wed, 28 Oct 2026 18:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210976;
	bh=9jQMZlaDswvE+YJxXuCPorYEynWui0i5Heh+cu1pHwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8IPo9gGxKGYV+5FwDdXZ0U8GPk6K97owQlYo86ieX9vK+xcyebVZSHSJc7ZHKOJd
	 Ai8eHrgJRUkcw1gjHDk60BQe+ScaNx0K4bu+y4EM/FydTXkIE75xPDl2z+f0UH1JrS
	 1PAGaiOOHgajPMMYwbvKbczqhwdgP8QY0lVrWVlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/571] tipc: prevent GCM nonce reuse on peer key changes
Date: Wed, 28 Oct 2026 17:55:25 +0100
Message-ID: <20261028170012.236291779@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dd7e8fad4213c..a83f1638a45ca 100644
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
@@ -1071,14 +1069,11 @@ static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
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
@@ -1257,7 +1252,6 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_crypto_key_detach(c->aead[k], &c->lock);
-	atomic64_set(&c->sndnxt, 0);
 	spin_unlock_bh(&c->lock);
 }
 
@@ -1404,8 +1398,6 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
  * It also considers if peer has no key, then we need to make own master key
  * (if any) taking over i.e. starting grace period and also trigger key
  * distributing process.
- *
- * The "per-peer" sndnxt is also reset when the peer key has switched.
  */
 static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 {
@@ -1456,7 +1448,6 @@ static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 		if (cur)
 			tipc_aead_users_dec(tx->aead[cur], 0);
 
-		atomic64_set(&rx->sndnxt, 0);
 		/* Mark the point TX key users changed */
 		tx->timer1 = jiffies;
 
@@ -1521,7 +1512,6 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	atomic_set(&c->key_distr, 0);
 	atomic_set(&c->peer_rx_active, 0);
-	atomic64_set(&c->sndnxt, 0);
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
 	c->rekeying_intv = TIPC_REKEYING_INTV_DEF;
-- 
2.53.0



