Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585425;
	b=pkqw20JHVr9MK1J+vHq97JGnUrFxtFltu5DKXKHDt8HYN5rmbVF8mloSm7NWMUzQR5dO
	 zeMGQtWN8nd6K/b35BcZy4QhsUT5QRaV0dvvUEtDxSwVXWMNB5rN5kQ5YUNoXdzVeV8Bh
	 Ukr5N2ZgKqKxkyX9X0Jk5Hg3bxoVBwf4oTSGD7BgnO6Nbsi3cBKlL2045rUAjmRbWF7k2
	 Vn7NsVCHC2btaapPyHa+4ps9xBwn2+iq8eE4kH25ruZAy5rZTqtDepaQEQP/q4X1TdO/Q
	 jju15fBnuir4h7A4/FYHWVhd4pza06tbQdVhjpFg0VTmkNhTA3YOEXvD3uQEjkaoe+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qnazMlyNY03fr1ttO+yYQiJiPuTFls7TrZ48KRbf3zY=;
	b=CoWlwjRPjMvkuu4AU9qZo/0aDA5gFgkSfEVyJvc2h4RZLbt4/Zh2hEHNHfWwcD/8K2GU
	 jBVZz6RfmrU/arJi5KQCNiJ/P+o2hxa9iY1IGIbFafYdM/okwpL00sPsJgaWpD0q0aShZ
	 d2ktsubRhsaztdPLSyD4+9H53QVjWDYuB6DmPFVygOrReI9zPwtwKdjbmHOlvt5YY5z4W
	 2qzBm3205fcFD9NuGYP4CdFJhL7u7eQjzYsQdgMk8FfOTjVHCW7S9yyepaOIuJLK3TTSU
	 B5Ls+4UF/8IEQrGqZups0PQtksQG004lEhZlOLdoW7uqxmO4LiKfAstJIiHOTUdZ/+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZTKFc4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BCD60A3836;
	Fri, 13 Nov 2026 15:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hZTKFc4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39051F000C5;
	Fri, 13 Nov 2026 15:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585425;
	bh=qnazMlyNY03fr1ttO+yYQiJiPuTFls7TrZ48KRbf3zY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hZTKFc4BSISLflGcVnNeeSHW9bpjzk1/Rv1Y4xjkxRIbr9Ty5sPdb3Uz4XjDb1yM4
	 KcVYyx0/sl5Dya6/gYS/UAa+KVtkw+8pyVRILIExAWCNnywdiuevGTvkTqeWKsD5/D
	 iiXJXna1kacPptUofZ7siHMbebDeoV9oBJNESoB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 088/507] batman-adv: tt: dont drop local events queued during TVLV update
Date: Fri, 13 Nov 2026 10:46:32 -0500
Message-ID: <20261113153756.946006992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit ed7a0dfdd370acb48be7a281df732c1bebcc7f1d ]

batadv_tt_tvlv_container_update() read the number of local changes without
holding changes_list_lock. batadv_tt_local_event() is not serialized by
the commit_lock and can queue new events before the changes_list is
flushed:

  CPU0                          CPU1
  batadv_tt_tvlv_container_update()
    num = ...local_changes;
                                batadv_tt_local_event()
                                  list_add_tail(...);
                                  ...local_changes++;
    spin_lock_bh(&...changes_list_lock);
    /* only num events copied but all freed */

The additional events were freed without ever being sent. Other nodes will
only notice this via a CRC mismatch and must request the full table.

The number of changes and the changes_list must therefore be taken
atomically. Events queued afterwards then stay in the tt.changes_list for
the next TT round.

The changes can no longer be kept for the next round when the TVLV buffer
allocation fails. But they would be sent with a skipped TTVN anyway, so the
other nodes have to request the full table in this case either way. The
last changeset is only dropped in this case when the TTVN was incremented.
Without new changes, it still describes the current TTVN.

Previously, the unconsumed changes caused a retry of the TVLV container
update in the next commit round. Since the changes are now consumed, the
next round would only take the path without changes and wait for
BATADV_TT_OGM_APPEND_MAX rounds before updating the container again. Until
then, the outdated container with the previous TTVN would still be
announced. The ogm_append_cnt is therefore reset on failure to retry the
update in the next OGM interval.

This doesn't make the CRC consistent with the announced changeset. The
local table modifications are still not serialized with the commit and
batadv_tt_local_transition_new() can still make a client part of the CRC
for which the event is only part of the next TT round. Such an
inconsistency is detected by the CRC check of the other nodes and solved
via a full table request.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-fc286ddd-5bed-4683-b842-ee7a307eeb19
Fixes: a73105b8d4c7 ("batman-adv: improved client announcement mechanism")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 61 +++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 6802203119dfa..b1dae5e1bc23d 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1006,22 +1006,24 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
  * batadv_tt_tvlv_container_update() - update the translation table tvlv
  *  container after local tt changes have been committed
  * @bat_priv: the bat priv with all the mesh interface information
+ * @changes_list: list of committed changes which will be consumed
+ * @tt_diff_entries_num: number of entries in @changes_list
  */
-static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
+static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv,
+					    struct list_head *changes_list,
+					    int tt_diff_entries_num)
 {
 	struct batadv_tvlv_tt_change *tt_change;
 	struct batadv_tt_change_node *entry;
 	struct batadv_tvlv_tt_data *tt_data;
 	struct batadv_tt_change_node *safe;
 	int tt_diff_entries_count = 0;
-	int tt_diff_entries_num = 0;
 	bool drop_changes = false;
 	size_t tt_extra_len = 0;
 	int tt_change_len = 0;
 	int tt_diff_len;
 	u16 tvlv_len;
 
-	tt_diff_entries_num = READ_ONCE(bat_priv->tt.local_changes);
 	tt_diff_len = batadv_tt_len(tt_diff_entries_num);
 
 	/* if we have too many changes for one packet don't send any
@@ -1039,19 +1041,39 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 
 	tvlv_len = batadv_tt_prepare_tvlv_local_data(bat_priv, &tt_data,
 						     &tt_change, &tt_diff_len);
-	if (!tvlv_len)
+	if (!tvlv_len) {
+		/* the changes are lost and the other nodes have to request the
+		 * full table. Don't answer TT requests for the new TTVN with
+		 * the stale changeset of the previous TTVN. Without changes, the
+		 * TTVN was not incremented and the last changeset is still valid
+		 */
+		if (drop_changes || tt_diff_entries_num > 0) {
+			list_for_each_entry_safe(entry, safe, changes_list,
+						 list) {
+				list_del(&entry->list);
+				kmem_cache_free(batadv_tt_change_cache, entry);
+			}
+
+			spin_lock_bh(&bat_priv->tt.last_changeset_lock);
+			kfree(bat_priv->tt.last_changeset);
+			bat_priv->tt.last_changeset = NULL;
+			bat_priv->tt.last_changeset_len = 0;
+			spin_unlock_bh(&bat_priv->tt.last_changeset_lock);
+		}
+
+		/* announce the already committed TTVN in the next OGM interval
+		 * instead of waiting for BATADV_TT_OGM_APPEND_MAX idle rounds
+		 */
+		atomic_set(&bat_priv->tt.ogm_append_cnt, 0);
 		return;
+	}
 
 	tt_data->flags = BATADV_TT_OGM_DIFF;
 
 	if (!drop_changes && tt_diff_len == 0)
 		goto container_register;
 
-	spin_lock_bh(&bat_priv->tt.changes_list_lock);
-	WRITE_ONCE(bat_priv->tt.local_changes, 0);
-
-	list_for_each_entry_safe(entry, safe, &bat_priv->tt.changes_list,
-				 list) {
+	list_for_each_entry_safe(entry, safe, changes_list, list) {
 		if (tt_diff_entries_count < tt_diff_entries_num) {
 			memcpy(tt_change + tt_diff_entries_count,
 			       &entry->change,
@@ -1061,7 +1083,6 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 		list_del(&entry->list);
 		kmem_cache_free(batadv_tt_change_cache, entry);
 	}
-	spin_unlock_bh(&bat_priv->tt.changes_list_lock);
 
 	tt_extra_len = batadv_tt_len(tt_diff_entries_num -
 				     tt_diff_entries_count);
@@ -3892,11 +3913,25 @@ static void batadv_tt_local_purge_pending_clients(struct batadv_priv *bat_priv)
  */
 static void batadv_tt_local_commit_changes_nolock(struct batadv_priv *bat_priv)
 {
+	LIST_HEAD(changes_list);
+	int changes_num;
+
 	lockdep_assert_held(&bat_priv->tt.commit_lock);
 
-	if (READ_ONCE(bat_priv->tt.local_changes) == 0) {
+	/* atomically get the list of changes. The TTVN decision and the
+	 * announced changeset must cover the same events. Events queued
+	 * afterwards stay in the tt.changes_list for the next TT round
+	 */
+	spin_lock_bh(&bat_priv->tt.changes_list_lock);
+	list_splice_init(&bat_priv->tt.changes_list, &changes_list);
+	changes_num = READ_ONCE(bat_priv->tt.local_changes);
+	WRITE_ONCE(bat_priv->tt.local_changes, 0);
+	spin_unlock_bh(&bat_priv->tt.changes_list_lock);
+
+	if (changes_num == 0) {
 		if (!batadv_atomic_dec_not_zero(&bat_priv->tt.ogm_append_cnt))
-			batadv_tt_tvlv_container_update(bat_priv);
+			batadv_tt_tvlv_container_update(bat_priv, &changes_list,
+							changes_num);
 		return;
 	}
 
@@ -3913,7 +3948,7 @@ static void batadv_tt_local_commit_changes_nolock(struct batadv_priv *bat_priv)
 
 	/* reset the sending counter */
 	atomic_set(&bat_priv->tt.ogm_append_cnt, BATADV_TT_OGM_APPEND_MAX);
-	batadv_tt_tvlv_container_update(bat_priv);
+	batadv_tt_tvlv_container_update(bat_priv, &changes_list, changes_num);
 }
 
 /**
-- 
2.53.0



