Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062715;
	b=SroYpPX9TPagmEgRNbexsjwR/t3hR+a2v2LHhAgCjMVvBcH6XfFvK+zbQEvjQyci8VRz
	 QVmVSfHDCDL8Rgdf441prGrXQf0FYdhMxwj16kQ0jZ7xeDFc87K4UKtPXGjNSx64haeqG
	 sBulhSSw+1ISFzJp2dIt+CTNnfCHW6TumCe1hPXUKYg8ue791J/geZsKJVeWpfDg+2w0/
	 iBXDQbw1OOEwqGBX4RrFuzdTUD9ZzT32n97YKa7JDkOuSxuQEKGlIqJ24dxG/BL37a9At
	 XBNpfns7U4iwbCdr5lslin0nxosH+ciMaMiVyzNL6A/p7SlKHiOVH5MbfDq3f2eLpxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062715;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BoyGQIO41IfCl2m+dZgcw7yfcJpUUTn4CZ578AsmB4g=;
	b=dB+RoQ6Ly5xvp7rmoC/dnh9FRZyP6MGl7HDF2CyofuNJ3WQ8ruO0lw4MU4YuXWSz9Tsb
	 S8g0raAqbn2Mxr9GrVt7dpOBXATgAuyPnFZMJL+TsYVbq8I8X0kkH2XAe3TuCv+oZTDy9
	 zPOcmFT+0AmIvqqmO/w8PK6dwunls0OySg6BX/p9RhtuxHxcKZ/xRxGHAYW48/NncTDQC
	 du3ZomzLUn2IFiDOs9N+0KptSMwApwTlKYBmiBBaNZJ+KuUtO3RLkGezQ4PnK8BQWuhC7
	 lw4H+eqtcUyu3FUnd3ADAl/QtIwQKZ8a5VX7EYAnyWeGQ1Aa0cC8IAa4dUbFqXH0YhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SZsqOnIf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42933606A326;
	Sat,  7 Nov 2026 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SZsqOnIf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D5C1F0089F;
	Sat,  7 Nov 2026 14:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062715;
	bh=BoyGQIO41IfCl2m+dZgcw7yfcJpUUTn4CZ578AsmB4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZsqOnIffkWG8J0DrZB164VnxHcJcl3MiifQqzzJWEJ9u7rcehncpAo8lLWw6z4cX
	 zfWkyOp3sVdOipduYy0uAd1p1vySH4nRTbRF3kU0Il6/fDPhAFqzv37LidDNR9Q2ek
	 n0r048ZJ1Ih7Ntjehx26GPfsz4kRN0J+mDOExkwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 009/869] tcp: Remove timeout arg from reqsk_timeout().
Date: Sat,  7 Nov 2026 08:44:51 -0500
Message-ID: <20261107134852.343459720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 207ce0f6bc131812c96cf4f6db328af5396cebac ]

reqsk_timeout() is always called with @timeout being TCP_RTO_MAX.

Let's remove the arg.

As a prep for the next patch, reqsk_timeout() is moved to tcp.h
and renamed to tcp_reqsk_timeout().

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20251106003357.273403-5-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c9c90cf437a9 ("mptcp: hold MP_JOIN msk ref when cloning reqsk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 8 --------
 include/net/tcp.h                  | 7 +++++++
 net/ipv4/inet_connection_sock.c    | 2 +-
 net/ipv4/tcp_minisocks.c           | 5 +++--
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index d50e0afc3193f..39ccb785dd4c1 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -297,14 +297,6 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
 void inet_csk_reqsk_queue_drop_and_put(struct sock *sk, struct request_sock *req);
 
-static inline unsigned long
-reqsk_timeout(struct request_sock *req, unsigned long max_timeout)
-{
-	u64 timeout = (u64)req->timeout << req->num_timeout;
-
-	return (unsigned long)min_t(u64, timeout, max_timeout);
-}
-
 void inet_csk_destroy_sock(struct sock *sk);
 void inet_csk_prepare_for_destroy_sock(struct sock *sk);
 void inet_csk_prepare_forced_close(struct sock *sk);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index e40bad5606486..f9bcfa8773a3a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -838,6 +838,13 @@ static inline u32 __tcp_set_rto(const struct tcp_sock *tp)
 	return usecs_to_jiffies((tp->srtt_us >> 3) + tp->rttvar_us);
 }
 
+static inline unsigned long tcp_reqsk_timeout(struct request_sock *req)
+{
+	u64 timeout = (u64)req->timeout << req->num_timeout;
+
+	return (unsigned long)min_t(u64, timeout, TCP_RTO_MAX);
+}
+
 u32 tcp_delack_max(const struct sock *sk);
 
 /* Compute the actual rto_min value */
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 3e9eaf9d341d1..9a87ea6c63b46 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -1128,7 +1128,7 @@ static void reqsk_timer_handler(struct timer_list *t)
 	     inet_rsk(req)->acked)) {
 		if (req->num_timeout++ == 0)
 			atomic_dec(&queue->young);
-		mod_timer(&req->rsk_timer, jiffies + reqsk_timeout(req, TCP_RTO_MAX));
+		mod_timer(&req->rsk_timer, jiffies + tcp_reqsk_timeout(req));
 
 		if (!nreq)
 			return;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index d05009f985afc..2d78801866396 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -717,7 +717,8 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 			 * it can be estimated (approximately)
 			 * from another data.
 			 */
-			tmp_opt.ts_recent_stamp = ktime_get_seconds() - reqsk_timeout(req, TCP_RTO_MAX) / HZ;
+			tmp_opt.ts_recent_stamp = ktime_get_seconds() -
+				tcp_reqsk_timeout(req) / HZ;
 			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
 		}
 	}
@@ -756,7 +757,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		    !tcp_rtx_synack(sk, req)) {
 			unsigned long expires = jiffies;
 
-			expires += reqsk_timeout(req, TCP_RTO_MAX);
+			expires += tcp_reqsk_timeout(req);
 			if (!fastopen)
 				mod_timer_pending(&req->rsk_timer, expires);
 			else
-- 
2.53.0



