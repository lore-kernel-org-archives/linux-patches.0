Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037802;
	b=TPWrNc/EluBXgeeus4Hvk1oaiz5N1a1/k6DjDXJvmBj19HuvtfBKphlMFrO+6sxMz+T0
	 QN8OmK1cEDR6I/I1zD34Yo1G/si4ZnhS3/WanLaVXwOIjpCzYYfQZgjR1iMXoAjhG+MTn
	 mQIAUauLRmaCc5B6/zpSyIkUOHdnMszIuUM/HogRkY+GlV+CoSHYcPW6xiuLKuA8mlziC
	 YIDGmOTc40g5Sx2C7zo9QyuYKXJBYujDSZF2dlTgk/XYQxWj/5cVi3B+Ti/1WTcW7q7xQ
	 YOMyix8TYyp6cOgvxVpEugp/MvTPcwmI6G47pmLZtRt9bysb1bBnXePUQAgadB1522Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iuHAmiu/UDe5QRLKJxcr8c8Md01xCirb9iCm0yNbnlY=;
	b=04NXcDJ7H9MvZ40gjhnzXNn2/E3w7EKvZBTvOgsZoaB/3qEe9HRpDJh7o7wkz2L1yF9U
	 8UFz+l2lim/EFPxYGpJV86b/6W/k88LZcEWbY5N5FjSqGrK85sXYDsBYNk4AARhMEHSME
	 9/lXCnVgsmbQeNM9vc7/jeO52g8gQl1hX8XQz2s0TRxnLmOyF/GG8tqYdZou1VhYWwxJW
	 PqRlVx3z7iWMxKnLmFQN991ziTa0R72Cfga671WvWaZouauWI/D3xrmzp5Qdy8w5xCMol
	 vwyAWfOePeGDUYtzw0sMLAzpmtTIKs5Ik0ME4eGGULinKVjYKopmB2EMJ4oGQAi+uyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3YI2+as;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB6D606A325;
	Wed, 18 Nov 2026 21:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p3YI2+as
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25DF1F000C4;
	Wed, 18 Nov 2026 21:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037802;
	bh=iuHAmiu/UDe5QRLKJxcr8c8Md01xCirb9iCm0yNbnlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3YI2+ascF+JuQjimFI75grtX/ZB1uom824SXhGaD7yP0dweo0H0c9cpCVljvUvdA
	 f+KsbSAYjpvPd3utuSopbSVVzkLGC2rDDEbLbSPcoFYBqlNX2FuJIfmaWlxUVBoQta
	 /KgdhziyiMp2JIjHp61ShZC98Sg4Wsk9TRglTNss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1524/3318] net: reject a negative TCP header offset in qdisc_pkt_len_segs_init()
Date: Wed, 18 Nov 2026 15:35:46 +0100
Message-ID: <20261118150406.680109794@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 35d2d6e5ac0d22428b2a0216061f3330c095393c ]

qdisc_pkt_len_segs_init() stores skb_transport_offset(), or the inner
offset, in the unsigned hdr_len. A header in front of skb->data gives a
negative offset. For an offset a little below zero, pskb_may_pull() gets a
small length and succeeds. Then a 64-bit kernel reads the TCP header far
after the skb and can crash. Further below zero pskb_may_pull() fails.

Commit 28a57fb2c5df ("net: iptunnel: fix stale transport header during
tunnel decapsulation") fixed one source of such offsets. Other code that
removes bytes from the front of a packet can leave the same stale header.

Return SKB_DROP_REASON_SKB_BAD_GSO for a negative offset in the TCP branch.
SKB_GSO_UDP_L4 and the other GSO types read no header and still get a wrong
qdisc_pkt_len(). On a 64-bit kernel only packets that cause the read after
the skb today get a new result. Then __dev_queue_xmit() drops them and
returns -EINVAL, but sch_handle_ingress() ignores the result. Their content
can be valid. Thus the code that leaves the header stale needs its own fix.

Fixes: 7fb4c1967011 ("net: pull headers in qdisc_pkt_len_segs_init()")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/20261101194433.2637113-1-alexei.starovoitov@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3c533479b45f7..61dfbfd283634 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3849,7 +3849,9 @@ static enum skb_drop_reason qdisc_pkt_len_init(struct sk_buff *skb)
 	if (likely(shinfo->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))) {
 		const struct tcphdr *th;
 
-		if (!pskb_may_pull(skb, hdr_len + sizeof(struct tcphdr)))
+		/* A header in front of skb->data gives a negative offset. */
+		if ((int)hdr_len < 0 ||
+		    !pskb_may_pull(skb, hdr_len + sizeof(struct tcphdr)))
 			return SKB_DROP_REASON_SKB_BAD_GSO;
 
 		th = (const struct tcphdr *)(skb->data + hdr_len);
-- 
2.53.0



