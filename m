Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062063;
	b=SzM24Y1WWcQrXNhYTKeoDBCnyzjq5/d/Cfaf+JvrzLmX2kGdP1wqNaeO7O8EPWYn3R9B
	 JWnSPnaNFW+8vDf1KdkJRKMT7GfyjbVPdnS/8+9QqybB8IWtEkaJueO5vmMF5bJjoceyp
	 HmI+RL3H3oZajq+Zx0TLpFjjAfjswXF1SWM0SlAKQlGsIlPSpJY3yGiQziwbPWVi6ZHMp
	 XgFx5nAUdjbBCEUNKLmveEkTNFayB7WXnfxDrJpUF2rHuYB0erkY+hW9IGeBwSLZonTgd
	 YHLuseOiFbNEq1+Nx+Y4eXhBW0kylqGLhh5duAYQCv5PJl8XYlQaYM6ECejKa0LNdCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DzO1RxvhCLw+deKOB7fEftC4Z0gQJXlrEMr7LE+g2cs=;
	b=kG4nk4kAxoU4ERXxfGKkrU86GIYsLqbqzIIKuB4mX0DGdWwTNFQsrZavk4ZIV9eK9AJp
	 aGCCmoNcHxt324hFifXy3aEEVvnwx3hiB8AKdUyspan0UCFI0yqanEMO2tfROJjop7SOd
	 1QJO2yJ5gdZ2GzLJUmsNzhujSssUrij4EF0M+RwXnyjcX1i36kaxeya9OqsLC3TaCx4xW
	 Z9NLLcABH6EnPBh7By6OLv/UCY9w43eg0WRTBAsIS44MPxGPGC3ZKpQe/gZjgH4xsW+f+
	 x1ow82LX4nuqMY9ElWwuELp3S7ZVrUf8WQ4ly+Qj/MQuf/Qb7rc/of50LK0U3tX9N4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAXmVCw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65514606A326;
	Thu, 19 Nov 2026 04:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fAXmVCw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6FC11F000C4;
	Thu, 19 Nov 2026 04:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062063;
	bh=DzO1RxvhCLw+deKOB7fEftC4Z0gQJXlrEMr7LE+g2cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fAXmVCw08oxerrgW3HOieKw8EwNUCsNykSZLDBPSvbEwyqhuRgZyiATG/rbpjFJOb
	 3rGGE+OY4BZPewdEzAiZzEQ8PgDytya91L5n03+NzDSomIgvKqNGRvKdUVao0kWJaW
	 Xp67BNwXtivSSnE4rXQiKCrY+XjNXSJa2SaFl1KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Ilya Maximets <i.maximets@ovn.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1734/1848] net: openvswitch: skip IPv4 later fragments on TCP/UDP set actions
Date: Wed, 18 Nov 2026 16:02:52 +0100
Message-ID: <20261118150032.160326512@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 14c0350142ab0a10ebeefed03b779df23749e16a ]

An IPv4 later fragment carries no L4 header, but key extraction leaves
ip.proto set to the real protocol and the flow may wildcard the frag
field, so validate_set() accepts such packets. set_tcp() and set_udp()
then treat the first bytes of the fragment payload as an L4 header,
rewrite them as ports and patch the bytes at the checksum offset,
corrupting the packet.

Skip these actions for OVS_FRAG_TYPE_LATER. IPv6 later fragments are not
affected, since their ip.proto is NEXTHDR_FRAGMENT and validate_set()
rejects L4 set actions for them.

Fixes: ccb1352e76cf ("net: Add Open vSwitch kernel components.")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Link: https://patch.msgid.link/20261015124749.4694-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/actions.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index b23fd48105751..f5c91d11c503a 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -616,6 +616,9 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct udphdr));
 	if (unlikely(err))
@@ -659,6 +662,9 @@ static int set_tcp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	__be16 src, dst;
 	int err;
 
+	if (flow_key->ip.frag == OVS_FRAG_TYPE_LATER)
+		return 0;
+
 	err = skb_ensure_writable(skb, skb_transport_offset(skb) +
 				  sizeof(struct tcphdr));
 	if (unlikely(err))
-- 
2.53.0



