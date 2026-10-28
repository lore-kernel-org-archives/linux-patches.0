Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215083;
	b=d2F+TE5HLucEO7CU7K4ejCtL9lP2Ey4sRWG8Ih6nEyA72iSa/4vRtxcYDl7s33uujD62
	 Jdlpyy9AYv+DA6Ulus28Tw5n/lKp1q2aoLRokXwtUxyY0fxyuaIkp9ihCT1X4eECkjwBq
	 LblreGJpgDQBkAvFqe6mhVOVdtdTjr2TymSJTrhNuMyTWP0McVhE8NkB1D1tAZa02EaID
	 35/2vpcjfU7b2epeV4uRxr0Wbk7yPVeveDrUAMX2SzkaH7f06rpJc24SxB4+Mqm/xCaCf
	 0evryyfViP/KbiZh5MsmqAYYtkmUjg4VY5Qp4mCYgHwALvgqGHksxE+KDLePOTDYfgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGiyc66baiIqcI/7vFiEYc5Uw/xOnkhZVyHsuAxqUVo=;
	b=kPrWoHKxlhklBhpduXDxqpzjo+6ZGLXUxfVNkWfgYXrx8e7pSYFIJAuuGRd3s7bB/Iwp
	 Tib4ce3BULs74rCMDLBkl2ysNWSI/mnjSaaHAuhaA7fVL6mgyuorbssQbF7+bvbUtYH1z
	 61okkcszcYpmeNBNfXAcebETOIAbQjMABVjCXJi+uiPcScvAnCnmRx6ZyupPbxXLGvzGD
	 DgKCRJH/ljbX0Jyb94tUiQWzQ5k+5guVbvUMXD6qNjKihBX2u0bG1yXAYJJhGKuRL2kJH
	 D4ZAyAeAFeafjLr7XYvJHA9wXjk01hl4thYGV+za2RYhQzyn/Jpv5zNu7koVumvZQ0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmX3aOxm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F85606A31C;
	Wed, 28 Oct 2026 19:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dmX3aOxm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280DC1F01825;
	Wed, 28 Oct 2026 19:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215082;
	bh=gGiyc66baiIqcI/7vFiEYc5Uw/xOnkhZVyHsuAxqUVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dmX3aOxmnTCLnFJ7EhpUIJcK6NhhstkK/T7HHSpRIIBXTX4bNGq0WlARn//yHjHyC
	 pb9cxQIV/A+cPTJ/Ng4G7hpxmY9GdaIeOfb8hZLHoREIudH5etH5VBBMSTD1W27XbM
	 1U1+p9XQpI2zl7rHb1TVUTX6IlL8g/dCzx/nTDmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1084/1887] sctp: disable BH before calling udp_tunnel_xmit_skb()
Date: Wed, 28 Oct 2026 17:53:00 +0100
Message-ID: <20261028170524.074724560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 2cd7e6971fc2787408ceef17906ea152791448cf ]

udp_tunnel_xmit_skb() / udp_tunnel6_xmit_skb() are expected to run with
BH disabled.  After commit 6f1a9140ecda ("add xmit recursion limit to
tunnel xmit functions"), on the path:

  udp(6)_tunnel_xmit_skb() -> ip(6)tunnel_xmit()

dev_xmit_recursion_inc()/dec() must stay balanced on the same CPU.

Without local_bh_disable(), the context may move between CPUs, which can
break the inc/dec pairing. This may lead to incorrect recursion level
detection and cause packets to be dropped in ip(6)_tunnel_xmit() or
__dev_queue_xmit().

Fix it by disabling BH around both IPv4 and IPv6 SCTP UDP xmit paths.

In my testing, after enabling the SCTP over UDP:

  # ip net exec ha sysctl -w net.sctp.udp_port=9899
  # ip net exec ha sysctl -w net.sctp.encap_port=9899
  # ip net exec hb sysctl -w net.sctp.udp_port=9899
  # ip net exec hb sysctl -w net.sctp.encap_port=9899

  # ip net exec ha iperf3 -s

- without this patch:

  # ip net exec hb iperf3 -c 192.168.0.1 --sctp
  [  5]   0.00-10.00  sec  37.2 MBytes  31.2 Mbits/sec  sender
  [  5]   0.00-10.00  sec  37.1 MBytes  31.1 Mbits/sec  receiver

- with this patch:

  # ip net exec hb iperf3 -c 192.168.0.1 --sctp
  [  5]   0.00-10.00  sec  3.14 GBytes  2.69 Gbits/sec  sender
  [  5]   0.00-10.00  sec  3.14 GBytes  2.69 Gbits/sec  receiver

Fixes: 6f1a9140ecda ("net: add xmit recursion limit to tunnel xmit functions")
Fixes: 046c052b475e ("sctp: enable udp tunneling socks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://patch.msgid.link/c874a8548221dcd56ff03c65ba75a74e6cf99119.1776017727.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/ipv6.c     | 10 +++++++---
 net/sctp/protocol.c |  2 ++
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/sctp/ipv6.c b/net/sctp/ipv6.c
index 3b07b9f5d7525..01fefac2f6e71 100644
--- a/net/sctp/ipv6.c
+++ b/net/sctp/ipv6.c
@@ -227,6 +227,7 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	__u8 tclass = np->tclass;
 	__be32 label;
+	int err;
 
 	pr_debug("%s: skb:%p, len:%d, src:%pI6 dst:%pI6\n", __func__, skb,
 		 skb->len, &fl6->saddr, &fl6->daddr);
@@ -263,9 +264,12 @@ static int sctp_v6_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
 	label = ip6_make_flowlabel(sock_net(sk), skb, fl6->flowlabel, true, fl6);
 
-	return udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
-				    &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
-				    label, sctp_sk(sk)->udp_port, t->encap_port, false);
+	local_bh_disable();
+	err = udp_tunnel6_xmit_skb(dst, sk, skb, NULL, &fl6->saddr,
+				   &fl6->daddr, tclass, ip6_dst_hoplimit(dst),
+				   label, sctp_sk(sk)->udp_port, t->encap_port, false);
+	local_bh_enable();
+	return err;
 }
 
 /* Returns the dst cache entry for the given source and destination ip
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 94878fc63f07b..76a5825d427ee 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1078,9 +1078,11 @@ static inline int sctp_v4_xmit(struct sk_buff *skb, struct sctp_transport *t)
 	skb_reset_inner_mac_header(skb);
 	skb_reset_inner_transport_header(skb);
 	skb_set_inner_ipproto(skb, IPPROTO_SCTP);
+	local_bh_disable();
 	udp_tunnel_xmit_skb((struct rtable *)dst, sk, skb, fl4->saddr,
 			    fl4->daddr, dscp, ip4_dst_hoplimit(dst), df,
 			    sctp_sk(sk)->udp_port, t->encap_port, false, false);
+	local_bh_enable();
 	return 0;
 }
 
-- 
2.53.0



