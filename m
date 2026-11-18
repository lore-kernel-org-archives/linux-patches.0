Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059442;
	b=UXaLt/8RZQwKg+XP8aHOquA9lkuEGnt3YDQ8Z3qKcGsG0K+R5U2wvhwK0zYfNAzvn/vU
	 w9mRKV0ZDm8SMx5AqtuirQkDNltXnu0P4N2TpZTtYbql2wFEnXmmHGME98iLUWymkbjNz
	 3uuW47MiBbG6FG9Zg5j3G1kg7C0xkZyAzU4cqti2/IP+NyHSKu4yuIsaHXuEiLuWnIiTv
	 NyHb9Ucm41YC4xtgPfuYDFWe7LgyHbDE22RgNAC3UBEK7S3SHmx+ifmAb8u935mze7UFA
	 OYqK2rowR2njxG8em9dmaMRxT2Ckf7O27bfy25jmWA0pQ6uG5TBUfHi1S5I19FA+IXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3TAl/AeAuPs9g/GzMjHpVzwwF0KupsiNMmOb9SScfm8=;
	b=1SvxH0MSc/3JQIjL7hLgUpqAjt9tUww1vPYOxdQbr977Po/BhxzHIFt/5hDOMWiLe4qg
	 2zQCZiBSsRjACc28ZFrfSxiX+qjfkElEyV8ww314g1nXOLTVN9kWP2wdbHftsTFfplp5O
	 iYHRl+ca5mxhU51XJ0giWGbUTfvd/f5O/ceIfqbJ3XedW5Dn7OF1EsvdMHTmOp1NfAzWC
	 o6ATxKALeVk09vuLdcz6FeZfoq9uJYxmZsxRVKEd3Id7chct1FhJVDsS7SkyKv4SpP8Pr
	 3Hdfsfnx8SJS/hrOBMa4sXibvg8+1Q1EYX4SX4FvbMbwauKKJOZ7AhKJd8es/4lvWXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sbv4IsEc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532C6606A325;
	Thu, 19 Nov 2026 03:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sbv4IsEc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85761F000C4;
	Thu, 19 Nov 2026 03:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059442;
	bh=3TAl/AeAuPs9g/GzMjHpVzwwF0KupsiNMmOb9SScfm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sbv4IsEc1TqVeNHeCr5u5LwWyAqVOSc5o0TcUaPrR9uTE7jhDKmIPOAwLcqlNscnL
	 DF3pmT6R/kPMj9MA+JjHfkIWxKB6TISTUYqiIincfrXJXs/hzZLZMyLNkLdqpB1kh+
	 FgGCxJANVGi1Q4m02QrmfasdNnY/37mxi6Wxqxok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0801/1848] batman-adv: tt: only update flags for TT events
Date: Wed, 18 Nov 2026 15:47:19 +0100
Message-ID: <20261118145949.902211130@linuxfoundation.org>
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
index ce36340f97459..df99ffaad1bae 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -456,6 +456,9 @@ batadv_tt_orig_list_entry_put(struct batadv_tt_orig_list_entry *orig_entry)
  * @bat_priv: the bat priv with all the soft interface information
  * @tt_local_entry: the TT entry involved in the event
  * @event_flags: flags to store in the event structure
+ *
+ * Only a single change per client is queued. It describes the latest state of
+ * the client and a new event therefore replaces an already queued one.
  */
 static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 				  struct batadv_tt_local_entry *tt_local_entry,
@@ -464,8 +467,7 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 	struct batadv_tt_change_node *tt_change_node, *entry, *safe;
 	struct batadv_tt_common_entry *common = &tt_local_entry->common;
 	u8 flags = common->flags | event_flags;
-	bool event_removed = false;
-	bool del_op_requested, del_op_entry;
+	bool del_op_requested;
 
 	tt_change_node = kmem_cache_alloc(batadv_tt_change_cache, GFP_ATOMIC);
 	if (!tt_change_node)
@@ -497,44 +499,23 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
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



