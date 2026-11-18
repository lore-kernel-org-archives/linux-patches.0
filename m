Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042233;
	b=aVlXmSieOgj6bFplp8+wQmeEDh9RF7dW/g0mijE8Q4jo/5yKx5zB5Zcy3X0mVBpm7xeM
	 09qwGLT/tW4i1bfKBhh/7/BItpB7wEsyhoE99zALBf/dFnQx3zDkr76BgGt77A0StVFEq
	 DTk4Gi6ppSdfH8oOoS6e3d6OEb1PuqXv2KFQnAWl9zVxCqPzC+e6plGfP1jmoLxkb9iW+
	 zP8Zjaj/MZ8oZ3rPD7rtDXxc/1aN4oteF8UKRvF+0MhT9XN7+T5fwFLXV2c8iuI5qE7bN
	 +f7EouBKWG2OZ3jXVtdAmo085HVDs5HVfLPjGXzKmsoj1j0mCq+f9pP2uEia64lH86g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AKmmf7NrvDCp7KXK4jcl9tCRpOhJv2fdogUt6nECKnY=;
	b=pd/3cLsKuj73BJBZ5xkan9F+mqLEmIw6XOqC/mjb4kb+oC81g9s3rTNFAOBt8wPPkBge
	 l1cbbxtoKEw3zjbmb4cKgS6sFSdAs6jpzwwVjYcKAOePew6oIvKcnso8eGLlr0HfHpiow
	 r9mFx44EWHVGHLJpsXUYdSBpSTK3+XHrUL+Z+kagJ61Niq2pPiZkJD0sQBszIQu/lZSIZ
	 3iQMXgt31N40tgZDafzn21LBoBawAH9ZPHmMwGOVimBxh0wjphjOwkn6BccWhvDuiqWb3
	 IF6IJRJ62Jy4PyunMm4EFtUTWuDrUzOcYJp9MG9U+F4a63X7GGKA7ouqyw5XpjMvLQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEOeAPD5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C75E606A32A;
	Wed, 18 Nov 2026 22:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PEOeAPD5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634381F000C4;
	Wed, 18 Nov 2026 22:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042232;
	bh=AKmmf7NrvDCp7KXK4jcl9tCRpOhJv2fdogUt6nECKnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEOeAPD5FXOCr0yd33T1MHz7whUT3GeaqMMGyW+OIw6Pnx5Nrrz6dSOAB2hqp76r7
	 1Bzm5JTV2WeZbim8rSpxR96AxKO3fR+JWf1w3x9VkzsPzPZdLUfEbBO/LABUeO3MFd
	 jxHnAX5gvfjo120eCSdkv7H1d14LUIPhnTvUj3RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Qiliang Yuan <odys.yuan@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3070/3318] tcp: tcp_metrics: use the socket netns, not the dst device netns
Date: Wed, 18 Nov 2026 16:01:32 +0100
Message-ID: <20261118150452.207706215@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 504bdcb8c1566a6f887f9accebe1aa99b502ae97 ]

tcp_get_metrics(), __tcp_get_metrics_req() and tcpm_new() look up and
create metrics entries in the netns of the cached dst device rather than
in the netns of the socket.

These usually match, but not after the device has been moved to another
netns or unregistered: a socket can keep a stale dst in sk_dst_cache
until it is checked again, and tcp_update_metrics() reads it with
__sk_dst_get() without any dst_check(). Once dst_dev_put() has run, the
dst device is blackhole_netdev and the entry is created in init_net.
Before that, for instance for routes through nexthop objects whose
cached dsts are released from a nested RCU callback, it is the netns the
device has just been moved to.

A TCP socket of netns A that enters TIME_WAIT in that window then
creates or updates an entry carrying A's addresses and RTT in another
netns, where TCP_METRICS_CMD_GET can dump it and where new connections
to the same peer inherit those metrics.

The metrics belong to the netns of the socket, so use sock_net() for
full sockets and request sockets, and pass it to tcpm_new().

Kernel sockets that do not hold a netns reference can still reach
tcp_time_wait() after tcp_net_metrics_exit_batch() has flushed the
entries of their dismantling netns, and an entry created then would
never be flushed and would keep a dangling tcpm_net. Make tcpm_new()
refuse to create entries when check_net() fails. Its callers are in
an RCU read-side section, and cleanup_net() waits for a grace period
between the refcount reaching zero and the flush, so an entry added
after a successful check is always seen by the flush.

Fixes: 51c5d0c4b169 ("tcp: Maintain dynamic metrics in local cache.")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261016084802.2725187-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index ca88ba261ea1e..d28ef811f0efa 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -161,16 +161,26 @@ static void tcpm_check_stamp(struct tcp_metrics_block *tm,
 	rcu_dereference_protected(p, lockdep_is_held(&tcp_metrics_lock))
 
 static struct tcp_metrics_block *tcpm_new(struct dst_entry *dst,
+					  struct net *net,
 					  struct inetpeer_addr *saddr,
 					  struct inetpeer_addr *daddr,
 					  unsigned int hash)
 {
 	struct tcp_metrics_block *tm;
 	bool reclaim = false;
-	struct net *net;
 
 	spin_lock_bh(&tcp_metrics_lock);
-	net = dst_dev_net_rcu(dst);
+
+	/* Do not add entries to a dismantling netns: they would not be
+	 * flushed again. Callers are in an RCU read-side section, and
+	 * cleanup_net() waits for a grace period after the netns refcount
+	 * reached zero and before tcp_metrics_flush_all(NULL) runs, so an
+	 * entry added after a successful check_net() is seen by the flush.
+	 */
+	if (unlikely(!check_net(net))) {
+		tm = NULL;
+		goto out_unlock;
+	}
 
 	/* While waiting for the spin-lock the cache might have been populated
 	 * with this entry and so we have to check again.
@@ -273,7 +283,7 @@ static struct tcp_metrics_block *__tcp_get_metrics_req(struct request_sock *req,
 		return NULL;
 	}
 
-	net = dst_dev_net_rcu(dst);
+	net = sock_net(req_to_sk(req));
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -318,7 +328,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	else
 		return NULL;
 
-	net = dst_dev_net_rcu(dst);
+	net = sock_net(sk);
 	hash ^= net_hash_mix(net);
 	hash = hash_32(hash, tcp_metrics_hash_log);
 
@@ -326,7 +336,7 @@ static struct tcp_metrics_block *tcp_get_metrics(struct sock *sk,
 	if (tm == TCP_METRICS_RECLAIM_PTR)
 		tm = NULL;
 	if (!tm && create)
-		tm = tcpm_new(dst, &saddr, &daddr, hash);
+		tm = tcpm_new(dst, net, &saddr, &daddr, hash);
 	else
 		tcpm_check_stamp(tm, dst);
 
-- 
2.53.0



