Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062605;
	b=ugz/ESl5KmmHVHIcrLwSCbW76i6D4NhOpYxewhz9Osh7cB0ewaHP1dKXcLgRXQ59GqZw
	 pj2WYqrtyLLshKmvQzdVUbnAxOHpNmD7440O7Wmij/1/LWF0CQQARrOmwe/gK5BNKKX1n
	 5E9rWH3/FyL/GsD5yzXZ9g84u0vWiNFvaDE7dkOeAiieO+gcsLyIwO4O0/Sibn6vVAH6F
	 T7/kjVeQlNOSxpY/RFvD599TnE8aZrEpcddw+CKnrCtRfbyAsDV+W+FVxzDBmQAqyYCsn
	 jQRlj4YSbgQiel3pDDpy0xQbiKZfIbsWAQ5p3M+LseMAiFNkyEE8AJ8TISs74in1lag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062605;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6sj4ntfZzhKByi9YwF1cAbB0mCQ1CsmFT6rf/z63XTk=;
	b=dMjwS+A4ZIxpyLFnpOcRUfnCEzaNpGg6DXdFLXQnrLY0yNWqGbvTDl+7t5wdDMzWG+Sc
	 uCa7y9IRfV6k/JExyUryAXVdxKitNLqIoVB0zJQV+DXlwiWIicR+ec62FFUlr+vT+zRRt
	 gBZ0J0vrGW9BCmCC3cxKhi31xxONObQKXmLrHQEC3qslaaPghmm1hbJsbqa/brJOESUzQ
	 QMNg/BclKkVpwEqw65y3xioAXfvOqKvsNXpr5tRyACpKvP5HL869qqDOroxRcsJas6Jhq
	 z+OFVDz3MxhdiLzNSe44DGfboBLKn7MCfNfmjIXROgYwSbneCDOD7WLSjLcyCSDToBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1/oEZwIp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67925606A334;
	Sat,  7 Nov 2026 14:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1/oEZwIp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C457E1F0089F;
	Sat,  7 Nov 2026 14:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062605;
	bh=6sj4ntfZzhKByi9YwF1cAbB0mCQ1CsmFT6rf/z63XTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/oEZwIpT+l9ISP6SEEg+TevV1in5pzAGSOykyKJORA8Unt7C1D9r50fP0VsmgiI6
	 jFwrHZ/6JUt4manHy4Ns+sb1hoVhIUWc4hfnkHIpN6pIRJP1Ubj8Mbr+URoc8fjD6A
	 a8FoMzOHAzOv1PPOAjPekjX9gKYoPNwjJZNCDqg8=
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
Subject: [PATCH 6.12 1478/1536] ipmr: fully initialize the synthetic IP header in ipmr_get_route()
Date: Sat,  7 Nov 2026 08:58:14 -0500
Message-ID: <20261107135039.362691204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index c3aa025362510..abd234f0861f5 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2315,6 +2315,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		skb_push(skb2, sizeof(struct iphdr));
 		skb_reset_network_header(skb2);
 		iph = ip_hdr(skb2);
+		memset(iph, 0, sizeof(*iph));
 		iph->ihl = sizeof(struct iphdr) >> 2;
 		iph->saddr = saddr;
 		iph->daddr = daddr;
-- 
2.53.0



