Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590534;
	b=Y7+nCpdfKyjVT8kxe5CoGpq3UgMKjDHyJx1vxvLEcTL0u0I9Cm4eB0hF47J/q0WG0jj0
	 0m4ntyhqoEfB0iceXjwnP+E/gcP8CiCgYsaPk1+lzVwZgX2PoZdEA8Coqb878/MrWgiro
	 kRXfdNvvojiEAS1Lrr5yph1cHXr+D3PBA730SCCbjdm4B4a6nCUSlfD9ybDGMkYRv+e7+
	 E68g2UeNqOQawVC7abWyV1UxNQelJp4njkxinYiJQsE3fTD5GDtxvS7yNsge2jT99edg4
	 D5OBjdtEnZKEZg7CEucVvRqgPGuxYHV+9WnIHXY/uVZ5nGO+CjvAUpTcrOJ6hfdFA2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590534;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gk2ydScf553h+zLnJKzJjOIMHhpPXTKa+icP8dkAEUo=;
	b=ho1DWFt5Ar8CddovskNmmODv+jn6x4tAGWaFyFbAZE+E9xRKHUbgVROGCA81HtlDPJM0
	 ACidV5KTdnmYZKKCX8elfg3exSIJsjaTsgZsI7LocnwkD2+SlVfbj6aMcOpoabLCUCkrl
	 DyOLfOyG9zIUrIODC2Bjot8t/N/GfrWnm+T/xhdl5VncaT0K+r8DqjASXvEjibLZXQU9O
	 Fgop1caV8OQPDbOezGcuWZUxNDRzzSDwUeSFxrAWRVaI+kuH3cGlMr3bt/+FYcUm8KcUG
	 WCB72Vf5iHCj/NRoDmoIev20N3QbI38g/R1gKPXhocLGLdzMiZNfJqG35aSwvQBbd4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pN5pdNzi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131D9606B365;
	Fri, 13 Nov 2026 17:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pN5pdNzi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB291F000C6;
	Fri, 13 Nov 2026 17:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590533;
	bh=Gk2ydScf553h+zLnJKzJjOIMHhpPXTKa+icP8dkAEUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pN5pdNzi/9G2dnYiBG/PGfi+EcGPvRTEGe37YQJYL99+hg1uiYwXuMo12ZPTy7ZIW
	 6pbqICI+LiMAkr1BaSADj4m0d745gwSdcV46jm9+idN5KyE1KV9GVlxUTLUsPf0xLQ
	 ar+63lrd1QYLVK+sIsShPUnxnE8DDc0dD8lmYuoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 475/686] batman-adv: tt: ignore ROAM flag of received ADD changes
Date: Fri, 13 Nov 2026 10:50:08 -0500
Message-ID: <20261113153837.030578409@linuxfoundation.org>
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

commit c5d68abe6e7f1dbd132a602cb696fe1fff0389eb upstream.

A received TT change (OGM diff or full table response) with the ROAM flag
but without DEL is handled by batadv_tt_global_add() like a ROAMING_ADV:

* a newly created global entry gets BATADV_TT_CLIENT_ROAM and is
  therefore excluded from the global CRC. The sender has it in its local
  CRC and the receiver has to request the full table again
* batadv_tt_global_purge_local() removes the local entry of the
  receiver. The receiver's own client is considered as roamed to the sender
  and frames for it are rerouted

The ROAM flag only has a meaning together with DEL. Drop it on reception to
keep it from populating the global table with a temporary ROAMING entry
which is not part of the CRC - and therefore causing a CRC mismatch.

Cc: stable@vger.kernel.org
Fixes: 068ee6e204e1 ("batman-adv: roaming handling mechanism redesign")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 3f0b26ad699c0..c73596ef6160c 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3268,20 +3268,29 @@ static void _batadv_tt_update_changes(struct batadv_priv *bat_priv,
 {
 	int i;
 	int roams;
+	u8 flags;
 
 	for (i = 0; i < tt_num_changes; i++) {
-		if ((tt_change + i)->flags & BATADV_TT_CLIENT_DEL) {
-			roams = (tt_change + i)->flags & BATADV_TT_CLIENT_ROAM;
+		flags = (tt_change + i)->flags;
+
+		if (flags & BATADV_TT_CLIENT_DEL) {
+			roams = flags & BATADV_TT_CLIENT_ROAM;
 			batadv_tt_global_del(bat_priv, orig_node,
 					     (tt_change + i)->addr,
 					     ntohs((tt_change + i)->vid),
 					     "tt removed by changes",
 					     roams);
 		} else {
+			/* an announced client cannot have roamed away from
+			 * orig_node. Only a ROAMING_ADV is allowed to add a
+			 * global entry with the ROAM flag
+			 */
+			flags &= ~BATADV_TT_CLIENT_ROAM;
+
 			if (!batadv_tt_global_add(bat_priv, orig_node,
 						  (tt_change + i)->addr,
 						  ntohs((tt_change + i)->vid),
-						  (tt_change + i)->flags, ttvn))
+						  flags, ttvn))
 				/* In case of problem while storing a
 				 * global_entry, we stop the updating
 				 * procedure without committing the
-- 
2.53.0



