Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213637;
	b=Mj+6Y/LsCiAqOOEKnhF6gVGYMQvUGa4uhdBgtWkIqG7S4Qgmbtxi9xMq/S/7Z2G+MosD
	 FG27Lf3IaHVJjcrWfRek5PRbnNCu5JCFnO93BCAvyUDCrspv3NekxoPMRnGwquTlrvr5L
	 cLLmfOZfXhZ8omYrTdMtv4BWecC4pyE+JOIFMl2Mpe0z24jDQG5sExHRtTlGUSA5wiWun
	 7YWwxbI4fnwPKM4aVOqZbzMGLt81JjfRi6Iateb+LyyYTGG1Bi2mM1bEHfMgMlxDdsiHn
	 3/LFgW3UspeDCdV1ip+fT/78AAUtV+h3NbKR+MlO1J+FX2c62TxAM4QBvA+XQNTbXkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SHi+9j+oJbAijy9fLpTR2/UCzETjHKfJbWrR+z8hkB8=;
	b=RWCt/Ea6NV0xpVqh28tXTtn9k1gqrlN811txhtk1nWfP0LZwQhBJSnZCLYgq1RCb26bS
	 wxTG1x9HCBqVkRBLTdYCnBXcLX/s7DB4l20JCFrbU8cDvu/9rWhAqwn1C/NNAD0C2pMx0
	 +1V/pFUerrP9135EiSMaJ0ZlEOltM1g7PQpSlx6IicbVEdhb7F6JZPEqzbB7iF8EwsJP2
	 JRvEKNvsWlYoAfZ023tJ++LfUqdr+zRVDQK67Mc92q/U5dJCj3CK91jG35BmKr45OO1d1
	 gmQN5tl/W7A9wTeq4aQvuEPAfQe1K4rrKCqkHi9H8DE8cPjTWd+UuliX/62eQupQaKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NusLBCgf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296BB606A31C;
	Wed, 28 Oct 2026 18:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NusLBCgf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C0FE1F01825;
	Wed, 28 Oct 2026 18:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213637;
	bh=SHi+9j+oJbAijy9fLpTR2/UCzETjHKfJbWrR+z8hkB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NusLBCgfgZBI7eaPZeYBNp8BjYOGo7wjD8vvMkZvsjaYEF0PpPWPHZT+wRWNj9LMQ
	 GxAIcGJTc12uvV+caxwDXz+ho05soAC4qSKf+WSZqLSC/mZGTbC5SWXZjpqNwnx6Vn
	 ym3dDYsknRO84tirGQ3tB/1iEq7F0Dp/aki2rpX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0574/1887] nexthop: Factor out hash threshold fdb nexthop selection
Date: Wed, 28 Oct 2026 17:44:30 +0100
Message-ID: <20261028170512.470780773@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit eedd47a6ec9f683f0b8d931aacca81985be55eec ]

The loop in nexthop_select_path_hthr() includes code to check for neighbor
validity. Since this does not apply to fdb nexthops, simplify the loop by
moving the fdb nexthop selection to its own function.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230719-nh_select-v2-1-04383e89f868@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b72a6a7ab957 ("net: nexthop: Increase weight to u16")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index cd93dd74608ac..e3d9660bf0e5c 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1153,11 +1153,31 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
 
+static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
+{
+	int i;
+
+	for (i = 0; i < nhg->num_nh; i++) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+
+		if (hash > atomic_read(&nhge->hthr.upper_bound))
+			continue;
+
+		return nhge->nh;
+	}
+
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
 static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 {
 	struct nexthop *rc = NULL;
 	int i;
 
+	if (nhg->fdb_nh)
+		return nexthop_select_path_fdb(nhg, hash);
+
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
 		struct nh_info *nhi;
@@ -1166,8 +1186,6 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 			continue;
 
 		nhi = rcu_dereference(nhge->nh->nh_info);
-		if (nhi->fdb_nh)
-			return nhge->nh;
 
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
-- 
2.53.0



