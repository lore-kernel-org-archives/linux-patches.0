Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213688;
	b=mzij8xg6vRosV9U8iVSs/8gPMtVuHpnIwaFISvsLwxrHB0bIBpTTsjDWiMf6Zs8HP8ot
	 T2IUNj2Fz6kmtFsRv1x2TdX6QXNTWg6VE5WSYhmvGmBoN9cFzZzrV2s+k3G+1ie3tJMug
	 tVnigfFgHpPaze/ON9FQWj6KG/ZvQU18teBy3HR5hhaZpOxbG0LaWD7soERXtXJrS5X00
	 BqXQyi/V8Rlxl2lYaku0De+MvWzCbSGg0Y6+i2slGIITItvfF0rwHN673X5qeo3jB6/XA
	 QEToD0CUDXg/1y9YU8ad13WSsejilHEZ7kc+Bsc4el1qm8F7/pdTtxEceT6KtBXPTgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rXkmPQzoz1uU1sFqNiPqWAqAF3LVCqaUq0nQ0s5oh5w=;
	b=zd4OtmBJKjYcyTF0RB7Gv0jF/uJUFArHaBe8cUzmD+uqK84buwWwl+ISOA0cB/O/fL43
	 LVvY4ZXJCc/e23QeE51YQzI0DR3wiGQq6jANJ1lMorQ0cH0OCT4M09sPWv7qHzFFN/MhE
	 2z8bAcELbT4+mtCfk2q4O0KIm86kdYrc/8duTS3hsZmzpY4f2yJr5vm8Qpj0B6CCKsNrj
	 n9O2OjAxlOBIGuKghegvZnsc24I+ke9YSkXnoKbLI/ZKbiHHLiS1siYegzhTXPdmZUSQ6
	 aXgfJl6MZ1Ss397uuwSolH/GlAcT8UJ/itzQ+B7UsXbnPX+/zwv9J3ewwwxMTpUovwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cB+QXt0i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12FD606A321;
	Wed, 28 Oct 2026 18:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cB+QXt0i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE931F01825;
	Wed, 28 Oct 2026 18:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213687;
	bh=rXkmPQzoz1uU1sFqNiPqWAqAF3LVCqaUq0nQ0s5oh5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cB+QXt0iCB0oC1buI77iCfG7hwmh/LKOxlubdzrK69Ho+gP8GUrFnq+zIJmQwelE0
	 8lhglbeLTOQuAOhih2RYkZnO8vCGMl0ldO4prInSp+qZ8sTJvlGk4ET6cKX/lPnSwU
	 aVSKmnjsGIu4VeOhIsMSPDcNkvxRqT0Kqchk3dyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0577/1887] net: nexthop: Have all NH notifiers carry NH ID
Date: Wed, 28 Oct 2026 17:44:33 +0100
Message-ID: <20261028170512.543657669@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit e99eb57e9b14d830a571c5255248d4d7eb08b27e ]

When sending the notifications to collect NH statistics for resilient
groups, the driver will need to know the nexthop IDs in individual buckets
to look up the right counter. To that end, move the nexthop ID from struct
nh_notifier_grp_entry_info to nh_notifier_single_info.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/8f964cd50b1a56d3606ce7ab4c50354ae019c43b.1709901020.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b72a6a7ab957 ("net: nexthop: Increase weight to u16")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nexthop.h | 2 +-
 net/ipv4/nexthop.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 2b12725de9c09..f7d4239347351 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -173,6 +173,7 @@ struct nh_notifier_single_info {
 		__be32 ipv4;
 		struct in6_addr ipv6;
 	};
+	u32 id;
 	u8 is_reject:1,
 	   is_fdb:1,
 	   has_encap:1;
@@ -180,7 +181,6 @@ struct nh_notifier_single_info {
 
 struct nh_notifier_grp_entry_info {
 	u8 weight;
-	u32 id;
 	struct nh_notifier_single_info nh;
 };
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5dc50bbdd2d07..0bf7b83bec1b9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -92,6 +92,7 @@ __nh_notifier_single_info_init(struct nh_notifier_single_info *nh_info,
 	else if (nh_info->gw_family == AF_INET6)
 		nh_info->ipv6 = nhi->fib_nhc.nhc_gw.ipv6;
 
+	nh_info->id = nhi->nh_parent->id;
 	nh_info->is_reject = nhi->reject_nh;
 	nh_info->is_fdb = nhi->fdb_nh;
 	nh_info->has_encap = !!nhi->fib_nhc.nhc_lwtstate;
@@ -137,7 +138,6 @@ static int nh_notifier_mpath_info_init(struct nh_notifier_info *info,
 		struct nh_info *nhi;
 
 		nhi = rtnl_dereference(nhge->nh->nh_info);
-		info->nh_grp->nh_entries[i].id = nhge->nh->id;
 		info->nh_grp->nh_entries[i].weight = nhge->weight;
 		__nh_notifier_single_info_init(&info->nh_grp->nh_entries[i].nh,
 					       nhi);
-- 
2.53.0



