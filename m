Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590620;
	b=r7Mge8B0Mf90rLPzb2DEgL8zegkn51h7zFtqSverDBfVL09mC/f4tiOGYODM335lswKV
	 lEfHFKlX8zFjdbgj0X68HXE3A+5mIRJVm9UUVtSw0ItTk1YgSwiVk0vIQ/kthGMIaoQDN
	 Ba8U4KNf7w8Fcix5xhREj01LfJ0A26pvOU7GKeaLd9P+69tiTHae79nGueoiSkgpWHkbk
	 /Y1CsAEWEeo8wna/z0vid+/GuvLcg62x+lBfA2Tf0K9Y2PgWxl/78/XlI/ZkBp12vxIS6
	 +wE4UrujdIX8Bm4z9br25+xDN/GuxeyIAd1ehJYfmJKyIZCs9REa0V5O49w8A3ks81Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590620;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I34GE3zz/PfJmAwEWWH8lX4AI6WdTzuAdWduWBmgkz8=;
	b=gLBkqvcxiKIJo9EXLebvtw/I+Tw8queJX1pvzAK6vOe4s1aHB8uCUlEcErwhPztT61vt
	 8l5CkWmbsCcMyAQGzFiNqlKaYlUp1Ytdqw43t3QV6ELIZR93UrD11Dv5AzibYWUlnSV7N
	 UVbeQoj5CpGSWrhqi60r4TQTn0JE60cCTBeKF4k+dbLkx2yxtXflO4IdHSdxuvuiA3pY4
	 exorfgkq/PMSIz4YYo+sRCPUxD1TIcbqSi7Pldhcs2F7nEKnfRzzYuNqZq6Uijny/uHvr
	 AObC3TwJ828Ykygd+GK5rpj/xuMyWcC5mCOr1J2D3Uzvouw0pnCkOoBVkVrC5EWvfXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVP7gC+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAC5607586F;
	Fri, 13 Nov 2026 17:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xVP7gC+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB55E1F000C6;
	Fri, 13 Nov 2026 17:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590619;
	bh=I34GE3zz/PfJmAwEWWH8lX4AI6WdTzuAdWduWBmgkz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVP7gC+MDLFAXRngz9FlXZL8o/xtjoFrK5STPofSj6pPXYlHVvilh9HHFo3PXhtoW
	 cWR4NNCTtEfuY7+DnHXodPXRyM6XLD20fMflYNXii4hojDGdcp6Kjz/qZDvxBSTjEC
	 nsNLJOkGylAaf6JSRquFHRRYobKHMnHmFSDy8c7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 544/686] ipmr: prevent info-leak in pmr_cache_report()
Date: Fri, 13 Nov 2026 10:51:17 -0500
Message-ID: <20261113153839.907379789@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4f34002e2e37639133693c13a2a9977fab86880d ]

Yiming Qian reported:

<quote>
 ipmr_cache_report()` allocates a report skb with `alloc_skb(128,
 GFP_ATOMIC)` and appends a `struct igmphdr` using `skb_put()`. In the
 non-`IGMPMSG_WHOLEPKT` path it initializes only:

 - `igmp->type`
 - `igmp->code`

 but does not initialize:

 - `igmp->csum`
 - `igmp->group`

 Later, `igmpmsg_netlink_event()` copies the bytes after `sizeof(struct
 igmpmsg)` into the `IPMRA_CREPORT_PKT` netlink attribute and emits
 `RTM_NEWCACHEREPORT` on `RTNLGRP_IPV4_MROUTE_R`.

 As a result, 6 bytes of stale heap data from the skb head are
 disclosed to userspace.
</quote>

Let's use skb_put_zero() instead of skb_put() to fix this bug.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260430070611.4004529-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 94a6736bb5ab ("ipmr: only copy pktinfo to cache reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index dd9ed871a1b4f..cd587d84f388e 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1112,11 +1112,12 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		msg->im_vif_hi = vifi >> 8;
 		ipv4_pktinfo_prepare(mroute_sk, pkt, false);
 		memcpy(skb->cb, pkt->cb, sizeof(skb->cb));
-		/* Add our header */
-		igmp = skb_put(skb, sizeof(struct igmphdr));
+		/* Add our header.
+		 * Note that code, csum and group fields are cleared.
+		 */
+		igmp = skb_put_zero(skb, sizeof(struct igmphdr));
 		igmp->type = assert;
 		msg->im_msgtype = assert;
-		igmp->code = 0;
 		ip_hdr(skb)->tot_len = htons(skb->len);	/* Fix the length */
 		skb->transport_header = skb->network_header;
 	}
-- 
2.53.0



