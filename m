Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619298;
	b=SgX1Mb//pZwWQD+VG7R7eDszDe+eHjedUr9zq0+Z755fSNS2FhW7gjZcj4rcqqYrPd/+
	 7coTIFqL6SF/V1AZx5gltLgc+YOrhbT+8zYPVjaNHuH7QjnnG++mknlU92Sh0zZa2Ss7K
	 AJEIvkouir1vo/+ZomnN8lWN1oxAA0oGTE+XUNTTEeZ/wKAGZ9IQnK3aecGxiSAjOKI7+
	 Kur3yd0TPfHVlh1lZLufDYp4C3IRNi7rUJovYMC8WYKVEde51NiqFDnF5/WImWTEnIS5u
	 JlhA70tRNtDoHjFPzPug7StMNb+ADW+bXwqFuMERiVd9Lq9kVGidGB9n/mY/uvJPdVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619298;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SI9ZAqr/1+RVWR+WaxIqkOKbHscTgnNi6RGflomH2ug=;
	b=30CEE4CLptB3BE0cW9Hn0/j7L6ZXHXObKeVk4K+JM2qFPLOWav0A6sArRCAcHmWwbhGj
	 X3VtXsaX/kKdJoAxUYmKfd781cg0akiMRnY8DLTQPdzhMKBnEfCTMrvj/wC/4KRTM2/Pw
	 63WMDx2FXyAlbp6bG41WkWM/D6cmZsBL6ZKnxhUE9ShlrXqI+yDVog8go4F6/Rq8LYcCe
	 qAvwiO9wVQQEBckw2zJbFSxwujpx8fyyCSWXWkxON/PoufC2blF8jbKWbwXTM1SgI6qzf
	 3R6vnmx88zwiBvk9sgoa75yLQ54ZgP+70dGvQTrxAafLtkVftLPAiTX5Qtz9+LHMOYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idPJSkJ3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EFE606A31E;
	Wed, 25 Nov 2026 15:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idPJSkJ3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80C181F000F4;
	Wed, 25 Nov 2026 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619298;
	bh=SI9ZAqr/1+RVWR+WaxIqkOKbHscTgnNi6RGflomH2ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idPJSkJ3YajKfG+ofYM+khHLPJxvZnL7sBJhrnGc+j0tkbMpM4+hPx2f6g0t3LX8D
	 MDn8Ajlh9IY63pk32zBqJ0F3/ArmNgWDk+GcQir+qY4NGPahYKffTVLd8HPJR0F6aA
	 dwvxsR/yhgk54cCzfBEIi3VrNKh24R7iUW/hycsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Michal Luczaj <mhal@rbox.co>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0507/1005] tcp: Do not allow buggy transitions between ehash and lhash2.
Date: Wed, 25 Nov 2026 15:30:45 +0100
Message-ID: <20261125143833.622614095@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 8cc3aef0cb198049805ecc061a2cc7b79b0ae43e ]

The following state transitions have long been a playground for
syzbot, and recently AI joined in, reporting a lot more bugs.

  * listen() + shutdown() + connect()
  * connect() + connect(AF_UNSPEC) + listen()

All the fix attempts would add more code to the fast path, which
is not worth it.

Instead of playing whack-a-mole with these edge-case bugs,
let's disallow these transitions.

Note that unhashed_state is placed in the 4-byte hole after
icsk_pmtu_cookie.

  $ pahole -C inet_connection_sock vmlinux
  struct inet_connection_sock {
  ...
	__u32                      icsk_pmtu_cookie;     /*  1208     4 */
	unsigned char              unhashed_state;       /*  1212     1 */

	/* XXX 3 bytes hole, try to pack */

Reported-by: Kyle Zeng <kylebot@openai.com>
Closes: https://lore.kernel.org/netdev/20260731140512.566464-1-david.lee@trailofbits.com/
Reported-by: Michal Luczaj <mhal@rbox.co>
Closes: https://lore.kernel.org/netdev/20260803-sockmap-lookup-tcp-leak-v2-0-306e025bfe66@rbox.co/
Reported-by: Hyunwoo Kim <imv4bel@gmail.com>
Closes: https://lore.kernel.org/netdev/20260824033331.1084971-1-imv4bel@gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260904033543.2635540-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8c011697f76a ("tcp: do not resurrect a former listener with SO_ATTACH_REUSEPORT_[CE]BPF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h |  1 +
 net/ipv4/inet_connection_sock.c    |  1 +
 net/ipv4/inet_hashtables.c         | 11 +++++++++++
 3 files changed, 13 insertions(+)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 433c2df23076d..903499581db7e 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -94,6 +94,7 @@ struct inet_connection_sock {
 	u32			  icsk_rto_max;
 	__u32                     icsk_delack_max;
 	__u32			  icsk_pmtu_cookie;
+	unsigned char		  unhashed_state;
 	const struct tcp_congestion_ops *icsk_ca_ops;
 	const struct inet_connection_sock_af_ops *icsk_af_ops;
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 71b0c344579f3..e56beec438773 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1262,6 +1262,7 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 	memset(&newicsk->icsk_accept_queue, 0,
 	       sizeof(newicsk->icsk_accept_queue));
 
+	newicsk->unhashed_state = 0;
 	inet_sk_set_state(newsk, TCP_SYN_RECV);
 
 	inet_clone_ulp(req, newsk, priority);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7ffa9171d6de1..860145d810ed4 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -804,6 +804,11 @@ int inet_hash(struct sock *sk)
 	inet_init_ehash_secret();
 
 	WARN_ON(!sk_unhashed(sk));
+
+	if (unlikely(inet_csk(sk)->unhashed_state &&
+		     inet_csk(sk)->unhashed_state != TCP_LISTEN))
+		return -EINVAL;
+
 	ilb2 = inet_lhash2_bucket_sk(hashinfo, sk);
 
 	spin_lock(&ilb2->lock);
@@ -833,6 +838,9 @@ void inet_unhash(struct sock *sk)
 		return;
 
 	sock_rps_delete_flow(sk);
+
+	inet_csk(sk)->unhashed_state = sk->sk_state;
+
 	if (sk->sk_state == TCP_LISTEN) {
 		struct inet_listen_hashbucket *ilb2;
 
@@ -1059,6 +1067,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	int ret, i, low, high;
 	bool local_ports;
 
+	if (unlikely(inet_csk(sk)->unhashed_state == TCP_LISTEN))
+		return -EINVAL;
+
 	if (port) {
 		local_bh_disable();
 		ret = check_established(death_row, sk, port, NULL, false,
-- 
2.53.0



