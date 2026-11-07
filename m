Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062722;
	b=maS6IPOnSn6RBC96aDTlTgX8f6R6eJzqGPPdVjace1oFkY5fT+sipLmuqgCDM/L52Wyr
	 MpNSEwAmuOHkwm+hZsfYUKteyUSuxtlzhmTQHHTdZ5NCLzyokWuj+PRkPHevuKjQ6t5WW
	 6+/hULo4ukcx6rWp8jH6loScqOE0sZ4oSRXRI1MGpwTXMffuHdUkqy0BNwovcT7VfzKfr
	 FK1rUUSc1VYV/zlioPf4P/3I6YheNERh/QCiiPkzpRBjKAQERaaTOh2jXXapl7SqP9JmX
	 4tmlq59RILwtnLTZLVX4qlcq0ZL2vmKHldWG1DZTxQGgZeJV4wfCoH4yHqGZwlnpfAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sIava7owvrXILTjojgxLU4IOa7cAiNXYQ9MnPodP8R4=;
	b=RsAr9oJlWQqFP0qzDI7017doVaO+5OBzf3AfPd45iWRmHvXFKtCxfK+A4UulzKi3+jNT
	 ydUsgWEqcXKPB+roeDqHAaSpNH865VLXIsEUO5nM4nq+XNMhdLIIJX6L0BgaozrJai6o5
	 UokkB32r7zXPp9i6+rSRVC1nhlkLV6d6+P2vU3iyTehALF2jVXL1OfBC7k0kta7rfdjLJ
	 4BwuyJ8EOuK7FqL355Zs8CZ9isPMSJCEmZV3qv75mu5QzFg9WLkANFvqQjUFqMwiFTMdL
	 fW2elwKe0zzmNbhvMrxw+zLD5jaygg9MZal5bwNmxY6CplNwwfHnIlnRVKfw0rM9F1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=autnJxWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA63606A32E;
	Sat,  7 Nov 2026 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=autnJxWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756991F008A1;
	Sat,  7 Nov 2026 14:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062721;
	bh=sIava7owvrXILTjojgxLU4IOa7cAiNXYQ9MnPodP8R4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=autnJxWUENSFynCWg94VaRrMnk1vUrr3w1VSMmU6/c1Ol1zBhptfIk9PcN33L2LMP
	 Ql5+IGowxSlOOoH8Kjv0731X4pQx33h96wp0vQ8k10su4CIo0Wn9NEfs87Lz5jUiGc
	 KMBI3C/UB4C5E5pzeMz03tReFIYYIyAWZoUfAT0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 010/869] tcp: accecn: unset ECT if receive or send ACE=0 in AccECN negotiaion
Date: Sat,  7 Nov 2026 08:44:52 -0500
Message-ID: <20261107134852.370145698@linuxfoundation.org>
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

From: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>

[ Upstream commit 4024081feb87fb11ac7bd36d8c397ccdd81ed302 ]

Based on specification:
  https://tools.ietf.org/id/draft-ietf-tcpm-accurate-ecn-28.txt

Based on Section 3.1.5 of AccECN spec (RFC9768), a TCP Server in
AccECN mode MUST NOT set ECT on any packet for the rest of the connection,
if it has received or sent at least one valid SYN or Acceptable SYN/ACK
with (AE,CWR,ECE) = (0,0,0) during the handshake.

In addition, a host in AccECN mode that is feeding back the IP-ECN
field on a SYN or SYN/ACK MUST feed back the IP-ECN field on the
latest valid SYN or acceptable SYN/ACK to arrive.

Signed-off-by: Chia-Yu Chang <chia-yu.chang@nokia-bell-labs.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260131222515.8485-11-chia-yu.chang@nokia-bell-labs.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: c9c90cf437a9 ("mptcp: hold MP_JOIN msk ref when cloning reqsk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_connection_sock.c |  3 +++
 net/ipv4/tcp_input.c            |  2 ++
 net/ipv4/tcp_minisocks.c        | 36 ++++++++++++++++++++++++---------
 net/ipv4/tcp_output.c           |  5 ++++-
 net/ipv4/tcp_timer.c            |  3 +++
 5 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 9a87ea6c63b46..15ad4414cbdb9 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -20,6 +20,7 @@
 #include <net/tcp_states.h>
 #include <net/xfrm.h>
 #include <net/tcp.h>
+#include <net/tcp_ecn.h>
 #include <net/sock_reuseport.h>
 #include <net/addrconf.h>
 
@@ -1126,6 +1127,8 @@ static void reqsk_timer_handler(struct timer_list *t)
 	    (!resend ||
 	     !tcp_rtx_synack(sk_listener, req) ||
 	     inet_rsk(req)->acked)) {
+		if (req->num_retrans > 1 && tcp_rsk(req)->accecn_ok)
+			tcp_rsk(req)->accecn_fail_mode |= TCP_ACCECN_ACE_FAIL_SEND;
 		if (req->num_timeout++ == 0)
 			atomic_dec(&queue->young);
 		mod_timer(&req->rsk_timer, jiffies + tcp_reqsk_timeout(req));
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6a2c05dff4215..28db1353445bf 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6236,6 +6236,8 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 	if (th->syn) {
 		if (tcp_ecn_mode_accecn(tp)) {
 			accecn_reflector = true;
+			tp->syn_ect_rcv = TCP_SKB_CB(skb)->ip_dsfield &
+					  INET_ECN_MASK;
 			if (tp->rx_opt.accecn &&
 			    tp->saw_accecn_opt < TCP_ACCECN_OPT_COUNTER_SEEN) {
 				u8 saw_opt = tcp_accecn_option_init(skb, tp->rx_opt.accecn);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 2d78801866396..ebcd78ad13efa 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -484,6 +484,10 @@ static void tcp_ecn_openreq_child(struct sock *sk,
 		tp->syn_ect_snt = treq->syn_ect_snt;
 		tcp_accecn_third_ack(sk, skb, treq->syn_ect_snt);
 		tp->saw_accecn_opt = treq->saw_accecn_opt;
+		if (treq->accecn_fail_mode & TCP_ACCECN_ACE_FAIL_SEND)
+			tcp_accecn_fail_mode_set(tp, TCP_ACCECN_ACE_FAIL_SEND);
+		if (treq->accecn_fail_mode & TCP_ACCECN_ACE_FAIL_RECV)
+			tcp_accecn_fail_mode_set(tp, TCP_ACCECN_ACE_FAIL_RECV);
 		tp->prev_ecnfield = treq->syn_ect_rcv;
 		tp->accecn_opt_demand = 1;
 		tcp_ecn_received_counters_payload(sk, skb);
@@ -752,16 +756,28 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 		 */
 		if (!tcp_oow_rate_limited(sock_net(sk), skb,
 					  LINUX_MIB_TCPACKSKIPPEDSYNRECV,
-					  &tcp_rsk(req)->last_oow_ack_time) &&
-
-		    !tcp_rtx_synack(sk, req)) {
-			unsigned long expires = jiffies;
-
-			expires += tcp_reqsk_timeout(req);
-			if (!fastopen)
-				mod_timer_pending(&req->rsk_timer, expires);
-			else
-				req->rsk_timer.expires = expires;
+					  &tcp_rsk(req)->last_oow_ack_time)) {
+			if (tcp_rsk(req)->accecn_ok) {
+				u8 ect_rcv = TCP_SKB_CB(skb)->ip_dsfield &
+					     INET_ECN_MASK;
+
+				tcp_rsk(req)->syn_ect_rcv = ect_rcv;
+				if (tcp_accecn_ace(tcp_hdr(skb)) == 0x0)
+					tcp_rsk(req)->accecn_fail_mode |= TCP_ACCECN_ACE_FAIL_RECV;
+			}
+			if (!tcp_rtx_synack(sk, req)) {
+				unsigned long expires = jiffies;
+
+				if (req->num_retrans > 1 && tcp_rsk(req)->accecn_ok)
+					tcp_rsk(req)->accecn_fail_mode |= TCP_ACCECN_ACE_FAIL_SEND;
+
+				expires += tcp_reqsk_timeout(req);
+				if (!fastopen)
+					mod_timer_pending(&req->rsk_timer,
+							  expires);
+				else
+					req->rsk_timer.expires = expires;
+			}
 		}
 		return NULL;
 	}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index ddcc7e53f2e34..f6210d4a3408f 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -333,8 +333,11 @@ static void tcp_ecn_send(struct sock *sk, struct sk_buff *skb,
 		return;
 
 	if (tcp_ecn_mode_accecn(tp)) {
-		if (!tcp_accecn_ace_fail_recv(tp))
+		if (!tcp_accecn_ace_fail_recv(tp) &&
+		    !tcp_accecn_ace_fail_send(tp))
 			INET_ECN_xmit(sk);
+		else
+			INET_ECN_dontxmit(sk);
 		tcp_accecn_set_ace(tp, skb, th);
 		skb_shinfo(skb)->gso_type |= SKB_GSO_TCP_ACCECN;
 	} else {
diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index eb549fea8fdd9..017a52022a1a2 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/gfp.h>
 #include <net/tcp.h>
+#include <net/tcp_ecn.h>
 #include <net/rstreason.h>
 
 static u32 tcp_clamp_rto_to_user_timeout(const struct sock *sk)
@@ -482,6 +483,8 @@ static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
 	 * it's not good to give up too easily.
 	 */
 	tcp_rtx_synack(sk, req);
+	if (req->num_retrans > 1 && tcp_rsk(req)->accecn_ok)
+		tcp_rsk(req)->accecn_fail_mode |= TCP_ACCECN_ACE_FAIL_SEND;
 	req->num_timeout++;
 	tcp_update_rto_stats(sk);
 	if (!tp->retrans_stamp)
-- 
2.53.0



