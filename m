Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061474;
	b=IsGnEZFPivnbZAmMHLLnhI6wqZO6h8QwovPeEWtFQeqRTGDwhId4w9JKkj0jKWVygcqU
	 lNnySuIWWlaKy3unebJ7WHyn5RmgAUhmFTL4AdxrM2/0Tuh7RxGcibqSQwCAI2BXQvM/Y
	 jqNzPZnv0uxGCCHiCTpyx0JwWZwXNhkERYVwzwo+txM4KSPNMrAchC1gijW2NLVHA15j+
	 p7ZQTTpffL3EBOP//CTYxs+p1rBwNwkGQwa0crnYtAooj9VmA6E8xGT4vTnMoUDtlHdjJ
	 tr+DcGmY3A+kIhRjb9A3+RwzBLWiA0XypcBF6R4IizwiwOX93XXFekIc0XspF48MFpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9s96rBKINuYXTbDM5VqMYUrKm4ISQ39ladudlsAgWgo=;
	b=EGKCnbV2HLHLvTjIworTvHTy+am9fS6EHk4GccLNwYVbci/4MmeAdvyxLmw/SpCNUxLc
	 mdc/wG7qoumzL7wNoyl0qzL5cskm0aF052zAOIv2/1HSRtyY8QqdPozWjuDiJuxDD2V/b
	 3c5QHmxkYZ1KKg7xHk3zkO2EqO6Dr/AXjf8pg/adKFn1/qbTecC5s6apISf+6xsaNXxgr
	 gGeTwbeP3AJa8/q9kvRb4Gy24/5lRYTuOFadeYK3tnBmkO8UpJ1ykbHq1rXy0lxU8NVkx
	 LBZb2NkOn3jKwlaRoWCmk9VFQpJQ/gb260MbylQqvM8GsWG3KBif6kQuxmH0zpB3nPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gpz0x8IQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5525606A331;
	Sat,  7 Nov 2026 14:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gpz0x8IQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755081F008A1;
	Sat,  7 Nov 2026 14:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061473;
	bh=9s96rBKINuYXTbDM5VqMYUrKm4ISQ39ladudlsAgWgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gpz0x8IQKoJxMaO0qQbVB26I6apunN39Y6msrGVFap3aZJghu73VV1jwqT0ucb6Mk
	 hCHsLSoExTlvuPtVH/ceWjIEiOTvH0FyOCWBpS5mQQ+lBW5w0rNTLNXf6YPkHZ+Ivj
	 LtwCUfF94Kv2dh+rRIR/JOUH5YT8zQ8USVBtiQpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 0573/1536] net/sched: act_ife: do not consume the inner header on egress
Date: Sat,  7 Nov 2026 08:43:09 -0500
Message-ID: <20261107135013.660876446@linuxfoundation.org>
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
@@ -762,6 +762,10 @@ static int tcf_ife_decode(struct sk_buff
 
 	skb->protocol = eth_type_trans(skb, skb->dev);
 	skb_reset_network_header(skb);
+	if (!skb_at_tc_ingress(skb)) {
+		skb_push(skb, ETH_HLEN);
+		skb_reset_mac_len(skb);
+	}
 
 	return action;
 }


