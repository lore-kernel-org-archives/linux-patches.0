Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058725;
	b=HqFvw2n24e7JAO9SbEylcr5/FtTUkmrbqWhLm1cc07FnDSl68nK/6ppCO+0iI9BWzXSl
	 nSkrf9xwuviIYkUbj/qiph5bQZYR+AOurAHPQUZ2EFryxZn2/wL99pj3IOFhPE+cruExB
	 YxomWi1bo7aEqwm0S6lLnj8PppFbgGr/C2mNd09erLwyg5C+9l+39Xxnq6gYXQ/y8x+gu
	 po9iZvWhz42twrTXA8T0/FzCUnSl9j2jPPZueUzVJfpj8j8Qk6o/xIJigXQTSD7OdHlBW
	 W0q/iOIMjhoQbRCsRsbjcFGu3oN/cpkz0VFgylO7KFsgXAjzRsZmiXFDQm+nvIgdrhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Y0vlkWJ+HXJA8DS8QzMxL8WrR3lXUBnaMnCqEh1Tzw4=;
	b=HCVDHoWMsPHztg9dvmPiMf0vRf1hsMfd3gOrC5UQBVO5GPTGTJ4W8++ZgqEXUX7CDp1R
	 Rrix/Tah/Yb0Tbu3Bjwai1kxMNY62iSjsc7b+EKsn5BQ8f2Y3wmBZf+rvG5uWdJY9rX03
	 WYDHG0oxg7VIURv6UW5WAmdECdzqR+Av8BjPR6VdD/bYq0YgcEaADpoUnIlKeUDhWmRve
	 nbqOcJBS1ziZCSQCyL/qZ4F/Ncx7av3uJI3mdgpwlYI7o1kvc+cF69QxFdJ1c8PhD3mqx
	 WeXTog7UcYkWUV25Zd03rnz83AgFgxJX3Gm4s7YMRRXj9rRYKJUyXaD6BjxPtMtv+3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wxk+T58y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F27606A320;
	Thu, 19 Nov 2026 03:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wxk+T58y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74D81F000C4;
	Thu, 19 Nov 2026 03:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058725;
	bh=Y0vlkWJ+HXJA8DS8QzMxL8WrR3lXUBnaMnCqEh1Tzw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wxk+T58yxQV26+YC0hQWtEkz3P6E1Y72W38rZUQRZQkLrBW8qu04IYEEC8ASzPchp
	 /uD5zjvPEX97wdcbIhIL8rNfYQcnE+8J2RmE/QPze4Dx48f/AljWzSxNCKcS3IJ+qY
	 5k/DzvjIQXr4JbPYCi8+d5TK+fhxpsnn5Dw+bGCE=
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
Subject: [PATCH 5.10 0589/1848] ipmr: fully initialize the synthetic IP header in ipmr_get_route()
Date: Wed, 18 Nov 2026 15:43:47 +0100
Message-ID: <20261118145940.089325356@linuxfoundation.org>
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
index ee5860cf76503..ad49b3a9f7a2e 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2297,6 +2297,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		skb_push(skb2, sizeof(struct iphdr));
 		skb_reset_network_header(skb2);
 		iph = ip_hdr(skb2);
+		memset(iph, 0, sizeof(*iph));
 		iph->ihl = sizeof(struct iphdr) >> 2;
 		iph->saddr = saddr;
 		iph->daddr = daddr;
-- 
2.53.0



