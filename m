Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063687;
	b=gchGwTtq66ANReH5CUo2X1kHFKjLu/lV8qvQCkrzocQAfrWrwxuM2+cfRuLbZg/lE8L8
	 Y8ngb528L3nWJ8FlkspKHhmbqTr5URR3ImCu2zE04QwqKL4dDVFDVEVn+Sr4sJOYEsGZj
	 iAIQlEpzcoQYezyeOOYb/u2h0QAssNUaWpMRri8cfQpOq6je8+aOHPdtJVceyjXs6106h
	 FVLCEqVEX9+M7VrJe00tvvSwI1htDkkPUeaplA57jBvgIMRGyRNbDRcUAF5BrApIn/Url
	 PzxB2O/VJ6xVShPq5zf7Kkq1dkrDuIrzc3ZQ3uzipcqj70EOS9wvBdowhpWLAa5sHow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tSx7HtjvyRPfMQUpUhiXrVa/q9xM5UqZHSrqaYAOvG8=;
	b=CLwNnPYon1FFBNBHKIz3PfnTZadSTYkb1aZ5W3GySsvdqME2FoSOpab2aibPbT4y9Lay
	 ySBlUix8ld79q4wMvUO8jMcB1a3vPSXCXZJYBMZcLwa6CkX0dFGWG1hi6+2kL70+6VhjT
	 NoBb7ev/2BfkbkQoKZXZojUGqhDeWx115dm1paogk4ycqlpmAvJppqkcFgt8wWjVc4FHw
	 l7ivldPkzYH9Gwn8wpQJ+uhLuRwjmMCVSgkeNpnfDoHr7RcKW5HXe6sQB3tvZ2yt5Dt6C
	 AWv/vMTpug5uczi3BkfaBt369YMe69yUGA6VDtn0FvVrgEYFoccktm+BGbTle4qtLZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZS98FPA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB33606A32C;
	Sat,  7 Nov 2026 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZS98FPA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462B61F0089F;
	Sat,  7 Nov 2026 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063686;
	bh=tSx7HtjvyRPfMQUpUhiXrVa/q9xM5UqZHSrqaYAOvG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZS98FPAFdy03v1LUm3KKaNQthvoCc4UC0WkJWpRdjoeIIBDs/m38LFpHVU6lx3iB
	 xGJb4uEaYTlmFmKNrbuXA4JQC+DYtlBz02pzNSf3WrVgVtIoNvb23dmn65PBa8cCML
	 DLo77grbxbVHcR7oInXrqihoIR/vP60Y6Wst6rdU=
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
Subject: [PATCH 6.18 793/869] ipmr: fully initialize the synthetic IP header in ipmr_get_route()
Date: Sat,  7 Nov 2026 08:57:55 -0500
Message-ID: <20261107134919.638993832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b1282c01a77e0..66a7f25f236b8 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -2474,6 +2474,7 @@ int ipmr_get_route(struct net *net, struct sk_buff *skb,
 		skb_push(skb2, sizeof(struct iphdr));
 		skb_reset_network_header(skb2);
 		iph = ip_hdr(skb2);
+		memset(iph, 0, sizeof(*iph));
 		iph->ihl = sizeof(struct iphdr) >> 2;
 		iph->saddr = saddr;
 		iph->daddr = daddr;
-- 
2.53.0



