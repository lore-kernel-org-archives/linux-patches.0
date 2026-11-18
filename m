Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044263;
	b=qWKsVXOvD+PEPMRwzuEMGYawkph3q3XZJZSukbJDDB5jyx6ICy5dQQgX6hXYg7oBz5wc
	 0G5GggOiMS8f1v8Z2oRaipQha3pTBLPxogglRw1TIORIqRJTjHocqcze2i1fDeQKIVK1W
	 ZHnNCcotVQupVAaAUy4Z9gWL8CRPdcrozwIZH8Qa9RmK3PeOyiaeHsCJPBdpll9l+HVqV
	 De5xexYzu6pwJVJjr5KMmxyleXihDTpueKiCLozcdlB8kv1xvKYEcQxEpp/B5kIhJRB1F
	 i4ikpMZHDWFcPQSW9sqlAtRCfcqm9RnKi1hr3QXwW10lKZsIrSumPRM9R/q6/uNQbJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/3jkDKyZ5wsq4FdpQIRb2s4ZV/SUaqvJmf09Rq6YnYs=;
	b=a0V/wdRjU7kHPk83WmFlfd6jMkVgZYAdpEoWWKNX3m9QvTZQMEallwg7LEFT2vt3LUOH
	 K5kYY2FlpZzWFc7jRO20j3VvNKRlomnog8JBCJnqAfpIvu3g+u69qO+XypnzKuUExThVA
	 el15aoaWeP5jY1C40QJVB0pyQ4YrL+wdANIpGpgbiWfnTKO3x/Y2K0/HuJCi8ShmWVU5M
	 lMVEIZ3SUJFWOj0fs0aTtorsa6i1UQRWgk2834K0xVjLSibLteDH3XDgIe9gapVfIY2zj
	 cszcCgpStMTTNDPfGC3Du/DkE3cqcbI8URe27RIcMHw0YDXyF0Z0kEYABHcLIBYPrHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCCVzUUd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB515606A320;
	Wed, 18 Nov 2026 23:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCCVzUUd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189491F000C5;
	Wed, 18 Nov 2026 23:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044263;
	bh=/3jkDKyZ5wsq4FdpQIRb2s4ZV/SUaqvJmf09Rq6YnYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCCVzUUdYSNFB/ubg0VTf8z7B8SpKrl6KRDmPq58d3WPaD8FAyEukyB3oDxBwnFbK
	 AirzQb7xyqTOLkWG6i0vxsm9+yK8sVjxDp4EL/+jCrdcf0ol6SOhkFUkcdgfccBWVY
	 wIiq4wvWCwMwVigY8V3ob2bFKwqrdRzCTpy3grEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0503/2857] net/sched: act_ife: do not consume the inner header on egress
Date: Wed, 18 Nov 2026 15:25:37 +0100
Message-ID: <20261118150219.567573409@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

commit 498c631f9c6d74aad4bf43039fa3ce70ae9a8bb7 upstream.

The issue:
tcf_ife_decode() unconditionally calls eth_type_trans(), which pulls
ETH_HLEN.  On egress this consumes the inner Ethernet header, and the
device receives an skb whose data points to the L3 header:

- loopback_xmit() parses L3 data as Ethernet: the "ethertype" comes
  from the inner IPv4 source address, and the decapsulated packet is
  dropped or misparsed.
- a real NIC transmits the frame without its Ethernet header.

(The __skb_pull() BUG this used to trigger in loopback_xmit() when the
remaining linear area was short is handled by "loopback: use
eth_type_trans_careful()".)

The Fix:
Parse the inner Ethernet header with eth_type_trans() in both directions,
then restore the egress data position and MAC length.  On ingress the
existing behavior is unchanged.  On egress, push the inner Ethernet header
back after parsing so the xmit path sees the original frame and later
actions see a consistent network header.

Conditions to recreate the bug:
- egress tc filter on lo: action ife decode pipe;
- AF_PACKET SOCK_RAW frame: outer Ethernet with ETH_P_IFE, IFE metadata,
  inner Ethernet + a valid IPv4 ICMP echo request to a local address;
- before this patch, no echo is received; after it, the echo is
  delivered and answered.

Fixes: ef6980b6becb ("introduce IFE action")
Cc: stable@vger.kernel.org
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
[edumazet: reworded changelog, the crash is now handled in loopback]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261028122703.2093730-6-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ife.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -761,6 +761,10 @@ static int tcf_ife_decode(struct sk_buff
 
 	skb->protocol = eth_type_trans(skb, skb->dev);
 	skb_reset_network_header(skb);
+	if (!skb_at_tc_ingress(skb)) {
+		skb_push(skb, ETH_HLEN);
+		skb_reset_mac_len(skb);
+	}
 
 	return action;
 }


