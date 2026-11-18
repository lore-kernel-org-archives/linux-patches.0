Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059425;
	b=sHkshK68rCUK0H6dvQ0nXbN7C9woIrp7yfDc8UNqslOiJcGm4xmejDPnW5pUyb0mSHxR
	 riHQkCQ1pO4hnbGLC03j0WNS2vhv1mwsjKx5sKsu7t9LKeKkcb3jkt/zvQejxaI3Q5nSy
	 +IfnHyql/OHXPgKH033TIuCs3iZOXIdCJt1Q7oROw8O4V9fYCOYalSviZYSNcAJMZzr1C
	 6BUOOME8RYiYJHev2xN4Ux5uaLWmIFISI+gM70Ger0vCWd6718BeftdWGnRDVIaVWMFbB
	 pgfvaxsaZyRPzYtwm2H5pbNZ80RZBJ3qNCmfZ+GXngz9uWmtAGpqXRbJrb6r+DFpNjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pWyQb4ohNDlYcGfBvNhmiqDWAiHpn2MHrwO2aTYPIEY=;
	b=3p3KtZyuHMozebM20JC0NqdQUnaWbbQOcertkLkVx7JqD1eCgxDhtpsQ7JQEQPl/1IEs
	 SN8GoBGZc69f+ORc4Pxm/86F9rWnbCgltpx80vDRSf6KexcZpgDTZZjvXysQjf2wUywjg
	 CFltphzX3LcGp1sbwXM2fB0hRD/NJyXB+pIwADny4HM5J3ltn237BDLaj2LliKh+bdWH8
	 LwvRbMWFjWaqDDB8gQKM+Wje7924Lle8bDk9HttqhnahZLjbDsTVMEhYK99gs/yMbry1+
	 O/5Jt/ZdMr+5eO8qHvSvUe89LDcFHU59xFbD+8XxBnzZLgNMQ8/wjo9DAhIzS3yoS+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1ICYj2l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C074606A326;
	Thu, 19 Nov 2026 03:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s1ICYj2l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A109C1F000C4;
	Thu, 19 Nov 2026 03:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059425;
	bh=pWyQb4ohNDlYcGfBvNhmiqDWAiHpn2MHrwO2aTYPIEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s1ICYj2l6rz4EN5jvaVpQW8yMi/gyfm45dA2ymArzZ7GuPrVb8EhJUgYRO73mmfLy
	 /RJTctyFzYjtWVFrqrFSlFBpI0IloRzypCJrKaoHkP4OUK36RFhZBIqchIEhZO2b8j
	 9kV2x8K6Q/L3kq2lawjKY4hHxXzj3WSTLxzTB3Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0800/1848] batman-adv: tt: ignore ROAM flag of received ADD changes
Date: Wed, 18 Nov 2026 15:47:18 +0100
Message-ID: <20261118145949.866384291@linuxfoundation.org>
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
index 1065003c99dfd..ce36340f97459 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3572,20 +3572,29 @@ static void _batadv_tt_update_changes(struct batadv_priv *bat_priv,
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



