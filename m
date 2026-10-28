Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213787;
	b=WHl988EXsg2rLI86VeFT/Llyc4Cyy3PUJl93ByTXbtmETRQcU8cj/hn9rtUU4mdrTkLr
	 Le423zzVEAA9k/m/8WLeXrDXJehqX7OnML37gIR0M3ohSQP/8JBKHMJJQL7u4R6jUL5/l
	 siRiqsBfs4/JysVa4MhLoqmvG8/+9qllv9Vk+TZAlfPUuIclit1PQYKsy7lFiRBlQq+cR
	 eM7bN1FoQ1zO7IqoIYbFiEoBEyQ5JAxXx8S869yIhXd33+qmqPMXoreThHsdmTV2Da7ug
	 tdr10eYebULu0dFY16iJZptjCn139bHDFuPJ1qNXyFVhixmylOjXDpx7UhcUhKFgO/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JNa83MJSeQLYOXRQmr70W6+TWfmJu6vBR/xwwlObeWM=;
	b=19lFVOL1k2DM7IMqFNoq/1UCNg70r42kRUlAT0gMIZqPffU6mQTHLePLWtCIwWojtF/7
	 eGVtlBpUKysDWqkLDr3Dec20+MHc3Q1rPiWIugu5u8MIMk7ec5RIHlHE2oVuIaD4S09nu
	 9s4FE1txNXMQ0k+vNJjQtHzet1z1NTmiaMrO/LvRgWx2sSG6eHWfnY5affvrlp+sMxEki
	 7fomFSULhPodC5+BSRdUaF8nVUjQrFjqzGI7ePG4eaPu3oXOuOiw3GkKsAiiu0cq7OISC
	 EXoJT0hCy9qKlF4Zkob81cc3kwam7CkTYPtr+cpqEmKp9zRnZiabCNxSasjcYKH4VlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylPUFBBM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B4D9606A31A;
	Wed, 28 Oct 2026 18:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylPUFBBM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8121F01825;
	Wed, 28 Oct 2026 18:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213787;
	bh=JNa83MJSeQLYOXRQmr70W6+TWfmJu6vBR/xwwlObeWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylPUFBBMe+AMtafqAB5H7oxWePJk82JJWt25e2Lbi+Z3Q8Xxq9nYxjUuetw1NOMvx
	 R+yWgpvb9kHj4I5DNtouxIs7Y2pSzTIMY2zWUuRCF5qQjG/XxV99MveIFpGcmqAk4r
	 HO5IBAuteSv+QxZ4zZczn6jC7PDKx9wyKaSdHERw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0575/1887] nexthop: Factor out neighbor validity check
Date: Wed, 28 Oct 2026 17:44:31 +0100
Message-ID: <20261028170512.495827764@linuxfoundation.org>
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

[ Upstream commit 4bb5239b43348f4a1cd73f44be3dc57ac653ae9c ]

For legacy nexthops, there is fib_good_nh() to check the neighbor validity.
In order to make the nexthop object code more similar to the legacy nexthop
code, factor out the nexthop object neighbor validity check into its own
function.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230719-nh_select-v2-2-04383e89f868@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b72a6a7ab957 ("net: nexthop: Increase weight to u16")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index e3d9660bf0e5c..005465e61ae3d 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1153,6 +1153,20 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
 	return !!(state & NUD_VALID);
 }
 
+static bool nexthop_is_good_nh(const struct nexthop *nh)
+{
+	struct nh_info *nhi = rcu_dereference(nh->nh_info);
+
+	switch (nhi->family) {
+	case AF_INET:
+		return ipv4_good_nh(&nhi->fib_nh);
+	case AF_INET6:
+		return ipv6_good_nh(&nhi->fib6_nh);
+	}
+
+	return false;
+}
+
 static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
 {
 	int i;
@@ -1180,26 +1194,15 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
 
 	for (i = 0; i < nhg->num_nh; ++i) {
 		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
-		struct nh_info *nhi;
 
 		if (hash > atomic_read(&nhge->hthr.upper_bound))
 			continue;
 
-		nhi = rcu_dereference(nhge->nh->nh_info);
-
 		/* nexthops always check if it is good and does
 		 * not rely on a sysctl for this behavior
 		 */
-		switch (nhi->family) {
-		case AF_INET:
-			if (ipv4_good_nh(&nhi->fib_nh))
-				return nhge->nh;
-			break;
-		case AF_INET6:
-			if (ipv6_good_nh(&nhi->fib6_nh))
-				return nhge->nh;
-			break;
-		}
+		if (nexthop_is_good_nh(nhge->nh))
+			return nhge->nh;
 
 		if (!rc)
 			rc = nhge->nh;
-- 
2.53.0



