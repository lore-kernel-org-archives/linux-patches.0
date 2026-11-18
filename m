Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050202;
	b=mkV4APUTLAG9hOoRvIJmfHjaI7QEqEGAwLjx+mRjPXk1msBBRX5gbLylKLd9Tcaw3IoX
	 Ar06ZYUhGzLXDfyD63cwHpzftVwOAbnkJe9cZ3inD/cTMAfBFnsd9KcFM6oBjf9J+KqUu
	 O+lAi1uOFqJWHqk4MyqAllGUPrqhId+y2Xw4VWnJ6wNYBPhNO1REjwDLcVaqPMiQUtw0t
	 AWzBnNzMzGIMnWrrjuugKn1rG3NoLC9p9zSMp+Fa6NuUkxYndyxpLtHi2FeavRYl4wI2V
	 mbfpYZEY4DHOTA3TOkYBIAJMWbXjfOUu+7YEv6iHahiRV0Patk7XtgLBI6YhnbPFfcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kX/OC8HnX+Y7tAbNpHucpW+tj2q2Ul/sBVyoHxJcZXQ=;
	b=YljwJIoqOv1xJbKcUO+qaRDFEnzM8nzT7K9d3M20hftze5Jx5Wj38tOTjGJb7pMfhSZM
	 ehIh318Msl3Wzyduo1q0K7KN/PYCiFznejPq9Dv8ZI4lrUjt6QwPS5ZEItCooGDdImQW8
	 HqFZDstc4dMPaDO9KBbOxjjy6XxoC+w87nj9/wfabSGUwHc3Yr4+Z/P/8P6VRu8pyo4yO
	 tLGwyrfmqKvCctd9qAzwYlVcs+p4DEuSkZk/1x6WMKDIkT6BKf431H8BXtlVKiVA3tVPk
	 n8ZdcFtZmMqo6UFtnlrtRKA+tw7ZweNgpps05/MyiQka5xnYaxA/hxIvEsqYgciQm7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1MRuLMq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98A1606A335;
	Thu, 19 Nov 2026 01:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J1MRuLMq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8271F000C5;
	Thu, 19 Nov 2026 01:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050202;
	bh=kX/OC8HnX+Y7tAbNpHucpW+tj2q2Ul/sBVyoHxJcZXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J1MRuLMqKla8yOSiH7mKUs+ip4wCPxfQm1rtBBA5AocMRmadSf2GF7bCHp1PhVGQz
	 Xfvp7LyXDOJ/o0sx3O2TGHzrKA6TvihIRe+W1xvXzj6ZGGP0gyEg4pLsBfydyPfRBs
	 naVtGme50YQQk+gvGKr2NhfD7LmrvxkbeIMWnjhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Fitzpatrick <bradfitz@tailscale.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2583/2857] gre: keep the UDP tunnel GSO type when completing GRO
Date: Wed, 18 Nov 2026 16:00:17 +0100
Message-ID: <20261118150334.508984234@linuxfoundation.org>
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

From: Brad Fitzpatrick <bradfitz@tailscale.com>

[ Upstream commit 718f364a20ecee4f25986789c25550cf4da73b4c ]

gre_gro_complete() assigns SKB_GSO_GRE to gso_type rather than OR-ing
it in. When GRE is carried over UDP by FOU or GUE, udp_gro_complete()
has already set SKB_GSO_UDP_TUNNEL{,_CSUM} before calling into the FOU
or GUE gro_complete handler and then gre_gro_complete(), so that bit is
lost.

That has broken forwarding of such packets since FOU gained GRO: if a
host with a FOU or GUE socket on the tunnel's port merges transit
packets and then forwards them out a device that can't segment them
itself, udp4_ufo_fragment() finds neither tunnel bit and fails, and
the packets are dropped. Since commit 3d010c8031e3 ("udp: do not accept
non-tunnel GSO skbs landing in a tunnel"), local receive is broken too:
udp_unexpected_gso() considers the merged skb, which reaches the
encapsulation socket without either UDP tunnel bit, unexpected and
hands it to udp_rcv_segment(). Segmenting fails, so the packet is
freed and counted in UdpInErrors. Either way, only packets GRO didn't
merge get through, so TCP over FOU or GUE GRE tunnels slows to about
one segment per round trip whenever the receiving device has GRO
enabled.

OR in SKB_GSO_GRE instead, as ipip_gro_complete() and
sit_gro_complete() do for SKB_GSO_IPXIP4. For plain GRE, gso_type is
still zero at this point unless the driver set it, so nothing changes
there in the usual case.

The assignment dates to commit bf5a755f5e91 ("net-gre-gro: Add GRE
support to the GRO stack"), but nothing set gso_type before it until
FOU GRO came along, so the Fixes tag points there.

Tested under virtme-ng with bulk TCP over a GRE tunnel between two
network namespaces joined by a veth, with GRO on the receiving veth and
segmentation off on the sending one, so GRO sees wire-sized packets.
32 MiB took:

                  before                  after
  FOU over IPv4   26.0s, 9658 UDP errors  0.28s, 0 errors
  GUE over IPv4   26.1s, 9686 UDP errors  0.39s, 0 errors
  FOU over IPv6   26.4s, 9860 UDP errors  0.16s, 0 errors
  plain GRE       0.17s                   0.15s

Forwarding the same FOU traffic through a third namespace with its own
FOU socket on the port, GRO on its ingress and segmentation off on its
egress, took 26.0s with 4826 egress drops before and 0.31s with none
after. On v6.8, before 3d010c8031e3, local receive was fine but
forwarding failed the same way (25.7s, 4764 drops).

With GRO off on the receiver, all took under 0.2s both before and
after. The gre_gso.sh and fou_mcast_encap.sh selftests give the same
results before and after.

Fixes: afe93325bc02 ("fou: Add GRO support")
Signed-off-by: Brad Fitzpatrick <bradfitz@tailscale.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261011-bradfitz-gre-fou-gro-b4-v1-1-df713aad1531@tailscale.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/gre_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 2b9cb5398335b..d1405f3e2a0f0 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -241,7 +241,7 @@ static int gre_gro_complete(struct sk_buff *skb, int nhoff)
 	__be16 type;
 
 	skb->encapsulation = 1;
-	skb_shinfo(skb)->gso_type = SKB_GSO_GRE;
+	skb_shinfo(skb)->gso_type |= SKB_GSO_GRE;
 
 	type = greh->protocol;
 	if (greh->flags & GRE_KEY)
-- 
2.53.0



