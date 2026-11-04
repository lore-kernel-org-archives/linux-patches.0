Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831329;
	b=lSx6yOTT5cx8/UNRY/hj1h6uLfLenWoslcDRxl23k2JkBbMqZn9rUyQwBfPQS5WvGMTe
	 jcNekPcn+rNlnFBvu1tFO6wEKB4rPHJl3WFjX/RI9lYCFNetIDiJiUr6wYHSxZAkiwWmf
	 rGsaDAw3uoKX98iog5NpRN8sU9PeByD0dtiJjSgo3nSTdinjKPgsdchfQYAJVw6bomTFW
	 ANmRjPuThbrqoGVWcz2nCAbvXmhlQBL4hDwhx1WxKmuDAckozdC3eqGId8UtOlhTvY8aj
	 YoU5uqPjfRhy3PJykVydtlgciK6td86HVz7vyEKkk3KqmWDeUjSbykg+qrwD+HIQFhw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AAAve2uVBeeyX41Z/gSLwI/CjPGMAe3zxC+xybCqzcU=;
	b=1vLB7IrW3sWogyZ7ndMUaviT15mcy/k7255Dycm2Nr0khVwWS9hjKtMVjP32oC+pI+BJ
	 oiaDZpdr0fxkJJUxff5MXZaK3BH60AaOjVETSdHyfpByAtWhm85y9AwyXS+ZXoZJOQz5I
	 dlJ0km2D0bQ3HhJEHIFnUc9/kaYjYmcekqRtyQpdgBl+dZmLbVNMLkaE8wDRZDsvoLeH2
	 VEiK3R/3wRNEZymgTi57QHHoGz3MTYBPpvHKk47ha8dDEajTJjh/xwcenvhFYXjlAJSUe
	 c/q6xRcDK9y4osCVfoAM0qUY488WibToGGY4LigR/P49vPdzR7ERGmHWjNBFVFuc4dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JYTVtC02;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18ED1606D821;
	Wed,  4 Nov 2026 22:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JYTVtC02
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A71AF1F000C1;
	Wed,  4 Nov 2026 22:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831329;
	bh=AAAve2uVBeeyX41Z/gSLwI/CjPGMAe3zxC+xybCqzcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYTVtC02ouPuyxrjFfW0a1LlvTqvygjxS+gCogeudeE1lsl9QvcXeNXFDNXmFQAiC
	 Xv+R9T0XA1rLxffnDUbiBG507m7XpXj4gufXXq26pTZqhH5/T892OE1ToME0VxZWcM
	 Gc2FneweM8+Jsxwx+b5pLPO/vZbG6ALXZu71QF04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 0631/1005] net/sched: act_ife: do not consume the inner header on egress
Date: Wed,  4 Nov 2026 16:06:04 -0500
Message-ID: <20261104211101.461439576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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


