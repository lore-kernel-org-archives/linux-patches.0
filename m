Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053564;
	b=A8idec1x4HpZRP0V+lJcX6FrN0wXHB+ufASvMYMkLuYZkAVfPi8lJX8uIEUsIIyv3s8O
	 26/5hOpe0YThIaVR54zdE1OdeOEVy1uwXDyKmSEy0wCvH1C5BXOlPbPrWbQsb9fjHYTkx
	 t7I3wkyO6v5RsiRvRdJ793zVP3aRD7xzZb7Q9tjBHwPKuEc0HrFS2LgVU5YNZIoSWKo1N
	 D9O0varO5U32c181saRZADhhG57akKv5547TE56/9+KcAx7BInmseJfyqqnCytkz+Ulax
	 rjVWi/+6Q9L3+7+0ICtRfkS8oNSQAJRL0D1P1Y+L1Z+aZy0EcSp8otBjJ1FRpOVLd6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053564;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HStfY8vtvVs+n0LGaYuHmceud6/ltSsF+om6/7MK3mY=;
	b=IzDLVCPCikG68jv+1juESKdgaMmyKzAllS/wRep9minne13RDN87Nt+ggFmpK4duPHYe
	 8ctT3Hoj3MOVJmHCtdx42CNyfmvb2vAPBqMXsq+EyktWi5wLE/RmrPkyWXU7ORyqyuJQ2
	 dDM7BuhMeqqwPq7ZUU3wquusNKRKch1jN6/R8GR9KISFvhZNhNKmTT6gwcZTZ1TASZrRt
	 1tMU2NOew4uK+52rVF+M281qYF2OVOx/sGE4OlWre2X0rLnZfNIg+oxJNdjzYQUefupww
	 i2l2jejCq1cn5qZ7i+P6blhKISwfToVfRcY5VQmpl3qvbanMbtf0v2MpKrB6iQ1XMLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa1yEWhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892EC606A325;
	Thu, 19 Nov 2026 01:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wa1yEWhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D70F91F000C4;
	Thu, 19 Nov 2026 01:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053564;
	bh=HStfY8vtvVs+n0LGaYuHmceud6/ltSsF+om6/7MK3mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wa1yEWhh+EY/RsGChVffBk6sXQf+n9FU0HRacntlaTpxfM09pvfT9vsx76YwDeuH5
	 xmORwx0QCaZN7RVW0azrADYmiUpgmo5WrSPFjKRxbA2VLGNliHT2NNI2f5GR1tZBAX
	 ibh/RRXIu5uyBiB5wgvmDAMzkeUsfIyKaoUu2XLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0963/2214] batman-adv: stop originator purge worker before freeing TT
Date: Wed, 18 Nov 2026 15:43:59 +0100
Message-ID: <20261118150050.829157613@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6d3d15332ff9e..717c4a1985fb5 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -262,6 +262,11 @@ void batadv_mesh_free(struct net_device *soft_iface)
 
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



