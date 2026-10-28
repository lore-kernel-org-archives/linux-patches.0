Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213138;
	b=4WFnjCVcy20eWOquMISwiVmBlDnrq0tuThPUOp/hlwLXS8K4BVG7d93sH64Fna7FlI3u
	 XPkwYr1JVDC5254o+I5NDky1T3g/OKUFsaa26U6THzk9Zjg5Ri6feXhdZ3l/3YaQdykX9
	 JxjNfCfpvTbaM6yrkbiHMO6H4Xb9gecYTNl8GBurL3wTQy4lf8uWIrS+Mp7h/D8sk95Ue
	 YMR/pZZs8D1Pc+GPKBa2/mPC3/v4SeJxXixZT0l6Xu3ozOETi8x04kcSrdp7tYKfNtfeg
	 6IKvfznMq/RyO4AEgQBRo/tnRxakIZ9Bdf8/38LYt+og8mHUPeGP8vCeixDXUBOUO4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CdsgMSSxQW2N+U6JUuj3fc7vC6xBDueYOUkC1130Dtw=;
	b=Vkutac/8ZsUhcAXr230Wgf/QTdiTp+Tazh/jWnwN9BQp+eOwPTPZ2W9LJ0FYkjq+Frp4
	 0yD1s3jEZOrj4UZ7onQMWkuh1fyPFA41ctr7KAevZ3JBiB/9fo5ByYL8KVWHboiP7beWW
	 t3IpqqjwoNyevwc7fVQSRm/gSYO/SapPeePTu5MFsXDTKbet0DWC4+g46Voz3w59J2bZg
	 +OYThbWpLYKZs/ocJOamRIwjJM7VzCxRFS5Sw+J5POYvhiix+5kn9Cv6B32RuN6wsvPFb
	 HRTkGO+mUk+8Y5B9R4bRrJ8TVAhmWSjFek018PwhG0hU0H5SWd3pLasJSIxdHSohmfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wNK/Wg1W";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464EC606A31A;
	Wed, 28 Oct 2026 18:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wNK/Wg1W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9669C1F01825;
	Wed, 28 Oct 2026 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213138;
	bh=CdsgMSSxQW2N+U6JUuj3fc7vC6xBDueYOUkC1130Dtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNK/Wg1Wtrho6Vx3nuHmMQJHEX6+8f8BHGfT+ST93tb3nrrpA6iNLHLCOs4MPVG2n
	 CINzKChieXtvUqcAFzSncr7HSEly6eyCRiVsDqtTzZX/QIRngzXIWT6iTzsCZsUsAZ
	 ge/rsmVI0svQlLJDtGiK2cGAgllCyBPeu6WrR2yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0401/1887] wifi: mac80211: account proxy paths against the mesh path limit
Date: Wed, 28 Oct 2026 17:41:37 +0100
Message-ID: <20261028170508.356593712@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit a5f35d4b112af1415ff06bd501c8cc26cc08aa8b ]

Proxy-path churn can drive the interface path counter negative and let
later mesh path additions exceed MESH_MAX_MPATHS.

mesh_path_free_rcu() decrements the interface mpaths counter for entries
from both the mesh and proxy path tables, but mpp_path_add() never
reserves a slot in that counter. Removing or expiring a proxy path
therefore returns a slot that was never charged.

mesh_path_add() uses the same counter to enforce MESH_MAX_MPATHS, so once
it falls below the number of installed paths the limit no longer holds.

Reserve the shared quota before allocating a proxy path and release it on
every unsuccessful addition. Mesh and proxy paths now share one
1024-entry budget, so mpp_path_add() can return -ENOSPC at that limit.

Fixes: ece1a2e7e860 ("mac80211: Remove mesh paths when an interface is removed")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260916113649.28315-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: Omitted the mesh_fast_tx_flush_addr() else branch because the helper is unavailable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a0ef296e3e4f3..f2970f33f96c5 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -449,10 +449,15 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 	if (is_multicast_ether_addr(dst))
 		return -ENOTSUPP;
 
+	if (!atomic_add_unless(&sdata->u.mesh.mpaths, 1, MESH_MAX_MPATHS))
+		return -ENOSPC;
+
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
 
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return -ENOMEM;
+	}
 
 	memcpy(new_mpath->mpp, mpp, ETH_ALEN);
 	tbl = &sdata->u.mesh.mpp_paths;
@@ -465,8 +470,10 @@ int mpp_path_add(struct ieee80211_sub_if_data *sdata,
 		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
-	if (ret)
+	if (ret) {
 		kfree(new_mpath);
+		atomic_dec(&sdata->u.mesh.mpaths);
+	}
 
 	sdata->u.mesh.mpp_paths_generation++;
 	return ret;
-- 
2.53.0



