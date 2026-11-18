Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037090;
	b=hRyzhNvbSfX4joDvYXbptyTxtfpg2Tt4jmBr7b6Ky8VDKvMYL7fJEC+PKAecFcCoyzna
	 cAbt1OMrtGKLCnEmTiqDE5JeLKVbGg1VkQaBWDfrR/tR3ZYqYvAQ+rZWjxVY2+9Niu1VH
	 FN8XWC3hoBJlRZ2zC2JUco708BEBXbqLAY1fQ0kDT6yv6ZGDZQv7T5EMF11hq6YMSDAe4
	 fV1NRd9D+LHXC0Kv/4V+Z+lmT+SYHsyZHRwv+eolzc9c7M1USDe3N+qgJ/HivlS/wY3rc
	 g7CnCr/I6D2sYPzAhwJXVRQXkSAzU5TSLD8B5zpH4JW40kEJ/njwrluMAfLN2bF8d9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037090;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xME+K8/HHqVZVo1Xv+xtazGmYqtQsrFdeWkFp1HLJII=;
	b=QPN99+o5IdVk7dRDLugHcnGgisqXycJsYTT96n0EC8oqvBsbod0a90ZEjt8n67b51Nwq
	 8kPIRITPdpUtWW09M0PDlpHQzM/c+WA74xXcVDKzkLbVAPXv/TjsD4P6ag/3HtWb7ar9A
	 IeEAt/r/2kwP8OHjJjgnUU05DM76wUrSIqg+nyrphSRRct3MHFYA2PDigMPyzXlWUjbzq
	 +Mr9CYfnQ87P0EwdsT/X3iBrgS1gwvy6mPmdTgyWK6i7PfgcJ7TOCGdF3x6FNQkVTMh1N
	 eNxFxvsYonp1HaDLDItldadKKVw6bSgsA2jXCwkTz4I+BgQdIFeTfJh7MKNRYCAeRWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwHgHxlW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9889606A320;
	Wed, 18 Nov 2026 21:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pwHgHxlW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E1971F000C4;
	Wed, 18 Nov 2026 21:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037090;
	bh=xME+K8/HHqVZVo1Xv+xtazGmYqtQsrFdeWkFp1HLJII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pwHgHxlW8k42cMno+bmG9FZZG/lrum1tVle8RaaaMoKeLLZ7yuruMx81vLHIgr0/4
	 ANvd8Jc+gj48msGyLLiG8hQl1hgoxm7VTO7PFT5F0ggmYbEzpCSRQa5IxWfG8mNWE8
	 q75lLrIv5n0tdKdgelEtqD2G08CwoHEEeJ/KmkDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <netdev-bot+sashiko@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1248/3318] ipmr: fully initialize the synthetic IP header in ipmr_get_route()
Date: Wed, 18 Nov 2026 15:31:10 +0100
Message-ID: <20261118150357.631207209@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 134351edc28e083c61012b6c69e8e54dd7fa5bcc ]

For an unresolved multicast route query, ipmr_get_route() builds a
synthetic IP header in the headroom obtained from
skb_realloc_headroom(), which does not zero the memory it allocates.
Only a few fields are initialized, leaving others as stale heap
contents.

ipmr_cache_report() copies this header into the IGMPMSG_NOCACHE report
that is queued to the mroute socket, so a recvmsg() on that socket leaks
the uninitialized bytes to user space: the 'tos' field [1] and the 'id'
and 'frag_off' fields [2].

Fix by zeroing the IP header before filling in the few fields that are
used, so that the entire header is initialized, as in ip6mr_get_route().

[1]
BUG: KMSAN: kernel-infoleak in _copy_to_iter
 raw_recvmsg

Uninit was stored to memory at:
 ipmr_cache_report
 ipmr_cache_unresolved
 ipmr_get_route

Uninit was created at:
 pskb_expand_head
 skb_realloc_headroom
 ipmr_get_route

Byte 1 of 28 is uninitialized

[2]
BUG: KMSAN: kernel-infoleak in _copy_to_iter
 raw_recvmsg

Uninit was stored to memory at:
 ipmr_cache_report
 ipmr_cache_unresolved
 ipmr_get_route

Uninit was created at:
 pskb_expand_head
 skb_realloc_headroom
 ipmr_get_route

Bytes 4-7 of 28 are uninitialized

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <netdev-bot+sashiko@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/0545f0c83f5ee2f6696210f87268e811ef655715.1792476357.git.zhilinz%40nebusec.ai
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261025071729.34967-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index e07e90717c50c..587fa6b1f9b92 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2314,6 +2314,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		skb_push(skb2, sizeof(struct iphdr));
 		skb_reset_network_header(skb2);
 		iph = ip_hdr(skb2);
+		memset(iph, 0, sizeof(*iph));
 		iph->ihl = sizeof(struct iphdr) >> 2;
 		iph->saddr = saddr;
 		iph->daddr = daddr;
-- 
2.53.0



