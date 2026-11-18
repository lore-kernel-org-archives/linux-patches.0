Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059445;
	b=GK3WX6TRS9856JgWmCRyNDn5YUJHdDT1V4Awj/qxHgI6KY+n4vqbdl3139TtBxuRsqU3
	 ZAhWScU+A2LajBxLbE8S3EcG/krEvn+omwCgIZI1QXi/k21eUK0hmZpdydQe9rZtMlK5o
	 BzLDQ3kg+1kRUunifJVP8JFn2CBeNcEImrvZd0BFYH6CFEGTbggbcJ7RNp+KfmCvweP9s
	 JzxhCuIbM1rlWUQXcsUzpVo9u/+Snbc/xQwFRnwjHSBZ0bPPrDZm94IDFNXQ5z71j+4iu
	 KPYN/5sAIImMvMjEdknDVtnS3VBP/MSYYhRiOkqTutQpp7UV/T1nsh+NrsUDZ2vsTxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QE/tOCN0T+p8kt+XO3fsM2QrXLDvvNoyGKla2lYPGbY=;
	b=L+nURJwUSHw5w5uqDkjnrtfEpgoLbY9N1Fbt2X61CHQJ9RA2PQNRIoLpdFacq+ubfoKz
	 5txFuwyhV6nWWWyPuTvqgJQpZnxP6yMzWo8+ASJ8SHvO2eXeJ8fC9B4cJrKr5H53MqyZl
	 pZmd5T9pVcZgDPKq8O3dUcoLUoU9RXCrBTrOcdFHoSXxmQJ3qbbGNWB+BzSlTN63MZ6Fg
	 IrDJ0Q5qoa6J27ft2nySM3Bv7GGIL2603K81uyp5jREdG8ogDu6K6MQ/UeSR+5IvCRTu/
	 65k5f4wShihL2I5qXN02nJOroFjShtYN7F60mDFNeyexkXsIGONov8YyvO/RKqI2n4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0a6Tpv9T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D41606A320;
	Thu, 19 Nov 2026 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0a6Tpv9T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676A61F000C4;
	Thu, 19 Nov 2026 03:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059444;
	bh=QE/tOCN0T+p8kt+XO3fsM2QrXLDvvNoyGKla2lYPGbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0a6Tpv9Tm8nf48FF5sn2GbcZAXewzgeEfUu8zd7X2zBxRhoWaLZ4KwSsYvjhq7XOC
	 9gsdTsxJK2AJ2HH8GsC5DAj7F80J1NNBKK9Oy2nEVc6xh5QTYjQBDPbxhUD3pWi9jB
	 ZZ2vESvYSyF4VK/eEoSPX2lp6uY37bx1h3e3VuCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0802/1848] batman-adv: tt: dont drop local events queued during TVLV update
Date: Wed, 18 Nov 2026 15:47:20 +0100
Message-ID: <20261118145949.937071401@linuxfoundation.org>
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

commit ed7a0dfdd370acb48be7a281df732c1bebcc7f1d upstream.

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
[ Context, switch to old "mesh_iface" name "soft_iface", access
 local_changes with atomic_t helpers ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 61 +++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 13 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index df99ffaad1bae..807eefa28ec26 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -1023,20 +1023,22 @@ batadv_tt_prepare_tvlv_local_data(struct batadv_priv *bat_priv,
  * batadv_tt_tvlv_container_update() - update the translation table tvlv
  *  container after local tt changes have been committed
  * @bat_priv: the bat priv with all the soft interface information
+ * @changes_list: list of committed changes which will be consumed
+ * @tt_diff_entries_num: number of entries in @changes_list
  */
-static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
+static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv,
+					    struct list_head *changes_list,
+					    int tt_diff_entries_num)
 {
 	struct batadv_tt_change_node *entry, *safe;
 	struct batadv_tvlv_tt_data *tt_data;
 	struct batadv_tvlv_tt_change *tt_change;
 	int tt_diff_len, tt_change_len = 0;
-	int tt_diff_entries_num = 0;
 	int tt_diff_entries_count = 0;
 	bool drop_changes = false;
 	size_t tt_extra_len = 0;
 	u16 tvlv_len;
 
-	tt_diff_entries_num = atomic_read(&bat_priv->tt.local_changes);
 	tt_diff_len = batadv_tt_len(tt_diff_entries_num);
 
 	/* if we have too many changes for one packet don't send any
@@ -1054,19 +1056,39 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 
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
-	atomic_set(&bat_priv->tt.local_changes, 0);
-
-	list_for_each_entry_safe(entry, safe, &bat_priv->tt.changes_list,
-				 list) {
+	list_for_each_entry_safe(entry, safe, changes_list, list) {
 		if (tt_diff_entries_count < tt_diff_entries_num) {
 			memcpy(tt_change + tt_diff_entries_count,
 			       &entry->change,
@@ -1076,7 +1098,6 @@ static void batadv_tt_tvlv_container_update(struct batadv_priv *bat_priv)
 		list_del(&entry->list);
 		kmem_cache_free(batadv_tt_change_cache, entry);
 	}
-	spin_unlock_bh(&bat_priv->tt.changes_list_lock);
 
 	tt_extra_len = batadv_tt_len(tt_diff_entries_num -
 				     tt_diff_entries_count);
@@ -3998,11 +4019,25 @@ static void batadv_tt_local_purge_pending_clients(struct batadv_priv *bat_priv)
  */
 static void batadv_tt_local_commit_changes_nolock(struct batadv_priv *bat_priv)
 {
+	LIST_HEAD(changes_list);
+	int changes_num;
+
 	lockdep_assert_held(&bat_priv->tt.commit_lock);
 
-	if (atomic_read(&bat_priv->tt.local_changes) < 1) {
+	/* atomically get the list of changes. The TTVN decision and the
+	 * announced changeset must cover the same events. Events queued
+	 * afterwards stay in the tt.changes_list for the next TT round
+	 */
+	spin_lock_bh(&bat_priv->tt.changes_list_lock);
+	list_splice_init(&bat_priv->tt.changes_list, &changes_list);
+	changes_num = atomic_read(&bat_priv->tt.local_changes);
+	atomic_set(&bat_priv->tt.local_changes, 0);
+	spin_unlock_bh(&bat_priv->tt.changes_list_lock);
+
+	if (changes_num == 0) {
 		if (!batadv_atomic_dec_not_zero(&bat_priv->tt.ogm_append_cnt))
-			batadv_tt_tvlv_container_update(bat_priv);
+			batadv_tt_tvlv_container_update(bat_priv, &changes_list,
+							changes_num);
 		return;
 	}
 
@@ -4019,7 +4054,7 @@ static void batadv_tt_local_commit_changes_nolock(struct batadv_priv *bat_priv)
 
 	/* reset the sending counter */
 	atomic_set(&bat_priv->tt.ogm_append_cnt, BATADV_TT_OGM_APPEND_MAX);
-	batadv_tt_tvlv_container_update(bat_priv);
+	batadv_tt_tvlv_container_update(bat_priv, &changes_list, changes_num);
 }
 
 /**
-- 
2.53.0



