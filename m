Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212902;
	b=wAI8lyrTtIibudElYMYi4Usrbk6nCFdRalp/uOXvByHZ0PJ+c1x/Vsx4RwnOEJvFPYrk
	 8I3JDcyDhI6X7oc4PZ6vItmgCagzRqGO9wm6Kkq/1xwCzfRI3w5ZJQLLB9/Jyi6LuhXV6
	 zzezWnnY8fgRjR/S1/UyofVoIR7M5jFqWpy6R5BrzpDv7XJVvfpXs/8l/LITq/3MjpmLs
	 +M8qVNDaQ1K8N68JQ6b9zMoDCr9BNHYxtzgcbC6KWy9ZcVNcjplDaIfFimYVGGwjUcqmC
	 ENp2ycYTcwHaEo1cyLUVJ9rF/6u9/yCn11zNQ9cLL7CBIX655mPV+pVBwWLOZvLgANA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MCpedhD3rnU9hveTww7WSU+PvfsXvcH/LowZjpJ0IuA=;
	b=hkGacAdmLQ97KW2wQl5Ro9SNJFLA2jKzYDQcH64oW8Ep1q5ZVDdQBVDNP1qTl8sD7Eva
	 ALFCuuoBnWCF5QZOHRu3AE2ukTAAv58V2Ng6mlJYHp5sIeONPpPwUCgcD3nGzY1dwL0L3
	 hDfNQfDyDmmv+9/JexY/pYHx8hhYTMSXOGLUvYLdabzKojido8cDPVMp96Om+UBoSNFEU
	 fninbPGJDI4rdmaudGZmyzmXRyU48m72pKsBOdRGD5PzM+3QhcCK62j/U0ImfIK57qxKH
	 VknLfXtbR3ABBemQP6cfzt0omNYW/aEN47bpTPkQJyGbHHCufALiohukn0jbWGxi+Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixRmhStK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C40660A2611;
	Wed, 28 Oct 2026 18:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ixRmhStK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA621F031E8;
	Wed, 28 Oct 2026 18:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212902;
	bh=MCpedhD3rnU9hveTww7WSU+PvfsXvcH/LowZjpJ0IuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ixRmhStKigR4za7ZFoUlxA2ZNqJiaVQAihPqySR7KFDx1ly81p83wevyscB6blhYh
	 zI12aM/Rp1uNLTJYdmCJUuIpaq1gU2eRsbL9giHC9Ny9JvtJCEKVypkIcssMZ5aj30
	 iKYn6msSMQhEXStR/R6LzYuYzv+j5JcMkEoUZZms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 0317/1887] wifi: mac80211: release mesh path quota on failed additions
Date: Wed, 28 Oct 2026 17:40:13 +0100
Message-ID: <20261028170506.440823895@linuxfoundation.org>
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

commit 7325a44474f20c1393a1c114c6811abce6ddfaf4 upstream.

Repeated failed or duplicate mesh path additions can exhaust
MESH_MAX_MPATHS while the path table holds fewer paths, which stops new
paths to reachable destinations from being created.

mesh_path_add() reserves a slot before allocating and inserting a path.
If allocation fails, the function returns without releasing the slot. If
the rhashtable insertion reports an error or an existing destination, the
function discards its candidate but retains the reservation. No new path
is installed in any of these cases.

Release the reservation whenever the candidate is not installed.

Fixes: ae76eef027f7 ("mac80211: return new mpath from mesh_path_add()")
Fixes: 60854fd94573 ("mac80211: mesh: convert path table to rhashtable")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse kasan
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260916113649.28315-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/mesh_pathtbl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -407,8 +407,10 @@ struct mesh_path *mesh_path_add(struct i
 		return ERR_PTR(-ENOSPC);
 
 	new_mpath = mesh_path_new(sdata, dst, GFP_ATOMIC);
-	if (!new_mpath)
+	if (!new_mpath) {
+		atomic_dec(&sdata->u.mesh.mpaths);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	tbl = &sdata->u.mesh.mesh_paths;
 	spin_lock_bh(&tbl->walk_lock);
@@ -421,6 +423,7 @@ struct mesh_path *mesh_path_add(struct i
 
 	if (mpath) {
 		kfree(new_mpath);
+		atomic_dec(&sdata->u.mesh.mpaths);
 
 		if (IS_ERR(mpath))
 			return mpath;


