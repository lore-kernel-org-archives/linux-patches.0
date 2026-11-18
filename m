Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042474;
	b=4q7lL4DX9MWWU5CoIhiYte8QARZikFKfiBv0LVxJwpRi9OTnFo4nQSv5JW8nBSkAIYGN
	 yFyXsda/zTfXSxvcW6bWS/7f2sHmkaSEOW9cPrOo93QyOo9h23T8Jb2/ChO9HRxwzfNCq
	 +0+uYtoqcmApJOL+jhivQW0dYOiAly9FUdoUrHiy2jN2TLycXKFUDOFqWsMkjY6fbePEB
	 B4fTR+X+mZH0GYHSA1WiTRHB3MQZECqqkV+5JTP32IYXOECpWmAxTIH/o2LpO6lmUVvhP
	 SrlNN6mgXiTUprlFYHDaitjfgSS/g1Z9Ta88hIieYjHBNLuw9BKZk0p85HghSC5UiTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=34hsotQOqv4y0xXyY76Z9292BSqnUcTSo+FJbtMNx2Y=;
	b=nw2AoHt9qYwo/4wSHvecRK53yFZmGNlsdwHXTifJld44xJIiXkVInsT4CASfNzcwadOI
	 D1Ofzo1vMaHQCBARgMUGYsaNBlAI6b+MJMpReapnDS8zGAjjUzwpK/uzrKqmBu+91j2La
	 8m4IwTNVD9s9JnQW1vAWodMeuW4lgWL4tUJmLwNWwouZ7ERaYCvXqiKVlVmCTNWRr1XIX
	 0HiXw9xhRB8z0NSFTq86en3cgrsajw1pp6ApC2+b6p7CaycnmKcW3ks9wxiPP9XZjkb7d
	 ei/IaQzq/NLsqLMlBqL/pM/o7Vj77+9/LHx2y+cUhcs6R6ZEWUrKcZjuj3ajWGRjP7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uYPxCEfZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBE5606A32C;
	Wed, 18 Nov 2026 22:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uYPxCEfZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3AD1F000C4;
	Wed, 18 Nov 2026 22:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042473;
	bh=34hsotQOqv4y0xXyY76Z9292BSqnUcTSo+FJbtMNx2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uYPxCEfZxVY/IurE+AumYnJvhSAMUnwwmGeVmrtdFuOs5Hz2/Sr7WQ8iRWHo77uvX
	 VCs+B1Z2fkIsLnV7U2g81hYA0qmdNBYR+Vd99VrV4Aq3IjslU/qwFBjLkoA+EntGhO
	 96gvgXEF4UhiahcnWhJNL7Iu5+wFeBHLko7GFLT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3183/3318] pppoe: drop discovery frames with no MAC header
Date: Wed, 18 Nov 2026 16:03:25 +0100
Message-ID: <20261118150455.299897024@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 406bf2dc8d6d3e93fdae0b66d2ae99b6b62e479c ]

Commit 8540827ebac6 ("pppoe: fix reception of frames with no mac
header") drops PPPoE session frames with no MAC header to avoid reading
uninitialized memory.

Apply the same to PPPoE discovery frames, as both functions read
eth_hdr(skb)->h_source.

Found by LLM static analysis, and reproduced using the same TUN
injection as described in the mentioned commit.

Fixes: 8540827ebac6 ("pppoe: fix reception of frames with no mac header")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261023080002.221332-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 1bdcedb5ce1a6..ed23f0bec5d67 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -496,6 +496,9 @@ static int pppoe_disc_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->pkt_type != PACKET_HOST)
 		goto abort;
 
+	if (skb_mac_header_len(skb) < ETH_HLEN)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 
-- 
2.53.0



