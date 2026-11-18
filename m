Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038001;
	b=DU9GPg9cs9N8+GZcveJHti3QqocHUciCMDGal78Pe5xNrslOkhYVPF69g+3lhtD9C0F1
	 /IUXPthxi29S0bp0l2adFVOeEGeu/qc1vJrIstVHCmduMjZFYYxF1zACpZItUbFzrXme3
	 CdFC2sjZOpMCJD7wqL/VG0EGXF6gjXM+QP6/sVdiGEDKUJ8kfIrNkHdTlwNnl7eZ4sFaK
	 RkA0mDzO1DI44vRVGS3HG6i27jqxWjSYzjW6+Lwba6XglqN/NwV5BU6VhwQ47T1DKes8Q
	 +Fkw5eNtxDoAaTCJTx3mxIuFVYZu8fKDnvX8JRDxvYd8oK61z6DHKJew4zuC6u+O7/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jcJ0pJh4Vj5nPl8oN3i7Nt016o4WUcngqSpjQgZ6Ncs=;
	b=ila12sXquxkVnV36oUwkO35aADxxldqcAeNCBd5E78yyCNpn/znIlZ0CJ0lDuB56dqjj
	 zAMoJBV95jg627q8D/WOE23RFjDgHFmGRmiVcD9YQHKV4sa3WOpNdIj/YeGwjrOh54bDX
	 80DFGA1sGC5O9M7/GZpkOngHmOov4MUIn/HtPoN1aOzMg67VMZcvXOpHD49pgRod9CwHN
	 +SA9nrTtZPfeDUrk9BQeoc6iUcJmn3g+S+6MvArhE2iGwrVcw5AMaA9npkYW5g7qqCmaW
	 vv9nu+x/yXhWwyVSmSWmevbPJS0Vn0zIqoxpiw1mjm1gOQgzcm1DDTmB4w8VBkwLChA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVrdDxKl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBBE606A325;
	Wed, 18 Nov 2026 21:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qVrdDxKl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FCC71F000CA;
	Wed, 18 Nov 2026 21:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038001;
	bh=jcJ0pJh4Vj5nPl8oN3i7Nt016o4WUcngqSpjQgZ6Ncs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qVrdDxKltsvt8/ycYOY8+NJMee2LE+9tESWpvt1TxizW0IvZDMOzaQhpFOhpvWy9G
	 x3i26WY1UdcI+3TKRh+DpvOMIkGLrtUwxZ4UFipNBkdOJBUvVlEnjNXqCZCnMMtJOx
	 lCEC2gx9SbiMDziXPlbOaBYd2L5z5iVbG6V7tQw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1591/3318] batman-adv: stop originator purge worker before freeing TT
Date: Wed, 18 Nov 2026 15:36:53 +0100
Message-ID: <20261118150408.874389306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48065fd09e1a8..fb8964d867349 100644
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



