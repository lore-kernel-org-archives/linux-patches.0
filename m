Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045834;
	b=f8dUIDZAYc1PGhNzuek9yLX/91bwOI+0uKEgszxMFqflEpVXvqGTsLeYvO4uo8ddcYC5
	 Z/XngHaE6vbwCAoPIs/0tMlx1bp5DP1xdiCbmYugIC6OLqj+rAPqv7l/CiNFTAWhiVG7U
	 pjvF8ISrzE9d2YjBaPW177QyOjDzXU/zBLFhE6EcnPXOvxvKwb17xnfhpOj6e4YE3PURJ
	 7B56HaafCaMKKxKTP9DFClsGoS9iRFT3COpxT8+sxzwUWvi9wgUQeP/xZF8lcuPabfM6g
	 eMULPUIyhTLdTYo9+nzLgmIBcd50SaZbOTeSIkV6zFPXZbxaOTNYQbUKlkwG9C3LaQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045834;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P6xpBjGRYwHZkLy4/59G6X5Awcmdp84hnMr/YKyuVi0=;
	b=Ntfrod+QxmnsD3bNy+inrFiumd/kewGYQw5/TM5sHVzndSSb9v77n925HKYS8MshAwl3
	 23xIHi9wSOpc5VV/CcKS93hr8p/hnwThAMAMgm77CE7Gd4+1rZtnYg03UKfsNlHvsypTt
	 leUhtITWp+7w8Puj9PLI/jpUN9GxdXTLu51pJtBYMR/o8teVKMKLSZrXkr9q1gw4/XXzB
	 DTFear9zVlJozTZpl7AjNq9sY7A9eT1M8lzUfbhKP4JzUPLovGFeWf2xotAX70RHWxati
	 ll5LGJALSNEuIJgykQ7B2WEXBxiN1F/yczGIhDVJNH0kjLhV7WSnGPsB3P1wnPwVHZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLXCaddP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4EF606A331;
	Wed, 18 Nov 2026 23:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hLXCaddP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C511F000C4;
	Wed, 18 Nov 2026 23:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045834;
	bh=P6xpBjGRYwHZkLy4/59G6X5Awcmdp84hnMr/YKyuVi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLXCaddPblixd88hg/LvaC/vIgy/oXP4TP1bMPdRAYTVTPM3o5N8ZHe/ZMZfa7GPi
	 wrD6NckvJJsIbgNfJq1wq0zIH9xXwguxYetn7TWrPja6iMFMDtwO0sbcdCZUM5H4dd
	 C0t1Y2rmJ1G5q1GcuDClH+Qq+It8oigQFjdCR0qE=
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
Subject: [PATCH 6.1 1064/2857] ipmr: fully initialize the synthetic IP header in ipmr_get_route()
Date: Wed, 18 Nov 2026 15:34:58 +0100
Message-ID: <20261118150239.906181160@linuxfoundation.org>
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
index dd4e8897ee9cd..948993a4f4157 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2300,6 +2300,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		skb_push(skb2, sizeof(struct iphdr));
 		skb_reset_network_header(skb2);
 		iph = ip_hdr(skb2);
+		memset(iph, 0, sizeof(*iph));
 		iph->ihl = sizeof(struct iphdr) >> 2;
 		iph->saddr = saddr;
 		iph->daddr = daddr;
-- 
2.53.0



