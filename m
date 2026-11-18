Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045633;
	b=D3JFH1aShZN7FGXrN2nixDrsyWXe5M7Krr+5q9kXPTh5DNAWN1xp3C46ElrGRJ2XDp1f
	 Skb2YfxVuk97s1HMJzeJuOYzaVHrJqdYZLksrGZFesrCJS/YD5xWTwFGcRKgTZcrfOg8D
	 0FE1rAahg41anGE1NypLb4pQmvs+PcJTD+By5UMMcIHCDPC/59BdyjDzVASMwys+RE0f/
	 bkHFoDlQd3qqeOW6ceHAK8xobgZOxX16O/OPtCEUu0gFSXnGFvo2j5WehkEVlfScLkdsO
	 eBUiMfTVvnEow+LfwauCSdgq9Gq5KCExHG7gC6RWEcHaqlOzsmnDMpnXnXc/uF52GDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bLYvNI8e+gRZwIVDMuIHlGir2OYKCz9BjtCloFVce+0=;
	b=tg7xDxcJ+w9MJR3Jib1fWodHYvs69aNq9CX0Dd3VgPfKcZju0nBtDCNJUyNDuds/VP1k
	 FWFDaKOxDD6vZrw01h+WLTaw8as9TpSqLRgCJSf+WkHGamyweXkZ8kWK4WmIAfAiFYlvd
	 zddiCnXLlqFQBAp78o4Qmra6sR3DkdPl5hAODblxctLAxUbHJhZiGF17MclRU9DKAIYDs
	 2gIwdQJh6om5PLCX4UNypZXMtSvC0aIeq5QcXveausRxoVoyFVFWZGwOcc6BSNNaEfw7+
	 6zy0pmg6CXeLoK8zlr4qSV1ZUyUh6WLILSzTLpewY6eza+s6yUCIR9uurvpOS02T6DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEYV8ifI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C06F606A325;
	Wed, 18 Nov 2026 23:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tEYV8ifI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89461F000C4;
	Wed, 18 Nov 2026 23:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045633;
	bh=bLYvNI8e+gRZwIVDMuIHlGir2OYKCz9BjtCloFVce+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tEYV8ifIq5hoYCWTEKhvIHSSefbbbI74lKLIswKnTDD9TxuNimVHvUmxeakZVc5yX
	 dFahr3VBeY3PsdRd727sqCBpmr37gIuTL9mnI4+xl0RQ0yBJgRAqmSD4DuSqLolS/a
	 +dWcGD7wOI+2QfJnIMlJlWeRiesDuWcc7penhDv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sorah Fukumori <her@sorah.jp>,
	Chase Hiltz <me@chasehil.tz>,
	Eric Dumazet <edumazet@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0994/2857] net: gro: dont chain linear parts larger than gso_size into frag_list
Date: Wed, 18 Nov 2026 15:33:48 +0100
Message-ID: <20261118150237.393816311@linuxfoundation.org>
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

From: Sorah Fukumori <her@sorah.jp>

[ Upstream commit 679f6929a66db9f5a6611dad37545fbd705962d5 ]

skb_gro_receive() chains an skb into the frag_list of the held packet
when its payload cannot be attached as page frags: when its head is
not a page fragment and still holds payload, or when its head and
frags would overflow the frags[] array of the last packet. Since commit
5eddb24901ee ("gro: add support of (hw)gro packets to gro stack"), that
skb may itself be a GSO packet whose linear part holds several
gso_size segments. skb_segment() cannot split the linear part of a
frag_list member across segments, so segmenting the aggregate in
software, e.g. when forwarding it to a device without NETIF_F_FRAGLIST,
hits

  BUG_ON(skb_headlen(list_skb) > len);

Fully linear GSO packets come from generic XDP. When the program does
not support frags, netif_skb_check_for_xdp() linearizes any nonlinear
skb with pskb_expand_head() and skb_linearize() and keeps its GSO
metadata. GRO on the device runs before generic XDP, so each aggregate
passed by the program carries all of its payload in a kmalloc'ed head.
A tunnel that decapsulates these packets and runs GRO again through
gro_cells then builds the bad frag_list. This was first seen on a
router that forwards TCP received over VXLAN, with a non-frags XDP
program attached in SKB mode to the underlying bond because one slave
lacks native XDP:

  kernel BUG at net/core/skbuff.c:4917!
  RIP: 0010:skb_segment+0xbb6/0xf40
  Call Trace:
   tcp_gso_segment
   ipv6_gso_segment
   skb_mac_gso_segment
   __skb_gso_segment
   validate_xmit_skb
   __dev_queue_xmit
   ip6_output
   ip6_sublist_rcv_finish
   ipv6_list_rcv
   netif_receive_skb_list_internal
   gro_complete
   dev_gro_receive
   gro_receive_skb
   gro_cell_poll
   __napi_poll
   net_rx_action

It reproduces with three network namespaces: TCP sent over VXLAN on an
IPv6 veth link to a router namespace that has an XDP_PASS program
without frags support attached to the underlay veth in generic mode
and GRO enabled on its VXLAN device, and forwards to a veth with
tx-scatter-gather-fraglist disabled.

A program with frags support in generic mode gives similar packets.
skb_pp_cow_data() rebuilds the skb with up to about a page of linear
data in a page_pool head_frag and keeps the GSO metadata, so once
frags[] is full the next such packet is chained through frag_list
with more than gso_size bytes in its head as well.

Refuse the merge when the linear part to be chained exceeds the held
packet's gso_size. tcp_gro_receive() then flushes the held packet and
the skb starts a new GRO packet as its head, whose linear length
skb_segment() handles.

Fixes: 5eddb24901ee ("gro: add support of (hw)gro packets to gro stack")
Cc: stable@vger.kernel.org
Assisted-by: claude-opus-5-5
Signed-off-by: Sorah Fukumori <her@sorah.jp>
Tested-by: Chase Hiltz <me@chasehil.tz>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20261013130250.3643916-1-her@sorah.jp
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index a5ce969c9f71c..bb0e87fb569c5 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -256,6 +256,10 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 	}
 
 merge:
+	/* skb_segment() cannot split the linear part of a frag_list member. */
+	if (unlikely(headlen > offset + skb_shinfo(p)->gso_size))
+		return -E2BIG;
+
 	/* sk ownership - if any - completely transferred to the aggregated packet */
 	skb->destructor = NULL;
 	skb->sk = NULL;
-- 
2.53.0



