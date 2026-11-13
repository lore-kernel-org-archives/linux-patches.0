Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591209;
	b=RQatGqCMrQguo9o96QggZEgJx8gWclJTVVUwt7fL/zjrTq6r/h62gLiB7FYbBSKgT9Il
	 4FRrVKMuI6yZK/UWZmv3vsiaNSfZhcJPF3cT9Vpn3Zp02fwQg7e4ZxbeLv8a9099sg1Wh
	 GrwPJ1hNPRJ+mNP2zIo0nwmb03S6mBsZL3v3f921oqwzKSC/ReuLOsh8VCGE6RVPDk5WY
	 /rNPzoVwQaSxzi8GZVBl+Ia32O1K+u8H9/1NyHyNSyLWXBnwepHWiOgV5fQ9TAIir3jwi
	 wFnLAvaqSNQ/BOzLNAXgvjpkUO8PDB8zs9ZOOscj3GQnwUrEcsjEo7B8ROOGwryOjYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AP4ZKc0AVaItApYDhikqe0MiKHVG7edmpz1/44jGvEg=;
	b=vzkqMWTBcP/nriHhQbt0eNWPp9QpIqiQIN+x0c8j0dma/HbZIbSL1wbSx0QAMW7/9Xen
	 FGIsrum160sEvl8yrD3WLxrd9vJB+3Uxj6c35iWLj+HbENwDOq3B7Q8X4+lPmMPURGzue
	 8L3YhJ0GI7YPVyVPzZonybCqXk+KRsO6NGzaPU4jpR30dTTV3AK3OKSDH4EZczuzEAH5s
	 KBVHz68fBt5ObdkDgp6KaIQaW5WJvX1UAzxNPDnqmbAZ2CUMi80xw+VG5q3vAvBfDA0Gg
	 zfP16O4B/Qxu6U2WH4XWU9IpUVsb6tCGffj5R71E3sNpWcPJdLo4MOUeWqSLPGX/jWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e8AMWGfU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2A26075866;
	Fri, 13 Nov 2026 17:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e8AMWGfU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691A71F000C5;
	Fri, 13 Nov 2026 17:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591209;
	bh=AP4ZKc0AVaItApYDhikqe0MiKHVG7edmpz1/44jGvEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e8AMWGfU4SHoTiSQ4Zmu5ekxDd+Yfm6dQQt5QdjWvZ/xTkPZo6Sk8YwuR5bVNgtiv
	 oCV/sWZ3bSYuZykwYnueUKAWcaNA84LlSRGeAklQ1zPalU6SZX9XVNObPgCHUv2psM
	 EzdHkF2yeOcJTLFSmUDivckjGi7Yt7rDJuzHkADU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/670] net: reject a negative TCP header offset in qdisc_pkt_len_segs_init()
Date: Fri, 13 Nov 2026 10:48:20 -0500
Message-ID: <20261113153823.248385193@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 058965698004d..f42ec2837143e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3890,7 +3890,9 @@ static enum skb_drop_reason qdisc_pkt_len_init(struct sk_buff *skb)
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



