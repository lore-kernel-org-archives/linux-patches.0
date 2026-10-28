Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213402;
	b=A//n6KCrv0c0xxGzODQoRq2XwhGNNl4/ZWO/RPsm/1SWXdrZq3IbrQpGaVlyxuaPwKru
	 KJqWs+mUohFdkh5x8DPRC1Kn8EZxZ6iGU6uuRYuH7z6OoS7W1UJ++ML7cKwlFYDtYVHRS
	 k36+3VP76j2kBzC6x2KO7VCZ6FSmY0bE99DRjTTC+NJouROt+1hTiO22D7bKTtqpuJJ+C
	 RQc2Cwaua54zy8Jta3K3sCkoz+nsvpTR+dM+WjfbuWhJ+7vcj18iZuVHy8dz082DLR6bb
	 WGVc5nOBDeIK1JvN0M/ReAoX2DmgVr2pbmMfbqSl4uQELEQMauWYtXQglR7Z2fNtCyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3iCKK3Qli8Bep3NG3AR02tMKHhfKo7boh6r0VQqwqfc=;
	b=08bsl4VdvZzei1xhF+raoXku7wkiAgotnNIYm7shY1fjbueID3g6nw+BCj8uuKrlZjRv
	 IjusmF4NE8ho9V6OcP1QtSu9utAMsr3PffpW4tRxi5ia0setID68A3xTZkHc48xojWuir
	 iIdDL5LK2vNJ3ESd19AwpjNZ7uDUv5iWZjr/lBlKeIdAp+MD59xez36cz4KUp6aPrB1kf
	 6k8x5OX7utmzA67ZRbyEB/9OlA0EVwg6qgteYWsiq1NVIoME4lmkO4eaQbaqsVT6OowRw
	 hIDUbDbo7sgMjdB2CAYGCYd/dCn3H7mPr2DXV7kPiksEMVdHSq8b94sUxCT4QJCQK0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukrbpmW5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E599606A325;
	Wed, 28 Oct 2026 18:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ukrbpmW5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBD01F031E2;
	Wed, 28 Oct 2026 18:50:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213402;
	bh=3iCKK3Qli8Bep3NG3AR02tMKHhfKo7boh6r0VQqwqfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ukrbpmW5n1AXuPgK8ir1tbNobTqSPAD0n5IKeNYNDRJ+0dxJOfjsE5TSvBFtXmGmi
	 lKOWh5U9pErygixqhppU2diifF43gSrOVh2ZDGfPLFtsVcWw7VqQMghHFtebIZdzkD
	 Rq/0N4+enqWhWANwdhH7yzVAdjjiTp6INf1vct6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0494/1887] flow_dissector: avoid u16 truncation of skb->len when computing thoff
Date: Wed, 28 Oct 2026 17:43:10 +0100
Message-ID: <20261028170510.521019913@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 99bda1ecbd56905f8bd934b9cdccd3bd251192b1 ]

__skb_flow_dissect() computes key_control->thoff using:

  key_control->thoff = min_t(u16, nhoff, skb ? skb->len : hlen);

min_t(u16, ...) casts both arguments to u16 before comparing them.
Whenever skb->len (or hlen) modulo 65536 is smaller than nhoff, the
truncated length wins and thoff is set to a bogus small value, even
when the dissection succeeded. For example, an IPv4/TCP frame with
skb->len == 65540 and nhoff == 34 gets thoff == 4, so callers such as
skb_probe_transport_header() point the transport header inside the
Ethernet header.

Such skbs are not exotic:
- At the time of commit d0c081b49137 ("flow_dissector: properly cap
  thoff field"), AF_PACKET with PACKET_VNET_HDR could already build GSO
  skbs larger than 64KB (MTU checks are skipped for GSO, and
  alloc_skb_with_frags() accepted up to MAX_SKB_FRAGS (17) order-0
  pages on top of the linear part).
- BIG TCP now makes skbs larger than 64KB common.
- The following patch makes tun_get_user() dissect IFF_TAP frames
  before eth_type_trans() pulls the Ethernet header, so a GSO frame
  carrying a 65522..65535 byte L3 packet will be dissected with
  skb->len in [65536, 65549].

Compare as u32 instead. If the resulting offset cannot be represented
in the u16 key_control->thoff, cap it to U16_MAX and report the
dissection as failed rather than silently returning a wrong transport
offset. thoff is still set on failure, as some callers (such as
eth_get_headlen()) use it regardless of the return value.

Fixes: d0c081b49137 ("flow_dissector: properly cap thoff field")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261001191140.2818991-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 12216a5710a92..a51c8930f6d0d 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -969,6 +969,7 @@ bool __skb_flow_dissect(const struct net *net,
 	int mpls_lse = 0;
 	int num_hdrs = 0;
 	u8 ip_proto = 0;
+	u32 thoff;
 	bool ret;
 
 	if (!data) {
@@ -1575,7 +1576,13 @@ bool __skb_flow_dissect(const struct net *net,
 	ret = true;
 
 out:
-	key_control->thoff = min_t(u16, nhoff, skb ? skb->len : hlen);
+	thoff = min_t(u32, nhoff, skb ? skb->len : hlen);
+	if (unlikely(thoff > U16_MAX)) {
+		/* Cannot be represented in key_control->thoff. */
+		thoff = U16_MAX;
+		ret = false;
+	}
+	key_control->thoff = thoff;
 	key_basic->n_proto = proto;
 	key_basic->ip_proto = ip_proto;
 
-- 
2.53.0



