Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043726;
	b=B/KDMWrLBwxB3ime75bRrSI/5IJyllb/nzz2YwhHpV2ScVVQiODZSWMoCDZnfJ7lNgvS
	 kEe0wqZTYZYpS9PFT7mPW3eV5pcFHUBYRerJFCSbO1/YGgd7dLG8wVggJfol210EnC1tn
	 Ok/Alxsjl44W+OwdxHp9m83VvuIZ9Hxo3ry/J6QboU22Xvb2VNGJclfjTCgliLS0rJi4y
	 J+NcpwoNDvzrm5rp8HowW9OhINjKP1bxoshiSnX1+DjZYMhfUJ7Hf+sQGcrYeh6fQxHTG
	 BcS5iJyD010FjO1yxCmzLlUzfRZQYugj0qB/wJ4ndgCEi60dt0M2vDYGwgjM1dWsW3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043726;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fu8aqyEILtyZN1GQqkkg1jraI5zm/Q1sXGojlhio6Tw=;
	b=W74PSkr4F23cwXmNjalR01oL1Z289s1nRfKPpbDelfbgcdsWlHKu9ztSabFDd9ggdNhf
	 tYyPYZpD+MMmK4tQUKTO9Z/Zo1SyUNClezfTunQN2XOrt5wkq7/jNNkEquWqjyEKk1rmJ
	 f+WfJM/nGV2EHO//QKkn0XHAv/LEQVg9xmjYtyF3ZxaBmeZjbxiQbTS45NzDA1iT4syjQ
	 4MaDBS2M4vIkQz3/W/r6JXMh5jeJHYep6jv894ts4bHap7pG5SK7Fur9L2jgRarTeunZK
	 ktC8AS/pj48RwYFwYao0AfuCttQrbboonqxQi3WjldFyencjSr4RGB+vEhPWv5nf93g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOORP7fD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC078606A32C;
	Wed, 18 Nov 2026 23:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOORP7fD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366401F000C7;
	Wed, 18 Nov 2026 23:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043726;
	bh=Fu8aqyEILtyZN1GQqkkg1jraI5zm/Q1sXGojlhio6Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOORP7fDa+DQDWuLMX2AHIhcAARobEPtlOK2eu5j5lfeXChs0wbu2r3aEyEXtddMV
	 UJAHhD7qpwGjnbCEbeZatXJfvfkOKII/gyxTN0Rskp5FSlkL5wyKgZK/1yXLi1sFkv
	 iBg5ZZi617ax5a0YJA2EiWCzVz0zExDNBxjl4oZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	co+71b6509cb791e531@bugs.sh,
	Kaho Jiang <kj2864@nyu.edu>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 0312/2857] net: ipv4: add zero check for snd_cwnd_clamp
Date: Wed, 18 Nov 2026 15:22:26 +0100
Message-ID: <20261118150212.676700355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Kaho Jiang <kj2864@nyu.edu>

commit 363c8c79220d0db4d65dcd570529ddda15067cb5 upstream.

When RTAX_CWND is locked, user is able to pass 0 into it.
This could lead to writing 0 to tp->snd_cwnd, leading to a
division by zero error.

Oops: divide error: 0000 [#1] SMP KASAN NOPTI
Call Trace:
 <IRQ>
 tcp_reno_cong_avoid (net/ipv4/tcp_cong.c:510 (discriminator 1))
 tcp_ack (net/ipv4/tcp_input.c:3517 net/ipv4/tcp_input.c:3873 net/ipv4/tcp_input.c:4440)
 tcp_rcv_established (net/ipv4/tcp_input.c:6685)
 tcp_v4_do_rcv (net/ipv4/tcp_ipv4.c:1854)
 tcp_v4_rcv (net/ipv4/tcp_ipv4.c:2248)
 ip_protocol_deliver_rcu (net/ipv4/ip_input.c:207 (discriminator 1))
 ip_local_deliver_finish (net/ipv4/ip_input.c:241 (discriminator 1))
 ip_local_deliver (./include/linux/netfilter.h:325 ./include/linux/netfilter.h:319 net/ipv4/ip_input.c:262)
 ip_rcv (./include/net/dst.h:481 (discriminator 6) net/ipv4/ip_input.c:492 (discriminator 6) ./include/linux/netfilter.h:325 (discriminator 6) ./include/li)
 __netif_receive_skb_one_core (net/core/dev.c:6297 (discriminator 4))
 __netif_receive_skb (net/core/dev.c:6410)
 process_backlog (net/core/dev.c:6761)
 __napi_poll.constprop.0 (net/core/dev.c:7830)
 net_rx_action (net/core/dev.c:7893 net/core/dev.c:8050)
 handle_softirqs (kernel/softirq.c:645)
 __irq_exit_rcu (kernel/softirq.c:679 kernel/softirq.c:519 kernel/softirq.c:758)
 irq_exit_rcu (kernel/softirq.c:775)
 sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1062 (discriminator 35) arch/x86/kernel/apic/apic.c:1062 (discriminator 35))
RIP: 0010:tcp_cong_avoid_ai (net/ipv4/tcp_cong.c:482)

Fix by checking if user pass in zero as parameter and if lock is present.

Fixes: 814d488c6126 ("tcp: fix the timid additive increase on stretch ACKs")
Cc: stable@vger.kernel.org
Suggested-by: Eric Dumazet <edumazet@kernel.org>
Reported-by: co+71b6509cb791e531@bugs.sh
Signed-off-by: Kaho Jiang <kj2864@nyu.edu>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261021235732.1313305-2-kj2864@nyu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/metrics.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/metrics.c
+++ b/net/ipv4/metrics.c
@@ -63,6 +63,11 @@ static int ip_metrics_convert(struct net
 	if (ecn_ca)
 		metrics[RTAX_FEATURES - 1] |= DST_FEATURE_ECN_CA;
 
+	if ((metrics[RTAX_LOCK - 1] & (1 << RTAX_CWND)) && !metrics[RTAX_CWND - 1]) {
+		NL_SET_ERR_MSG(extack, "Locked cwnd metric must be non zero");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 


