Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624874;
	b=tw9URg4yj1G4yAHFuQst9vXwQEsxX+6+53Y1OLvuQ01Jf9+FpsOXqHiGbrh7fShqQXZ1
	 kKq7o216K+iX0/r9+ubJpsQbbtuKfAA6MvctkVahEFxzMmn6jgrzPWI+7n+yliI5ZsM7H
	 iMl+LV3fR7NXM0RD0Yww0eTP3xFRObDp712XBOM+NG6VwuGwNQMpq/KrpNIqPVORVCRz3
	 X0eIWa8Q3nHn186ScPczPgrdCwAe8NOLAHns4WbgnPdq50iNzxypyrUzm0pRylaeBug9g
	 b5IySpEGXAyNYxeYMZR469snMQl35j+6ACMfTuLw/zmW7gbSrdlDIihHCNhNjq5HD2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Nchz3vM/023FbTH5xhQAfcsSXgaaYDETo17JO2tUSs=;
	b=2glsur4eJ6JYAzpZx5+V/p4Oo9+A19df9Wkax63qqegTJK7r0Bfu6Wfnf3Ru6YCosBDP
	 IunbZCdd6egEcJ+I4nTbSJpL7vxPCIfKIIlV6V05jkobfGd2LKc1pgTWKRnQpAMz35l+5
	 GNKUdwXX6dx7PCUuOMq+7bAeyeaCJ+mz78riBy31J2XW5nQtyQV6lfdFi0POvkCRCD5L9
	 FutrEnzpOxQ9lJtZAfGK0oZTm0mu7phMw+YwQOyrs5omMB2ge+E6YNHjHiwHfBSqILeK1
	 FDtLKIj9tZaQp0cuZj2HKPreW2+sG25pX8ADl5Z7dplz3D9y0rtUlJq3bN5TC+eHqYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeKNd4U0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4100606A31E;
	Wed, 25 Nov 2026 16:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MeKNd4U0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73A21F000D0;
	Wed, 25 Nov 2026 16:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624874;
	bh=2Nchz3vM/023FbTH5xhQAfcsSXgaaYDETo17JO2tUSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MeKNd4U0qc0Zmh8UmYd46034JBi4sQlqcer5v7/H7dhA4AP8SyDxS3khi5UFkNaYD
	 C3WrmpDssFHgDx8BjBSE9Nw3esqITfqnErZL0S7x3u0pNRGO7eCVCyAUakp8WnyZOI
	 5CAI6KySfwhGT/X2aT7/sZz2uwDLFf/+boyBFHtY=
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
Subject: [PATCH 6.12 335/816] tcp: Do not allow buggy transitions between ehash and lhash2.
Date: Wed, 25 Nov 2026 15:31:23 +0100
Message-ID: <20261125143856.952502692@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e8ee9164ec5ac..2ff01a8fbef2b 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -101,6 +101,7 @@ struct inet_connection_sock {
 	__u32                     icsk_rto_min;
 	__u32                     icsk_delack_max;
 	__u32			  icsk_pmtu_cookie;
+	unsigned char		  unhashed_state;
 	const struct tcp_congestion_ops *icsk_ca_ops;
 	const struct inet_connection_sock_af_ops *icsk_af_ops;
 	const struct tcp_ulp_ops  *icsk_ulp_ops;
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 64093410f6d52..5b6436e6f242c 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1304,6 +1304,7 @@ struct sock *inet_csk_clone_lock(const struct sock *sk,
 	memset(&newicsk->icsk_accept_queue, 0,
 	       sizeof(newicsk->icsk_accept_queue));
 
+	newicsk->unhashed_state = 0;
 	inet_sk_set_state(newsk, TCP_SYN_RECV);
 
 	inet_clone_ulp(req, newsk, priority);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 7035e35bea5e1..a597c176a5e45 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -744,6 +744,11 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
+
+	if (unlikely(inet_csk(sk)->unhashed_state &&
+		     inet_csk(sk)->unhashed_state != TCP_LISTEN))
+		return -EINVAL;
+
 	ilb2 = inet_lhash2_bucket_sk(hashinfo, sk);
 
 	spin_lock(&ilb2->lock);
@@ -785,6 +790,9 @@ void inet_unhash(struct sock *sk)
 		return;
 
 	sock_rps_delete_flow(sk);
+
+	inet_csk(sk)->unhashed_state = sk->sk_state;
+
 	if (sk->sk_state == TCP_LISTEN) {
 		struct inet_listen_hashbucket *ilb2;
 
@@ -1017,6 +1025,9 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	int step, l3mdev;
 	u32 index;
 
+	if (unlikely(inet_csk(sk)->unhashed_state == TCP_LISTEN))
+		return -EINVAL;
+
 	if (port) {
 		local_bh_disable();
 		ret = check_established(death_row, sk, port, NULL);
-- 
2.53.0



