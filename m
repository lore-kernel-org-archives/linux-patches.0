Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619584;
	b=jxdzPxNfhwsi85dGdesm5z1y3jLTunVi1bG3rWGIQOFChBbFuSaWbyQsUviI8c1jvAjJ
	 flV83azXT5cwtdmpZupY+LNx04umAwn7Pg/6PYhoKPGGzUxtm4QGnESvmLE/WQ9lXlhes
	 fyF0eWVulzZYtxk7P8arvDUCGKyDhpO+vf6/Xs6mHVn7ofMVM0LGcHM7+BUfwBTwUGH65
	 Bl7w27T3Ev/YofPGSj5OYmV6rv/OGwA2pK52l6Y3TgURP9AhlRc1cthkv/2nm6raJMc6a
	 P4nMiG0RFzcblLjFcxsqkLFjRfaW156d4DeWO7p8J/yJN/o3RX742aZ+N9cZfPV8big==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6w4chp7zeEqi+YirnrnjffDlS+XM1fM6uN+sNDq9BiM=;
	b=bdELYxYtKHRi2nKMxCILufD8n9QIHZeo179DmW6JQvwmSjzRd6gfz0VgNVpH41CVOjxw
	 +BseMCihAF+zz8JNto3GckEChubn8tEKMzvWIaxB+7rqPZB3F/XPi6+Oexyh3L+SiFyHa
	 EhYTkJygmNn2/bZpEFNgRsSMMtl1/QAb4S3RIIcpqy+2SSbfW4o2d+t/m+Gi9OaIzFK9x
	 qlVf4bD68NqpX//KTOimlkpqZlxgqsoI6OMzjtUt7VH+St7jA3yPiK0WayzCjcGYizL33
	 fOGUu10QvxXILTVpCY/2sdEe8Sp9GigaqCkAQX/3dvyk0s5YI/BXHWN9N6cnKVqwTJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8N+ieuU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEE6606A31E;
	Wed, 25 Nov 2026 15:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a8N+ieuU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1952B1F000C0;
	Wed, 25 Nov 2026 15:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619584;
	bh=6w4chp7zeEqi+YirnrnjffDlS+XM1fM6uN+sNDq9BiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8N+ieuU3w/j8wbU7efc83yPlwNI2o1sV/+5tlUpMKSTN7XtjmwnKsgGLewPCjn5z
	 iFIXrjeyLIOe7CqPpJJZW5eAZtUKJzA84VyuXvklAPUjMWv3zjgLiU9xQaJ2LYXFsg
	 LcLJf/qHzRKc2BIgKCHlt37ribrdghgVyM7r+3gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0642/1005] tcp: do not coalesce segments after FIN
Date: Wed, 25 Nov 2026 15:33:00 +0100
Message-ID: <20261125143836.792297950@linuxfoundation.org>
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

From: Hyunwoo Kim <imv4bel@gmail.com>

commit 1c46780dec48893b8c25fd5e33a3127e8dc39dd4 upstream.

A FIN consumes a sequence number. If another FIN segment is coalesced
into an skb that already carries FIN, end_seq advances to account for
the additional FIN, but tcp_flags still contains only one FIN bit.

When the preceding gap is filled and tcp_ofo_queue() processes the
coalesced skb, rcv_nxt advances to the skb's end_seq. When the receive
path consumes all data in the skb, copied_seq advances by the data
length and one sequence number for FIN. If three or more FIN segments
have been coalesced into one skb, tcp_inq() can still return a positive
value after the receive queue becomes empty and the SOCK_DONE adjustment
is applied.

TCP_ZEROCOPY_RECEIVE is another consumer affected by this state.
tcp_zerocopy_receive() takes its length from tcp_inq() and follows
skb->next without checking for the end of the receive queue.

Software kTLS receive is one consumer affected by this state. When
strp->copy_mode is false, tls_strp_msg_consume() calls the TCP helper
tcp_read_done() to consume the current TLS record. In the reproducer,
tcp_read_done() consumed the record data and one FIN before freeing the
receive skb.

When kTLS looked for the next record, tcp_inq() reported at least
TLS_HEADER_SIZE bytes even though the receive queue was empty.
tcp_recv_skb() returned NULL, so tls_strp_load_anchor_with_queue() hit
WARN_ON_ONCE() and returned without updating the anchor.

Since tcp_inq() had reported at least TLS_HEADER_SIZE,
tls_strp_read_sock() proceeded to tls_strp_check_queue_ok().
skb_shinfo(strp->anchor)->frag_list still pointed to the freed receive
skb. tls_strp_check_queue_ok() then read TCP_SKB_CB(first)->seq through
the stale pointer, causing a use-after-free.

The reproducer followed this call path:

  tls_rx_rec_done()
    tls_strp_msg_consume()
      tcp_read_done()                       // frees the receive skb
    tls_strp_check_rcv()
      tls_strp_read_sock()
        tls_strp_load_anchor_with_queue()   // returns after WARN_ON_ONCE()
          tcp_recv_skb() == NULL
        tls_strp_check_queue_ok()
          TCP_SKB_CB(first)->seq            // reads the freed receive skb

KASAN reported:

  BUG: KASAN: slab-use-after-free in tls_strp_check_queue_ok.isra.0+0x5f/0x100
  Read of size 4 at addr ffff888103169ca8 by task ktls-server/71
  ...
  Call Trace:
   <TASK>
   ...
   tls_strp_check_queue_ok.isra.0+0x5f/0x100
   tls_strp_check_rcv+0x2a9/0x400
   ...
   tls_sw_recvmsg+0x3ce/0xa10
   ...
   sock_recvmsg+0xea/0x100
   __sys_recvfrom+0x142/0x1f0
   ...
   __x64_sys_recvfrom+0x76/0x90
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   ...
   </TASK>
  ...
  Freed by task 71:
   ...
   napi_skb_cache_put+0x24/0xf0
   skb_attempt_defer_free+0x183/0x3b0
   tcp_read_done+0x2d4/0x340
   tls_strp_msg_consume+0x45/0x80
   tls_sw_recvmsg+0x3c4/0xa10
   ...

In tcp_try_coalesce(), skip coalescing when the destination skb already
carries FIN. tcp_add_backlog() calls skb_try_coalesce() directly instead
of using this helper, so add the same check there. Since both paths check
only the destination skb, a final segment carrying data and FIN can still
be coalesced into an skb without FIN when the other coalescing checks pass.

Fixes: e93a0435f809 ("tcp: allow segment with FIN in tcp_try_coalesce()")
Fixes: 4f693b55c3d2 ("tcp: implement coalescing on backlog queue")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/au3HMfqNW3_DRMqS@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_input.c |    4 ++++
 net/ipv4/tcp_ipv4.c  |    2 ++
 2 files changed, 6 insertions(+)

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5263,6 +5263,10 @@ static bool tcp_try_coalesce(struct sock
 	if (!tcp_skb_can_collapse_rx(to, from))
 		return false;
 
+	/* Nothing follows a FIN. */
+	if (unlikely(TCP_SKB_CB(to)->tcp_flags & TCPHDR_FIN))
+		return false;
+
 	if (!skb_try_coalesce(to, from, fragstolen, &delta))
 		return false;
 
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1957,6 +1957,8 @@ enum skb_drop_reason tcp_add_backlog(str
 	    ((TCP_SKB_CB(tail)->tcp_flags ^
 	      TCP_SKB_CB(skb)->tcp_flags) &
 	     (TCPHDR_ECE | TCPHDR_CWR | TCPHDR_AE)) ||
+	    /* Nothing follows a FIN, see tcp_try_coalesce() */
+	    (TCP_SKB_CB(tail)->tcp_flags & TCPHDR_FIN) ||
 	    !tcp_skb_can_collapse_rx(tail, skb) ||
 	    thtail->doff != th->doff ||
 	    memcmp(thtail + 1, th + 1, hdrlen - sizeof(*th)) ||


