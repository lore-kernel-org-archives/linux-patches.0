Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215307;
	b=xM1aIqep9C2IYjPT88nZROuQqUgwcoxWCK/WTPQFrnKChMkDELFtwEOCe06m5hGiP33S
	 y7iKBdWptLr5jMXeIio6JR9rp4BUYxyRPYBh9NpKLUoesaf4CkNYmE8I+lL61AukPAvCv
	 72ASRppjnnCmjWATv0NjIDBlYtF1zu/ZISkuw+EjjlUQTBOPpV1iLQOh6kCuIZGQAovUd
	 ufZrt1OUikN+utUXu4otaJKrLR2Dwg1p5ZcQVaA3pFqheTczhGBNnsWee9ycSkAH6WNJf
	 3997KH7V6QFQrD6KiHiznvbxohN+2xLXYNIWWjcQWM/Q9sxOF1JwbwbpoYYi0aiQk3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7Q/T7UfUqAuUKnI/+EomQhFqAgyR+dazDjhISiUTQs=;
	b=iM4dBHJm1tXQ0ef+jYCGFEwn65y5gFjfzCOAsivDfpcJz5qMf/yow8mIU3D7+0mgwoh1
	 1YVsie2gpD8qzFVO+/WLywcViVSQJrRiQKlw7rOr/35y/FRaI6ZehBGnZOlp2WW5XBWeY
	 Cdw7N9gdEpRBOdA/mPLhCTYq6byJIHTngPWEzSQNVMCJAzG23MZrmt4W7wBjCtd1zn0H1
	 u4gbVnGEP8PTwYm1dL1xiiLjP75X7nXFnftW0ztJrDsTG+d8aMNUgdRPOIJb11eOtO+em
	 uj9HAgDSfNsaunXwyjEe2vJyPxWxtBWC0DaJv9Kl2ikLuEFWx19JPX2t2rH+WJ0CrYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSFuhseM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA358606A31E;
	Wed, 28 Oct 2026 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSFuhseM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D5621F01825;
	Wed, 28 Oct 2026 19:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215306;
	bh=s7Q/T7UfUqAuUKnI/+EomQhFqAgyR+dazDjhISiUTQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSFuhseM3b5i6z+cUnmxFvM/zH/vq33mYTplAI/IKMU/rJjE0iWJRRGpUooq5i5H+
	 XLtBngKdoa4KS/eqPVHPL7L9gyheEMEJsn1xsLxE5jp6gNvCVvNbn3zfQXWpKe5TxX
	 cvF5RNYkhkhXqpmUhWSCEvqLW+uwioM1gqNmHbGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1164/1887] tcp: challenge ACK for non-exact RST in SYN-RECEIVED
Date: Wed, 28 Oct 2026 17:54:20 +0100
Message-ID: <20261028170525.892054517@linuxfoundation.org>
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

From: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>

[ Upstream commit a28c4fcbf774e23b4779cae468e3497a5ad1f4a1 ]

The SYN-RECEIVED request-socket path in tcp_check_req() accepts an
in-window RST without requiring SEG.SEQ to exactly match RCV.NXT.  A
non-exact RST therefore removes the request instead of eliciting a
challenge ACK.

RFC 9293 section 3.10.7.4 applies the RFC 5961 reset check in
SYN-RECEIVED: an exact RST resets the connection, while a non-exact
in-window RST must trigger a challenge ACK and be dropped.

Apply that check before the ACK-field validation, following the RFC
sequence-number, RST, then ACK processing order.  Factor the per-netns
challenge ACK quota out of tcp_send_challenge_ack() so request sockets
can share it.  Use the request socket's send_ack() callback and its own
out-of-window ACK timestamp to send and rate-limit the response.

Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Fixes: 282f23c6ee34 ("tcp: implement RFC 5961 3.2")
Cc: stable@vger.kernel.org
Signed-off-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260717081443.809393-2-yangyx22@mails.tsinghua.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h        |  2 ++
 net/ipv4/tcp_input.c     | 56 ++++++++++++++++++++++++++++++----------
 net/ipv4/tcp_minisocks.c | 12 ++++++++-
 3 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 51a17dadb7556..4161bd71fb50f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1641,6 +1641,8 @@ static inline bool tcp_paws_reject(const struct tcp_options_received *rx_opt,
 
 bool tcp_oow_rate_limited(struct net *net, const struct sk_buff *skb,
 			  int mib_idx, u32 *last_oow_ack_time);
+void tcp_reqsk_send_challenge_ack(struct sock *sk, struct sk_buff *skb,
+				  struct request_sock *req);
 
 static inline void tcp_mib_init(struct net *net)
 {
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 55e5325479c01..9074af9da52d8 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3707,24 +3707,17 @@ bool tcp_oow_rate_limited(struct net *net, const struct sk_buff *skb,
 	return __tcp_oow_rate_limited(net, mib_idx, last_oow_ack_time);
 }
 
-/* RFC 5961 7 [ACK Throttling] */
-static void tcp_send_challenge_ack(struct sock *sk)
+/* Consume one slot from the per-netns RFC 5961 challenge ACK quota.
+ * Returns true if a challenge ACK may be sent.
+ */
+static bool tcp_challenge_ack_allowed(struct net *net)
 {
-	struct tcp_sock *tp = tcp_sk(sk);
-	struct net *net = sock_net(sk);
 	u32 count, now, ack_limit;
 
-	/* First check our per-socket dupack rate limit. */
-	if (__tcp_oow_rate_limited(net,
-				   LINUX_MIB_TCPACKSKIPPEDCHALLENGE,
-				   &tp->last_oow_ack_time))
-		return;
-
 	ack_limit = READ_ONCE(net->ipv4.sysctl_tcp_challenge_ack_limit);
 	if (ack_limit == INT_MAX)
-		goto send_ack;
+		return true;
 
-	/* Then check host-wide RFC 5961 rate limit. */
 	now = jiffies / HZ;
 	if (now != READ_ONCE(net->ipv4.tcp_challenge_timestamp)) {
 		u32 half = (ack_limit + 1) >> 1;
@@ -3735,12 +3728,49 @@ static void tcp_send_challenge_ack(struct sock *sk)
 	count = READ_ONCE(net->ipv4.tcp_challenge_count);
 	if (count > 0) {
 		WRITE_ONCE(net->ipv4.tcp_challenge_count, count - 1);
-send_ack:
+		return true;
+	}
+	return false;
+}
+
+/* RFC 5961 7 [ACK Throttling] */
+static void tcp_send_challenge_ack(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct net *net = sock_net(sk);
+
+	/* First check our per-socket dupack rate limit. */
+	if (__tcp_oow_rate_limited(net,
+				   LINUX_MIB_TCPACKSKIPPEDCHALLENGE,
+				   &tp->last_oow_ack_time))
+		return;
+
+	/* Then check the per-netns RFC 5961 rate limit. */
+	if (tcp_challenge_ack_allowed(net)) {
 		NET_INC_STATS(net, LINUX_MIB_TCPCHALLENGEACK);
 		tcp_send_ack(sk);
 	}
 }
 
+/* Send a challenge ACK from a SYN-RECEIVED request socket. Uses
+ * __tcp_oow_rate_limited() directly so that an RST carrying payload
+ * cannot bypass the per-request rate limit.
+ */
+void tcp_reqsk_send_challenge_ack(struct sock *sk, struct sk_buff *skb,
+				  struct request_sock *req)
+{
+	struct net *net = sock_net(sk);
+
+	if (__tcp_oow_rate_limited(net, LINUX_MIB_TCPACKSKIPPEDCHALLENGE,
+				   &tcp_rsk(req)->last_oow_ack_time))
+		return;
+
+	if (tcp_challenge_ack_allowed(net)) {
+		NET_INC_STATS(net, LINUX_MIB_TCPCHALLENGEACK);
+		req->rsk_ops->send_ack(sk, skb, req);
+	}
+}
+
 static void tcp_store_ts_recent(struct tcp_sock *tp)
 {
 	tp->rx_opt.ts_recent = tp->rx_opt.rcv_tsval;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 67735100f9acf..675f3c412c443 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -709,7 +709,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 * elsewhere and is checked directly against the child socket rather
 	 * than req because user data may have been sent out.
 	 */
-	if ((flg & TCP_FLAG_ACK) && !fastopen &&
+	if ((flg & TCP_FLAG_ACK) && !(flg & TCP_FLAG_RST) && !fastopen &&
 	    (TCP_SKB_CB(skb)->ack_seq !=
 	     tcp_rsk(req)->snt_isn + 1))
 		return sk;
@@ -742,6 +742,16 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		flg &= ~TCP_FLAG_SYN;
 	}
 
+	/* RFC 5961 section 3.2, as clarified by RFC 9293 section
+	 * 3.10.7.4, requires a challenge ACK for a non-exact
+	 * in-window RST in SYN-RECEIVED.
+	 */
+	if ((flg & TCP_FLAG_RST) &&
+	    TCP_SKB_CB(skb)->seq != tcp_rsk(req)->rcv_nxt) {
+		tcp_reqsk_send_challenge_ack(sk, skb, req);
+		return NULL;
+	}
+
 	/* RFC793: "second check the RST bit" and
 	 *	   "fourth, check the SYN bit"
 	 */
-- 
2.53.0



