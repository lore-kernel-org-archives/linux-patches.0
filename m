Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591301;
	b=2WQAq183lxaAJ+GLf6v8wvyvoDvCIdDtombdp7qJ84vX42RYzdjOw2ylGLrTyFcaQHFe
	 rGE5Y3QAi7urahJ8hTpXErcuSIsZzPLIMdYYjKa4pSBSZ2i2cFHxAImwQFXwsaBroF9xH
	 qtF8U4HMOi+lC0xUdweUwm9vir+I3QLuMB6vQM7B1bA3lXu7oOrV361ELFeBu8QlrVMN5
	 EEBnv1ptIQ74iijI73ivItcIwS5AJuvzqGIG/gqiI+jZaelwlkxrTeVgyRRjfnV6LTOl/
	 2FELyN7MV05kzvmBqbZE270nR/7IeRBXafuiEIRwsWU8qA+jAVXCnarfzL2k+p2WCvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FYS3nuERrGWt7xFtfrZfNYo9BvmrDTqOhwx+H8hNWeQ=;
	b=o1+F95PzVDr27BYO/7Sb5s4nEv4W1NDjiwdzxpbrs0TAoxMgHFtlsb6haDNFsV5+vO32
	 VTP7VYbqUdY9YILvt0P6nNHi1VvhQPWV4eY0lyCUg+gF7dLz9uZ4jS4enRvSYnP42bVyV
	 1YMqti1SidJ+D9tuuUqKoYwYlO1+xsiVVKhnTQTifV8gV2t2jFvdFxdWYuXq2KZRnaw7u
	 ErGif7THXvTdUfvf1FBFmadm+YiDTblYntIn2q5Q9mFtSWosvG9FzZhASiMVs/YzydE9S
	 8V0aPzE6nLyZr25m/9815wujHHnp9jGtGj6n3XqobCQfNwOWQe/go5ah6Wcm+iywrWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITGNusa5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DB6606B201;
	Fri, 13 Nov 2026 17:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITGNusa5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48611F000C4;
	Fri, 13 Nov 2026 17:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591300;
	bh=FYS3nuERrGWt7xFtfrZfNYo9BvmrDTqOhwx+H8hNWeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITGNusa5ZaF/Oy6Jn1ObKfhLuFzEotM5zpqQCL+I747h67NYyoVIoU7TdCUA67Et0
	 DhGMxwQlf7c/Hu+nB0bemZ91uLx/C/8IaK0RvW7PWdBx2KudEzVMmc15Kdu7CiHhd/
	 4p0GqrIFhUtP9Eugm9w7fdavsXACcdFIOGmHl3AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 416/670] batman-adv: tt: only update flags for TT events
Date: Fri, 13 Nov 2026 10:49:40 -0500
Message-ID: <20261113153825.841193803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit ad1fd828aa3944efc393b84b0d7c02483f1b5638 upstream.

In the first implementation of the translation table events, it was only
possible to announce:

* ADD: new locally detected client
* DEL: disappeared local client

If an ADD event was queued and then a DEL event was queued in the same
timeslot, it is valid to destroy both events because nothing actually
changed for remode nodes

But with commit 3c4f7ab60cc2 ("batman-adv: improve the TT component to
support runtime flag changes") and subsequent changes, it could also happen
that there are extra ADD events:

* ADD: _NEW_ locally detected client
* ADD: already existing client with new flags
* DEL: disappeared local client

The first and the last type of event could in theory still be removed
together from the (to be announced) events queue. But if the "update flags"
ADD is dropped together with the DEL, it would still leave global
translation table of a remote node in the incorrect state - believing that
the client didn't disappear.

If a detected client was previously announced, a DEL event must only
overwrite the "update flags" ADD but the DEL itself must still continue to
exist in the (to be anounced) events queue. For now, adjustment of the
announced flags is used for everything instead of dropping already queued
up events completely.

Similarly, a DEL followed by an ADD caused both entries to be deleted. But
the new ADD could announce flags changes which were not yet present for the
client before it was marked for DELetion. The new ADD must therefore only
overwrite the DEL - but still be kept.

Cc: stable@vger.kernel.org
Fixes: 3c4f7ab60cc2 ("batman-adv: improve the TT component to support runtime flag changes")
[ Context, drop now unused code for removed entries ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 41 ++++++++----------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index 96d67ec1a8af9..031f9bd8f72dd 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -455,6 +455,9 @@ batadv_tt_orig_list_entry_put(struct batadv_tt_orig_list_entry *orig_entry)
  * @bat_priv: the bat priv with all the soft interface information
  * @tt_local_entry: the TT entry involved in the event
  * @event_flags: flags to store in the event structure
+ *
+ * Only a single change per client is queued. It describes the latest state of
+ * the client and a new event therefore replaces an already queued one.
  */
 static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 				  struct batadv_tt_local_entry *tt_local_entry,
@@ -463,8 +466,7 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 	struct batadv_tt_change_node *tt_change_node, *entry, *safe;
 	struct batadv_tt_common_entry *common = &tt_local_entry->common;
 	u8 flags = common->flags | event_flags;
-	bool event_removed = false;
-	bool del_op_requested, del_op_entry;
+	bool del_op_requested;
 
 	tt_change_node = kmem_cache_alloc(batadv_tt_change_cache, GFP_ATOMIC);
 	if (!tt_change_node)
@@ -496,44 +498,23 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 		if (entry->change.vid != tt_change_node->change.vid)
 			continue;
 
-		/* DEL+ADD in the same orig interval have no effect and can be
-		 * removed to avoid silly behaviour on the receiver side. The
-		 * other way around (ADD+DEL) can happen in case of roaming of
-		 * a client still in the NEW state. Roaming of NEW clients is
-		 * now possible due to automatically recognition of "temporary"
-		 * clients
-		 */
-		del_op_entry = entry->change.flags & BATADV_TT_CLIENT_DEL;
-		if (!del_op_requested && del_op_entry)
-			goto del;
-		if (del_op_requested && !del_op_entry)
-			goto del;
-
-		/* this is a second add in the same originator interval. It
-		 * means that flags have been changed: update them!
+		/* the other nodes may know the client with different
+		 * flags. A DEL+ADD must therefore still announce the
+		 * current flags and an ADD+DEL must still remove the
+		 * client. ADD+ADD and DEL+DEL only update the flags
 		 */
-		if (!del_op_requested && !del_op_entry)
-			entry->change.flags = flags;
-
-		continue;
-del:
-		list_del(&entry->list);
-		kmem_cache_free(batadv_tt_change_cache, entry);
+		entry->change.flags = flags;
 		kmem_cache_free(batadv_tt_change_cache, tt_change_node);
-		event_removed = true;
+
 		goto unlock;
 	}
 
 	/* track the change in the OGMinterval list */
 	list_add_tail(&tt_change_node->list, &bat_priv->tt.changes_list);
+	atomic_inc(&bat_priv->tt.local_changes);
 
 unlock:
 	spin_unlock_bh(&bat_priv->tt.changes_list_lock);
-
-	if (event_removed)
-		atomic_dec(&bat_priv->tt.local_changes);
-	else
-		atomic_inc(&bat_priv->tt.local_changes);
 }
 
 /**
-- 
2.53.0



