Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041958;
	b=QyyDsua5pnIcKViOH2NQsIR80N3Oeqbr3vRF0+tp/GC6mVtP5ECEDkrlwCBu1pWZuAGn
	 ZUD5jCEz5RubVwSp+WkRYOirisKdOjOiKDOqXBhlt0aMRaMTxuVoWupK9Ra+uUeFH9NfL
	 c+DwdaIVMt/aKON+IgNe004fyGxOuxPWwn+ae+nZA0JNUD8WIqCx6p6TY9pGRD5hUJEqc
	 jvwnez7lfFNtnqxXiNtORYbma9jmE7T7KNdWgItP8vCmv79NZtD1AbONtGwuM9RXuH2ct
	 O/Sct3Jj+TNxKXFwHlr62myT2zeHrYceO04+qbJJeaS8hvJkZkLIUzUhkYS4cagIO7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tiUnuVGbvJFKjY1iRNPv7igCZ4HRvTLiWP3Ps9Pk8Xk=;
	b=Hvo0vVhGecHV8E/YmUcUElU3JfBw2SbE7HxI5nXmiAvEwLSSrEF9hT8abDvlAFgZSKZc
	 Wb95yH0flPzlQPfSaTr7wyE7Ja11uFLrwiogNMKqL+yBAI3DxwHo4/Ymszun8GeCgl05K
	 AGrb8OyNSRl2Pn3mRfG7xvkhb3gYIb3KZ8fIAUwkP+mucnuhuVxW0cR5SH/ZAgOHRJhrG
	 DlmvD0SwxcQx/8TmReJyjYyUkebn3gAdp4O9i3URYxZlThrZerZsvuI3PlISBYC1RDlkw
	 KzBIJid5m3U2I2wjq0yLmwylCnftTgy4P5Eden/3rCzz/zlB1AuaI2TbJ+92HZutGmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQl154fo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3167060A2612;
	Wed, 18 Nov 2026 22:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cQl154fo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841A61F000C4;
	Wed, 18 Nov 2026 22:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041958;
	bh=tiUnuVGbvJFKjY1iRNPv7igCZ4HRvTLiWP3Ps9Pk8Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQl154foOsU2xarquBua2WURYCLafJh5MTlZ4KWZsG8g1olMmPsVtaWoQW6kFE6kZ
	 kI0NzSNjmSTGQpF3lEWsD9wUgxeUOrfj5upJKanfnQoSNYACkxle5mLEUrRbTWi/Bz
	 4wAAuN6ttnxXZvQb+eEaIfBmToNhnRzcC3NqWD94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2999/3318] bpf: Pull the inner header for End.DT6 in End.BPF
Date: Wed, 18 Nov 2026 16:00:21 +0100
Message-ID: <20261118150450.232176299@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 434324c611a98bc76dc850d45d67756dae5622cf ]

bpf_lwt_seg6_action(SEG6_LOCAL_ACTION_END_DT6) pulls the outer headers off
the packet and hands it to seg6_lookup_nexthop(), which reads the inner
IPv6 header at skb->data. Nothing says that this header is in the head of
the skb, or that there is one. If the head ends with the outer headers,
the route is looked up for whatever lies behind the head, and the packet
is dropped or leaves by the wrong route. If the program then pushes an SRH
with SEG6_LOCAL_ACTION_END_B6, seg6_do_srh_inline() pulls an IPv6 header
off a head which has none, and __skb_pull() hits its BUG(): the kernel
panics on a packet from the network.

GRO pulls the inner header of a plain IPv6 in IPv6 packet into the head. It
takes a packet which GRO does not look into that far, one with a fragment
header in front of the inner header for example, or a device without GRO,
and a driver which leaves the inner header in a fragment.

Make sure of the inner header together with the outer ones. The program
goes on behind an error of the helper, so do it before the packet is
changed. A pull which fails can still have moved the head, so look for the
SRH again.

Fixes: 486cdf21583e ("bpf: add End.DT6 action to bpf_lwt_seg6_action helper")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-13-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 432856e47f61c..0e50d1eb146f9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6623,9 +6623,14 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 
 		if (ipv6_find_hdr(skb, &hdroff, IPPROTO_IPV6, NULL, NULL) < 0)
 			return -EBADMSG;
-		if (!pskb_pull(skb, hdroff))
+		/* As long as nothing has been changed, the program goes on */
+		if (!pskb_may_pull(skb, hdroff + sizeof(struct ipv6hdr))) {
+			/* but the head may have moved */
+			bpf_update_srh_state(skb);
 			return -EBADMSG;
+		}
 
+		__skb_pull(skb, hdroff);
 		skb_postpull_rcsum(skb, skb_network_header(skb), hdroff);
 		skb_reset_network_header(skb);
 		skb_reset_transport_header(skb);
-- 
2.53.0



