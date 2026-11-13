Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590535;
	b=kkYydqIiZ6yiGiB5BR0voQl8jHl4A9BbVRCHCBOrBScsM2EasWkwVYNRlpAMZEqmB3a0
	 V2y1Dj5Luoq37+XjcvmkKuNYV+AsAHZ+wtZoNEBJhd3wX5sc6UlBeHlxTt9e/BVl53dJC
	 VD+iB9vi4xpsbWDsZs7DK92zKPt4QWmUdc2M22EbxAhBH1io1BQMotExf0ryVCdMf4sRz
	 /F9foFLDXxB5bOU1CIDayoDmAQKIKm08nL2Gm8VtGINgkf4xkAnWyNjpsKL51tGbnACOu
	 BgUIMb8+i83EvkGVJemUnaUVyLAPZp6/oceDTkRYO8Plf4KPO1KDRCJl/9eue2aUvhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590535;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+fiIVly8jPzJ7+pMoZGFMhcGMMlZtXobElzuN9e0bDc=;
	b=La+F6DsaeBXqLb5ioGRB+gHOopoiLtFRLfz9KNeTwuLJibC2Ejm9ANNIRlwA+eMky3Va
	 YzbQYmJsZg5t7X//zKbPBvA+a2xSRPQD4N1f6E2tjZw2WV7n1q93XsQNcmZ6IjogDhcKb
	 HGZdDpFPxHDKRh73UPCA+EYiRmcRRhjqvjSjheeP7nJh5u0MhGuqc4iHpLfoImsFr3ZWl
	 9MhJzY81tfhpykJMo+MUDxZ/iNhXOeK6eR4MKthFPr/wjS7a8PCkMgz/1s0+oQeLwn6HQ
	 DonximGcPuCO9Ekiim7gSIVatQz0dHG6PZPrPjcmmt9ZgrS1qRGH9eCSp6hdL5KtJLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVop00Pt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C61606B365;
	Fri, 13 Nov 2026 17:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tVop00Pt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935271F000C9;
	Fri, 13 Nov 2026 17:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590534;
	bh=+fiIVly8jPzJ7+pMoZGFMhcGMMlZtXobElzuN9e0bDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVop00PtQYJw4GogCe7g1ZIlByU+K2dDhh5PcSqdMgXvbbOi4DeahgQsB7wH5JPcZ
	 SLc+1YjrolqzZZEDEKkd/kNxfI63h/zMlf5wUcq8nMQ8mvANmCyfH312vWbWknzXpn
	 Vmd8J60GNepm1RUxkCxMVRU25D5F0bjVr+pQSZAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 476/686] batman-adv: tt: only update flags for TT events
Date: Fri, 13 Nov 2026 10:50:09 -0500
Message-ID: <20261113153837.067670959@linuxfoundation.org>
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
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index c73596ef6160c..e7242706e3345 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -415,6 +415,9 @@ batadv_tt_orig_list_entry_put(struct batadv_tt_orig_list_entry *orig_entry)
  * @bat_priv: the bat priv with all the mesh interface information
  * @tt_local_entry: the TT entry involved in the event
  * @event_flags: flags to store in the event structure
+ *
+ * Only a single change per client is queued. It describes the latest state of
+ * the client and a new event therefore replaces an already queued one.
  */
 static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 				  struct batadv_tt_local_entry *tt_local_entry,
@@ -423,7 +426,7 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 	struct batadv_tt_change_node *tt_change_node, *entry, *safe;
 	struct batadv_tt_common_entry *common = &tt_local_entry->common;
 	u8 flags = common->flags | event_flags;
-	bool del_op_requested, del_op_entry;
+	bool del_op_requested;
 	size_t changes;
 
 	tt_change_node = kmem_cache_alloc(batadv_tt_change_cache, GFP_ATOMIC);
@@ -457,25 +460,12 @@ static void batadv_tt_local_event(struct batadv_priv *bat_priv,
 		if (entry->change.vid != tt_change_node->change.vid)
 			continue;
 
-		del_op_entry = entry->change.flags & BATADV_TT_CLIENT_DEL;
-		if (del_op_requested != del_op_entry) {
-			/* DEL+ADD in the same orig interval have no effect and
-			 * can be removed to avoid silly behaviour on the
-			 * receiver side. The  other way around (ADD+DEL) can
-			 * happen in case of roaming of  a client still in the
-			 * NEW state. Roaming of NEW clients is now possible due
-			 * to automatically recognition of "temporary" clients
-			 */
-			list_del(&entry->list);
-			kmem_cache_free(batadv_tt_change_cache, entry);
-			changes--;
-		} else {
-			/* this is a second add or del in the same originator
-			 * interval. It could mean that flags have been changed
-			 * (e.g. double add): update them
-			 */
-			entry->change.flags = flags;
-		}
+		/* the other nodes may know the client with different
+		 * flags. A DEL+ADD must therefore still announce the
+		 * current flags and an ADD+DEL must still remove the
+		 * client. ADD+ADD and DEL+DEL only update the flags
+		 */
+		entry->change.flags = flags;
 
 		kmem_cache_free(batadv_tt_change_cache, tt_change_node);
 		goto update_changes;
-- 
2.53.0



