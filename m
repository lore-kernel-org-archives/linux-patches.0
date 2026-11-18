Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050102;
	b=aiS8jFHz8sLtcto4YuNk88Qgqut4Qlvg4TSfYBOZJyNcotgvhXnTfR8R7BfqFfT7W/NO
	 wvOeCGnE2yrh0DEfF8YZ5UsRoGiJY8WJ0A86vdnXvqSJdlV2ZGnS9Mr5/9a8Qu3VMMIWc
	 Y3wr1eJD5PILRSw8qPbvflNA16QuaTa2ij/hw06WPWQ1XoIg4wrZsCZaPHQkljACRUUda
	 r4s/Ytz1u+uzu9BYVF2i8esKehV6Pj5lASn4BtySKAIoOecoUd3BeT7uXzmM4GjAUk6UI
	 axPxXQFw2UNX7k2+6s2DAbGtKqliYzjj0yyijcqPtrhHJ/MvwrPaqjKgzt6SBToAvIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h0AczDv3S4UaaGhR3YxH9oD0YC75P3zKfTUGTHG+YvA=;
	b=OvMzFC54IaoJQihaeMT8cdR3A0wWYVgiQukzlivu922Q6XAu3nsmruNvs1fQQ9cIhYQS
	 H8oLnaN6f9zVTmhd8Zx4xgaIsejJddVlR41l92hx4mrL89FmAJ13WrzD5/cIhuy8w5vs3
	 plYC0KhAoglw5NIcK0dOC+Cipype8nnEOudgE5f6scn9JKFICCyzg9WX4GuasCwsT+9wK
	 j0CuhWIX0DNEPrnfyXCOYxRvFoHGVRQXa3hKrDMR7fDgek9OLP4ljPt5JCMhGDeLUl9bv
	 nWXIBEMbokvrZhb2roSUQ8YRjRspwz7Gu2Rw62RYc8luUXawTxxnx9u1ke1t2Ojad/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igA49JQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF00260A2600;
	Thu, 19 Nov 2026 01:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=igA49JQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2044F1F000C4;
	Thu, 19 Nov 2026 01:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050102;
	bh=h0AczDv3S4UaaGhR3YxH9oD0YC75P3zKfTUGTHG+YvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igA49JQLz9vo9JV5vh/8u+L1Ast38+nXPZ/OeSfs+YRmrURfHvz5v8JVK8+r5MxDl
	 NTn2QtQbVMUE8jVDMW7YJCw7726kNcFu1fZA4vNR0NApenqTxqg/Oo4ZE2Za2/hoHp
	 UHAa2RmCp01Y0wpdXr9C7eOY1FHZ4qLu2kmY94Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2589/2857] bpf: Pull the inner header for End.DT6 in End.BPF
Date: Wed, 18 Nov 2026 16:00:23 +0100
Message-ID: <20261118150334.749516922@linuxfoundation.org>
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
index 711c2846fe60d..a468e8d4773d9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6545,9 +6545,14 @@ BPF_CALL_4(bpf_lwt_seg6_action, struct sk_buff *, skb,
 
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



