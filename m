Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061127;
	b=3gRyvi1i+oLJQD2wQk1fd6vKwTGhqT0BQRFq1Ku59J9L1tRf11kPsjcEEOiHqR9TN1+S
	 AbwoDfHPmfq1hk80G4KKZ5ASrfCqPV2lLrzeZtBTgg4etE65YSDTkJFGW1KZXugtz5qVH
	 dBeWuRjelKAiW1qfAdexPwIufoXxq7nITFhvcrhviQtglrIy5e3NVnRETTErTirSv8EkH
	 xwJIo6GDpkDMplBeA2tZtskuo5B/FkFf2JOwEs/weatvrKPKHyTca9o8BeI9nmuTjUpAl
	 dNw4/PLJey/Ga6MYXMQ1EJb5clk5Kd3fLwF6R8Wsjqo+3ZjVIJA78zwi4hvUV0z0TOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061127;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uqiJxlDXlOK2ECIKfzwnBtq8DQAgGqyyeZl77JQ5s5M=;
	b=zydKsFKzs4vg0OB17d45XRNgjSfKLUHjuzh5jDddQpMgpIBZaJz2M34BvtENeqg8fEjf
	 YwkZb4Vxgj45IhutGQXaveagZNKuwHH62nKmowK/Dip1snF1iAfk/PcWvcznosdv4Mgg1
	 N9d4r4CQBZG77dr10+u0dhgP+73e2J0jpdpG0qZhxJJLY3LbiBHkKTMI5f5g/Mm0BWoWJ
	 06ofJyGz2dZVhbvRtQuXDqjOIe4UZaz2vrOQV3cAYQBHa9AOp9F1hpaXGABjqGwmrCW/M
	 yL4ZgmSd0czJUDdCgbX/el97R3TX46VV3V0OYkxrSnYWz7sCuySpZxStJkIyae2zrHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6eXERLF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607BA606A332;
	Sat,  7 Nov 2026 14:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6eXERLF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AACB1F0089F;
	Sat,  7 Nov 2026 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061127;
	bh=uqiJxlDXlOK2ECIKfzwnBtq8DQAgGqyyeZl77JQ5s5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6eXERLFeo9VQ5QKz50DnMZWqqvKpzKbCJVU9blKLIvw6ewrIW7yoIVdI3n9ZaLnS
	 lPxqknP334Bxp6VQDjhwGkrviQys+mEtKPMJ1+aIP8LtyKAN0kGC37zbHO8y4n+rjw
	 3NChG/egoVzealCBpK688oUZwItVCsU5lcS+ft78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	co+71b6509cb791e531@bugs.sh,
	Kaho Jiang <kj2864@nyu.edu>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 0439/1536] net: ipv4: add zero check for snd_cwnd_clamp
Date: Sat,  7 Nov 2026 08:40:55 -0500
Message-ID: <20261107135009.881398116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -60,6 +60,11 @@ static int ip_metrics_convert(struct nla
 	if (ecn_ca)
 		metrics[RTAX_FEATURES - 1] |= DST_FEATURE_ECN_CA;
 
+	if ((metrics[RTAX_LOCK - 1] & (1 << RTAX_CWND)) && !metrics[RTAX_CWND - 1]) {
+		NL_SET_ERR_MSG(extack, "Locked cwnd metric must be non zero");
+		return -EINVAL;
+	}
+
 	return 0;
 }
 


