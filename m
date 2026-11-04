Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826947;
	b=TrDsnoaC//VLs0zBc3Ef9O8btLBAKMshAWI16dAetN5ma8goGo8li4dD/CNS9QxEwSWT
	 bA+w7d9azEO8DLe8P7pwyhFoVHVU3vLUK7Jv8JDxMxdTb1d/GKz08uj2iG2g2DT3f1Z95
	 yRdP6x4GBDbsG+8JjISrZQOM7MAU5fgr/IiHZNaIZiNKk7EWgZMnH5O2k+o5v2yyChHXE
	 99UpbgYgHWzNeAjS4HxxFVC/JnnDJ5jz6gaqclNVYL9kmJS0OJpABNWQs+SnkZcUqYTVZ
	 r1O+n0wG1vgluGCg/6odKSqjCQOy4RBxsByfryt5ArmW+SkCGaYg9PgRxHW8TL9vwKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/k3ILRHOX+J/9XEYPlJqFr0WiwZrNJ3jM/6WSHBx2mQ=;
	b=jm7yIv18MVYQ9SyNZ+WSLZine76z0UyRdxQLXp6UDlc4Uq1a1WIlmOycAh5wss1CEWQf
	 biF0m9Ow6SJuGDnJSEGDZlaH1/Im9MPgAizHDWm52ezBsiNaypXijSCO9o99GywHP07Yd
	 UIGMRuYdvUCzdFgx66YIy75no7yVIisgZb0LCWtzw29kn4soV1XBSdCXR0H8aRVwi1Bn1
	 syY+F7C7JBN4l6k9ss4EMfX3QYCZAZUagcfqaHkLh/46t3e1AHpRh+XOBiTjpq1bhXpWB
	 Z9pwDzx1wQwv4yAfMdwgyG3WXsuK2W5JBgMEZdMB7SKrmIMi7rLyZANX4rawRaFL5BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zrjx7h/J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE01607350A;
	Wed,  4 Nov 2026 21:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zrjx7h/J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D001F0093A;
	Wed,  4 Nov 2026 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826947;
	bh=/k3ILRHOX+J/9XEYPlJqFr0WiwZrNJ3jM/6WSHBx2mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zrjx7h/JahQRtHWbYpeZ5Le05+Z+PcX3kVZwej7ChAWvb2wB4WY2EHXqkKC5v8A5/
	 mCyTj1ZY8EdJ18x32tZj+vppSpCUar3KEjqJD6AnYHBzPq30IY9PWio/L4WHtE67v7
	 HonHzh/+Srqtm7B/i6FZIUvCvkI0973RroaAZy5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 103/547] net/sched: act_ife: do not consume the inner header on egress
Date: Wed,  4 Nov 2026 16:04:47 -0500
Message-ID: <20261104211041.145186200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
@@ -769,6 +769,10 @@ static int tcf_ife_decode(struct sk_buff
 
 	skb->protocol = eth_type_trans(skb, skb->dev);
 	skb_reset_network_header(skb);
+	if (!skb_at_tc_ingress(skb)) {
+		skb_push(skb, ETH_HLEN);
+		skb_reset_mac_len(skb);
+	}
 
 	return action;
 }


