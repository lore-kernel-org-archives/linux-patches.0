Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052899;
	b=Y6kwQNBR1YpIVfhwRGUhrQJSSS7cfissK4Kh3uyaXYJGGWyRDsWlWLGWnTZVgrIm3Qnc
	 LgNiX1zFBPeZxM1u8AjmGHQ2ffbODn09pYavwb17YE9rB34LoxT1bOv3CWxL59YPQS44B
	 RaXNV47Kv74vKDWyPexlotMasmWebp5/coVwqixhhA47G8EUj6MGL4ykCIBH02hCWSpce
	 pj80NOCBuEVVTvQ8/FIJafqE5oAh6wedPqmXAmRFANTLQCyfKqRNdzKaBXtARKwxbOHBA
	 wzEJcf/6tvw2gcoIMaI7yE/4vQ9KQzDJLnhjgywcSwr7lqEqdoTneQYqu2Tg5HhWRTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ioU55sSsrcT0M+aE93UMiuR+wo0cE9aXsj/QzjuPED4=;
	b=ijpucXym+S3BLhRB+6o1RAAAQCUsHlpD0I+MN6lGWR5C/YTBszNTqY1WV4PyMGVgb9Xt
	 pHasshHJnWvp+iv4VaO4lsvxoOw5X5sLlwE3pqF2RLoHpDQwbY6EkNGpikrc6n3RP+9bw
	 spFz91NWT8mrZe2p+xK2FGOYhpdPtpZ3bSPTs6xWpGOweDGuCF1ParaPIuHBJi0NaR1ME
	 0la9y7tAuKMWInqDMOgw67MPUmdJ3/GhBlpVhr8WwHm37eymkNL+3/rut2Zr7a8wSyQ31
	 9Jfq7nlpzFIdc0L8gIwkUoOiNK0Zw5JCak3kp4mk46l8g4VfbWn6Dx53qJbopA4mYgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGDUt+zJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF5F606A31C;
	Thu, 19 Nov 2026 01:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MGDUt+zJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2851F000C5;
	Thu, 19 Nov 2026 01:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052898;
	bh=ioU55sSsrcT0M+aE93UMiuR+wo0cE9aXsj/QzjuPED4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MGDUt+zJeqHJ/cgFaAjoCwiFp1dX5ToYOwEuExSDjmZQAXvhbE/qsyJvxC68go22l
	 MT0mo9Ou15BqqQ/a9VM/hdWkOkpbITyy5Hx7O+f23SCGP12PZ3VYkPg4mHsxeZdi+X
	 4TqoUfyRlN+JFC9wHy9Nl8HzQr0N0b2XAZiOGipU=
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
Subject: [PATCH 5.15 0725/2214] ipmr: fully initialize the synthetic IP header in ipmr_get_route()
Date: Wed, 18 Nov 2026 15:40:01 +0100
Message-ID: <20261118150040.775807096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 855da7c3a906a..dc33f432e0f0c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2283,6 +2283,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		skb_push(skb2, sizeof(struct iphdr));
 		skb_reset_network_header(skb2);
 		iph = ip_hdr(skb2);
+		memset(iph, 0, sizeof(*iph));
 		iph->ihl = sizeof(struct iphdr) >> 2;
 		iph->saddr = saddr;
 		iph->daddr = daddr;
-- 
2.53.0



