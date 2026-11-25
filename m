Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618442;
	b=qJ/P8PSTY2bz5DEUldgVYMtKgreiXQvIOjTpa3HBMfHhiGMOTBUOjcFsorK+9Owojh2/
	 1bqwxrT3YRDYsmVqMRurkaKWTUOEt0EKEOgZ8EIkhwyPb/2q4yxfRp76lPJOzl0fV36gJ
	 7MI0TxVB7mc6R2pjB/E3bnqOf5aoxX5ezefEnC67m+1Rl9RkF0lD6fot+AvZfeTaxdLhv
	 GxzXfC6PWGKLvBhTNMGGjQuXQxsLnFZ8A/6eN1s5QsKFhistkDjyTnd63ooztER5p7J2i
	 5J2CvWYOYHMCF9WsAMvGL/cX7UsnpoAjTw+z2mTYfWXemCJ6s5Q/hw63JMV2+Uqthdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3IVwCjoV111ovYvgUVfKMKoXeIRckMSyOmyzGL2Uaqs=;
	b=mLBQ/INtBGRvVY4vOAkF1SpQOSScdTC3BccN3Gn7d3Ey2LEIElpD3XBf9FCo39cCZ3y7
	 +rO+4zqvc2vM/qT1eFdCIgogKq92x1E2Vl4gkCzP7derxpilSSMIa1sda5yTgaG9UIqcN
	 UXpWGFYE6sy7RlVNp9Gne94R0NJ2+b47Ilv6gem0X1VcE1xwmiwYDWjZHwxUxiOr/ODvL
	 cgQDMflunnOZxOi/ZG/JHzZqQAuWfhKi4GJGL6Ra5z/1Q9YNFLm5vGgSGAOndNEJAJIM0
	 2wqs6XEmoZgm0xwbHJoP211AeejY20TjU4wdMOXDJJ/Ed9DSyDOsCdb7xSPcqdlPn/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wix058Hr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCF7606A31E;
	Wed, 25 Nov 2026 14:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wix058Hr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1244F1F000C6;
	Wed, 25 Nov 2026 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618441;
	bh=3IVwCjoV111ovYvgUVfKMKoXeIRckMSyOmyzGL2Uaqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wix058HrsikPsf6LXIKYeqpaMT4hSFHVh/LwExwtCmwWL78SQMoYeqYRp5g7n9pol
	 SQw06HQemHUXmVFA7SO42tS/63elIy4YM1Gwj9PaJN+Nb6++lX/ml+ChIqwuz4EdcX
	 ZdpTB3FCDr5ThujqyeBb+53LIjSWKCaLTIz5nbfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anvik Loitongbam <permissiontogallop@gmail.com>,
	Yingjie Wang <x-professor@outlook.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0281/1005] tcp: ipv6: do not read ireq->pktopts from tcp_v6_send_synack()
Date: Wed, 25 Nov 2026 15:26:59 +0100
Message-ID: <20261125143828.326118306@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 8e069fd3fd396b89af417e50b359bc9892dd41cd ]

When IPV6_FL_F_REFLECT is set on a listener, or the
net.ipv6.flowlabel_reflect sysctl has FLOWLABEL_REFLECT_ESTABLISHED,
tcp_v6_send_synack() reflects the flowlabel of the SYN packet,
reading it from the skb stored in ireq->pktopts.

Since commit 079096f103fa ("tcp/dccp: install syn_recv requests
into ehash table"), request sockets are processed without holding
the listener lock. A cpu can then process a retransmitted SYN for a
request socket, and send a SYNACK from tcp_check_req(), while another
cpu receives the ACK completing the 3WHS. tcp_v6_syn_recv_sock()
consumes ireq->pktopts when it wins the hashdance, and the first cpu
reads a freed skb:

  BUG: KASAN: slab-use-after-free in tcp_v6_send_synack (include/linux/skbuff.h:3152 include/linux/ipv6.h:110 net/ipv6/tcp_ipv6.c:582)
  Read of size 8 at addr ffff88802b08b608 by task poc-ipv6-pktopt/5076

  Call Trace:
   <IRQ>
   tcp_v6_send_synack (include/linux/skbuff.h:3152 include/linux/ipv6.h:110 net/ipv6/tcp_ipv6.c:582)
   tcp_rtx_synack (net/ipv4/tcp_output.c:4719)
   tcp_check_req (net/ipv4/tcp_minisocks.c:762)
   tcp_v6_rcv (net/ipv6/tcp_ipv6.c:1826)
   ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:479)
   ip6_input_finish (net/ipv6/ip6_input.c:534)
   ip6_input (include/linux/netfilter.h:325 include/linux/netfilter.h:319 net/ipv6/ip6_input.c:545)
   ipv6_rcv (include/net/dst.h:481 net/ipv6/ip6_input.c:119 include/linux/netfilter.h:325 include/linux/netfilter.h:319 net/ipv6/ip6_input.c:351)

  Freed by task 5074 on cpu 0 at 15.412249s:
   kmem_cache_free (include/linux/kasan.h:235 mm/slub.c:2780 mm/slub.c:6630 mm/slub.c:6757)
   tcp_v6_syn_recv_sock (net/ipv6/tcp_ipv6.c:1528)
   tcp_check_req (net/ipv4/tcp_minisocks.c:934)
   tcp_v6_rcv (net/ipv6/tcp_ipv6.c:1826)
   ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:479)
   ip6_input_finish (net/ipv6/ip6_input.c:534)

Request socket migration has the same issue: reqsk_migrate_reset()
transfers ireq->pktopts to the clone, which can be freed while
another cpu holding a reference on the old request socket is still
sending a SYNACK.

The SYNACK timer itself is not an issue, because
inet_csk_reqsk_queue_drop() calls timer_delete_sync().

Save the flowlabel of the SYN in the request socket instead, so that
tcp_v6_send_synack() no longer needs ireq->pktopts.

As a side effect, the flowlabel is also reflected for SYN packets
reusing a TIME_WAIT socket, as ireq->pktopts is not set in this case.

Fixes: e994b2f0fb92 ("tcp: do not lock listener to process SYN packets")
Fixes: 079096f103fa ("tcp/dccp: install syn_recv requests into ehash table")
Fixes: c905dee62232 ("tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.")
Reported-by: Anvik Loitongbam <permissiontogallop@gmail.com>
Reported-by: Yingjie Wang <x-professor@outlook.com>
Closes: https://lore.kernel.org/netdev/82c31e4d5043f3dbd11b44177cfba779d335aae3.1793599929.git.x-professor@outlook.com/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261102075441.3771550-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/tcp.h | 3 +++
 net/ipv6/tcp_ipv6.c | 5 +++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 6a8c77719322f..647b585e1cf94 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -179,6 +179,9 @@ struct tcp_request_sock {
 	u8				ao_rcv_next;
 	bool				used_tcp_ao;
 #endif
+#if IS_ENABLED(CONFIG_IPV6)
+	__be32				syn_flowlabel;
+#endif
 };
 
 #define tcp_rsk(ptr) container_of_const(ptr, struct tcp_request_sock, req.req)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index be50b2fe12742..40025284b9110 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -578,8 +578,8 @@ static int tcp_v6_send_synack(const struct sock *sk, struct dst_entry *dst,
 				    &ireq->ir_v6_rmt_addr);
 
 		fl6->daddr = ireq->ir_v6_rmt_addr;
-		if (inet6_test_bit(REPFLOW, sk) && ireq->pktopts)
-			fl6->flowlabel = ip6_flowlabel(ipv6_hdr(ireq->pktopts));
+		if (inet6_test_bit(REPFLOW, sk))
+			fl6->flowlabel = tcp_rsk(req)->syn_flowlabel;
 
 		tclass = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_reflect_tos) ?
 				(tcp_rsk(req)->syn_tos & ~INET_ECN_MASK) |
@@ -789,6 +789,7 @@ static void tcp_v6_init_req(struct request_sock *req,
 	ireq->ir_v6_loc_addr = ipv6_hdr(skb)->daddr;
 	ireq->ir_rmt_addr = LOOPBACK4_IPV6;
 	ireq->ir_loc_addr = LOOPBACK4_IPV6;
+	tcp_rsk(req)->syn_flowlabel = ip6_flowlabel(ipv6_hdr(skb));
 
 	/* So that link locals have meaning */
 	if ((!sk_listener->sk_bound_dev_if || l3_slave) &&
-- 
2.53.0



