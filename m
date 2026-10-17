Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C61A39EF01;
	Sat, 17 Oct 2026 17:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257753; cv=none; b=J5/nMaOiAeHuAQByoOSLNSO8JoEgO7PRe6XEAhGpAolgOaGHqKSwOu/NApZHFlTikmDecvbXAPkMmARCl5/4bya+XceeCetSQtj3oCZOE9uo8agE53uRyjTnd7KU4Hjxg2iN1w1QJG63ctunC6HyRmibb3RRcBwhsdIMMaxBSh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257753; c=relaxed/simple;
	bh=PWQC8O/wPcZHuOJL/21CNi5slyV3U7iKCT64fSDJYGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWrzZt1Qp9vlugfPT+4jdU/tSTdbH/lNr8yCP2NrN6BprzW19+pIIV0DLk4f/Hx52x0K8SIv5I5E4x/Ul10kCOFFnHWrx2ld8/TdKAhQ5azrXZr2C6MBETbFp8rl/0Q9QlX/MSA3AoGK33X+S8MsJnPwhxXG1Np2LxHtdBtO+WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN6jPZIc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN6jPZIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FFB1F000C4;
	Sat, 17 Oct 2026 17:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257751;
	bh=twzASb0dvqvGodBrfCzK1qheNCHCLnG1Ct+zASr6Pv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EN6jPZIcU576/XhIy0IF81tUqZxGU/baPEG+hfl39E++oFeUImE2FvLg3D4qi9Ick
	 hAhnOO9s8NEZopc+MP+V/apjXY60KFZuEH64MvgD4xhYRRP5mgWUXTL+/mAWH/BXZa
	 rwCfwRQS3wJAr/HRs4msG8Np2TH/5LOlaCE7njEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0617/1674] net: nexthop: Have all NH notifiers carry NH ID
Date: Sat, 17 Oct 2026 17:48:09 +0200
Message-ID: <20261017160446.916395812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a00acde974a9..67f98a136a6d8 100644
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



