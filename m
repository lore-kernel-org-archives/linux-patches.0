Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059456;
	b=D/KLa55iXo1PHwRsqCMVWxM+v3HvIKyCZsqG3zi9wJfbu9ykHz6VzIJxpr6VTHLOnkxr
	 411EQYwMMW+8MrCzamErMVZE2EmsU5S2r9a3oeZx9Q/WlwVwfboxbhEQSr8+anF2NtkFb
	 l/brlVCNibFuGKOQ8zE7ET6GqXslyNuJD+qciCrzVh6h1Fx+ZC7xHo+xxZxdn32+x+OV+
	 p1TkvXKrnR5yRmkrNU3gB6TNLaoei7dF6c8T4/GxNbdlYB9Ogm5P6Yoa7zqB/Itu7PPh2
	 dCT3ubrs+lOKjYqka27dlgeTLBaGqFj96qfFDFP4UQAv2XiyjvcBjxfTYkOqpggsoMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SPiGL7jQZk17BAhUSmzzkPTV3e6NyPTy9v0p0tk0Nnc=;
	b=0V5Omjc36SNXMOavc5xGJRCgS44SCzfeHX7vrzPZ0ZPVgirtsl8adSUzqjdEYJTLjwmv
	 UR/Ab5Pfha5mngPEzbo9/qaLGTVI4siibIfI7MiSjCjIlSQKEXToMVxzfTHtA+XKYEVGS
	 jUTVmhNOqADRdRtdWfgcrZhUl6tiLR7CkVVjq8EHgRozv0qeEq0lBEaSuoPw8mkjakWuS
	 CPQRqQ1nbb08wJhDQ/j34xdGBhIXBkUcKKpu7pLDf4qzJFGjJ0pfqTLbrs6D3aSf1oCDB
	 11BYvE3DZ83wS1HSHYQ9Cz803WW6LyaGTwzxi1Uj0QgYrtkxot20DRkqEXomS1g4i1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEWdZtIc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49DFE606A32A;
	Thu, 19 Nov 2026 03:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uEWdZtIc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10EB1F000C4;
	Thu, 19 Nov 2026 03:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059456;
	bh=SPiGL7jQZk17BAhUSmzzkPTV3e6NyPTy9v0p0tk0Nnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uEWdZtIcLs5ei/1GKPj2IblhD6wmNJcMVCKxTWeQDRU2b56Lck8gElmR2eUcs1Hxs
	 QsYtPP5OO9NILKIJKxG7H08Nwc8BPqKfNGhOSsp5n3oUalzA3BOW4MSULc42HDJ0Fn
	 uMvqIxU2mgnqS3wu3quQ4WLzBX6vUmiXY27r2L68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0796/1848] batman-adv: stop originator purge worker before freeing TT
Date: Wed, 18 Nov 2026 15:47:14 +0100
Message-ID: <20261118145949.724363125@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit f89eda5a9ccf82cba06b085b42ebc4886b8dfe9e upstream.

batadv_mesh_free() releases the translation tables via batadv_tt_free()
before batadv_originator_free() stops orig_work. The purge worker can
therefore still run while the TT is torn down. When an originator times
out, batadv_purge_orig_ref() calls batadv_tt_global_del_orig(), which
loads tt.global_hash and walks all buckets while taking their locks:

  CPU0                          CPU1
  batadv_tt_free()              batadv_purge_orig()
                                  batadv_tt_global_del_orig()
                                    hash = ...tt.global_hash;
    batadv_tt_global_table_free()
      batadv_hash_destroy(hash);
                                    spin_lock_bh(&hash->list_locks[i]);

Disable orig_work at the beginning of batadv_mesh_free(), directly after
the mesh was marked as deactivating. The second
disable_delayed_work_sync() in batadv_originator_free() is harmless because
it is free'd anyway.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260708091821.314516-1-sw%40simonwunderlich.de?part=3
Fixes: 9d31b3ce8168 ("batman-adv: fix potential TT client + orig-node memory leak")
[ Switch to cancel_delayed_work_sync() ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 860194a06e534..e484128f1bbc2 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -269,6 +269,11 @@ void batadv_mesh_free(struct net_device *soft_iface)
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
+	/* the originator purge worker accesses (among others) the TT tables
+	 * and must therefore be stopped before any of them are freed
+	 */
+	cancel_delayed_work_sync(&bat_priv->orig_work);
+
 	batadv_purge_outstanding_packets(bat_priv, NULL);
 	batadv_tp_stop_all(bat_priv);
 
-- 
2.53.0



