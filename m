Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704190;
	b=N7om1RrVXkx1QZKC2HNw7UsuqKMzTdVz3F4X/u6mV2P3cAI7Ht6hrF7JJifHhfLOfirC
	 MbV0q4w7jJji0hZ/zY3GuTc01z3eCIVQVblM5e6aNvcRgrX8i/kjcMjm8qoJZfx0TjxeN
	 xqIbgW4quEOnmqTS6kYi3HhDzYIZPrqDe5YBd87fPHwH3WbytPiBrJOvRyG9CQdnA4tQr
	 bgIrvBaTPaDyTzn72BU4WIAj6qPxC6BMTNOo6o95GJpdDnXw022s8L5k8kWT8A5HZhIS0
	 FMyqyo9qrhby3YQ++ROOaMbS1bVTum+lwoj/44wutdrRK6xeExkJMnferOpp2arli7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xuvWUHXKj9b4s/GN9The3MUDuW8p9emxo/FBrQUca24=;
	b=sajNfOBh0WHCyP0ls0tcWIXxc5ZTiX3aXy1R5z6nq/Q7V7p2Mo3jyL7KCO+DAH/QRebQ
	 FrInnCQybKP3MaT620L21/3CipFA7/Cx4KNiFN0EONQllyuOyc0VpV6re6HV6LKBkPIbV
	 aGr7YxWEqIqdQ18/zjbf3dfEoFH6mmNG3iKK5i5qYXUdGP7eWCcZ1Iey5HvjtxpnunN92
	 vu2W/dOLytjVVzNlRFNNU033nOqrng8DaNvbFgoICGrWH0j1nfZAkxNQ51s0qEmFKz9Rj
	 Rk66+9McIu0w6rlfRXPmnHBwzZu8UrrhpQ7q1F9jJkLsHHF4OKhfJF88wWeQfXYkciA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAtBv32l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C257606A326;
	Thu, 26 Nov 2026 14:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAtBv32l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D54B1F000D3;
	Thu, 26 Nov 2026 14:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704190;
	bh=xuvWUHXKj9b4s/GN9The3MUDuW8p9emxo/FBrQUca24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAtBv32lps7o/e2l1heWELy0IzDyF+rMjRbD6XgLKykmToafRxw2J8h5BXkIGZpzT
	 sJbxybnza5XxYoWvu66YuTI0nFuMJoXozmVoSJ/3TdxLj73uymXVCcRTwQ6otZKBwu
	 /wPYpzmL9Shnu/TOmPv+hA/LbyejVzuaHIZMXFII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/265] bpf: Reject non-IPv6 packets in BPF_LWT_ENCAP_SEG6
Date: Thu, 26 Nov 2026 15:36:06 +0100
Message-ID: <20261126143607.650938327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit 58e39f8d58b141b96c030008a20dde9d625ec997 ]

The mode BPF_LWT_ENCAP_SEG6 of bpf_lwt_push_encap() pushes an IPv6 header
and an SRH, and it replaces the dst. The SRH says that IPv6 follows, and
skb->protocol does not change. Thus the mode assumes an IPv6 packet, but an
lwt_in prog also runs for IPv4 packets. After the prog, bpf_input() calls
orig_input() of the old dst. This IPv4 handler reads the pushed headers as
IPv4. It can write after the packet data, and the kernel crashes.

                 after the push         orig_input() expects
                 ---------------------  --------------------
  skb->protocol  ETH_P_IP               ETH_P_IP
  dst            rt6_info               rtable
  packet         | IPv6 | SRH | IPv4 |  | IPv4 |

The mode BPF_LWT_ENCAP_SEG6_INLINE returns -EBADMSG for non-IPv6 packets.
Apply this check to both modes. End.BPF does not change, because
seg6_local_input() drops non-IPv6 packets.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-17-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index da6cf7ef22976..c58b4f8aa57c1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5738,11 +5738,15 @@ static int bpf_push_seg6_encap(struct sk_buff *skb, u32 type, void *hdr, u32 len
 	if (!seg6_validate_srh(srh, len, false))
 		return -EINVAL;
 
+	/*
+	 * The encap mode names IPv6 as the inner protocol, and neither mode
+	 * updates skb->protocol.
+	 */
+	if (skb->protocol != htons(ETH_P_IPV6))
+		return -EBADMSG;
+
 	switch (type) {
 	case BPF_LWT_ENCAP_SEG6_INLINE:
-		if (skb->protocol != htons(ETH_P_IPV6))
-			return -EBADMSG;
-
 		err = seg6_do_srh_inline(skb, srh);
 		break;
 	case BPF_LWT_ENCAP_SEG6:
-- 
2.53.0



