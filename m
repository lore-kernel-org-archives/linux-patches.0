Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590212;
	b=Jyr1i/qjeS40vkQiv3+1tFKYKBNk2X2fro0/VksFN7QuEL0FYHN8blvHZkf3q0KjfsiP
	 rePyl0P3bnF9R4I2et8Kd22Z5EtI/u6aHkDEs1LIDs1jtB/jf4O8XLMEh0H3NXYSbtB3b
	 oxEO1AZY5KYywczspX2uTYcpwPH4i/3Vd4YCFkKr6S9SZZFO8y936M4q+WlzDREZKkVU0
	 ahfCPbKwl7ft2KFoubC6g4UOFpiBi1Zil46bAfo5eYUdAm89I4f9nc2MexfYK3ATDRuM8
	 6LT+WfXro9UioMOPPAqRVmCeyYFcMNXEjbHnBOI2ZhnNZU+p0akt8Rw23dn04dASNag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RS+Wr/ROGzDbKVH4VrU00nUzvKcMsmgTbRPdtuwGoxM=;
	b=E149GVxul38RwLMzTPDTI4f/sJZ/G2ViXZ73EcGWksaPOPJgh2E2+cxI0lRZnZ26Pn7e
	 HvP8m5D34hv6PczuSq0+Gwc4zC1lbgTy4mqgZDt1I01qfJR90Ik6h+QdvT9OXrPWBf3wL
	 CLUUGbpm2vsLz8ogLbX4WE+7ntTICDlixbdeuIaoXdbv4e9KqZFmWbqSKRu/0GWDxYMeG
	 XJq6Ikt76g64ztgrUYkMCGQGSaDxuNhRZpx2NTCe5q/a1WCtpfJLc817KkR1BPI9bAJ3j
	 fuK0y+tL6u6KKdgTw4WBRxvnIyqeZxaAloo3kgIdBqXUo7ufbK3UhXTJhSOB/74w/Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSshe6Gk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3682A606A88F;
	Fri, 13 Nov 2026 17:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CSshe6Gk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D713A1F000C6;
	Fri, 13 Nov 2026 17:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590212;
	bh=RS+Wr/ROGzDbKVH4VrU00nUzvKcMsmgTbRPdtuwGoxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSshe6GkbAGsikbp883MNW7u/rlNmQh6ZRjOeJMF6jSX4gRunaSGdW+FpM54B3jXA
	 ni3InvONWzOksNC7+cw1xon7IIcg7iWULeoIJ4Ca9TaZEAIP8ReRkJKb6nQk+H1Er7
	 5J6/PSCrp7cYyspMDFRXPBeQm0X5vFIGVrSvbyT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/686] batman-adv: stop originator purge worker before freeing TT
Date: Fri, 13 Nov 2026 10:45:47 -0500
Message-ID: <20261113153828.286492578@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit f89eda5a9ccf82cba06b085b42ebc4886b8dfe9e ]

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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 870754d1d86f9..6ffa65ef3d162 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -249,6 +249,11 @@ void batadv_mesh_free(struct net_device *mesh_iface)
 
 	atomic_set(&bat_priv->mesh_state, BATADV_MESH_DEACTIVATING);
 
+	/* the originator purge worker accesses (among others) the TT tables
+	 * and must therefore be stopped before any of them are freed
+	 */
+	disable_delayed_work_sync(&bat_priv->orig_work);
+
 	batadv_purge_outstanding_packets(bat_priv, NULL);
 	batadv_tp_stop_all(bat_priv);
 
-- 
2.53.0



